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

password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "admin" > id_agrocd.txt
echo $password >> id_agrocd.txt

while [[ $(sudo kubectl get pods -n argocd -o 'jsonpath={..status.containerStatuses[*].ready}') != "true true true true true true false" || $(sudo kubectl get pods -n dev -o 'jsonpath={..status.containerStatuses[*].ready}') != "true" ]]; do
    echo "Waiting for pods..."
    sleep 5
done

sudo kubectl get services -n argocd
sudo kubectl get services -n dev
sudo kubectl get deployments -n dev

# sleep 30

sudo kubectl port-forward -n argocd service/argocd-server 8080:443