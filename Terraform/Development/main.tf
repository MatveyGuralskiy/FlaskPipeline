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

# Create Public Subnet in Availability Zones A, B
resource "aws_subnet" "Public_A" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "${var.Region}a"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet - ${var.Environment}"
  }
}

resource "aws_subnet" "Public_B" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "${var.Region}b"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet - ${var.Environment}"
  }
}

# Create Route Tables for Public Subnet A, B
resource "aws_route_table" "Public_RouteTable_A" {
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
    Name = "Public RouteTable A- ${var.Environment}"
  }
}

# Create Route Tables for Public Subnet A, B
resource "aws_route_table" "Public_RouteTable_B" {
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
    Name = "Public RouteTable B- ${var.Environment}"
  }
}

# Attach Public Subnets to Route Tables
resource "aws_route_table_association" "RouteTable_Attach_A" {
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.Public_RouteTable_A.id
}

resource "aws_route_table_association" "RouteTable_Attach_B" {
  subnet_id      = aws_subnet.Public_B.id
  route_table_id = aws_route_table.Public_RouteTable_B.id
}


# Create 2 Private Subnets in different Availability Zones: A, B
resource "aws_subnet" "Private_A" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "${var.Region}a"

  tags = {
    Name = "Private Subnet - ${var.Environment}"
  }
}

resource "aws_subnet" "Private_B" {
  vpc_id            = aws_vpc.VPC_FlaskPipeline.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "${var.Region}b"

  tags = {
    Name = "Private Subnet - ${var.Environment}"
  }
}

# Create Private Route Tabless for Availability zones: A, B
resource "aws_route_table" "Private_Route_Table_A" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_A.id
  }
  route {
    cidr_block = var.CIDR_VPC
    gateway_id = "local"
  }
  tags = {
    Name = "Route Table Private Subnet A- ${var.Environment}"
  }
}

resource "aws_route_table" "Private_Route_Table_B" {
  vpc_id = aws_vpc.VPC_FlaskPipeline.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_B.id
  }
  route {
    cidr_block = var.CIDR_VPC
    gateway_id = "local"
  }
  tags = {
    Name = "Route Table Private Subnet B- ${var.Environment}"
  }

}

# Elastic IP for NAT A
resource "aws_eip" "NAT_A_EIP" {
  domain = "vpc"
  tags = {
    Name = "Elastic IP A - ${var.Environment}"
  }
}

# Elastic IP for NAT B
resource "aws_eip" "NAT_B_EIP" {
  domain = "vpc"
  tags = {
    Name = "Elastic IP B - ${var.Environment}"
  }
}

# NAT Gateway A
resource "aws_nat_gateway" "NAT_A" {
  allocation_id = aws_eip.NAT_A_EIP.id
  subnet_id     = aws_subnet.Public_A.id
  tags = {
    Name = "NAT Gateway A - ${var.Environment}"
  }
}

# NAT Gateway B
resource "aws_nat_gateway" "NAT_B" {
  allocation_id = aws_eip.NAT_B_EIP.id
  subnet_id     = aws_subnet.Public_B.id
  tags = {
    Name = "NAT Gateway B - ${var.Environment}"
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

# Launch Configuration for Auto-Scaling Group
resource "aws_launch_configuration" "Postgres_Database-LC" {
  name          = "Postgres-Database"
  image_id      = data.aws_ami.Latest_Ubuntu.id
  instance_type = var.Database_type

  key_name = "Frankfurt"

  user_data = file("../../Bash/database.sh")

  security_groups = [aws_security_group.Database_SG.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto-Scaling Group for Database
resource "aws_autoscaling_group" "Postgres_Database-ASG" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.Private_A.id, aws_subnet.Private_B.id]

  launch_configuration = aws_launch_configuration.Postgres_Database-LC.id

  tag {
    key                 = "Name"
    value               = "Database-ASG"
    propagate_at_launch = true
  }
}

# Dynamic Security Group for Database
resource "aws_security_group" "Database_SG" {
  name        = "PostgreSQL Security Group"
  description = "Security Group for PostgreSQL"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  dynamic "ingress" {
    for_each = ["5432"]
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
    Name = "PostgreSQL Database SG"
  }
}

# Create Master Instance
resource "aws_instance" "Master_Instance" {
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Master_type
  subnet_id         = aws_subnet.Public_A.id
  security_groups   = [aws_security_group.SG_Development.id]
  availability_zone = "${var.Region}a"
  key_name          = "Frankfurt"
  # Bash script to install tools for Master
  user_data = file("../../Bash/master_instance.sh")
  tags = {
    Name = "Master Instance"
  }
}

# Dynamic Security Group for Master Instance
resource "aws_security_group" "SG_Development" {
  name        = "Master Security Group"
  description = "Security Group for Master Instance"
  vpc_id      = aws_vpc.VPC_FlaskPipeline.id

  dynamic "ingress" {
    for_each = ["5432", "5000", "8000", "8080", "9000", "80", "22", "443", "465"]
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
    Name = "Master SG"
  }
}
