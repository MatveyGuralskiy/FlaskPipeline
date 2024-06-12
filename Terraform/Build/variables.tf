#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

variable "Region_GER" {
  description = "AWS Region to work with Germany"
  type        = string
  default     = "eu-central-1"
}

variable "Region_USA" {
  description = "AWS Region to work with USA"
  type        = string
  default     = "us-east-1"
}

variable "Env_Development" {
  description = "Environment for the Project Development"
  type        = string
  default     = "Development"
}

variable "Env_Production" {
  description = "Environment for the Project Production"
  type        = string
  default     = "Production"
}

variable "Remote_State_S3_Dev" {
  description = "Terraform Backend Bucket Name"
  type        = string
  default     = "flaskpipeline-project-development"
}

variable "Remote_State_S3_Prod" {
  description = "Terraform Backend Bucket Name for Production"
  type        = string
  default     = "flaskpipeline-project-production"
}
