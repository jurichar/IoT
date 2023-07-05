#!/bin/bash
#!/bin/bash

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export PATH=$PATH:/usr/local/bin

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -

kubectl apply -f /home/vagrant/files/app1
kubectl apply -f /home/vagrant/files/app2
kubectl apply -f /home/vagrant/files/app3
kubectl apply -f /home/vagrant/files/ingress.yaml
