from pymongo.database import Database


def fix_media_summary(db: Database):
    collection_media = db['GrosFichiers/media']
    collection_fichiersRep = db['GrosFichiers/fichiersRep']

    count = 0

    pipeline = [
        # {"$match": {"images.small.nonce": {"$exists": True}}},
        # {"$project": {"fuuid": 1}},
        # {"$lookup": {
        #     "from": "GrosFichiers/fichiersRep",
        #     "localField": "fuuid",
        #     "foreignField": "fuuids_versions.0",
        #     "as": "fichiersrep",
        #     "pipeline": [
        #         {"$project": {"tuuid": 1, "mimetype": 1, "flag_summary": 1, "supprime": 1}}
        #     ]
        # }},
        # {"$match": {"fichiersrep.supprime": False, "fichiersrep.flag_summary": True, "fichiersrep.mimetype": {"$regex": "^image/"}}},
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
        {"$match": {"comments.0": {"$exists": False}}}
    ]

    # cursor_media = collection_media.aggregate(pipeline)
    # for media in cursor_media:
    #     # print(media)
    #     fichiersrep = media['fichiersrep'][0]
    cursor_fichiersrep = collection_fichiersRep.aggregate(pipeline)
    for fichiersrep in cursor_fichiersrep:
        # print(fichiersrep)
        tuuid = fichiersrep['tuuid']

        if len(fichiersrep['comments']) == 0:
            print(tuuid)
            count += 1
            # collection_fichiersrep.update_one({"tuuid": tuuid}, {"$set": {"flag_summary": False}})


    print(f"\n-------\nCounted {count} files\n-------")
