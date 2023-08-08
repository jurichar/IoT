#!/bin/bash
sudo pkill -f "kubectl port-forward"
sudo k3d cluster delete part3