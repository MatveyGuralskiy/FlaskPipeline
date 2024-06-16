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
    Name = "Route Table Public Subnets - ${var.Environment}"
  }
}

# Attach Subnets to Route Table
resource "aws_route_table_association" "RouteTable_Attach_Subnet_A" {
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.Public_Subnets.id
}

resource "aws_route_table_association" "RouteTable_Attach_Subnet_B" {
  subnet_id      = aws_subnet.Public_B.id
  route_table_id = aws_route_table.Public_Subnets.id
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
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }
  instance_types = ["t3.micro"]

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
