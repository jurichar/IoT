#!/bin/bash

function deploy_argocd() {
	sudo kubectl create namespace argocd
	sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

	# install argo cd CLI
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64

	# Expose argocd api server
	kubectl port-forward svc/argocd-server -n argocd 8080:443
}

function deploy_dev() {
	sudo kubectl create namespace dev

	sudo kubectl apply -f App/app-deploy.yaml -n dev
	sudo kubectl apply -f App/app-service.yaml -n dev
}

sudo k3d cluster create part3
sudo kubectl config use-context k3d-part3

deploy_dev
deploy_argocd

sudo kubectl get svc -n dev
sudo kubectl get deployments -n dev

wait 100

sudo kubectl port-forward -n argocd service/argocd-server 8080:443