
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

This project establishes a CI/CD pipeline for a Flask application using PostgreSQL as the database. The pipeline ensures secure password management through hashing and salting. The application code is hosted on GitHub, with Jenkins orchestrating the CI/CD process. Here’s a breakdown of how it works:

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

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/FlaskPipeline-Demonstration.jpeg?raw=true">

<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/FlaskPipeline-AWS-Demo.jpeg?raw=true">

## 👣 Steps of Project and Detail Demonstration

### Continuous Integration
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/FlaskPipeline-CI.jpeg?raw=true">

### Continuos Deployment
<img src="https://github.com/MatveyGuralskiy/FlaskPipeline/blob/main/Screens/FlaskPipeline-CD.jpeg?raw=true">

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
