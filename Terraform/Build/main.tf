provider "aws" {
  region = var.Region
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

#------------Remote state and S3 Bucket-----------------

# Create S3 Bucket for Terraform
resource "aws_s3_bucket" "Bucket" {
  bucket = var.Remote_State_S3

  tags = {
    Name = "${var.Environment} - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning" {
  bucket = aws_s3_bucket.Bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption" {
  bucket = aws_s3_bucket.Bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
