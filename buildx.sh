#!/bin/bash

# Login securely
#echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin

# Build and push
#docker buildx create --name winbuilder --use || docker buildx use winbuilder
#docker buildx build --platform windows/amd64 \
 # -t $DOCKERHUB_USER/windows-devbox:latest \
 # --push .
