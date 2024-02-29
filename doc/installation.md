# MilleGrilles : installation

## Système d'exploitation

MilleGrilles fonctionne sur debian linux.

## Installer docker

```
sudo apt install docker.io
```

## Installeur d'instance

Installer une instance. Elle pourra être configurée comme instance 3.protégé (ou n'importe quel autre types).

```
git clone https://github.com/dugrema/millegrilles.instance.python.git
cd millegrilles.instance.python
git submodule update --init etc/catalogues
./install.sh
```

## Finaliser setup

Cette partie n'est pas encore automatisée.

```
sudo cp etc/daemon.json /etc/docker
sudo systemctl restart docker
sudo systemctl enable mginstance
sudo systemctl restart mginstance
```

La préparation peut prendre un certain temps. Vérifier qu'il n'y a pas d'erreurs dans le fichier de logging :

`tail -100 /var/log/millegrilles/mginstance.log`

Ouvrir un navigateur vers : https://nom_serveur/installation

- Sélectionner sécurité 3.protégé
- Créer une nouvelle clé. Conserver le fichier et le mot de passe. Cliquer sur suivant.
- Entrer le mot de passe et fichier (c'est une étape de confirmation).
- Cliquer sur suivant.

Il n'y a pas de marqueurs de progrès. L'application mginstance va redémarrer plusieurs fois. Suivre le progrès
avec :

`tail -f /var/log/millegrilles/mginstance.log`

Il est possible de suivre l'installation des services avec : docker stats

Lorsque coupdoeil est demarre, MilleGrilles est prêt.

Redémarrer mginstance pour éviter quelques problèmes de connexion initiaux (bugs) :

`sudo systemctl restart mginstance`

## Créer un compte propriétaire

Ouvrir un navigateur vers : https://nom_serveur/millegrilles

Créer un compte. Par exemple : proprietaire.

Ajouter une méthode d'authentification forte avec le bouton Ajouter (clé). 
Aller le menu Compte / Administrer.
Mettre le mot de passe de la MilleGrille et uploader le fichier de clé.
Cliquer sur Mettre à jour le compte.

Le compte est maintenant un délégué global de type propriétaire (administrateur). L'application Coup D'Oeil devrait
être dans la liste des applications. C'est l'application d'administration de la MilleGrille.
