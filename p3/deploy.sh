#!/bin/bash

# Définition des codes de couleur
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Pas de couleur

sudo k3d cluster create part3 --api-port 6443 --agents 2

# sudo kubectl config use-context k3d-part3
sudo kubectl config set-cluster part3 --server=https://localhost:6443 --insecure-skip-tls-verify=true

sudo kubectl create namespace dev
sudo kubectl create namespace argocd

if sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>/dev/null; then
    echo -e "${GREEN}ArgoCD applied successfully.${NC}"
else
    echo -e "${RED}Error applying ArgoCD.${NC}"
fi

while [[ $(sudo kubectl get pods -n argocd -o 'jsonpath={..status.containerStatuses[*].ready}' 2>/dev/null) != "true true true true true true true" ]]; do    
    echo -e "\e[10A"
    for i in {1..10}; do
        echo -n "                                                                                                 "
    done
    echo -e "\e[10A"

    echo -e "${YELLOW}Waiting for pods argocd...${NC}"
    sudo kubectl get pods -n argocd
    sleep 2
done


echo -e "${GREEN}All ArgoCD pods are ready!${NC}"

password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "user: admin" > id_agrocd.txt
echo "password : $password" >> id_agrocd.txt

if sudo kubectl apply -f application.yaml -n argocd 2>/dev/null; then
    echo -e "${GREEN}Application deployment applied successfully.${NC}"
else
    echo -e "${RED}Error applying app deployment.${NC}"
fi

if sudo kubectl apply -f project.yaml -n argocd 2>/dev/null; then
    echo -e "${GREEN}Project service applied successfully.${NC}"
else
    echo -e "${RED}Error applying app service.${NC}"
fi

while [[ $(sudo kubectl get pods -n dev -o 'jsonpath={..status.containerStatuses[*].ready}' 2>/dev/null) != "true" ]]; do    
    echo -e "\e[10A"
    for i in {1..10}; do
        echo -n "                                                                                                 "
    done
    echo -e "\e[5A"

    echo -e "${YELLOW}Waiting for pods dev...${NC}"
    sudo kubectl get pods -n dev
    sleep 2
done


