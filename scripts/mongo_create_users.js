// Creation d'usagers administrateur pour Mongo dans MilleGrilles
use admin 

// Changer un mot de passe au besoin
//db.changeUserPassword('admin','<new_password>')

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
      pwd: "PWD_OPLOGGER",
      roles: 
        [ 
          {role: "read", db: "local"} 
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


