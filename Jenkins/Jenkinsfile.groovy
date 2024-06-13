/*---------------------------
FlaskPipeline Project
Created by Matvey Guralskiy
---------------------------*/
pipeline {
    agent any
    // Enviroment Variables for Project
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        GITHUB_CREDENTIALS = credentials('github')
        AWS_ACCESS_KEY_ID     = credentials('access-key')
        AWS_SECRET_ACCESS_KEY = credentials('secret-key')
        SONAR_LOGIN_KEY = credentials('sonar-project')
        DOCKER_VERSION = 'V1.0'
        SECRET_ENV = credentials('secret-env')
    }
     
    stages {
        // Clean Up Workspace for Pipeline
        stage('Clean Workspace') {
            steps {
                sh 'rm -rf *'
                sh 'echo "Finished to Clean Up Work Directory"'
            }
        }
        // Clone GitHub repository and Image Application to Docker Image
        stage('Clone Repository') {
            steps {
                script {
                    try {
                        dir('Project') {
                            sh 'echo "Starting to Clone and Build Image"'
                            withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_PASSWORD')]) {
                                if (fileExists('Application')) {
                                    dir('Application') {
                                        sh 'git pull origin main'
                                    }
                                } else {
                                    sh 'git clone https://github.com/MatveyGuralskiy/FlaskPipeline.git Application'
                                }
                            }
                        }
                    } catch (Exception e) {
                        error "Failed to clone repository: ${e.message}"
                    }
                }
            }
        }
        // Add Secret env file for PostgreSQL connection
        stage('Add Env file') {
            steps {
                script {
                    dir('Project/Application/Application') {
                        sh "cp ${SECRET_ENV} .env"
                        sh 'echo "Finished Copy Env file"'
                    }
                }
            }
        }
        // SonarQube Standards Analysis Code
        stage('SonarQube Check') {
            steps {
                script {
                    withSonarQubeEnv('Sonar-Qube') {
                        sh '/opt/sonar-scanner/bin/sonar-scanner \
                          -Dsonar.projectKey=Sonar-Qube \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://localhost:9000 \
                          -Dsonar.login=$SONAR_LOGIN_KEY'
                        sh 'echo "Finished SonarQube Analysis of Flask Application"'
                    }
                }
            }
        }
        // Unit Test for Code Application
        stage('Run Unit Tests') {
            steps {
                script {
                    dir('Project/Application/Application') {
                        sh 'python3 unit_test.py'
                        sh 'echo "Finished Unit Tests"'
                    }
                }
            }
        }
        // Bandit Security Analysis
        stage('Bandit Check') {
            steps {
                script {
                    dir('Project/Application/Application') {
                        sh 'bandit -r app.py'
                        sh 'echo "Finished Bandit Tests"'
                    }
                }
            }
        }
        // Build Docker Image of Application
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        dir('Project/Application/Application') {
                            sh "docker-compose up --build -d"
                        }
                        sh 'echo "Application created to Docker Image"'
                    } catch (Exception e) {
                        error "Failed to Build Docker Image: ${e.message}"
                    }
                }
            }
        }
        // Rename Image for Uploading to DockerHub
        stage('Rename and Push Docker Image to DockerHub') {
            steps {
                script {
                    try {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            sh "docker tag flask-pipeline:$DOCKER_VERSION matveyguralskiy/flask-pipeline:$DOCKER_VERSION"
                            sh "docker push matveyguralskiy/flask-pipeline:$DOCKER_VERSION"
                            echo "Docker Image uploaded"
                        }
                    } catch (Exception e) {
                        error "Failed to push Docker image to DockerHub: ${e.message}"
                    }
                }
            }
        }
        // Scan Docker Image with Aqua Trivy
        stage('Aqua Trivy Scanning') {
            steps {
                script {
                    try {
                        def trivyReport = sh(script: "trivy image matveyguralskiy/flask-pipeline:$DOCKER_VERSION --format json", returnStdout: true).trim()
                        writeFile file: 'trivy_report.json', text: trivyReport
                        echo "Trivy scan completed and report saved as trivy_report.json"
                        // Read Results
                        def vulnerabilities = readJSON file: 'trivy_report.json'
                        def criticalVulnerabilities = vulnerabilities.Results[0].Vulnerabilities.findAll { it.Severity == "CRITICAL" }
                        if (criticalVulnerabilities.size() > 1) {
                            error "Critical vulnerabilities found in the Docker image. Build failed."
                        }
                    } catch (Exception e) {
                        error "Failed to scan Docker image with Trivy: ${e.message}"
                    }
                }
            }
        }
        // Testing Container from DockerHub
        stage('Run Docker Compose') {
            steps {
                script {
                    try {
                        dir('Project/Application/Docker') {
                            sh 'docker-compose -f docker-compose.test.yml up -d'
                            echo "Docker Compose finished testing"
                        }
                    } catch (Exception e) {
                        error "Failed to test Docker Container with Docker Compose: ${e.message}"
                    } finally {
                        // Clean up after testing
                        dir('Project/Application/Docker') {
                            sh 'docker-compose -f docker-compose.test.yml down'
                        }
                    }
                }
            }
        }
        // Run Terraform files to create Infrastructure
        stage('Run Terraform') {
            steps {
                script {
                    try {
                        dir('Terraform/Infrastructure') {
                            withEnv(["AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"]) {
                                sh 'terraform init'
                                sh 'terraform apply -auto-approve'
                            }
                        }
                        echo "Terraform apply completed successfully"
                        echo "Finished deployment"
                    } catch (Exception e) {
                        error "Failed to run Terraform configuration: ${e.message}"
                    }
                }
            }
        }
        // Config Cluster.yaml file
        stage('Prepare EKS Cluster Config') {
            steps {
                script {
                    // Get values from Terraform output
                    def vpcId = sh(script: 'terraform output -raw VPC_ID', returnStdout: true).trim()
                    def publicSubnetsIds = sh(script: 'terraform output -raw Public_Subnets_ID', returnStdout: true).trim()
                    def eksSecurityGroupId = sh(script: 'terraform output -raw EKS_Security_Group_ID', returnStdout: true).trim()
                    
                    // Read existing Cluster.yaml file
                    def clusterConfig = readFile('Cluster.yaml')
                    
                    // Replace placeholders with actual values
                    clusterConfig = clusterConfig.replace('PLACEHOLDER_VPC_ID', vpcId)
                    clusterConfig = clusterConfig.replace('PLACEHOLDER_PUBLIC_SUBNET_1_ID', publicSubnetsIds.split("\n")[0].trim())
                    clusterConfig = clusterConfig.replace('PLACEHOLDER_PUBLIC_SUBNET_2_ID', publicSubnetsIds.split("\n")[1].trim())
                    clusterConfig = clusterConfig.replace('PLACEHOLDER_EKS_SG_ID', eksSecurityGroupId)
                    
                    // Write modified Cluster.yaml file
                    writeFile file: 'Cluster.yaml', text: clusterConfig
                }
            }
        }
        // Create EKS Cluster and Check if Cluster Exists
        stage('Creating EKS Cluster and Check it') {
            steps {
                script {
                    try {
                        dir ('Project/Application/Kubernetes') {
                            withEnv(["AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"]) {
                                // Check if the cluster already exists
                                def clusterExists = sh(script: 'eksctl get cluster -o json | jq -r ".[].metadata.name" | grep -Fxq "FlaskPipeline-Cluster"', returnStatus: true) == 0

                                if (!clusterExists) {
                                    // Apply the cluster configuration
                                    sh 'eksctl create cluster -f Cluster.yaml'
                                } else {
                                    echo 'EKS cluster FlaskPipeline-Cluster already exists, skipping creation.'
                                } catch (Exception e) {
                                    error "Failed to run Terraform configuration: ${e.message}"
                                }
                            }
                        }
                    }
                }
            }
        }
    // Send Email if Job Failed
    post {
        failure {
            emailext (
                subject: "Build Failed: ${currentBuild.fullDisplayName}",
                body: "Your Jenkins build has failed. Check the console output for details",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: "mathewguralskiy@gmail.com"
            )
        }
    }
}