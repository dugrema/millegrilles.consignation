import datetime

from pymongo.database import Database

from mongo_script import mg_mongo_connect


def run(db: Database):
    collection_fichiersrep = db['GrosFichiers/fichiersRep']

    count = 0

    pipeline = [
        {"$match": {"supprime": False, "flag_summary": True, "type_node": "Fichier", "mimetype": {"$regex": "^image/"}}},
        {"$lookup": {
            "from": "GrosFichiers/fileComments",
            "localField": "tuuid",
            "foreignField": "tuuid",
            "as": "comments",
            "pipeline": [
                {"$project": {"comment_id": 1}}
            ]
        }},
        {"$match": {"comments.0": {"$exists": False}}},
        # {"$limit": 20}
    ]

    cursor_fichiersrep = collection_fichiersrep.aggregate(pipeline)
    for fichiersrep in cursor_fichiersrep:
        # print(fichiersrep)
        tuuid = fichiersrep['tuuid']

        print(tuuid)
        count += 1
        # collection_fichiersrep.update_one({"tuuid": tuuid}, {"$set": {"flag_summary": False}})


    print(f"\n-------\nCounted {count} files\n-------")


def main():
    _client, db = mg_mongo_connect()
    run(db)


if __name__ == '__main__':
    start = datetime.datetime.now()
    print(f"Started: {start}")
    main()
    duration = datetime.datetime.now() - start
    print(f"Duration: {duration}")
