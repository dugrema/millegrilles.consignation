// Creation d'usagers administrateur pour Mongo dans MilleGrilles
use admin

// Creation d'usagers pour les scripts python
// Persistance de transactions
db.createUser(
   {
     user: "transaction",
     pwd: "PWD_TRANSACTION",
     roles:
       [
         { role: "readWrite", db: "mg-NOM_MILLEGRILLE" }
       ]
   }
)

// Gestionnaire de domaines
db.createUser(
   {
     user: "mgdomaines",
     pwd: "PWD_MGPROCESSUS",
     roles:
       [
         { role: "readWrite", db: "mg-NOM_MILLEGRILLE" }
       ]
   }
)

// Procedure de backup
db.createUser(
   {
     user: "backup",
     pwd: "PWD_BACKUP",
     roles:
       [
         "backup"
       ]
   }
)
