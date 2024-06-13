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

# Create 2 Public Subnets in different Availability Zones:A, B
resource "aws_subnet" "Public_Subnets" {
  count             = length(var.Public_Subnet_CIDR)
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = element(var.Public_Subnet_CIDR, count.index)
  availability_zone = data.aws_availability_zones.Availability.names[count.index]
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet ${count.index + 1}"
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

# Attach Public Subnets to Route Table
resource "aws_route_table_association" "Public_Routes" {
  count          = length(aws_subnet.Public_Subnets[*].id)
  route_table_id = aws_route_table.Public_Subnets.id
  subnet_id      = element(aws_subnet.Public_Subnets[*].id, count.index)
}


#--------------------EKS Cluster-----------------------
# Dynamic Security Group for EKS and Worker Nodes
resource "aws_security_group" "EKS_SG" {
  name        = "EKS Security Group"
  description = "Security Group for EKS Cluster and Worker Nodes"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  dynamic "ingress" {
    for_each = ["8080", "443", "80", "5000", "10250"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS SG"
  }
}
