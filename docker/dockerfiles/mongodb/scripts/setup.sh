#!/bin/bash

echo "Installation de mongodb pour MilleGrilles"
echo "APP_SOURCE_DIR = $APP_SOURCE_DIR"
echo "APP_BUNDLE_DIR = $APP_BUNDLE_DIR"

mkdir -p $APP_BUNDLE_DIR

echo "Fichiers dans $APP_BUNDLE_DIR :"
find $APP_BUNDLE_DIR

# Cleanup
rm -rf $APP_SOURCE_DIR

echo "Installation completee"