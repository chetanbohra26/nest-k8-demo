APP_NAME=nest-k8-demo
TAG ?= latest
K8S_DIR=.devops/k8
NAMESPACE ?= app-service

up:
	bash ${K8S_DIR}/scripts/up.sh $(APP_NAME) $(TAG) $(K8S_DIR) $(NAMESPACE)

up-server:
	bash ${K8S_DIR}/scripts/up-server.sh $(APP_NAME) $(TAG) $(K8S_DIR) $(NAMESPACE)
