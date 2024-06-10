#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

output "S3_Bucket_name" {
  value = aws_s3_bucket.Bucket.bucket_domain_name
}
