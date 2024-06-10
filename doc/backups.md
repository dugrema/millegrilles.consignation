# MilleGrilles : backup

## Module de backup

Le module _backup_ est responsable du backup des **transactions** (base de données). Il doit être installé lors de la 
création d'une nouvelle MilleGrille. Le module est disponible dans Coup D'Oeil et peut être installé sur une instance
3.protege ou 4.secure.

Les fichiers de backup sont conservés par domaine (e.g. CorePki, GrosFichiers, SenseursPassifs). Seule la clé de
MilleGrille peut déchiffrer leur contenu. L'instance avec le module de backup les conserve sous :

`/var/lib/docker/volumes/millegrilles-backup/_data`

Les fichiers de backup sont régulièrement propagés à toutes les instances du module de consignation "fichiers".

Un backup complet est fait à toutes les semaines. Un backup incrémental est fait à toutes les heures.

## Backup des fichiers

Le module de backup n'est pas responsable du backup des fichiers - il s'occupe uniquement des transactions (bases de 
données).

Le module de consignation de fichiers (`fichiers`) est responsable de conserver les fichiers **et les copies de backup**.

## Migrer une MilleGrille

La migration d'une MilleGrille s'effectue avec la création d'un nouveau certificat de MilleGrille et la restoration
des backups provenant d'une autre MilleGrille. 

Raisons pour une migration : 

- la clé de MilleGrille a été volée,
- la clé de MilleGrille va expirer (durée 20 ans),
- la structure des messages a changée (e.g. nouvelle version de MilleGrilles)

