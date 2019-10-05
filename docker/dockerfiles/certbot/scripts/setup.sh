#!/bin/sh

echo "Copie des fichiers vers $APP_BUNDLE_DIR"
mkdir -p $APP_SOURCE_DIR $APP_BUNDLE_DIR

echo "Installation des programmes MilleGrilles Python"
cd $APP_SOURCE_DIR/tmp/MilleGrilles.consignation.python
python3 setup.py install
pip3 install -r requirements.txt

cd $APP_SOURCE_DIR/tmp/MilleGrilles.deployeur
python3 setup.py install
pip3 install -r requirements.txt

cp $APP_SOURCE_DIR/tmp/MilleGrilles.deployeur/bin/*.py $APP_BUNDLE_DIR

echo "Suppression du folder $APP_SOURCE_DIR"
# rm -rf $APP_SOURCE_DIR

apt update
apt install certbot -y

echo "Setup termine"
