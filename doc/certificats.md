# MilleGrilles : certificats

Les certificats sont générés pour chaque module qui doit intéragir sur la MilleGrille. 

Un certificat est utilisé pour l'authentification du module. Il permet de s'authentifier sur le bus MQ et sur des 
systèmes de transferts de fichier en utilisant le protocole TLS. Les messages transportés sur le bus MQ ou échangés
directement entre modules de la MilleGrilles (e.g. bluetooth) sont signés par un certificat pour garantir l'origine.

Un certificat valide : 

- n'est pas expiré
- correspond à la MilleGrille

Ces modules peuvent être des agents d'entretien de serveur (e.g. mginstance, midcompte), des applications web (e.g. 
collections, senseurspassifs_web), des usagers (role usager), etc. Chaque module se fait attribuer un certificat lors
de sa création et possède une méthode pour renouveller le certificat avant expiration.

Le module certissuer possède une clé intermédiaire qui lui permet de signer tous les certificats requis par la 
MilleGrille. Ce module est accessible par le port http 2080 sur une instance 3.protege ou 4.secure. Le certificat
intermédiaire a une durée de 18 mois et doit être renouveller manuellement avec la clé de MilleGrille. 

## Types de certificats

1. Certificat de MilleGrille
2. Certificat intermédiaire
3. Certificat de module
4. Certificat d'usager

### Certificat de MilleGrille

La création du certificat de MilleGrille est la première action effectuée à l'installation d'une MilleGrille. Une clé 
privée Ed25519 est chiffrée avec un mot de passe et conservée avec le nouveau certificat self-signed dans un fichier sur 
la deuxième page de l'installeur (https://*serveur_protégé*/installation). Le certificat self-signed devient le 
certificat racine (root) de la MilleGrille et sert à calculer l'identificateur de la MilleGrille (IDMG).

Le certificat de MilleGrille expire après 20 ans et ne peut pas être renouvellé. Si la MilleGrille est encore en
utilisation, il faut la migrer vers un nouveau certificat de MilleGrille en utilisant l'option de migration avec la 
restoration de backup.

La clé de MilleGrille (et son mot de passe) sont requis pour :

- Créer un premier compte propriétaire (administrateur)
- Installer de nouvelles instances 4.sécure ou migrer vers une nouvelle instance 3.protégé
- Renouveller le certificat intermédiaire d'instances 3.protégé et 4.sécure
- Restorer le système avec les backups chiffrés
- Migrer le système vers une nouvelle MilleGrille

*Avertissements*

Si la clé de MilleGrille est perdue, il n'y a aucune façon de la récupérer. La MilleGrille cessera éventuellement de 
fonctionner lorsque le dernier certificat intermédiaire va expirer ou dès que l'instance serveur 3.protégé est endommagé.

La clé du certificat de MilleGrille (fichier ou code QR) et son mot de passe sont des outils 
d'administration sans restriction. Ils donnent accès à toutes les données et toutes les actions de la MilleGrille. 
Ces deux éléments doivent être conservés dans un endroit sécuritaire mais accessible en cas de besoin. 

Si la clé de MilleGrille est volée, il faut rapidement migrer vers une nouvelle MilleGrille. Voir le cas migration dans
le document MilleGrille : backups.

### Certificat intermédiaire

Lors de l'installation d'une instance serveur de type 3.protégé ou 4.sécure, la clé de MilleGrille est utilisée pour
générer un certificat intermédiaire. Ce certificat est utilisé par le module certissuer pour signer tous les certificats
de modules requis par la MilleGrille.

Le certificat intermédiaire est valide pour 18 mois. Il peut être renouvellé en tout temps avec la clé de MilleGrille
et l'application d'installation (https://*serveur*/installation).

### Certificat de module

Tous les modules sur la MilleGrille reçoivent un certificat a leur installation. Ils ont aussi une méthode qui leur
permet de renouveller automatiquement leur certificat avant son expiration.

Sans certificat valide, il n'est pas possible d'émettre de messages (requetes, commandes, événements) sur la MilleGrille.

### Certificat usager

Les usagers d'une MilleGrille reçoivent un certificat durant l'authentification (login) de l'application /millegrilles. 
Ce certificat est conservé dans le navigateur. Ceci permet à un usager d'être authentifié auprès de tous les modules à 
partir de la signature électronique appliquée à chaque message.

La création du certificat est transparente et aucune action spéciale n'est requise de la part de l'usager. Voici les
actions qui produisent un nouveau certificat pour un usager :

- Créer un nouveau compte (inscription)
- Authentifier avec un passkey (appareil mobile, clé de sécurité USB)
- Activer sur un autre appareil à partir du même compte ou avec un compte propriétaire (administrateur)

Ce certificat est généré de la même façon que les autres certificats de modules, mais il a un role particulier (usager)
qui peut être validé à tout moment. Le certificat usager contient aussi le nom de l'usager (champ common name x.509) et
le userId (via une extension x.509).

Exemple de l'utilité du certificat usager : 

- Le userId n'a pas besoin d'être transmis avec une requête ou une commande. Le module de base de données utilise le certificat pour associer les données à l'usager.
- Un navigateur peut être authentifié directement avec un appareil bluetooth sans passer par le bus MQ ou wifi.
