# MilleGrilles : cryptographie

## Signatures

| Version | Algorithme |
|---------|------------|
| 1       | Obsolete   |
| 2       | Ed25519    |

## Chiffrage symmétrique

| Version | Algorithme                           |
|---------|--------------------------------------|
| mgs1    | AES256-CBC                           |
| mgs2    | AES256-GCM                           |
| mgs3    | chacha20-poly1305                    |
| mgs4    | chacha20-poly1305 (libsodium stream) |

Les versions mgs1, mgs2 et mgs3 sont obsoletes.

## Chiffrage asymmétrique des clés

Les clés sont chiffrées avec X25519. 

Le chiffrage asymmétrique utilise la clé publique format Ed25519 de la MilleGrille et la converti
en format X25519 pour l'utiliser comme public-peer dans le chiffrage. 

Méthode 1

Pré-requis : la clé secrète n'a pas encore été générée.

Une clé privée X25519 est générée et sa partie publique est stockée comme clé de déchiffrage. Ceci permet de 
conserver la clé de déchiffrage dans un format restreint (32 bytes). 

Un secret est généré en combinant la clé privée et la clé publique peer. Ce secret est haché une fois avec Blake2s 
pour générer la clé secrète symmétrique à utiliser.

Le déchiffrage fonctionne d'une manière similaire - on prend la clé privée de la MilleGrille et la clé publique peer
stockée comme clé asymmétrique. On combine ces deux clés pour obtenir un secret et on hache le résultat avec Blake2s. 
Le résultat est la même valeur que la clé secrète symmétrique précédente.

Méthode 2

Pré-requis : la clé secrète a déjà été générée.

Lorsqu'il n'est pas possible d'utiliser la clé de MilleGrille directement comme peer pour générer un secret, une clé de 
chiffrage intermédiaire est utilisée pour chiffrer la clé secrète et cette clé est chiffrée à son tour avec 
chacha20-poly1305. Le nonce (IV) de chiffrage est (...vérifier, c'était la clé publique ou bien un hachage de la clé 
publique).

Le stockage de cette clé asymmétrique prend 80 bytes, soit plus de 2 fois plus de place que la version simple :

- 32 bytes de clé peer intermédiaire
- 32 bytes de secret chiffré
- 16 bytes de tag pour vérifier le chiffrage
