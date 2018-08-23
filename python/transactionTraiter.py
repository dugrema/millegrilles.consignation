#!/usr/bin/python3
# Programme principal pour faire les lectures de RabbitMQ vers MongoDB
# pour l'insertion des transactions.

from mgTransactions.TransactionConfiguration import TransactionConfiguration
from mgTransactions.TransactionLirePika import TransactionLirePika

class TransactionMain:

    def __init__(self):
        self.configuration = TransactionConfiguration()
        self.transactionlirePika = TransactionLirePika(self.configuration)

    def run(self):
        print("Demarrage du traitement des transactions MQ -> MongoDB")
        
        print("Fin execution transactions MQ -> MongoDB")


if __name__ == "__main__":
    transactionMain = TransactionMain()
    transactionMain.run()
    exit(0)

