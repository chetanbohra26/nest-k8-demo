#!/bin/bash
set -e

APP_NAME=${1}
TAG=${2}
K8S_DIR=${3}
NAMESPACE=${4}

echo "Building Docker image $APP_NAME:$TAG..."
docker build -f .devops/Dockerfile -t "$APP_NAME:$TAG" -t "$APP_NAME:latest" .

echo "Importing image into Kubernetes runtime..."
sudo docker save "$APP_NAME:$TAG" | sudo k3s ctr images import -

echo "Deploying Kubernetes manifests to namespace $NAMESPACE..."
kubectl apply -f "$K8S_DIR"/namespace.yaml
kubectl apply -f "$K8S_DIR"/ -n "$NAMESPACE"

echo "Updating deployment image and restarting..."
kubectl set image deployment/$APP_NAME $APP_NAME="$APP_NAME:$TAG" -n "$NAMESPACE"
kubectl rollout restart deployment $APP_NAME -n "$NAMESPACE"

echo "✅ Application $APP_NAME:$TAG is up!"
