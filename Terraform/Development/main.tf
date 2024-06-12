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
    bucket  = "flaskpipeline-project-development"
    key     = "Development/terraform.tfstate"
    region  = "eu-central-1"
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

# Create Public Subnet
resource "aws_subnet" "Public_Subnet" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "${var.Region}a"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet - ${var.Environment}"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "Public_RouteTable" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block = var.CIDR_VPC
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_FlaskPipeline.id
  }
  tags = {
    Name = "Public RouteTable - ${var.Environment}"
  }
}

# Attach Public Subnet to Route Table
resource "aws_route_table_association" "RouteTable_Attach" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_RouteTable.id
}


#-----------Database and Master-------------
# Image for Database and Master
data "aws_ami" "Latest_Ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Dynamic Security Group
resource "aws_security_group" "SG_Development" {
  name        = "PosgreSQL Security Group"
  description = "Security Group for Master Instance and PosgreSQL"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  dynamic "ingress" {
    for_each = ["5432", "5000", "8000", "8080", "9000", "80"]
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

# Create Database
resource "aws_instance" "Postgres_Database" {
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Database_type
  subnet_id         = aws_subnet.Public_Subnet.id
  security_groups   = [aws_security_group.SG_Development.id]
  availability_zone = "${var.Region}a"
  # Bash script to install Docker Image of Database
  user_data = file("../../Bash/database.sh")
  tags = {
    Name = "PostgreSQL Database"
  }
}

# Create Master Instance
resource "aws_instance" "Master_Instance" {
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Master_type
  subnet_id         = aws_subnet.Public_Subnet.id
  security_groups   = [aws_security_group.SG_Development.id]
  availability_zone = "${var.Region}a"
  # Bash script to install tools for Master
  user_data = file("../../Bash/master_instance.sh")
  tags = {
    Name = "Master Instance"
  }
}
