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
    bucket  = "flaskpipeline-project-bucket"
    key     = "Database/terraform.tfstate"
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

# Create 2 Private Subnets in different Availability Zones: A, B
resource "aws_subnet" "Private_Subnets" {
  count             = length(var.Private_Subnet_CIDR)
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = element(var.Private_Subnet_CIDR, count.index)
  availability_zone = data.aws_availability_zones.Availability.names[count.index]
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

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

# Private Route Table
resource "aws_route_table" "Private_Subnets" {
  count  = length(var.Private_Subnet_CIDR)
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT[count.index].id
  }
  tags = {
    Name = "Route Table Private Subnets - ${var.Environment}"
  }
}

# Attach Private Subnets to Route Table
resource "aws_route_table_association" "Private_Routes" {
  count          = length(aws_subnet.Private_Subnets[*].id)
  route_table_id = aws_route_table.Private_Subnets[count.index].id
  subnet_id      = element(aws_subnet.Private_Subnets[*].id, count.index)
}

# Elastic IP for NAT
resource "aws_eip" "NAT_Elastic_IP" {
  count = length(var.Private_Subnet_CIDR)
  tags = {
    Name = "Elastic IP - ${var.Environment}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "NAT" {
  count         = length(var.Private_Subnet_CIDR)
  allocation_id = aws_eip.NAT_Elastic_IP[count.index].id
  subnet_id     = element(aws_subnet.Public_Subnets[*].id, count.index)
  tags = {
    Name = "NAT Gateway ${count.index + 1} - ${var.Environment}"
  }
}


#-----------Database-------------
# Image for Launch Configuration
data "aws_ami" "Latest_Ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Dynamic Security Group for Database
resource "aws_security_group" "Database_SG" {
  name        = "PosgreSQL Security Group"
  description = "Security Group for Flask, PosgreSQL"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  dynamic "ingress" {
    for_each = ["5432", "5000"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
    Name = "PostgreSQL Database SG"
  }
}

# Launch Configuration for Auto-Scaling Group
resource "aws_launch_configuration" "Database-PostgreSQL-LC" {
  name          = "Postgres-Database"
  image_id      = data.aws_ami.Latest_Ubuntu.id
  instance_type = var.Instance_type

  user_data = file("../../Bash/database.sh")

  security_groups = [aws_security_group.Database_SG.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto-Scaling Group for Database
resource "aws_autoscaling_group" "Database-PostgreSQL-ASG" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = aws_subnet.Private_Subnets[*].id

  launch_configuration = aws_launch_configuration.Database-PostgreSQL-LC.id

  tag {
    key                 = "Name"
    value               = "Database-ASG"
    propagate_at_launch = true
  }
}
