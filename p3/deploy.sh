#!bin/bash

sudo k3d cluster create part3

sudo kubectl config use-context k3d-part3

sudo kubectl create namespace dev
sudo kubectl create namespace argocd

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl apply -f App/app-deploy.yaml -n dev
sudo kubectl apply -f App/app-service.yaml -n dev

sudo kubectl get svc -n dev
sudo kubeclt get deployments -n dev