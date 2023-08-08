#!/bin/bash

# Définition des codes de couleur
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Pas de couleur

function deploy_argocd() {
	sudo kubectl create namespace argocd

	if sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>/dev/null; then
		echo -e "${GREEN}ArgoCD applied successfully.${NC}"
	else
		echo -e "${RED}Error applying ArgoCD.${NC}"
	fi

	# install argo cd CLI
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64

	sudo kubectl apply -f application.yaml -n argocd
}

function deploy_dev() {
	sudo kubectl create namespace dev

	if sudo kubectl apply -f App/app-deploy.yaml -n dev 2>/dev/null; then
		echo -e "${GREEN}App deployment applied successfully.${NC}"
	else
		echo -e "${RED}Error applying app deployment.${NC}"
	fi

	if sudo kubectl apply -f App/app-service.yaml -n dev 2>/dev/null; then
		echo -e "${GREEN}App service applied successfully.${NC}"
	else
		echo -e "${RED}Error applying app service.${NC}"
	fi

	sudo kubectl port-forward -n dev service/wil-service 8888:8888 &
}

sudo k3d cluster create part3 --api-port 6443 --agents 2 
sudo kubectl config set-cluster part3 --server=https://localhost:6443 --insecure-skip-tls-verify=true
sudo kubectl config use-context k3d-part3

deploy_argocd
deploy_dev

sudo kubectl get pods -n argocd -w
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > psswd.txt

# sudo kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'

password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "admin:$password" > id_agrocd.txt

sudo kubectl get svc -n dev
sudo kubectl get deployments -n dev

wait 100

sudo kubectl port-forward -n argocd service/argocd-server 8080:443
sudo kubectl port-forward -n dev service/wil-service 8888:8888 &
