from pymongo.database import Database


def fix_media_summary(db: Database):
    collection_media = db['GrosFichiers/media']
    collection_fichiersrep = db['GrosFichiers/fichiersRep']
    collection_comments = db['GrosFichiers/fileComments']

    count = 0

    pipeline = [
        {"$match": {"images.small.nonce": {"$exists": True}}},
        {"$lookup": {
            "from": "GrosFichiers/fichiersRep",
            "localField": "fuuid",
            "foreignField": "fuuids_versions.0",
            "as": "fichiersrep"
        }},
        {"$match": {"fichiersrep.flag_summary": True}},
        {"$lookup": {
            "from": "GrosFichiers/fileComments",
            "localField": "fichiersrep.tuuid",
            "foreignField": "tuuid",
            "as": "comments"
        }},
    ]

    # cursor_media = collection_media.find({"images.small.header": {"$exists": True}})
    cursor_media = collection_media.aggregate(pipeline)
    for media in cursor_media:
        fichiersrep = media['fichiersrep'][0]
        tuuid = fichiersrep['tuuid']
        try:
            is_image = fichiersrep['mimetype'].startswith('image/')
        except (KeyError, AttributeError):
            continue
        if is_image and len(media['comments']) == 0:
            print(f"No comment for tuuid:{tuuid}")
            count += 1

    # print(f"Media: {media}")
        # fuuid = media["fuuid"]
        # cursor_fichierrep = collection_fichiersrep.find({"fuuids_versions.0": fuuid})
        # for fichierrep in cursor_fichierrep:
        #     # print(f"Fichier rep: {fichierrep}")
        #     tuuid = fichierrep['tuuid']
        #     try:
        #         image_type = fichierrep['mimetype'].startswith('image/')
        #         if image_type and fichierrep.get('flag_summary') is not False:
        #             comment = collection_comments.find_one({"tuuid": tuuid})
        #             if not comment:
        #                 print(f"No comment for tuuid:{tuuid}")
        #                 count += 1
        #                 # collection_fichiersrep.update_one({"tuuid": tuuid}, {"$set": {"flag_summary": False}})
        #     except (KeyError, AttributeError):
        #         pass

    print(f"Counted {count} files")
