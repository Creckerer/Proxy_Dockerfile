#!/bin/bash
IMAGE_NAME=${1:-"local/mtproxy"}
START_DIR="$PWD"
if [ -d "${PWD}/MTProxy" ]; then
  cd "${PWD}/MTProxy"
  git pull && \
    echo "GIT PULL USED"
else
  git clone "https://github.com/TelegramMessenger/MTProxy" && \
    echo "GIT CLONED REPO"
  cd "${PWD}/MTProxy"
fi
#------------------------------------------------------
cd "${START_DIR}"
if [ -z "$(docker images -q $IMAGE_NAME:latest)" ]; then
  docker build -t $IMAGE_NAME:latest .
elif [ -n "$(docker images -q $IMAGE_NAME:latest)" ]; then
  docker tag  $IMAGE_NAME:latest $IMAGE_NAME:backup
  docker build -t $IMAGE_NAME:latest . || \
    { echo "LATEST BUILD CRASH"; exit 1; }
fi
#-----------------------------------------------------