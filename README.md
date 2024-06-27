
<div align="center">

  <img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Application/static/images/Logo.png?raw=true" alt="logo" width="400" height="auto" />
  <h1>FlaskPipeline</h1>
  
  <p>
    Automated Application deployment system using tools such as <strong>Flask, PosgreSQL, Docker, Jenkins, Terraform,<br> ArgoCD, Kubernetes, Grafana, Prometheus, Ansible and more</strong>
  </p>
  <p>
    <img src="https://img.shields.io/badge/Flask-darkseagreen" alt="AWS">&nbsp;
    <img src="https://img.shields.io/badge/AWS-coral" alt="AWS">&nbsp;
    <img src="https://img.shields.io/badge/Docker-blue" alt="Docker">&nbsp;
    <img src="https://img.shields.io/badge/Jenkins-tomato" alt="Jenkins">&nbsp;
    <img src="https://img.shields.io/badge/Terraform-mediumpurple" alt="Terraform">&nbsp;
    <img src="https://img.shields.io/badge/ArgoCD-lightseagreen" alt="ArgoCD">&nbsp;
    <img src="https://img.shields.io/badge/Ansible-white" alt="Ansible">&nbsp;
    <img src="https://img.shields.io/badge/Kubernetes-skyblue" alt="Kubernetes">&nbsp;    
    <img src="https://img.shields.io/badge/Grafana-firebrick" alt="Grafana">&nbsp;
    <img src="https://img.shields.io/badge/Prometheus-goldenrod" alt="Prometheus">&nbsp;
    <img src="https://img.shields.io/badge/GitHub-black"  alt="GitHub">&nbsp;
    <img src="https://img.shields.io/badge/Git-darkred"  alt="Git">&nbsp;

  </p>
</div>

  <p align="center">
    <br>
    <a href="https://www.linkedin.com/in/matveyguralskiy/">LinkedIn</a>
    .
    <a href="https://github.com/MatveyGuralskiy/FlaskPipeline/issues">Report Bug</a>
    ·
    <a href="https://matveyguralskiy.com">My Website</a>
  </p>

<h2>🔍 About the Project</h2>

This project establishes a full CI/CD pipeline for a Flask application using PostgreSQL as the database. The pipeline ensures secure password management through hashing and salting. The application code is hosted on GitHub, with Jenkins orchestrating the CI/CD process. Here’s a breakdown of how it works:

Source Code Management:

The application code is stored on GitHub.
A webhook triggers a Jenkins job whenever a new commit is pushed.
Continuous Integration:

Jenkins initiates the job and performs several tests:
SonarQube: Conducts code quality analysis.
Unit Tests: Validates the functionality of the code.
Bandit: Executes security checks.
Docker and Security Scanning:

After successful testing, Jenkins builds a Docker image.
Aqua Trivy: Scans the Docker image for vulnerabilities.
Docker Image Deployment:

The Docker image is uploaded to DockerHub.
Docker Compose verifies the container configuration.
Kubernetes and Infrastructure Management:

ArgoCD: Sets up a Kubernetes cluster.
Terraform: Deploys the application and provisions resources on AWS.
Configuration Management:

Ansible: Manages updates and configurations.
Monitoring and Notifications:

Grafana and Prometheus: Provide monitoring for the application and infrastructure.
Email notifications are sent if any issues arise.
This setup ensures that the application is rigorously tested, secure, and automatically deployed to a scalable environment, with continuous monitoring and alerts for any issues.

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Demo/FlaskPipeline-Demonstration.jpeg?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Demo/FlaskPipeline-AWS-Demo.jpeg?raw=true">

## 📺 Preview

