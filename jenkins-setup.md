# Jenkins CI/CD Server Setup on Ubuntu


## Overview
A comprehensive guide for deploying a production-ready Jenkins CI/CD environment with Docker integration and security scanning capabilities.

This setup provides a complete Jenkins automation server configured with essential DevOps tools:
- **Jenkins** - CI/CD automation server with Java 21
- **Docker** - Container engine for building and deploying applications
- **Trivy** - Security vulnerability scanner for container images
- **Production-ready** configuration with best practices


## Prerequisites
Before starting, ensure you have:
- **Operating System:** Ubuntu 20.04 LTS or higher
- **System Resources:** Minimum 2GB RAM and 10GB disk space
- **Access:** Sudo/root privileges
- **Network:** Internet connectivity for package downloads


### Required Ports
Ensure the following ports are accessible in your firewall or security group:

| Service | Port | Purpose |
|---------|------|---------|
| Jenkins | 8080 | Web UI and API access |
| SSH     | 22   | Remote server connection |

---

## Installation Guide

### Step-1: Install Jenkins Server
Use an automated installation script `jenkins.sh` to simplify setup from [here](/scripts/jenkins.sh).
```sh
# Make the script executable
chmod +x jenkins.sh

# Run the installation
./jenkins.sh

# Check Jenkins service status (look for "active (running)")
sudo systemctl status jenkins --no-pager

# Verify Java version
java -version

# Confirm Jenkins is listening on port 8080
sudo ss -tulnp | grep 8080
```

What the script does:
- Installs Java OpenJDK 21 (required for Jenkins)
- Adds the official Jenkins repository
- Installs the latest Jenkins LTS version
- Starts and enables Jenkins service


### Step-2: Docker Installation on Jekins server
Use an automated installation script `docker.sh` to simplify setup from [here](/scripts/docker.sh).
```sh
# Make the script executable
sudo chmod +x docker.sh

# Run the script
./docker.sh

# Verify Docker installation
sudo docker --version
sudo docker compose version

# Verify by running the hello-world image
sudo docker run hello-world
```

### Step-3: Post-Installation Configuration for Jenkins
Add the Jenkins user to the Docker group to allow Docker commands without `sudo`
```sh
# Add Jenkins system user to docker group
sudo usermod -aG docker jenkins

# Restart Jenkins to apply group changes
sudo systemctl restart jenkins                    
```

> **Note:** Using `$USER` here will not work for Jenkins pipelines because Jenkins runs under the `jenkins` system user. Always use `jenkins` user for group addition.


### Step-4 Trivy Installation on Jenkins server
Trivy scans container images, filesystems, and Git repositories for vulnerabilities.

Use an automated installation script `trivy.sh` to simplify setup from [here](/scripts/trivy.sh).

```sh
# Make the script executable
sudo chmod +x trivy.sh

# Run the script
./trivy.sh

# Verify Trivy installation
trivy --version
```

### Step-5: Ensure Jenkins User Access
If Trivy is installed system-wide, verify that the Jenkins user can execute it:
```sh
# Switch to Jenkins user
sudo su - jenkins

# Check Trivy version
trivy --version
```

> **Note:** If the Jenkins user cannot run Trivy directly, add its path to Jenkins global tool configuration or ensure it is in the system PATH.



## Troubleshooting (Common Issues and Solutions)

### 1. Jenkins Won't Start

```sh
# Check logs
sudo journalctl -u jenkins -f

# Restart service
sudo systemctl restart jenkins

# Check port availability
sudo netstat -tulnp | grep 8080
```

### 2. Docker Permission Denied

```sh
# Re-add users to docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Restart Docker
sudo systemctl restart docker

# Restart Jenkins
sudo systemctl restart jenkins
```

### 3. Trivy Scan Fails in Jenkins

```sh
# Verify Trivy is executable by Jenkins
sudo -u jenkins trivy --version

# Check Trivy path in Jenkins Tools configuration
which trivy

# Update Trivy database
trivy image --download-db-only
```

### System Information Commands

Useful commands for monitoring your Jenkins server:
```sh
# Check system resources
free -h
df -h

# Monitor Jenkins process
ps aux | grep jenkins

# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Check all services status
sudo systemctl status jenkins docker
```


## Cleanup (Optional)
To remove Jenkins and related tools:
```sh
# Stop services
sudo systemctl stop jenkins docker

# Remove packages
sudo apt remove --purge jenkins docker-ce docker-ce-cli containerd.io -y

# Remove data directories (CAUTION: Deletes all data)
sudo rm -rf /var/lib/jenkins
sudo rm -rf /var/lib/docker

# Remove Trivy
sudo rm /usr/local/bin/trivy
```


Follow the Post-Installation Jenkins Configuration Guide [here](/jenkins-configuration.md).


---

## Additional Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
