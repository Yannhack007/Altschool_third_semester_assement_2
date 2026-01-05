#!/bin/bash
set -e

NAMESPACE=muchtodo
K8S_DIR="../kubernetes"

echo "Création du namespace..."
kubectl apply -f $K8S_DIR/namespace.yaml

echo "Déploiement MongoDB..."
kubectl apply -f $K8S_DIR/mongodb/mongodb-secret.yaml
kubectl apply -f $K8S_DIR/mongodb/mongodb-configmap.yaml
kubectl apply -f $K8S_DIR/mongodb/mongodb-pvc.yaml
kubectl apply -f $K8S_DIR/mongodb/mongodb-deployment.yaml
kubectl apply -f $K8S_DIR/mongodb/mongodb-service.yaml

echo "Déploiement Backend..."
kubectl apply -f $K8S_DIR/backend/backend-secret.yaml
kubectl apply -f $K8S_DIR/backend/backend-configmap.yaml
kubectl apply -f $K8S_DIR/backend/backend-deployment.yaml
kubectl apply -f $K8S_DIR/backend/backend-service.yaml

# echo "Déploiement Ingress..."
# kubectl apply -f $K8S_DIR/ingress.yaml

echo "Déploiement terminé !"
kubectl get pods -n $NAMESPACE
kubectl get svc -n $NAMESPACE
