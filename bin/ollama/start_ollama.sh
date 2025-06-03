#!/bin/env bash

#OLLAMA_IMAGE="ollama/ollama:0.6.6"
#OLLAMA_IMAGE="ollama/ollama:0.7.0"
OLLAMA_IMAGE="ollama/ollama:0.8.0"

docker stop ollama; true
sleep 3
# docker run --rm -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama $OLLAMA_IMAGE

#  -p 11434:11434 \
docker run --rm -d \
  --gpus=all \
  --env OLLAMA_KEEP_ALIVE=60m \
  -v ollama:/root/.ollama \
  --network millegrille_net \
  --name ollama $OLLAMA_IMAGE

