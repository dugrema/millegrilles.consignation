# MilleGrilles : format des messages

## Structure

Inspire par nostr

Exemple de message

```{
  "id": "b9fead6eef87d8400cbc1a5621600b360438affb9760a6a043cc0bddea21dab6",
  "pubkey": "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",
  "estampille": 1681650062,
  "kind": 8,
  "routage": {"action": "fichePublique", "domaine": "CoreTopologie", "partition": "ZABC1"},
  "origine: "zeYncRqEqZ6eTEmUZ8whJFuHG796eSvCTWE4M432izXrp22bAtwGm7Jf",
  "dechiffrage": {
    "format": "mgs4",
    "header": "m6Y9EbvfEzN2FVz3sIkwQpAErewQBs4bi",
    "hachage": "zSEfXUCRKy4K356KmLo6ETupg6h8Tc3ctvpdbpGzfytmX9WTcptULHEyhozcRm29iocKtMheYgVuxDNPe4KQnxc8k7F4U4" 
  },
  "pre-migration": {
    estampille: 1671554193,
    id: "5d0ef4c0-94de-4141-8954-7f006cbbbcfd",
    pubkey: "10319064594e3990f78a35b288c83b33029ebab0e14206ea92908985022905a9" 
  },
  "contenu": "{\"Champ\":\"valeur\"}",
  "sig": "908a15e46fb4d8675bab026fc230a0e3542bfade63da02d542fb78b2a8513fcd0092619a2c8c1221e581946e0191f2af505dfdf8657a414dbca329186f009262",
  "certificat": [
     "-----BEGIN CERTIFICATE-----\nMIIClDCCAkagAwIBAgIUdkc2yl6WSpl ... +GFuCp92IBw==\n-----END CERTIFICATE-----\n",
     "-----BEGIN CERTIFICATE-----\nMIIBozCCAVWgAwIBAgIKBBdSWFdJiDN ... A6bAfGc7dGHsL\n-----END CERTIFICATE-----\n" 
  ],
  "millegrille": "-----BEGIN CERTIFICATE-----\nMIIBQzCB9qADAgECAgo ... H94CH4d1VCPwI\n-----END CERTIFICATE-----",
  "attachements": {
    "cles": {
      "fingerprint cert destinataire 1": "cle dechiffrage",
      "fingerprint cert destinataire 2": "cle dechiffrage" 
    }
  }
}
```

## Enveloppe d'un message

Voici les éléments qui peuvent être présents a la base d'un message. Les éléments possibles dépendent de la sort (kind)
du message.

- id
- pubkey
- estampille
- kind
- routage
- origine
- dechiffrage
- pre-migration
- contenu
- sig
- certificat
- millegrille
- attachements

### Champ id

Hachage blake2s (32 bytes) encodé en hexadécimal d'une partie du contenu de l'enveloppe.

Les champs utilisés pour le hachage dépendent du kind. Les valeurs des champs sont mis dans un array json et le hachage est calculé sur la valeur json-str en utf-8.

Pour un kind:0 on calculerait le hachage du contenu suivant :

```array_champs = ["6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",1681650062,0,"{\"Champ\":\"valeur\"}"]```

Pour les champs en format dictionnaire (e.g. routage, chiffrage), il faut utiliser un algorithme de tri des noms de champs pour toujours obtenir le même ordre. Dans le routage l'ordre des champs doit toujours être action,domaine[,partition].

Exemple de kind:1

```array_champs = ["6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",1681650062,0,"routage":{"action":"fichePublique","domaine":"CoreTopologie","partition":"ZABC1"},"{\"Champ\":\"valeur\"}"]```

| Language    | Methode                                                                             |
|-------------|-------------------------------------------------------------------------------------|
| Python      | json.dumps(array_champs, *sort_keys=True*, *separators=(',', ':')*)                 |
| Javascript  | utiliser module *npm 'json-stable-stringify'* : stringify(array_champs).normalize() |
| Rust        | todo                                                                                |

### Champ pubkey

Clé publique ed25519 du certificat utilisé pour signer le message. Le champ pubkey agit aussi comme identificateur de certificat (fingerprint) pour identifier le module d'origine du message.

### Estampille

Valeur epoch en secondes (int).

### Kind

