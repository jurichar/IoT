#!/usr/bin/bash

# Start vagrant
vagrant up

sudo cp /etc/host /etc/host.backup

# Add hosts
sudo echo "192.168.56.110  app1.com" >> /etc/hosts
sudo echo "192.168.56.110  app2.com" >> /etc/hosts
