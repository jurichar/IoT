#!/bin/bash

sudo kubectl port-forward -n argocd service/argocd-server 8080:443 &
sudo kubectl port-forward -n dev service/wil-service 8888:8888 &

while 1; do
    echo -e "${YELLOW}Waiting for port-forward...${NC}"
    sleep 20
    if [[ $(sudo kubectl get pod -n dev -o 'jsonpath={..status.containerStatuses[*].ready}' 2>/dev/null) != "true" ]]; then
        while [[ $(sudo kubectl get pods -n dev -o 'jsonpath={..status.containerStatuses[*].ready}' 2>/dev/null) != "true" ]]; do    
            echo -e "${YELLOW}Waiting for pods dev...${NC}"
            sudo kubectl get pods -n dev
            sleep 20
        done
        sudo kubectl port-forward -n dev service/wil-service 8888:8888 &
        echo -e "${GREEN}Port-forward dev applied successfully.${NC}"
    fi
done