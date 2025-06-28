from pymongo.database import Database


def fix_media_summary(db: Database):
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
        {"$limit": 20}
    ]

    cursor_fichiersrep = collection_fichiersrep.aggregate(pipeline)
    for fichiersrep in cursor_fichiersrep:
        # print(fichiersrep)
        tuuid = fichiersrep['tuuid']

        if len(fichiersrep['comments']) == 0:
            print(tuuid)
            count += 1
            # collection_fichiersrep.update_one({"tuuid": tuuid}, {"$set": {"flag_summary": False}})


    print(f"\n-------\nCounted {count} files\n-------")