Sorte d'enveloppe de messages.

| Kind | Description                | Champs hachage                                                   | Format contenu                              |
|------|----------------------------|------------------------------------------------------------------|---------------------------------------------|
| 0    | Document                   | pubkey, estampille, kind, contenu                                | json string                                 |
| 1    | Requete                    | pubkey, estampille, kind, routage, contenu                       | json string                                 |
| 2    | Commande                   | pubkey, estampille, kind, routage, contenu                       | json string                                 |
| 3    | Transaction                | pubkey, estampille, kind, routage, contenu                       | json string                                 |
| 4    | Réponse                    | pubkey, estampille, kind, contenu                                | json string                                 |
| 5    | Évenement                  | pubkey, estampille, kind, routage, contenu                       | json string                                 |
| 6    | Réponse chiffrée           | pubkey, estampille, kind, dechiffrage, contenu                   | json string + gzip + mgs4 + unpadded base64 |
| 7    | Transaction migrée         | pubkey, estampille, kind, routage, pre-migration, contenu        | json string                                 |
| 8    | Commande inter-millegrille | pubkey, estampille, kind, routage, origine, dechiffrage, contenu | json string + gzip + mgs4 + unpadded base64 |

### Routage

Information de routage du message. Utilisé pour le traitement dans les applications.

Champs supportés

* domaine : le nom du domaine ou module qui va effectuer le traitement (e.g. GrosFichiers, Documents, fichiers, CoreTopologie)
* action : l'action ou commande a exécuter (e.g. sauvegarder, listeFichiers, rechiffrerCle)
* partition : optionnel, représente un module qui écoute pour une instance, un usager, etc.

### Origine

Identificateur de MilleGrille (IDMG) d'origine du message. L'identificateur est un hachage en blake2s du certificat de MilleGrille avec un byte de version et un code multihash. Cette valeur calculée permet de s'assurer d'utiliser le bon certificat CA lors de la validation d'un message inter-millegrille.

### Déchiffrage

Information de déchiffrage. Variable, peut inclure des paramètres pour algorithme de déchiffrages (tag, header, iv), des clés chiffrées et des identificateurs pour retrouver les clés de déchiffrage.

Champs : 

| Champ  | Description                                                                                              |
|--------|----------------------------------------------------------------------------------------------------------|
| format | le format de chiffrage (e.g. mgs4 => algorithme libsodium stream xchacha20-poly1305 avec blocks de 64kb) |
| header | optionnel - header de déchiffrage (e.g. mgs4)                                                            |
| iv     | optionnel - nonce de déchiffrage                                                                         |
| tag    | optionnel - tag de déchiffrage                                                                           |
| cles   | optionnel - cles en format { pubkey_1: clé chiffrée ed25519 format multibase, pubkey_2: ... }            |
| cle    | optionnel - cle unique chiffrée ed25519 format multibase. Utilisé pour kind:6 (réponse chiffrée)         |

### Pre-migration

Le champ pre-migration est utilisé lors d'une migration de transactions d'un backup vers une nouvelle MilleGrille ou un 
nouveau format d'enveloppe de messages. L'information du champ est utilisée lors de la régénération du contenu de chaque 
domaine pour associer les identificateurs correctement. 

### Contenu

C'est le contenu utile du message (payload). Le contenu est toujours conservé en format texte mais l'encodage dépend du 
kind de l'enveloppe. Pour les kinds 6 et 8, le contenu est compressé (gzip), chiffré (e.g. mgs4) et conservé en unpadded 
base64. Pour les autres kinds, le contenu est en json-str.

*Raison de l'utilisation du format texte :*

Le format texte est utilisé pour éviter les erreurs de conversion qui peuvent survenir entre différents systèmes lors du
calcul du hachage. Exemple d'erreur : la représentation de valeurs float64 sont différentes en python, javascript et 
rust. Lors d'une vérification de message, la conversion du message d'origine vers un json-str peut donner un résultat 
différent. Le format de stockage en texte évite ce problème.

### sig

Signature ed25519 en format hexadécimal du id (les 32 bytes du hachage blake2s) avec la clé du certificat. Utilisé pour la non-répudiation. 

Un message avec une signature invalide doit être rejeté.

### Certificat

