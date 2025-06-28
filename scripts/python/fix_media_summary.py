from pymongo.database import Database


def fix_media_summary(db: Database):
    collection_media = db['GrosFichiers/media']

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

    print(f"Counted {count} files")
