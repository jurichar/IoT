#!/bin/bash

function deploy_argocd() {
	sudo kubectl create namespace argocd
	sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

	# install argo cd CLI
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64

	sudo kubectl apply -f application.yaml -n argocd
}

function deploy_dev() {
	sudo kubectl create namespace dev

	sudo kubectl apply -f App/app-deploy.yaml -n dev
	sudo kubectl apply -f App/app-service.yaml -n dev
}

sudo k3d cluster create part3 --api-port 6443 --agents 2 
sudo kubectl config set-cluster part3 --server=https://localhost:6443 --insecure-skip-tls-verify=true
sudo kubectl config use-context k3d-part3

sudo kubectl get pods -n argocd -w
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > psswd.txt

# sudo kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'
sudo kubectl apply -f project.yaml -n argocd

deploy_dev
deploy_argocd

while [[ $(sudo kubectl get pods -n argocd -o 'jsonpath={..status.containerStatuses[*].ready}') != "true true true true true true false" || $(sudo kubectl get pods -n dev -o 'jsonpath={..status.containerStatuses[*].ready}') != "true" ]]; do
    echo "Waiting for pods..."
    sleep 5
done

password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "admin" > id_agrocd.txt
echo $password >> id_agrocd.txt

sudo kubectl get svc -n dev
sudo kubectl get deployments -n dev

wait 100

sudo kubectl port-forward -n argocd service/argocd-server 8080:443
sudo kubectl port-forward -n dev service/wil-service 8888:8888 &
