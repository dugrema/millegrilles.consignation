docker service create \
  --name mon_secret \
  --secret dev3.pki.ca.passwords.20191001134313 \
  --config dev3.pki.ca.root.cert.20191001134313 \
  --secret dev3.pki.ca.root.key.20191001134313 \
  --config dev3.pki.ca.millegrille.cert.20191001134313 \
  --secret dev3.pki.ca.millegrille.key.20191001134313 \
  --secret dev3.passwd.python.maitredescles.json.20191001134313 \
  --config dev3.pki.maitredescles.cert.20191001134313 \
  --secret dev3.pki.maitredescles.key.20191001134313 \
  --secret dev3.pki.maitredescles.key_cert.20191001134313 \
  --config dev3.pki.ca.millegrille.fullchain.20191001134313 \
  --mount type=bind,source=/home/mathieu/mgdev/certs,target=/opt/millegrilles/dist/ \
  --entrypoint "sleep 10000" \
  ubuntu