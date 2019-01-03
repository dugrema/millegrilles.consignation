// Creation d'usagers administrateur pour Mongo dans MilleGrilles
use admin

// Changer un mot de passe au besoin
//db.changeUserPassword('admin','<new_password>')

// Ajouter un role
/*
db.grantRolesToUser(
  "cuisine",
  [
    {role: "read", db: "mg-maple"}
  ]
)

// Revoke
db.revokeRolesFromUser(
   "coupdoeil",
   [{
     "role": "readWrite",
     "db": "mg-sansnom"
   }]
)
*/

db.createUser(
    {
      user: "mathieu",
      pwd: "PWD_MATHIEU",
      roles: [ "root" ]
    }
)

db.createUser(
    {
      user: "mongoxp",
      pwd: "PWD_MONGOXP",
      roles: [ "root" ]
    }
)

db.createUser(
    {
      user: "oplogger",
      pwd: "p1234",
      roles:
        [
          {role: "read", db: "local"}
        ]
    }
)

db.createUser(
    {
      user: "dev",
      pwd: "p1234",
      roles:
        [
          {role: "read", db: "local"},
          {role: "readWrite", db: "mg-sansnom"}
        ]
    }
)

// Creation d'usagers pour les scripts python

// Persistance de transactions
db.createUser(
   {
     user: "transaction",
     pwd: "PWD_TRANSACTION",
     roles:
       [
         { role: "readWrite", db: "mg-maple" }
       ]
   }
)

// Execution des processus
db.createUser(
   {
     user: "mgprocessus",
     pwd: "PWD_MGPROCESSUS",
     roles:
       [
         { role: "readWrite", db: "mg-maple" }
       ]
   }
)

db.createUser(
   {
     user: "mgdomaines",
     pwd: "PWD_MGPROCESSUS",
     roles:
       [
         { role: "readWrite", db: "mg-maple" }
       ]
   }
)

// Creation d'usagers pour les appareils
db.createUser(
   {
     user: "cuisine",
     pwd: "PWD_CUISINE",
     roles:
       [
         { role: "read", db: "mg-maple" }
       ]
   }
)

db.createUser(
   {
     user: "garage",
     pwd: "PWD_GARAGE",
     roles:
       [
         { role: "read", db: "mg-maple" }
       ]
   }
)

db.createUser(
   {
     user: "chambre",
     pwd: "PWD_CHAMBRE",
     roles:
       [
         { role: "read", db: "mg-pivoine" }
       ]
   }
)

// Usagers web

// Creer un usager coupdoeil pour meteor avec access au oplog
db.createUser(
   {
     user: "coupdoeilmeteor",
     pwd: "PWD",
     roles:
       [
         { role: "read", db: "mg-pivoine" },
         { role: "read", db: "local" }
       ]
   }
)

db.createUser(
   {
     user: "backup",
     pwd: "PWD",
     roles:
       [
         "backup"
       ]
   }
)

// Creation d'usagers pour les appareils
db.createUser(
   {
     user: "vmhost5",
<<<<<<< HEAD
     pwd: "7G3iTQ1f5962",
=======
     pwd: "PWD",
>>>>>>> f80fa9fcb6c184be613c43bca0c10c7a9875b9a2
     roles:
       [
         { role: "read", db: "mg-pivoine" }
       ]
   }
)
