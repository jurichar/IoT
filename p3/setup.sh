#!/bin/bash

function install_docker() {
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

	sudo apt-get update -y
	sudo apt-get install ca-certificates curl gnupg -y

	sudo install -m 0755 -d /etc/apt/keyrings -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg

	echo \
  	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	sudo apt-get update -y

	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	echo "docker installed!"
}

function install_kubectl() {
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	echo "kubectl installed!"
	rm kubectl
}

function install_dependencies() {
	install_docker
	install_kubectl
}

install_dependencies

#install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.0.0 bash

#launch deploy script
bash deploy.sh
