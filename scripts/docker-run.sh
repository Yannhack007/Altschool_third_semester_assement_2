#!/bin/bash
set -e

echo "Lancement des conteneurs via docker-compose"

docker compose up --build -d

echo "Conteneurs démarrés"
docker ps
