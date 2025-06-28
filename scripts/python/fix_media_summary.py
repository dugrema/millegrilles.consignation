from pymongo.database import Database


def fix_media_summary(db: Database):
    collection_media = db['GrosFichiers/media']
    cursor_media = collection_media.find({"images.small.header": {"$exists": True}})

    collection_fichiersrep = db['GrosFichiers/fichiersRep']
    collection_comments = db['GrosFichiers/fileComments']

    count = 0

    for media in cursor_media:
        # print(f"Media: {media}")
        fuuid = media["fuuid"]
        cursor_fichierrep = collection_fichiersrep.find({"fuuids_versions.0": fuuid})
        for fichierrep in cursor_fichierrep:
            # print(f"Fichier rep: {fichierrep}")
            tuuid = fichierrep['tuuid']
            try:
                image_type = fichierrep['mimetype'].startswith('image/')
                if image_type and fichierrep.get('flag_summary') is not False:
                    comment = collection_comments.find_one({"tuuid": tuuid})
                    if not comment:
                        print(f"No comment for tuuid:{tuuid}")
                        count += 1
                        # collection_fichiersrep.update_one({"tuuid": tuuid}, {"$set": {"flag_summary": False}})
            except (KeyError, AttributeError):
                pass

    print(f"Counted {count} files")
