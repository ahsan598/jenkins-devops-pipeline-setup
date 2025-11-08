#!/bin/bash

# ===========================================================
# Backup SonarQube and Nexus Data Script for Ubuntu Instances
# ===========================================================

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "Backing up Nexus..."
sudo docker run --rm \
  -v nexus-data:/data \
  -v $BACKUP_DIR:/backup \
  ubuntu tar czf /backup/nexus-backup-$DATE.tar.gz /data

echo "Backing up SonarQube..."
sudo docker run --rm \
  -v sonarqube-data:/data \
  -v $BACKUP_DIR:/backup \
  ubuntu tar czf /backup/sonarqube-backup-$DATE.tar.gz /data

echo "Backing up PostgreSQL..."
sudo docker run --rm \
  -v postgres-data:/data \
  -v $BACKUP_DIR:/backup \
  ubuntu tar czf /backup/postgres-backup-$DATE.tar.gz /data

echo "Backup completed! Files saved in $BACKUP_DIR"
