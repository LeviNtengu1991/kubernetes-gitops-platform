SHELL := /bin/bash
CLUSTER_NAME := gitops-lab

.PHONY: cluster validate install argocd status clean

cluster:
	kind create cluster --name $(CLUSTER_NAME) --config kind/cluster.yaml

validate:
	helm lint charts/platform-demo
	helm template platform-demo charts/platform-demo --namespace platform-lab > /tmp/platform-demo-rendered.yaml

install:
	helm upgrade --install platform-demo charts/platform-demo --namespace platform-lab --create-namespace --wait

argocd:
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

status:
	kubectl -n platform-lab get deploy,pod,svc,hpa,pdb

clean:
	kind delete cluster --name $(CLUSTER_NAME)
