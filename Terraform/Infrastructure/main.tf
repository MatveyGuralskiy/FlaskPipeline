#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

# Provider AWS for Virginia
provider "aws" {
  region = var.Region
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

# Provider AWS for Frankfurt
provider "aws" {
  alias  = "ger"
  region = var.GER_Region
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

# Remote State sends on S3 Bucket
terraform {
  backend "s3" {
    bucket  = "flaskpipeline-project-production"
    key     = "Production/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}


#-----------VPC-------------
# Create VPC
resource "aws_vpc" "VPC_FlaskPipeline" {
  provider   = aws
  cidr_block = var.CIDR_VPC
  tags = {
    Name = "VPC FlaskPipeline"
  }
}

# Create Internet Gateway and Automatically Attach
resource "aws_internet_gateway" "IG_FlaskPipeline" {
  provider = aws
  vpc_id   = aws_vpc.VPC_FlaskPipeline.id
  tags = {
    Name = "IG FlaskPipeline"
  }
}

# Data about Availability zones
data "aws_availability_zones" "Availability" {
  provider = aws
}

# Create 2 Public Subnets in different Availability Zones: A, B
resource "aws_subnet" "Public_A" {
  provider          = aws
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.Region}a"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name                     = "Public Subnet A"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "Public_B" {
  provider          = aws
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.Region}b"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name                     = "Public Subnet B"
    "kubernetes.io/role/elb" = 1
  }
}

# Public Route Table
resource "aws_route_table" "Public_Subnets" {
  provider = aws
  vpc_id   = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block = var.CIDR_VPC
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_FlaskPipeline.id
  }
  tags = {
    Name = "Route Table Public Subnets"
  }
}

# Attach Public Subnets to Route Table
resource "aws_route_table_association" "RouteTable_Attach_Subnet_A" {
  provider       = aws
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.Public_Subnets.id
}

resource "aws_route_table_association" "RouteTable_Attach_Subnet_B" {
  provider       = aws
  subnet_id      = aws_subnet.Public_B.id
  route_table_id = aws_route_table.Public_Subnets.id
}

#---------------VPC Peering---------------
# Account ID
data "aws_caller_identity" "current" {
  provider = aws
}

# Remote State of Development Terraform files
data "terraform_remote_state" "remote_state" {
  backend = "s3"

  config = {
    bucket = "flaskpipeline-project-development"
    key    = "Development/terraform.tfstate"
    region = "eu-central-1"
  }
}

# VPC Peering Connection between VPC Virginia and VPC Frankfurt
resource "aws_vpc_peering_connection" "VPC_Peering" {
  provider      = aws
  vpc_id        = aws_vpc.VPC_FlaskPipeline.id
  peer_vpc_id   = data.terraform_remote_state.remote_state.outputs.VPC_ID
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_region   = var.GER_Region
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# VPC Peering Automatic Accepter
resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = aws.ger
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_Peering.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

# Attach Routing of VPC between each other

resource "aws_route" "Route_Private_A_vpc2_to_vpc1" {
  provider                  = aws.ger
  route_table_id            = data.terraform_remote_state.remote_state.outputs.Private_Route_Table_A_ID
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_Peering.id
}

resource "aws_route" "Route_Private_B_vpc2_to_vpc1" {
  provider                  = aws.ger
  route_table_id            = data.terraform_remote_state.remote_state.outputs.Private_Route_Table_B_ID
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_Peering.id
}

resource "aws_route" "Route_Public_Subnets_vpc1_to_vpc2" {
  provider                  = aws
  route_table_id            = aws_route_table.Public_Subnets.id
  destination_cidr_block    = "192.168.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_Peering.id
}

resource "aws_route" "Route_Public_A_vpc2_to_vpc1" {
  provider                  = aws.ger
  route_table_id            = data.terraform_remote_state.remote_state.outputs.Public_RouteTable_A_ID
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_Peering.id
}

resource "aws_route" "Route_Public_B_vpc2_to_vpc1" {
  provider                  = aws.ger
  route_table_id            = data.terraform_remote_state.remote_state.outputs.Public_RouteTable_B_ID
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_Peering.id
}

#------------Bastion Host-----------------

# Image for Launch Configuration
data "aws_ami" "Latest_Ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Security Group for Bastion Host
resource "aws_security_group" "Bastion_Host_SG" {
  name        = "Bastion Host Security Group"
  description = "Security Group for SSH"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion Host SG"
  }
}

# Launch Configuration for Auto-Scaling Group
resource "aws_launch_configuration" "Bastion-Host-LC" {
  name          = "Bastion-Host"
  image_id      = data.aws_ami.Latest_Ubuntu.id
  instance_type = var.Instance_type

  key_name        = var.Key_SSH
  security_groups = [aws_security_group.Bastion_Host_SG.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto-Scaling Group for Bastion Host
resource "aws_autoscaling_group" "Bastion-Host-ASG" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]

  launch_configuration = aws_launch_configuration.Bastion-Host-LC.id

  tag {
    key                 = "Name"
    value               = "Bastion-Host-ASG"
    propagate_at_launch = true
  }
}

