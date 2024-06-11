#!/bin/bash
# Master Instance Installation

# Install Java
sudo apt update -y && \
sudo apt install -y fontconfig openjdk-17-jre

# Install Jenkins
sudo wget -q -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key && \
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null && \
sudo apt-get update -y && \
sudo apt-get install -y jenkins

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# To run docker
sudo systemctl start docker
sudo systemctl enable docker

# To Add User to Docker
sudo usermod -aG docker $USER

# To Add Jenkins User to Docker
sudo usermod -aG docker jenkins

# Install Terraform
sudo snap install terraform --classic

# Install Sonarqube
sudo docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# Wait for Sonarqube to start
sleep 60