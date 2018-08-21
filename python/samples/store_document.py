#!/usr/bin/python3

# Consignation d'une transaction

import datetime
from pymongo import MongoClient

client = MongoClient('localhost', 27017, username="root", password="example")
print("Verify if connection established")
client.admin.command('ismaster')
print("Connection is established")

db = client["mg-consignation-dev1"]
collection = db.transactions

post = {"author": "Mike",
        "text": "My first blog post!",
        "tags": ["mongodb", "python", "pymongo"],
        "date": datetime.datetime.utcnow()}

post_id = collection.insert_one(post).inserted_id

print("Post_id: %s" % post_id)
