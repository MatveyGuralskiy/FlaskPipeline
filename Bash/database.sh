#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
# Install Docker
sudo apt-get update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# Run Docker Service
sudo systemctl start docker
# Start Docker Service with OS
sudo systemctl enable docker

# Add User to Docker
sudo usermod -aG docker $USER

# Run PostgreSQL container
docker run -d -p 5432:5432 --name postgres-db matveyguralskiy/postgres-database:V1.0