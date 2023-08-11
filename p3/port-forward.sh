#!/bin/bash

# Fonction pour le port-forward du service argocd-server
port_forward_argocd() {
    while true; do
        sudo kubectl port-forward -n argocd service/argocd-server 8080:443
        echo "ArgoCD port-forward stopped. Restarting in 5 seconds..."
        sleep 5
    done
}

# Fonction pour le port-forward du service wil-service
port_forward_dev() {
    while true; do
        sudo kubectl port-forward -n dev service/wil-service 8888:8888
        echo "Dev port-forward stopped. Restarting in 5 seconds..."
        sleep 5
    done
}

# Exécutez les fonctions en arrière-plan
port_forward_argocd &
port_forward_dev &