[![Demonstraion Video](https://img.youtube.com/vi/66-BB7M-uA8/maxresdefault.jpg)](https://www.youtube.com/watch?v=66-BB7M-uA8)

### Continuous Integration
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Demo/FlaskPipeline-CI.jpeg?raw=true">

### Continuos Deployment
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Demo/FlaskPipeline-CD.jpeg?raw=true">

## 👣 Steps of Project and Detail Demonstration
- [ ] Clone Repository
- [ ] Create S3 Buckets for Terraform Remote State
- [ ] Create Resources with Terraform in Frankfurt
- [ ] Connect to Master Instance with SSH
- [ ] Sign Up to Jenkins
- [ ] Install Plugins for Jenkins Pipeline
- [ ] Create Credentials for Jenkins Pipeline
- [ ] Create env file
- [ ] Create Credentials for Jenkins in SonarQube
- [ ] Create SonarQube Local Repository with Token
- [ ] Modified Jenkins System setting
- [ ] Create Jenkins Pipeline with Git
- [ ] Add Webhook to GitHub
- [ ] Choose Input for Deployment in Jenkins
- [ ] Configure Ansible Master
- [ ] Open Port 22 and 9100 to Security group of EKS Nodes
- [ ] Prometheus Confirgurations
- [ ] Grafana Configurations inside Instance
- [ ] Import Dashboard for Grafana
- [ ] Edit Query of Grafana Metric
- [ ] Create Alert Rule
- [ ] Attach email, Notification policy
- [ ] Connect to the Cluster and Create Policy with IAM role
- [ ] Create AWS Load Balancer Controller
- [ ] Create ArgoCD
- [ ] Create Private Repository for your Project
- [ ] Configure ArgoCD with your GitHub Private Repository
- [ ] Modified Values and Ingress files: VPC, Subnets, SSL Certificate
- [ ] Run GitHub Actions with Version 1.0
- [ ] Create Project in ArgoCD
- [ ] Update Version in GitHub Repository
- [ ] Run GitHub Actions with new Version
- [ ] Check if ArgoCD makes Deployment correctly

#### Clone Repository
Install Git to your PC [Git](https://git-scm.com/downloads)
```
git clone https://github.com/MatveyGuralskiy/FlaskPipeline.git
```

#### Create S3 Buckets for Terraform Remote State
- [x] Create S3 Buckets for Terraform Remote State

Install Terraform to your PC [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)

Go to Repository --> Terraform --> Build

Now Inside the directory *Build* run CMD

*Don't forget to edit S3 Bucket names to Unique!*

```
# To initialize
terraform init
# To Plan Terraform
terraform plan
# To Apply and Create Resources in AWS
terraform apply -auto-approve
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Build-1-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Build-2-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Build-3-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Build-4-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Build-5-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Build-6-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-S3-1-12.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-S3-2-13.png?raw=true">
<br>

#### Create Resources with Terraform in Frankfurt
- [x] Create Resources with Terraform in Frankfurt

Go to Directory Terraform --> Development

```
# To initialize
terraform init
# To Plan Terraform
terraform plan -out=tfplan
# To Apply and Create Resources in AWS
terraform apply -auto-approve tfplan
```
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Development-1-7.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Development-2-8.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Development-3-9.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Development-4-10.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Terraform-Development-5-11.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-S3-3-14.png?raw=true">

Resources we're created in AWS:

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-VPC-1-15.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-EC2-1-16.png?raw=true">
<br>

#### Connect to Master Instance with SSH
- [x] Connect to Master Instance with SSH

Use MobaXterm for SSH Connection to Master Instance

Create Session and take Public IP of Master Instance, Username will be *ubuntu* and choose also your Private Key

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SSH-Master-1-17.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SSH-Master-2-18.png?raw=true">
<br>

#### Sign Up to Jenkins
- [x] Sign Up to Jenkins

Use Public IP of Master Instance and Insert him to your Browser and attach to Public IP port 8080 *Public IP:8080*

Go to your Master Instance and copy secret password from file

```
sudo su
nano /var/jenkins_home/secrets/initialAdminPassword
# Copy Secret Password and Insert it in Browser
```
Install Plugins and Register

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-1-19.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-2-20.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-3-21.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-4-22.png?raw=true">
<br>

#### Install Plugins for Jenkins Pipeline
- [x] Install Plugins for Jenkins Pipeline

Go to Manage Jenkins --> Plugins --> Available Plugins

Install Plugins:

- Pipeline Utility Steps

- SonarQube Scanner

After Installation Restart Jenkins Server

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-5-23.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-6-24.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-6-25.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-6-26.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-7-27.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-8-28.png?raw=true">
<br>

#### Create Credentials for Jenkins Pipeline
- [x] Create Credentials for Jenkins Pipeline

Go to Manage Jenkins --> Credentials --> Add Credentials

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-9-39.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-10-40.png?raw=true">

You need to create Credentials:

- *dockerhub* - Your DockerHub Account (Type: Username and password)

- *github* - Your GitHub Account (Type: Username and password)

- *gmail* - Your Google Account Credentials *App Password, Not a regular password of your Account* (Type: Username and password)

- *aws-access* - Your IAM User Credentials of Access key (Type: Secret text)

- *aws-secret* - Your IAM User Credentials of Secret key (Type: Secret text)



#### Create env file
- [x] Create env file

Create env file in your PC, inside the file enter:
```
SECRET_KEY=YOUR_PASSWORD
SQLALCHEMY_DATABASE_URI=postgresql://postgres:YOUR_PASSWORD@PRIVATE_IP_DATABASE/flask_db
```
Check Private IP of Database and Insert to the env file

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Env-1-41.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-EC2-1-42.png?raw=true">

Now create Credential:

- *secret-env* - Upload your env file to Jenkins (Type: Secret file)

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-11-43.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-12-44.png?raw=true">
<br>

#### Create Credentials for Jenkins in SonarQube
- [x] Create Credentials for Jenkins in SonarQube

Go to SonarQube Server on Port 9000 --> Public_IP:9000

Login:
```
Login: admin
Password: admin
```
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-1-29.png?raw=true">

Now we need to create Token for Jenkins to Login to your SonarQube

Administration --> Security --> Users --> Update Token --> Jenkins --> generate

Copy them and create in Jenkins Credential of it

- *sonarqube* - Your SonarQube Token (Type: Secret text)

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-1-30.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-2-31.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-3-32.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-4-33.png?raw=true">

#### Create SonarQube Local Repository with Token
- [x] Create SonarQube Local Repository with Token

Now we need to create Local Repository for SonarQube Testing

Projects --> Manually --> Set Up --> Locally --> Generate

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-5-34.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-6-35.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-7-36.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-8-37.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-SonarQube-9-38.png?raw=true">

Copy Token you got and attach it in Jenkins Credentials

- *sonar-project* - Your SonarQube Token Repository (Type: Secret text)



#### Modified Jenkins System setting
- [x] Modified Jenkins System setting

Now we need to attach our email for Notifications from Jenkins and add SonarQube Server to Jenkins

Go to Manager Jenkins --> System

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-13-45.png?raw=true">

Let's Start with SonarQube:

Scroll to *SonarQube servers* title --> Add SonarQube

Edit Name and attach Credentials of SonarQube Token: *sonarqube*

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-14-46.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-15-47.png?raw=true">

After that we should edit out Email settings:

Scroll to *Extended E-mail Notification*

Here we need to configure SMTP with Gmail

```
SMTP server:
smtp.gmail.com
SMTP Port:
465
Advanced:
Credentials of gmail
# Choose: Use SSL
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-16-48.png?raw=true">

You need to edit also an Email Notification

```
SMTP server:
smtp.gmail.com
Advanced:
# Choose: Use SMTP Authentiocation
Username: Your Email
Password: Your App password (not a regular gmail password of your account)
# Choose also: Use SSL
SMTP Port: 465
# Your can Test your configuration if you want by sending an email
```

After everything click to Save and Apply

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-17-49.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-18-50.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-19-51.png?raw=true">
<br>

#### Create Jenkins Pipeline with Git
- [x] Create Jenkins Pipeline with Git

Go to Main Dashboard --> New Item --> Pipeline

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-20-52.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-21-53.png?raw=true">

Now Discard old build if you want

in GitHub Project insert Project url of GitHub Repository

Build Triggers choose GitHub hook trigger for GITScm polling

And finally in Pipeline Definition choose Pipeline script from SCM

SCM - Git

Repositories your Repository Url of GitHub Repository

Choose in Credentials *github*

Branch should be */main of what ever you want

And in Script path enter: Jenkins/Jenkinsfile.groovy

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-22-54.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-23-55.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-24-56.png?raw=true">
<br>

#### Add Webhook to GitHub
- [x] Add Webhook to GitHub

Go to your GitHub Repository --> Settings --> Webhooks

In Payload URL enter: http:PUBLIC_IP_JENKINS:8080/github-webhook/

Contact type: application/json

Just the push event and Active it

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Webhook-1-57.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Webhook-2-58.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Webhook-3-59.png?raw=true">

After that change something in Repository and make push of commit to check if Jenkins Webhook works



#### Choose Input for Deployment in Jenkins
- [x] Choose Input for Deployment in Jenkins

When you push commit from Git to GitHub, Jenkins will see it and Start a Job

Jenkins Input will ask you if you want to make Deployment choose Yes and in the second Input we will ask you again if you're sure about it, so choose also 'Yes'

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-25-60.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-26-61.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-27-62.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-28-63.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-29-64.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Jenkins-30-65.png?raw=true">

Now you got all Infrastructure with Terraform in Virginia

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-EC2-2-69.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-EKS-1-68.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-VPC-2-66.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-VPC-Peering-1-67.png?raw=true">
<br>


#### Configure Ansible Master
- [x] Configure Ansible Master

Now use SSH connection with MobaXterm to Ansible Master, copy Public IP of Ansible master or use Bastion Host Instance (Upload to Bastion Host Secret Key)

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Ansible-1-70.png?raw=true">

Attach your AWS Credentials with command 
```
aws configure

ACCESS KEY
SECRET KEY
REGION: us-east-1
FORMAT: json
```
Create Crontab task now every 3 days on 2AM
```
crontab -e
# Choose number 1
#Enter this command:
0 2 */3 * * ansible-playbook -i /home/ubuntu/FlaskPipeline/Ansible/ansible-aws_ec2.yml /home/ubuntu/FlaskPipeline/Ansible/Playbook.yaml >> /path/to/ansible_cron.log 2>&1
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Ansible-2-71.png?raw=true">

Move Private Key to Ansible Master and Change his Permissions

```
cd .ssh/
Upload it with MobaXterm buttom at the left of Console
chmod 600 YOUR_KEY.pem
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Ansible-3-72.png?raw=true">
<br>

#### Open Port 22 and 9100 to Security group of EKS Nodes
- [x] Open Port 22 and 9100 to Security group of EKS Nodes

Go to EC2 Console in Virginia

Choose every EKS Node (Without Name tag)

Click on Security --> Security Group

Now in Security group add Inbound Ports 22 and 9100 to 0.0.0.0/0 (to everyone)

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-Node-SG-1-73.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-Node-SG-2-74.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-Node-SG-3-75.png?raw=true">
<br>

#### Prometheus Confirgurations
- [x] Prometheus Confirgurations

Copy Public IP of Prometheus Instance and connect to him with MobaXterm

Now we need to change Prometheus Configuration file to attach our Nodes IP's

```
sudo su
nano /etc/prometheus/prometheus.yaml
# Go to EC2 Console and Copy every Private IP of Nodes
# Your Prometheus file should looks like that:
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "nodes"
    static_configs:
      - targets:
          - 10.0.4.224:9100 #Change here to Nodes Private IP's
          - 10.0.4.116:9100
          - 10.0.4.128:9100
          - 10.0.3.18:9100
          - 10.0.3.168:9100
          - 10.0.3.42:9100

# Save everything and Restart Prometheus
systemctl restart prometheus
```

Now go to Prometheus Server to check if Targets of Instances are Okay use Public IP of Prometheus Instance and Port 9090

Prometheus_IP:9090

Go to targets and check Instances

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Prometheus-1-76.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Prometheus-2-77.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Prometheus-3-78.png?raw=true">
<br>

#### Grafana Configurations inside Instance
- [x] Grafana Configurations inside Instance

Now connect also with SSH to Grafana Instance

We need to edit our Grafana configuration file first of all to add SMTP

```
sudo su
nano /etc/grafana/grafana.ini
# Ctrl + /
# Enter line: 900
# Edit lines:
enabled = true
user = "YOUR EMAIL"
password = "YOUR APP PASSWORD ONLY"
# Delete ";" from this lines and from lines:
from_address
from_name
# After That restart the Grafana server
systemctl restart grafana-server
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-1-79.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-2-80.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-3-81.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-4-82.png?raw=true">

Our Grafana Server is ready for usage



#### Import Dashboard for Grafana
- [x] Import Dashboard for Grafana

Go to Public IP of Grafana Instance and Port 3000 

Public_IP:3000

```
Login: admin
Password: admin
```
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-5-83.png?raw=true">

Now go to Dashboard --> New --> Import

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-6-84.png?raw=true">

Enter this code and Click Load

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-7-85.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-8-86.png?raw=true">
<br>

#### Edit Query of Grafana Metric
- [x] Edit Query of Grafana Metric

Go to your new Dashboard and find CPU Basic and click to Options --> Modified

Change Metrics and leave only one metric and click Save and Apply

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-9-87.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-10-88.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-11-89.png?raw=true">
<br>

#### Create Alert Rule
- [x] Create Alert Rule 

Now we need to create Alert Rule for our Grafana

Click on Dashboard Metric we edited before --> More --> New alert rule

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-12-90.png?raw=true">

Now edit all Metrics like here, if CPU highly than 80% we will get email notification

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-13-91.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-15-93.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-16-94.png?raw=true">

#### Attach email, Notification policy
- [x] Attach email, Notification policy

Go to Alerting --> Contact points --> Edit default email

You can also test it 

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-17-95.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-18-96.png?raw=true">

Create Notification Policy 

with CPU equal 80

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Grafana-19-97.png?raw=true">
<br>

#### Connect to the Cluster and Create Policy with IAM role
- [x] Connect to the Cluster and Create Policy with IAM role

You can connect to your Cluster from every Linux OS, for example I run it on my VM

Before you start you need to enter your AWS Credentials to VM

Install kubectl, argocd, helm and eksctl on your VM

```
# Install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# Install ArgoCD
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x ./argocd
sudo mv ./argocd /usr/local/bin/argocd
argocd version

#Install Helm
curl -LO https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz
tar -zxvf helm-v3.12.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version

# Install EKSctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

Now to connect to your Cluster and create Policies use this commands:

```
# Connect to Cluster
aws eks update-kubeconfig --name EKS-FlaskPipeline --region us-east-1
# Create Policy
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=EKS-FlaskPipeline --approve
# Install My IAM JSON Policy from directory Policy
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://alb_controller_iam_policy.json
# Install IAM Service Account Policy, Change to Your Account ID
eksctl create iamserviceaccount \
    --cluster=EKS-FlaskPipeline \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::YOUR_ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
    --approve
# If he already exist attach to the command: --override-existing-serviceaccounts
```

#### Create AWS Load Balancer Controller
- [x] Create AWS Load Balancer Controller

Let's create AWS Load Balancer Controller on our EKS Cluster

```
helm repo add eks https://aws.github.io/eks-charts
helm repo update
# Copy your VPC ID
aws eks describe-cluster --name EKS-FlaskPipeline --query "cluster.resourcesVpcConfig.vpcId" --output text

# Insert VPC to your command
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system   \
  --set clusterName=EKS-FlaskPipeline \
  --set serviceAccount.create=false \
  --set region=us-east-1 \
  --set vpcId=YOUR_VPC_ID \
  --set serviceAccount.name=aws-load-balancer-controller
```

Check if you have AWS Load Balancer Controller
```
# To see Deployment
kubectl get deployment aws-load-balancer-controller -n kube-system
# to see Pods
kubectl get pods -n kube-system
```



#### Create ArgoCD
- [x] Create ArgoCD

We finally at the stage to create ArgoCD in our Cluster

```
# To install ArgoCD to the Cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get all -n argocd
# It's List of Secrets
kubectl get secret -n argocd
# Save your Secret, it's gonna be your Password for Connection to ArgoCD
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# Change ArgoCD to LoadBalancer to get Domain
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc -n argocd
# For the project resources
kubectl create namespace flaskpipeline-project
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Argo-Intall-1-103.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Argo-Intall-2-104.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Argo-Intall-3-105.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Argo-Intall-4-106.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Argo-Intall-5-107.png?raw=true">
<br>

#### Create Private Repository for your Project
- [x] Create Private Repository for your Project

Install all files from Directory ArgoCD_Repository to your Private Repository

After that we need to create Secret for GitHub Actions

Go to GitHub Main Settings --> Your Profile --> Developer Settings --> Personal Access Tokens --> Token Classic --> Generate

Now Copy the Secret and Create Secret inside ArgoCD_Repository Secret with name GITHUBACTIONS



#### Configure ArgoCD with your GitHub Private Repository
- [x] Configure ArgoCD with your GitHub Private Repository

Follow the Domain of Load Balancer for ArgoCD

Now connect to ArgoCD

```
Login: admin
Password: SECRET_YOU_GET_BY_COMMAND
```

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-ArgoCD-1-108.png?raw=true">

Go to User Info and Change Password that you want, Refresh ArgoCD

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-ArgoCD-2-109.png?raw=true">

Now we need to connect our Private Repository with SSH

Create SSH key and Public Key connect to your Private Repository

Go to Deploy Keys And attach Public Key here

In ArgoCD insert Private Key SSH

Use SSH Link of Repository for ArgoCD

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-ArgoCD-4-111.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-ArgoCD-SSH-1-112.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-ArgoCD-5-113.png?raw=true">
<br>

#### Modified Values and Ingress files: VPC, Subnets, SSL Certificate
- [x] Modified Values and Ingress files: VPC, Subnets, SSL Certificate

Go to ArgoCD Private Repository you create and change in Kubernetes/Ingress.yaml Certificate ARN

Go to AWS Console --> Certificate Manager --> Requests --> Copy ARN of SSL Certificate

After this you need to check our Public Subnets ID's and VPC id and Enter them to the Kubernetes/values.yaml

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-AWS-Certificate-SSL-125.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Helm-1-117.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/Project/Project-Helm-2-118.png?raw=true">
<br>

#### Run GitHub Actions with Version 1.0
- [x] Run GitHub Actions with Version 1.0


#### Create Project in ArgoCD
- [x] Create Project in ArgoCD


#### Update Version in GitHub Repository
- [x] Update Version in GitHub Repository


#### Run GitHub Actions with new Version
- [x] Run GitHub Actions with new Version


#### Check if ArgoCD makes Deployment correctly
- [x] Check if ArgoCD makes Deployment correctly


### 📱 Application for Docker Image Built With

* Flask
* HTML
* CSS
* JavaScript
* PostgreSQL
* SQL injection solve
* Hashing function + solt

<h2>📂 Repository</h2>
<p>
  |-- /Ansible
  
  |-- /Application

  |-- /Bash

  |-- /Database

  |-- /Docker

  |-- /Jenkins

  |-- /Monitoring

  |-- /Policy

  |-- /Screens

  |-- /Terraform

  |-- /.gitignore

  |-- LICENSE

  |-- README.md

</p>

## 📺 Preview

[![Demonstraion Video](https://img.youtube.com/vi/66-BB7M-uA8/maxresdefault.jpg)](https://www.youtube.com/watch?v=66-BB7M-uA8)

## 📚 Acknowledgments
Documentations for you to make the project

* [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
* [AWS for begginers](https://aws.amazon.com/getting-started/)
* [Terraform work with AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Docker Build Images](https://docs.docker.com/build/)
* [DockerHub Registry](https://docs.docker.com/docker-hub/)
* [Git Control your code](https://git-scm.com/doc)
* [HTML to build Application](https://developer.mozilla.org/en-US/docs/Web/HTML)
* [CSS to style Application](https://developer.mozilla.org/en-US/docs/Web/CSS)
* [SSH connect to Instances](https://www.ssh.com/academy/ssh/command)
* [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
* [EKS Cluster](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
* [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)

<h2>📢 Additional Information</h2>
<p>
  I hope you liked my project, don’t forget to rate it and if you notice a code malfunction or any other errors.
  
  Don’t hesitate to correct them and be able to improve your project for others
</p>

## 📩 Contact

Email - <a href="mailto:mathewguralskiy@gmail.com">Contact</a>

GitHub - <a href="https://github.com/MatveyGuralskiy" target="_blank">Profile</a>

LinkedIn - <a href="https://www.linkedin.com/in/matveyguralskiy/" target="_blank">Profile</a>

Instagram - <a href="https://www.instagram.com/matvey_guralskiy/" target="_blank">Profile</a>

<h2>© License</h2>
<p>
Distributed under the MIT license. See LICENSE.txt for more information.
</p>
