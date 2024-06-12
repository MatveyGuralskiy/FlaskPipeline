#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

provider "aws" {
  region = var.Region_GER
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "usa"
  region = var.Region_USA
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}


#------------Remote state and S3 Bucket-----------------
# Create S3 Bucket for Development
resource "aws_s3_bucket" "Bucket_Development" {
  provider = aws
  bucket   = var.Remote_State_S3_Dev

  tags = {
    Name = "${var.Env_Development} - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning_Dev" {
  bucket = aws_s3_bucket.Bucket_Development.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption_Dev" {
  bucket = aws_s3_bucket.Bucket_Development.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create S3 Bucket for Production
resource "aws_s3_bucket" "Bucket_Production" {
  provider = aws.usa
  bucket   = var.Remote_State_S3_Prod

  tags = {
    Name = "${var.Env_Production} - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning_Prod" {
  provider = aws.usa
  bucket   = aws_s3_bucket.Bucket_Production.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption_Prod" {
  provider = aws.usa
  bucket   = aws_s3_bucket.Bucket_Production.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
