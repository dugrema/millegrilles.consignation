#!/bin/env bash

#OLLAMA_MODELS="/var/lib/docker/volumes/ollama/_data/models/"
OLLAMA_MODELS="/mnt/docker/volumes/ollama/_data/models"
OLLAMA_SAVE_LOAD_PATH="/home/mathieu/git/ollama-save-load"

# INPUT_NAME="qwen3_8b-q4_K_M.tar.gz"
INPUT_NAME="$1"

if [ -z $INPUT_NAME ]; then
	echo "Required params: [INPUT_NAME]"
	exit 1
fi

# /home/mathieu/git/ollama-save-load/ollama-save.py qwen3:8b-q4_K_M | gzip > qwen3_8b-q4_K_M.tar.gz
sudo OLLAMA_MODELS="${OLLAMA_MODELS}" "${OLLAMA_SAVE_LOAD_PATH}/ollama-load.py" "${INPUT_NAME}"
