#!/bin/bash
set -e

IMAGE_NAME=much-to-do-backend
TAG=latest

echo "Construction de l'image Docker: $IMAGE_NAME:$TAG"

docker build -t $IMAGE_NAME:$TAG .

echo "Image construite avec succès : $IMAGE_NAME:$TAG"