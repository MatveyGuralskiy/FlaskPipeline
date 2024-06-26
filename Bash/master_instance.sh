#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
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

#Install Docker-Compose
curl -SL https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Terraform
sudo snap install terraform --classic

# Install Sonarqube
sudo docker run -d --name sonar --restart always -p 9000:9000 sonarqube:lts-community

# Wait for Sonarqube to start
sleep 60

# Install wget
sudo apt update
sudo apt install wget -y

# Install Archieve of SonarScanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip

# Unzip it
sudo apt install unzip -y
unzip sonar-scanner-cli-4.6.2.2472-linux.zip

# Move it to /opt directory and change owner
sudo mv sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner
sudo chown -R $USER:$USER /opt/sonar-scanner

# Add Environment Variables
echo 'export PATH="$PATH:/opt/sonar-scanner/bin"' >> ~/.bashrc
source ~/.bashrc

# Install Requirements of Flask Application
sudo apt update -y && \
sudo apt install -y python3-flask
sudo apt install -y python3-flask-sqlalchemy
sudo apt install -y python3-flask-bcrypt
sudo apt install -y python3-dotenv
sudo apt install -y python3-psycopg2
sudo apt install -y python3-unittest2

# Install Bandit for Testing
sudo apt install -y bandit

# Install Aqua Trivy for Testing Docker Build
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y