#!/bin/bash

# =========================================================
# Trivy Installation Script for Ubuntu Instances
# Compatible with Ubuntu 20.04, 22.04, 24.04
# Installs Aqua Security's Trivy from official repository
# =========================================================

# Update package list
sudo apt update

# Install prerequisites
sudo apt install wget apt-transport-https gnupg lsb-release -y

# Add Trivy repo GPG key and repository
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

# Update apt sources & install Trivy
sudo apt update
sudo apt install trivy -y
