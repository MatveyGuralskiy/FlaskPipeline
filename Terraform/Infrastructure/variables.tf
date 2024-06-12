#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

variable "Region" {
  description = "Route53 ACM Region"
  type        = string
  default     = "us-east-1"
}

variable "Environment" {
  description = "Environment for the Project"
  type        = string
  default     = "Production"
}

variable "Instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

variable "CIDR_VPC" {
  type        = string
  description = "My CIDR Block of AWS VPC"
  default     = "10.0.0.0/16"
}

variable "Private_Subnet_CIDR" {
  description = "VPC Private Subnet CIDR blocks"
  type        = list(any)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "Public_Subnet_CIDR" {
  description = "VPC Public Subnet cidr blocks"
  type        = list(any)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "Node_type" {
  description = "Node Instance type"
  type        = string
  default     = "t3.micro"
}
