#!/bin/bash
docker buildx create --name winbuilder --use || docker buildx use winbuilder
docker buildx build --platform windows/amd64 -t windows-devbox:latest --load .