#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

variable "Region" {
  description = "Route53 ACM Region"
  type        = string
  default     = "eu-central-1"
}

variable "Environment" {
  description = "Environment for the Project"
  type        = string
  default     = "Development"
}

variable "Database_type" {
  type        = string
  description = "Database PostgreSQL Instance type"
  default     = "t2.micro"
}

variable "Master_type" {
  type        = string
  description = "Master Instance type"
  default     = "t3.medium"
}

variable "CIDR_VPC" {
  type        = string
  description = "My CIDR Block of AWS VPC"
  default     = "10.0.0.0/16"
}
