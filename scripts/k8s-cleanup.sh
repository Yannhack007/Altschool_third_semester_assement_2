#!/bin/bash
set -e

NAMESPACE=muchtodo
K8S_DIR="../kubernetes"

echo "Nettoyage des ressources K8s..."

kubectl delete -f $K8S_DIR/backend/backend-service.yaml || true
kubectl delete -f $K8S_DIR/backend/backend-deployment.yaml || true
kubectl delete -f $K8S_DIR/backend/backend-configmap.yaml || true
kubectl delete -f $K8S_DIR/backend/backend-secret.yaml || true

kubectl delete -f $K8S_DIR/mongodb/mongodb-service.yaml || true
kubectl delete -f $K8S_DIR/mongodb/mongodb-deployment.yaml || true
kubectl delete -f $K8S_DIR/mongodb/mongodb-pvc.yaml || true
kubectl delete -f $K8S_DIR/mongodb/mongodb-configmap.yaml || true
kubectl delete -f $K8S_DIR/mongodb/mongodb-secret.yaml || true

kubectl delete -f $K8S_DIR/namespace.yaml || true

echo "Nettoyage terminé !"
