APP_NAME=nest-k8-demo
TAG ?= latest
K8S_DIR=.devops/k8

up:
	${K8S_DIR}/scripts/up.sh $(APP_NAME) $(TAG) $(K8S_DIR)