#--------------------EKS Cluster-----------------------

# IAM role for EKS
data "aws_iam_policy_document" "Assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM role for EKS
resource "aws_iam_role" "Main_Role" {
  name               = "eks-cluster-cloud"
  assume_role_policy = data.aws_iam_policy_document.Assume_role.json
}

# IAM role for EKS
resource "aws_iam_role_policy_attachment" "Main_Role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Main_Role.name
}

#EKS Cluster
resource "aws_eks_cluster" "EKS" {
  name     = "EKS-FlaskPipeline"
  role_arn = aws_iam_role.Main_Role.arn

  vpc_config {
    subnet_ids = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Main_Role-AmazonEKSClusterPolicy
  ]
}

# IAM Role for Nodes
resource "aws_iam_role" "Node_Role" {
  name = "EKS_Node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Policies for Nodes
resource "aws_iam_role_policy_attachment" "Node_Role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.Node_Role.name
}

resource "aws_iam_role_policy_attachment" "Node_Role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.Node_Role.name
}

resource "aws_iam_role_policy_attachment" "Node_Role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.Node_Role.name
}

# Create Node Group
resource "aws_eks_node_group" "Worker_Nodes" {
  cluster_name    = aws_eks_cluster.EKS.name
  node_group_name = "Node-FlaskPipeline"
  node_role_arn   = aws_iam_role.Node_Role.arn
  subnet_ids      = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    name    = aws_launch_template.EKS_Node_Template.name
    version = aws_launch_template.EKS_Node_Template.latest_version
  }

  tags = {
    Environment = "Production"
  }

  depends_on = [
    aws_iam_role_policy_attachment.Node_Role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Node_Role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.Node_Role-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Launch Template for EKS Nodes
resource "aws_launch_template" "EKS_Node_Template" {
  name          = "EKS_Node_Template"
  instance_type = "t3.medium"
  key_name      = "Virginia"
  user_data     = filebase64("../../Bash/worker_node.sh")
}

#--------------Master Ansible--------------------

# Create Master Ansible
resource "aws_instance" "Master_Ansible" {
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Public_B.id
  security_groups   = [aws_security_group.Ansible_SG.id]
  availability_zone = "${var.Region}b"
  key_name          = var.Key_SSH
  # Bash script to install Ansible
  user_data = file("../../Bash/master_ansible.sh")
  tags = {
    Name = "Master Ansible"
  }
}

# Security group for Master Ansible
resource "aws_security_group" "Ansible_SG" {
  name        = "Master Ansible Security Group"
  description = "Security Group for SSH"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Master Ansible SG"
  }
}

#---------Monitoring (Grafana and Prometheus)-------------

# Create Prometheus Instance
resource "aws_instance" "Prometheus" {
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Public_A.id
  security_groups   = [aws_security_group.Monitoring_SG.id]
  availability_zone = "${var.Region}a"
  key_name          = var.Key_SSH
  private_ip        = "10.0.3.100"
  # Bash script to install Prometheus
  user_data = file("../../Monitoring/prometheus.sh")
  tags = {
    Name = "Monitoring - Prometheus"
  }
}

# Create Grafana Instance
resource "aws_instance" "Grafana" {
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Public_A.id
  security_groups   = [aws_security_group.Monitoring_SG.id]
  availability_zone = "${var.Region}a"
  key_name          = var.Key_SSH
  # Bash script to install Grafana
  user_data = file("../../Monitoring/grafana.sh")
  tags = {
    Name = "Monitoring - Grafana"
  }
}

# Security group for Monitoring
resource "aws_security_group" "Monitoring_SG" {
  name        = "Monitoring Security Group"
  description = "Security Group for SSH"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  dynamic "ingress" {
    for_each = ["3000", "9090", "9100", "22", "587"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Monitoring SG"
  }
}

#------------Route53 DNS and ACM-----------------

# Create ACM Request
resource "aws_acm_certificate" "FlaskPipeline_cert" {
  domain_name       = "web.matveyguralskiy.com"
  validation_method = "DNS"
}

# Route53 Zone information
data "aws_route53_zone" "Application_Zone" {
  name         = "matveyguralskiy.com"
  private_zone = false
}

# Create DNS Record in Route53
resource "aws_route53_record" "FlaskPipeline_cert_validation" {
  # Dynamic Record
  for_each = {
    # Domain Validation Option for ACM
    for dvo in aws_acm_certificate.FlaskPipeline_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.Application_Zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# DNS Validation of ACM
resource "aws_acm_certificate_validation" "FlaskPipeline_cert_validation" {
  certificate_arn         = aws_acm_certificate.FlaskPipeline_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.FlaskPipeline_cert_validation : record.fqdn]
}
