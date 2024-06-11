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