Champ optionnel qui contient la chaine du certificat en format PEM utilisé pour signer le message. Le certificat de MilleGrille (CA) *ne doit pas* être inclus dans la liste.

Ce champ n'est pas inclus dans le calcul du id (hachage).

### Millegrille

Champ optionnel avec le certificat en format PEM de la MilleGrille. Ce certificat est utilisé comme CA pour valider la chaine du certificat.

Ce champ n'est pas inclus dans le calcul du id (hachage).

### Attachements

Champ optionnel utilisé pour inclure du contenu volatil qui n'est pas inclus dans le calcul du id (hachage). Le contenu 
des attachements doit pouvoir être validé indépendamment du message puisqu'il ne peut pas être vérifié par la signature 
de l'enveloppe.

Les attachements peuvent être des enveloppes signées. Par exemple dans la Messagerie, les messages inter-millegrilles 
(kind:8) incluent un attachement de routage individualisé pour chaque MilleGrille de destination. Chaque attachement est 
à son tour un message inter-millegrille signé qui peut être validé et déchiffré par la MilleGrille de destination.

## Catégories de message

Le kind va explicitement représenter une de ces catégories de messages.

- Document
- Requête
- Commande
- Transaction
- Réponse
- Événement

Les documents ne sont pas routables dans le système de message MQ.

Le requetes, commande et transactions visent un module d'exécution en particulier. 

Une réponse vise un demandeur en particulier. La réponse peut être chiffrée (kind:6) en utilisant la clé publique du 
certificat du demandeur (pubkey de la requète ou commande).

### Requêtes

Une requête est un message émis par un module système ou un usager pour obtenir de l'information d'un autre domaine ou
module. La requête est asynchrone et doit générer une réponse. 

### Réponses

La réponse est un message qui cible un demandeur particulier. 

Sources des réponses :
- une requête doit générer une réponse,
- une commande peut fournir une réponse (optionnel selon la logique).

En cas d'erreur, la réponse doit être {"ok": false}.

### Données volatiles et persistentes

MilleGrilles distingue deux types de données dans la base de données : volatile et persistente. 

Les données volatiles sont générées à partir d'intéractions avec les domaines (commandes ou événement). Ces données
sont perdues si le système est régénéré (par exemple sur restauration d'un backup). Les données volatiles devraient 
généralement pouvoir être recrées à partir d'information courante sur le système.

Les données persistentes sont des données qui doivent être conservées entre les redémarrages du système ou après
restauration d'un backup.

Exemples de données volatiles dans la base de données : 

- température courante d'un senseur,
- transferts de fichiers en cours.

Exemples de données persistentes :

- information d'un fichier (nom, date, taille, etc.),
- lectures d'un senseur de température,
- compte usager.

Les données persistentes sont conservées sous forme de transactions (message kind: 3) ou sous forme de commandes 
(kind: 2) qui ont été validées avant d'être traitées selon le même processus que des transactions.

### Rôle des transactions

Les transactions servent à modifier la base de données d'un seul domaine. Les transactions sont des messages de 
traitement internes qui devraient être traités par des modules de niveau de sécurité 3.protégé ou 4.sécure. 

Particularité :

- atomiques : tout ou rien,
- pas de commandes : aucuns effets secondaires sur d'autres domaines,
- pas de requêtes : données entièrement contenues dans la transaction et la base de données du même domaine.

Une transaction ne doit pas générer de nouvelles données à partir de sources externes au domaine. Si de nouveaux 
identificateurs doivent être générés, ils doivent pouvoir être recrées exactement à chaque ré-execution de la transaction.
Si un procédé a besoin d'un identificateur aléatoire, il faut l'executer sous forme de commande et générer une nouvelle
transaction comme résultat du procédé. Cette transaction va conserver le nouvel identificateur et toujours donner le
même résultat.

Exemples de traitements à éviter : 

- traitement avec un nom d'usager mais la logique requiers une requête pour trouver le user_id sur un autre domaine.
- conserver un fichier chiffré mais la clé de chiffrage est générée dans la transaction.

Pour éviter ces situations, utiliser une commande pour effectuer le traitement et sauvegarder le résultat avec une
ou plusieurs transactions. Une commande peut émettre des transactions vers plusieurs domaines.

## Hachage et signature

