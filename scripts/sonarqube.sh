#!/bin/bash

# =======================================================
# SonarQube Installation Script for Ubuntu Instances
# =======================================================

# Update package list
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

# Run SonarQube container
sudo docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  sonarqube:lts-community

echo "SonarQube started on http://<server_ip>:9000"
echo "Username: admin | Password: admin"
