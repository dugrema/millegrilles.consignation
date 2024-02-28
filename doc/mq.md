# MilleGrilles : bus MQ

## Routing keys

Les messages sont acheminés aux consommateurs en utilisant un routing avec consommateurs enregistrés sur routing key. 
La seule exception est la réponse : elle est acheminé directement via la Q du demandeur.

Formats de la routing key :

- categorie.domaine.action
- categorie.domaine.partition.action

Le domaine peut-être un pseudo-domaine (backup, certificat, fichiers, global, servicemonitor, etc.). Les pseudo-domaines 
commencent par une minuscule et représentent des appareils ou composants qui peuvent réagir à des commandes, requêtes 
ou événements. Les pseudo-domaines ne peuvent pas traiter les transactions.

Par exemple :

- transaction.Pki.nouveauCertificat
- evenement.GrosFichiers.ff7db38a-111a-4df5-8e96-69648f0d55ba.ajoutPreview
- requete.certificat.zQmPeUEL12hBStW59BvKrvmEJGiV5P5WzrCyqx7Px158Yxu
- commande.fichiers.transcoderVideo

Les consommateurs vont s'enregistrer sur les exchanges en fonction de la sécurité d'émission du message 
(1.public, 2.prive, 3.protege ou 4.secure) et écouter avec ces routing keys.
