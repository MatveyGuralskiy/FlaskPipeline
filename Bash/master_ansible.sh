#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
sudo apt update
# Install Ansible
sudo apt-get install -y ansible

# Install PIP
sudo apt install -y pip

# Install AWS Library
sudo apt install -y python3-boto3

# Clone GitHub Repository
cd /home/ubuntu/
git clone https://github.com/MatveyGuralskiy/FlaskPipeline.git

# Install AWS CLI
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
