#!/bin/bash
set -euxo pipefail

# Update package metadata.
dnf update -y

# Install Docker.
dnf install -y docker

# Enable and start Docker.
systemctl enable docker
systemctl start docker

# Wait for Docker daemon to be ready.
until systemctl is-active --quiet docker; do
  sleep 2
done

# Remove old container if it exists.
docker rm -f autoops-nginx || true

# Pull and run nginx.
docker pull nginx:latest
docker run -d \
  --name autoops-nginx \
  --restart unless-stopped \
  -p 80:80 \
  nginx:latest

# Write a basic log for troubleshooting.
echo "AutoOps setup complete - nginx container running on port 80" > /var/log/autoops-user-data.log
date >> /var/log/autoops-user-data.log
docker ps >> /var/log/autoops-user-data.log