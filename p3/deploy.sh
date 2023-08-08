#!/bin/bash

sudo k3d cluster create part3

sudo kubectl config use-context k3d-part3

sudo kubectl create namespace dev
sudo kubectl create namespace argocd

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl apply -f App/app-deploy.yaml -n dev
sudo kubectl apply -f App/app-service.yaml -n dev

password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "admin" > id_agrocd.txt
echo $password >> id_agrocd.txt

sudo kubectl get svc -n dev
sudo kubectl get deployments -n dev

wait 100

sudo kubectl port-forward -n argocd service/argocd-server 8080:443