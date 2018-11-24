import datetime

date_courante = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc)

print("Date: %s" % date_courante.isoformat())