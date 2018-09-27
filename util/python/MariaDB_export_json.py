#!/usr/bin/python

import mysql.connector
import pika
import json
import uuid
import datetime
from decimal import Decimal


class ImportDataToTransaction:

    def __init__(self):
        self._cnmaria = None
        self._connectionmq = None
        self._channel = None
        self._cursor = None
        self._taille_batch = 20
        self._taille_max = 100000

        self._transaction_header = {
            'signature_contenu': '',
            'source-systeme': 'cuisine@cuisine.maple.mdugre.info',
            'indice-processus': 'MGPProcessus.Appareils.ProcessusSenseurConserverLecture'
        }

    def connecter(self):
        self._cnmaria = None
        self._cnmaria = mysql.connector.connect(user='cuisine_senseur', password='cuisine',
                                        host='infraserv1',
                                        database='lectmeteo',
                                        autocommit=True)

        self._connectionmq = pika.BlockingConnection(pika.ConnectionParameters('dev2'))
        self._channel = self._connectionmq.channel()


    def deconnecter(self):
        self._cnmaria.close()
        self._connectionmq.close()

    def executer(self):

        try:
            self.connecter()
            print("Connecte")

            # Executer requete SQL
            self.requete_sql()

            # Iterer
            self.iterer()

        finally:
            self.deconnecter()
            print("Deconnexion completee")

    def requete_sql(self):
        self._cursor = self._cnmaria.cursor()
        self._cursor.execute(
            '''
select hist.location, hist.temps_lect as temps_lecture, 
case
    when hist.location = 'Bureau' then 16
    when hist.location = 'Chambre' then 21
    when hist.location = 'ChambreFroide' then 24
	when hist.location = 'Cuisine' then 2
    when hist.location = 'Extension' then 20
    when hist.location = 'Estension_old2' then 9
    when hist.location = 'Garage' then 13
    when hist.location = 'Inconnu' then 5
    when hist.location = 'Mobile' then 5
    when hist.location = 'Mobile-1' then 5
    when hist.location = 'Patio' then 3
	when hist.location = 'Refrigerateur' then 19
	when hist.location = 'Remise' then 15
	when hist.location = 'Sous-sol' then 12
    else cast(hist.location as signed)
end as senseur,
       temperature, humidite, pression, bat_mv
from lectmeteo.lect_hist hist
     left join lectmeteo.lect_etat etat 
            on etat.temps_lect = hist.temps_lect
		   and etat.instrument_id = case
    when hist.location = 'Bureau' then 16
    when hist.location = 'Chambre' then 21
    when hist.location = 'ChambreFroide' then 24
	when hist.location = 'Cuisine' then 2
    when hist.location = 'Extension' then 20
    when hist.location = 'Estension_old2' then 9
    when hist.location = 'Garage' then 13
    when hist.location = 'Inconnu' then 5
    when hist.location = 'Mobile' then 5
    when hist.location = 'Mobile-1' then 5
    when hist.location = 'Patio' then 3
	when hist.location = 'Refrigerateur' then 19
	when hist.location = 'Remise' then 15
	when hist.location = 'Sous-sol' then 12
    else cast(hist.location as signed)
end
where hist.location != '0'
  and hist.temps_lect between '2018-09-01' and '2018-09-25'
order by hist.temps_lect desc
            
                 LIMIT %s''' % self._taille_max)

    def iterer(self):
        resultat = self._cursor.fetchmany(size=self._taille_batch)

        while len(resultat) > 0:

            for ligne in resultat:
                ligne_dict = self.traiter_ligne(ligne)
                transaction = self.preparer_transaction(ligne_dict)
                self.transmettre_transaction(transaction)

            resultat = self._cursor.fetchmany(size=self._taille_batch)

    def traiter_ligne(self, ligne):
        ligne_dict = dict(zip(self._cursor.column_names, ligne))
        #print('Ligne dict: %s' % str(ligne_dict))

        # Convertir Decimal en float
        key_to_delete = []
        for key, value in ligne_dict.items():

            if isinstance(value, Decimal):
                ligne_dict[key] = float(value)
            elif isinstance(value, datetime.datetime):
                ligne_dict[key] = int(value.timestamp())
            elif value is None:
                key_to_delete.append(key)

        for key in key_to_delete:
            del(ligne_dict[key])

        return ligne_dict


    def preparer_transaction(self, transaction):

        transaction_header = {
            'estampille': transaction['temps_lecture'],
            'uuid-transaction': str(uuid.uuid1())
        }

        transaction_header.update(self._transaction_header)
        transaction_charge = transaction

        transaction_charge['noeud'] = 'cuisine.maple.mdugre.info'

        transaction_message = {
            'charge-utile': transaction_charge,
            'info-transaction': transaction_header
        }

        message_utf8 = json.dumps(transaction_message, sort_keys=True, ensure_ascii=False)

        #print("JSON output transaction: %s" % message_utf8)

        return message_utf8

    def transmettre_transaction(self, message):
        self._channel.basic_publish(exchange='millegrilles.evenements',
                              routing_key='sansnom.transaction.nouvelle',
                              body=message,
                              properties=pika.BasicProperties(delivery_mode=2))


# --- MAIN ---

def main():
    importer = ImportDataToTransaction()
    importer.executer()


main()
