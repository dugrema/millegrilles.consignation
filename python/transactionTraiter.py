#!/usr/bin/python3
# Programme principal pour faire les lectures de RabbitMQ vers MongoDB
# pour l'insertion des transactions.

from mgTransactions.TransactionConfiguration import TransactionConfiguration
from mgTransactions.TransactionLirePika import TransactionLirePika

class TransactionMain:

    def __init__(self):
        self.configuration = TransactionConfiguration()
        self.transactionLirePika = TransactionLirePika(self.configuration)

    def connecter(self):
        self.connexionMq = self.transactionLirePika.connecter( self.dummyCallback )

    def deconnecter(self):
        self.transactionLirePika.deconnecter()

    # Methode principale de traitement
    def run(self):
        print("Demarrage du traitement des transactions MQ -> MongoDB")
        print("MQ Host: %s, MQ Queue: %s" % (self.configuration.mqHost, self.configuration.mqQueue))

        self.connecter()

        print("Fin execution transactions MQ -> MongoDB")

    # Dummy pour recevoir un message de RabbitMQ
    def dummyCallback(self, ch, method, properties, body):
        print("Message recu: %s" % body)

# Fonction main. Demarre la lecture des queues de 
# transaction et la sauvegarde dans MongoDB.
if __name__ == "__main__":
    transactionMain = TransactionMain()
    try:
        transactionMain.run()
    finally:
        transactionMain.deconnecter()

    exit(0)

