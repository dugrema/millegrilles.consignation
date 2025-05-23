# MilleGrilles

Le système d'information MilleGrilles est une plateforme qui relie des usagers, des appareils et des applications 
sécuritairement.

Chaque MilleGrille est unique. Elle a son propre identificateur cryptographique qui peut être vérifié et utilisé comme
garantie d'origine.

Les applications de MilleGrilles n'utilisent pas de mots de passe. L'usager utilise des méthodes d'authentification
fortes comme un appareil mobile ou une clé de sécurité USB/NFC pour accéder à son compte.

MilleGrilles expose un bus de communication sécurisé qui échange des messages avec une signature électronique.

## Raison d'être / vision

* Pas de mots de passe pour les usagers.
* Chiffrage des fichiers au repos.
* Applications mobiles web sans app store.
* Sécurité de connexion middleware, toujours TLS avec certificat client.
* Distribution des clés.
* Distribution de contenu dans le cloud.

## Technologies

- passkeys
- signature électronique avec ed25519
- chiffrage asymmétrique x25519
- chiffrage symmétrique chacha20-poly1305 (libsodium stream)
- rabbit mq
- mongodb
- sqlite
- nginx

### Langages de programmation

- python
- rust
- react (javascript)
- micropython (RaspberryPi PICO)
