import argparse
import datetime

from argparse import Namespace
from time import sleep

from pymongo.collection import Collection
from pymongo.database import Database

from mongo_script import mg_mongo_connect

CONST_BATCH_SIZE = 50

def remaining(args: Namespace, db: Database):
    collection_fichiersrep = db['GrosFichiers/fichiersRep']

    count = 0

    # mimetype_match = "application/pdf"
    mimetype_match = {"$regex": "^image/"}
    # mimetype_match = {"$regex": "^video/"}

    pipeline = [
        {"$match": {
            "supprime": False, "flag_summary": True, "type_node": "Fichier",
            "mimetype": mimetype_match,
        }},
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
    ]

    if args.limit:
        # {"$limit": 20}
        pipeline.append({"$limit": args.limit})

    cursor_fichiersrep = collection_fichiersrep.aggregate(pipeline)
    batch_tuuids: list[str] = list()
    for fichiersrep in cursor_fichiersrep:
        count += 1

        if args.verbose:
            print(fichiersrep)

        if args.apply:
            tuuid = fichiersrep['tuuid']
            batch_tuuids.append(tuuid)
            if len(batch_tuuids) >= CONST_BATCH_SIZE:
                apply(collection_fichiersrep, batch_tuuids)
                batch_tuuids.clear()

    # Last batch
    if len(batch_tuuids) > 0:
        apply(collection_fichiersrep, batch_tuuids)
        batch_tuuids.clear()

    print(f"\n-------\nCounted {count} files\n-------")


def apply(collection: Collection, tuuids: list[str]):
    collection.update_many({"tuuid": {"$in": tuuids}}, {"$set": {"flag_summary": False}})
    for tuuid in tuuids:
        print(tuuid)


def count_processing(db: Database):
    collection_fichiersrep = db['GrosFichiers/fichiersRep']
    while True:
        try:
            count = collection_fichiersrep.count_documents({"flag_summary": False})
            current_date = datetime.datetime.now()
            print(f"{current_date} Entries currently processing: {count} files", end="\r")
            sleep(10)
        except KeyboardInterrupt:
            print()  # Leave the last entry on screen
            return


def run(args: Namespace, db: Database):
    if args.processing:
        count_processing(db)
    else:
        remaining(args, db)

def __parse_command_line():
    parser = argparse.ArgumentParser(description="Instance manager for MilleGrilles")
    parser.add_argument(
        '--verbose', action="store_true", required=False,
        help="More logging"
    )
    parser.add_argument(
        '--apply', action="store_true", required=False,
        help="Apply changes"
    )
    parser.add_argument(
        '--limit', type=int, required=False,
        help="Limit number of rows to fetch"
    )
    parser.add_argument(
        '--processing', action="store_true", required=False,
        help="Count number of currently processing entries"
    )

    args = parser.parse_args()
    return args


def main():
    args = __parse_command_line()
    _client, db = mg_mongo_connect()
    run(args, db)


if __name__ == '__main__':
    start = datetime.datetime.now()
    print(f"Started: {start}")
    main()
    duration = datetime.datetime.now() - start
    print(f"Duration: {duration}")
