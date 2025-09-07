#!/bin/bash
set -e

APP_NAME=${1}   # default if not passed
TAG=${2}              # default if not passed
K8S_DIR=${3}

echo "Using Minikube Docker environment..."
eval $(minikube -p minikube docker-env)

echo "Building Docker image $APP_NAME:$TAG..."
docker build -f .devops/Dockerfile -t "$APP_NAME:$TAG" -t "$APP_NAME:latest" .

echo "Deploying Kubernetes manifests..."
kubectl apply -f "$K8S_DIR"/

echo "Updating deployment image and restarting..."
kubectl set image deployment/$APP_NAME $APP_NAME="$APP_NAME:$TAG"
kubectl rollout restart deployment $APP_NAME

echo "✅ Application $APP_NAME:$TAG is up!"