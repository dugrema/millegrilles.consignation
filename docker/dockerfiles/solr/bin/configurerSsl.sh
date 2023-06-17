#/usr/bin/env bash

${MG_DIR}/bin/preparerKeystore.sh

server/scripts/cloud-scripts/zkcli.sh -zkhost solrzookeeper:2181 -cmd clusterprop -name urlScheme -val https
