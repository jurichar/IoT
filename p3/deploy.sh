#!/bin/bash

# Définition des codes de couleur
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Pas de couleur

sudo k3d cluster create part3

sudo kubectl config use-context k3d-part3

sudo kubectl create namespace dev
sudo kubectl create namespace argocd

if sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>/dev/null; then
    echo -e "${GREEN}ArgoCD applied successfully.${NC}"
else
    echo -e "${RED}Error applying ArgoCD.${NC}"
fi

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

while [[ $(sudo kubectl get pods -n argocd -o 'jsonpath={..status.containerStatuses[*].ready}' 2>/dev/null) != "true true true true true true false" || $(sudo kubectl get pods -n dev -o 'jsonpath={..status.containerStatuses[*].ready}' 2>/dev/null) != "true" ]]; do    
    echo -e "${YELLOW}Waiting for pods...${NC}"
    sleep 20
done

password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "user: admin" > id_agrocd.txt
echo "password : $password" >> id_agrocd.txt

sudo kubectl get services -n argocd
sudo kubectl get services -n dev
sudo kubectl get deployments -n dev

sudo kubectl apply -f App/application.yaml 

sudo kubectl port-forward -n argocd service/argocd-server 8080:443 &
sudo kubectl port-forward -n dev service/wil-service 8888:8888 &