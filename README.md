
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
- [ ] Make changes in GitHub Repository to run Jenkins
- [ ] Choose Input for Deployment in Jenkins
- [ ] Connect to Ansible Master
- [ ] Attach your AWS Credentials
- [ ] Move Private Key to Ansible Master
- [ ] Open Port 22 and 9100 to Security group of EKS Nodes
- [ ] Modified Crontab for Ansible
- [ ] Connect with SSH to Prometheus Instance
- [ ] Edit Prometheus Configuration file
- [ ] Restart Prometheus
- [ ] Connect with SSH to Grafana Instance
- [ ] Edit Grafana Configuration file
- [ ] Restart Grafana
- [ ] Import Dashboard for Grafana
- [ ] Edit Query of Grafana Metric
- [ ] Create Alert Rule
- [ ] Attach email, Notification policy
- [ ] Connect to the Cluster and Create Policy with IAM role
- [ ] Create AWS Load Balancer Controller
- [ ] Create ArgoCD
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

  |-- /Screens

  |-- /Terraform

  |-- /.gitignore

  |-- LICENSE

  |-- README.md

</p>

## 📺 Preview

[![Demonstraion Video](https://img.youtube.com/vi/66-BB7M-uA8/maxresdefault.jpg)](https://www.youtube.com/watch?v=xGXY5STkIak)

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
