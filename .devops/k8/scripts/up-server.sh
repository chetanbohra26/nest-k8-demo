#!/bin/bash
set -e

APP_NAME=${1}
TAG=${2}
K8S_DIR=${3}
NAMESPACE=${4}

echo "Building Docker image $APP_NAME:$TAG..."
docker build -f .devops/Dockerfile -t "$APP_NAME:$TAG" -t "$APP_NAME:latest" .

echo "Importing image into Kubernetes runtime..."
if command -v k3s &>/dev/null; then
  sudo docker save "$APP_NAME:$TAG" | sudo k3s ctr images import -
elif command -v kind &>/dev/null && kind get clusters &>/dev/null 2>&1; then
  kind load docker-image "$APP_NAME:$TAG" --name "$(kind get clusters 2>/dev/null | head -1)"
elif command -v microk8s &>/dev/null; then
  sudo docker save "$APP_NAME:$TAG" | sudo microk8s ctr images import -
elif [ -S /run/containerd/containerd.sock ] || [ -S /var/run/containerd/containerd.sock ]; then
  sudo docker save "$APP_NAME:$TAG" | sudo ctr -n k8s.io images import -
else
  echo "❌ Could not detect K8s runtime. Push to registry instead."
  exit 1
fi

echo "Deploying Kubernetes manifests to namespace $NAMESPACE..."
kubectl apply -f "$K8S_DIR"/namespace.yaml
kubectl apply -f "$K8S_DIR"/ -n "$NAMESPACE"

echo "Updating deployment image and restarting..."
kubectl set image deployment/$APP_NAME $APP_NAME="$APP_NAME:$TAG" -n "$NAMESPACE"
kubectl rollout restart deployment $APP_NAME -n "$NAMESPACE"

echo "✅ Application $APP_NAME:$TAG is up!"
