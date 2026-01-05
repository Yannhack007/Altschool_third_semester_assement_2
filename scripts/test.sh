#!/usr/bin/env bash
set -euo pipefail

# Apply the ingress manifest from the repo root
# Note: use forward slashes; backslashes are Windows-specific

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_PATH="${ROOT_DIR}/kubernetes"

echo "Applying: ${MANIFEST_PATH}"

kubectl apply -f "${MANIFEST_PATH}/namespace.yaml"
kubectl apply -f "${MANIFEST_PATH}/mongodb/"
kubectl apply -f "${MANIFEST_PATH}/backend/"
kubectl apply -f "${MANIFEST_PATH}/ingress.yaml"

sleep 30
echo "Done."
