# MilleGrilles : sécurité

Les niveaux de sécurité reconnus dans MilleGrilles sont :

- 1.public
- 2.privé
- 3.protégé
- 4.sécure

Le niveau 1.public est le moins sécuritaire et 4.sécure est le plus sécuritaire.

## Instances

MilleGrilles a 4 types d'instance de serveurs. Chaque type correspond à un niveau de sécurité.

### Instance 1.public

L'instance publique peut seulement recevoir des modules de sécurité de niveau 1.public. Il doit se connecter au bus MQ
mais n'a accès qu'à l'exchange 1.public. 

Exemples de modules publics : 

- postmaster : service smtp pour émettre des courriels

### Instance 2.privé

L'instance privée peut servir à conserver les fichiers ou accueillir des usagers dans des applications web. Elle se 
connecte aux exchanges 1.public et 2.privé du bus MQ. Une instance privée peut recevoir tous les modules 2.privé ou
1.public. 

Exemples de modules privés :

- collection_web : interface web du file manager de MilleGrilles
- senseurspassifs_web : interface web du système de contrôle de microcontroleurs
- senseurspassifs_relai : relai http/websocket pour microcontroleurs
- documents_web : interface web pour documents chiffrés / password manager de MilleGrilles
- fichiers : file manager de MilleGrilles, reçoit et distribue les fichiers chiffrés
- maitrecomptes : page d'accès / login pour les usagers
- messagerie_web : notifications pour l'usager
- stream : streaming video et audio pour collection_web

### Instance 3.protégé

L'instance 3.protégé est un singleton d'une MilleGrille - il doit y en avoir une et une seule. 
Cette instance peut recevoir tous les modules requis pour le fonctionnement d'une MilleGrille. C'est aussi celle qui 
héberge le bus MQ (RabbitMQ) auquel tous les autres modules doivent se connecter.

L'instance 3.protégée peut recevoir tous les modules 1.public, 2.privé et 3.protégé.

Exemples de modules protégés :

- core : 4 domaines de base (certificats, comptes usagers, topologie, catalogues modules) requis par MilleGrilles
- coupdoeil : interface d'administration de MilleGrilles
- grosfichiers_backend : service de gestion du domaine et base de données GrosFichiers (collection/file manager de MilleGrilles)
- documents_backend : service de gestion du domaine et base de données Documents (password manager de MilleGrilles)
- messagerie_backend : notifications de MilleGrilles pour les usagers
- mq : Le bus MQ (RabbitMQ)
- mongo : Base de données utilisées par les domaines MilleGrilles
- backup : Backup des transactions
- media : Conversion de vidéos, création de thumbnails
