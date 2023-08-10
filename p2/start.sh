#!/bin/bash

# Start vagrant
vagrant up

# Add hosts
sudo echo "192.168.56.110  app1.com" >> /etc/hosts
sudo echo "192.168.56.110  app2.com" >> /etc/hosts

# Wait kubectl in vagrant up
sleep 30

# Open app in browser
firefox app1.com &
firefox app2.com &