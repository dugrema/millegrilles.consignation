import tempfile

import pymongo
from pymongo import MongoClient
from pymongo.database import Database

MILLEGRILLES_PATH = '/var/opt/millegrilles'

IDMG_FILE  = f'{MILLEGRILLES_PATH}/configuration/idmg.txt'
CONST_CA   = f'{MILLEGRILLES_PATH}/configuration/pki.millegrille.cert'
CONST_CERT = f'{MILLEGRILLES_PATH}/secrets/pki.mongo.cert'
CONST_KEY  = f'{MILLEGRILLES_PATH}/secrets/pki.mongo.key'

def mg_mongo_connect() -> (MongoClient, Database):
    with tempfile.NamedTemporaryFile('w+') as keyfile:
        # Prepare
        with open(CONST_KEY) as file:
            keyfile.write(file.read())
        with open(CONST_CERT) as file:
            keyfile.write(file.read())
        keyfile.write('\n')
        keyfile.flush()

        keypath = keyfile.name
        myclient = pymongo.MongoClient(
            f"mongodb://localhost:27017/",
            tls=True, tlsCaFile=CONST_CA, tlsCertificateKeyFile=keypath,
            authMechanism="MONGODB-X509")

    with open(IDMG_FILE) as file:
        idmg = file.read().strip()
    db = myclient[idmg]
    return myclient, db


def main():
    client, db = mg_mongo_connect()
    is_primary = client.is_primary
    print(f"Connection Test: OK\nPrimary: {is_primary}")

if __name__ == '__main__':
    main()
