import tempfile
from fix_media_summary import fix_media_summary

import pymongo

CONST_CA = '/var/opt/millegrilles/configuration/pki.millegrille.cert'
CONST_CERT = '/var/opt/millegrilles/secrets/pki.mongo.cert'
CONST_KEY = '/var/opt/millegrilles/secrets/pki.mongo.key'

def connect(keyfile: tempfile.NamedTemporaryFile):
    with open(CONST_KEY) as file:
        keyfile.write(file.read())
    with open(CONST_CERT) as file:
        keyfile.write(file.read())
    keyfile.write('\n')
    keyfile.flush()

    keypath = keyfile.name
    myclient = pymongo.MongoClient(f"mongodb://localhost:27017/", tls=True, tlsCaFile=CONST_CA, tlsCertificateKeyFile=keypath, authMechanism="MONGODB-X509")
    return myclient


def run(client):
    db = client["zbaTeMFXpvuALGcPLx7UYFjW2oCz8fbDpyyse5boZB22VX8NvSQfMaSR"]
    fix_media_summary(db)


def main():
    with tempfile.NamedTemporaryFile('w+') as keyfile:
        client = connect(keyfile)
    run(client)


if __name__ == '__main__':
    main()
