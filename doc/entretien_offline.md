# Préparation et entretien offline

x86_64

1. Ubuntu LTS le plus récent, avec upgrades pour les packages sur x84_64 (debs)
2. Packages (debs) pour l'environnement de développeemnt sur x86_64
3. Rust
4. NodeJS, et NodeJS headers
5. Snaps pour les logiciels de développement
6. Contenu du répertoire backup/offline de jenkins (sur jenkins2)

aarch64

1. RaspberryPi OS pour aarch64 le plus récent, avec upgrades pour les packages (debs)
2. Rust
3. Contenu du répertoire backup/offline de jenkins (sur pi-dev7)

## Préparer les archives debs pour l'upgrade systeme

Utiliser un système qui vient juste d'être réinstallé (Ubuntu, RaspberryPi).

Appliquer cette variale d'environnement a chaque redémarrage.
`export PATH_WORK=~/work/offline`

<pre>
echo "Downloader toutes les archives .deb pour l'ugrade sous $PATH_WORK"
mkdir -p $PATH_WORK/debs/1.upgrade
sudo apt update && sudo apt upgrade -dy
sudo mv /var/cache/apt/archives/*.deb $PATH_WORK/debs/1.upgrade

# ** Desactiver la connexion reseau **
echo "Effectuer upgrade"
sudo dpkg -i $PATH_WORK/debs/1.upgrade/*.deb
</pre>

Appliquer correctifs, downloads au besoin. Pour Ubuntu 22.04.3 LTS : 
<pre>
# ** Activer la connexion reseau **
sudo apt install -d --fix-broken
sudo mv /var/cache/apt/archives/*.deb $PATH_WORK/debs/1.upgrade
# ** Desactiver la connexion reseau **

sudo dpkg -i $PATH_WORK/debs/1.upgrade/libpam*
sudo dpkg -i $PATH_WORK/debs/1.upgrade/libreoffice-core*
sudo apt install --fix-broken

# Repeter cette etape tant qu'il reste des packages a downloader
</pre>

Redémarrer.

## Preparer les archives debs pour MilleGrilles

Preparer packages requis par MilleGrilles. Ceci couvre le développement et l'utilisation de MilleGrilles.

<pre>
mkdir -p ~/work/offline/debs/2.millegrille

# ** Activer la connexion reseau **
sudo apt install -dy ssh docker.io \
python3-pip python3-venv python3.10-venv \
cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
# ** Desactiver la connexion reseau **

sudo mv /var/cache/apt/archives/*.deb $PATH_WORK/debs/2.millegrille

sudo dpkg -i $PATH_WORK/debs/2.millegrille/*.deb
</pre>

Redémarrer.

## Downloader les snaps

Ce sont les logiciels de développement (IDE) sous Linux.

<pre>
# ** Activer la connexion reseau **
mkdir -p $PATH_WORK/snaps
snap download --target-directory $PATH_WORK/snaps core18
snap download --target-directory $PATH_WORK/snaps code 
snap download --target-directory $PATH_WORK/snaps pycharm-community
snap download --target-directory $PATH_WORK/snaps --edge rustrover
snap download --target-directory $PATH_WORK/snaps core
snap download --target-directory $PATH_WORK/snaps sqlitebrowser
snap download --target-directory $PATH_WORK/snaps gnome-3-34-1804
snap download --target-directory $PATH_WORK/snaps thonny

# Downloads optionnels
snap download --target-directory $PATH_WORK/snaps chromium
snap download --target-directory $PATH_WORK/snaps core20
snap download --target-directory $PATH_WORK/snaps core22
snap download --target-directory $PATH_WORK/snaps cups
snap download --target-directory $PATH_WORK/snaps gimp
snap download --target-directory $PATH_WORK/snaps notepadqq
snap download --target-directory $PATH_WORK/snaps vlc

# ** Desactiver la connexion reseau **
</pre>

## Downloader logiciels de développement

Downloader les plus récentes versions de Rust et npm.

Rust : https://forge.rust-lang.org/infra/other-installation-methods.html

Aller dans la section Standalone installers. Downloader les versions stable :

* aarch64-unknown-linux-gnu	
* x86_64-unknown-linux-gnu

NodeJS : https://nodejs.org/en/download/

Downooader les versions LTS suivantes : 

* Linux Binaries x64
* Linux Binaries ARMv8
