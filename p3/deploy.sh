#!/bin/bash

function deploy_argocd() {
	#install argocd
	sudo kubectl create namespace argocd
	sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

	# install argo cd CLI
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64

	# Wait for pods crtl-c when pods are running
	sudo kubectl get pods -n argocd -w

	password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
	echo "admin:$password" > credentials.txt
	sudo kubectl apply -f application.yaml -n argocd
	sudo kubectl apply -f project.yaml -n argocd
}

function deploy_dev() {
	sudo kubectl create namespace dev

	sudo kubectl apply -f App/app-deploy.yaml -n dev
	sudo kubectl apply -f App/app-service.yaml -n dev
}

function setup_cluster() {
	sudo k3d cluster create part3 --api-port 6443 --agents 2 
	sudo kubectl config set-cluster part3 --server=https://localhost:6443 --insecure-skip-tls-verify=true
	sudo kubectl config use-context k3d-part3
}


setup_cluster
deploy_argocd
deploy_dev

sudo kubectl get svc -n dev
sudo kubectl get deployments -n dev

sudo -b su -c "sudo kubectl port-forward -n argocd service/argocd-server 8080:443 &"
sudo -b su -c "sudo kubectl port-forward -n dev service/wil-service 8888:8888 &"
