# Lecture de nouvelles transactions via Pika.
import json, time, sys, os, traceback, codecs
import pika

class TransactionLirePika:

    def __init__(self, configuration):
        self.configuration = configuration
        self.cnx = None
        self.connectionmq = None
        self.channel = None

        self.reader = codecs.getreader("utf-8")
          
        self.inError = True

    def connecter(self, callback):
        #mq_queue = "transactions" #os.environ['MQ_QUEUE']
        #mq_host = "dev2" #os.environ['MQ_HOST']

        self.connectionmq = pika.BlockingConnection(pika.ConnectionParameters(self.configuration.mqHost))
        self.channel = self.connectionmq.channel()
        self.channel.queue_declare(queue=self.configuration.mqQueue)   

        self.channel.basic_consume(callback,
                                   queue=self.configuration.mqQueue,
                                   no_ack=True)

        self.channel.start_consuming()

        return self.connectionmq

    def enterErrorState(self):
        self.inError = True
      
        if self.channel != None:
            try:
                self.channel.stop_consuming()
            except:
                None
      
        self.disconnect()
         
    def deconnecter(self):
        try:
            if self.connectionmq != None:
                self.connectionmq.close()
        finally:
            self.channel = None
            self.connectionmq = None

