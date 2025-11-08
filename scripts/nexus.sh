#!/bin/bash

# =======================================================
# Nexus Installation Script for Ubuntu Instances
# =======================================================

# Update package list
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

# Run Nexus container
sudo docker run -d \
  --name nexus \
  -p 8081:8081 \
  -v nexus-data:/nexus-data \
  sonatype/nexus3

echo "Nexus started on http://<server_ip>:8081"
echo "Get password: sudo docker exec nexus cat /nexus-data/admin.password"
