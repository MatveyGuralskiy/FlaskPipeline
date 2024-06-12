#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

variable "Region" {
  description = "AWS Region to work with"
  type        = string
  default     = "eu-central-1"
}

variable "Environment" {
  description = "Environment for the Project"
  type        = string
  default     = "Development"
}

variable "Remote_State_S3" {
  description = "Terraform Backend Bucket Name"
  type        = string
  default     = "flaskpipeline-project-development"
}
