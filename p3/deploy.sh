#!/bin/bash

# Définition des codes de couleur
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Pas de couleur

sudo k3d cluster create part3 --api-port 6443 --agents 2 
sudo kubectl config set-cluster part3 --server=https://localhost:6443 --insecure-skip-tls-verify=true

sudo kubectl create namespace dev
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl get pods -n argocd -w
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > psswd.txt
# sudo kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'
sudo kubectl apply -f project.yaml -n argocd

sudo kubectl apply -f application.yaml -n argocd
sudo kubectl get pods -n dev -w
sudo kubectl port-forward -n argocd service/argocd-server 8080:443 &
sudo kubectl port-forward -n dev service/wil-service 8888:8888 &