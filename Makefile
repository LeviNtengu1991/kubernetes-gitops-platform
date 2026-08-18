SHELL := /bin/bash
CLUSTER_NAME := gitops-lab
ARGO_CD_VERSION := v3.4.6
METRICS_SERVER_VERSION := v0.8.1
KUBE_PROMETHEUS_STACK_VERSION := 88.0.1

.PHONY: cluster validate install metrics-server observability argocd status clean

cluster:
	kind create cluster --name $(CLUSTER_NAME) --config kind/cluster.yaml

validate:
	helm lint charts/platform-demo
	helm template platform-demo charts/platform-demo --namespace platform-lab > /tmp/platform-demo-rendered.yaml

install:
	helm upgrade --install platform-demo charts/platform-demo --namespace platform-lab --create-namespace --wait

metrics-server:
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/$(METRICS_SERVER_VERSION)/components.yaml
	kubectl -n kube-system patch deployment metrics-server --type=json \
	  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
	kubectl -n kube-system rollout status deployment/metrics-server --timeout=180s

observability:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
	  --version $(KUBE_PROMETHEUS_STACK_VERSION) --namespace monitoring --create-namespace \
	  --set prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues=false \
	  --set prometheus.prometheusSpec.probeSelectorNilUsesHelmValues=false --wait
	kubectl apply -f observability/blackbox.yaml
	kubectl apply -f observability/prometheus-rules.yaml

argocd:
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n argocd --server-side --force-conflicts \
	  -f https://raw.githubusercontent.com/argoproj/argo-cd/$(ARGO_CD_VERSION)/manifests/install.yaml

status:
	kubectl -n platform-lab get deploy,pod,svc,hpa,pdb

clean:
	kind delete cluster --name $(CLUSTER_NAME)
