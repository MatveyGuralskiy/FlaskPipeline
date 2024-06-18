#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

provider "aws" {
  region = var.Region
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
  cidr_block = var.CIDR_VPC
  tags = {
    Name = "VPC FlaskPipeline"
  }
}

# Create Internet Gateway and Automatically Attach
resource "aws_internet_gateway" "IG_FlaskPipeline" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  tags = {
    Name = "IG FlaskPipeline"
  }
}

# Data about Availability zones
data "aws_availability_zones" "Availability" {}

# Create 2 Public Subnets in different Availability Zones: A, B
resource "aws_subnet" "Public_A" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.Region}a"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "Public_B" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.Region}b"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet B"
  }
}

# Public Route Table
resource "aws_route_table" "Public_Subnets" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
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
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.Public_Subnets.id
}

resource "aws_route_table_association" "RouteTable_Attach_Subnet_B" {
  subnet_id      = aws_subnet.Public_B.id
  route_table_id = aws_route_table.Public_Subnets.id
}

# Create 2 Private Subnets in different Availability Zones: A, B
resource "aws_subnet" "Private_A" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.Region}a"
  tags = {
    Name = "Private Subnet A"
  }
}

resource "aws_subnet" "Private_B" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.Region}b"
  tags = {
    Name = "Private Subnet B"
  }
}

resource "aws_route_table" "Private_Route_Table_A" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "Route Table Private Subnet A- ${var.Environment}"
  }
}

resource "aws_route_table" "Private_Route_Table_B" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "Route Table Private Subnet B- ${var.Environment}"
  }

}

# Attach Private Subnet A to Route Table
resource "aws_route_table_association" "Route_Table_Private_A" {
  subnet_id      = aws_subnet.Private_A.id
  route_table_id = aws_route_table.Private_Route_Table_A.id
}

# Attach Private Subnet B to Route Table
resource "aws_route_table_association" "Route_Table_Private_B" {
  subnet_id      = aws_subnet.Private_B.id
  route_table_id = aws_route_table.Private_Route_Table_B.id
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

resource "aws_iam_role" "Main_Role" {
  name               = "eks-cluster-cloud"
  assume_role_policy = data.aws_iam_policy_document.Assume_role.json
}

resource "aws_iam_role_policy_attachment" "Main_Role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Main_Role.name
}

#EKS Cluster
resource "aws_eks_cluster" "EKS" {
  name     = "EKS_FlaskPipeline"
  role_arn = aws_iam_role.Main_Role.arn

  vpc_config {
    subnet_ids = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Main_Role-AmazonEKSClusterPolicy
  ]
}

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
    desired_size = 8
    max_size     = 12
    min_size     = 8
  }

  launch_template {
    name    = aws_launch_template.EKS_Node_Template.name
    version = aws_launch_template.EKS_Node_Template.latest_version
  }

  remote_access {
    ec2_ssh_key = "Virginia"
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

resource "aws_launch_template" "EKS_Node_Template" {
  name          = "EKS_Node_Template"
  instance_type = "t3.micro"
  user_data     = "../../Bash/worker_node.sh"
}

/*
# Development EKS Cluster
resource "aws_eks_cluster" "EKS_Dev" {
  name     = "EKS_FlaskPipeline_Dev"
  role_arn = aws_iam_role.Main_Role.arn

  vpc_config {
    subnet_ids = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Main_Role-AmazonEKSClusterPolicy
  ]
}

# Create Node Group Dev
resource "aws_eks_node_group" "Worker_Nodes_Dev" {
  cluster_name    = aws_eks_cluster.EKS_Dev.name
  node_group_name = "Node-FlaskPipeline-Dev"
  node_role_arn   = aws_iam_role.Node_Role.arn
  subnet_ids      = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]

  scaling_config {
    desired_size = 8
    max_size     = 12
    min_size     = 8
  }
  instance_types = ["t3.micro"]

  remote_access {
    ec2_ssh_key = "Virginia"
  }

  tags = {
    Environment = "Development"
  }

  depends_on = [
    aws_iam_role_policy_attachment.Node_Role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Node_Role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.Node_Role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
*/
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
