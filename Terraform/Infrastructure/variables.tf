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

variable "Key_SSH" {
  description = "Key Pair Name"
  type        = string
  default     = "Virginia"
}
