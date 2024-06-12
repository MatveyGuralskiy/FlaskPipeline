#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

output "S3_Bucket_name" {
  value = aws_s3_bucket.Bucket_Development.bucket_domain_name
}

output "S3_Bucket_name" {
  value = aws_s3_bucket.Bucket_Production.bucket_domain_name
}
