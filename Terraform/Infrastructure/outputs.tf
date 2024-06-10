#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

output "Certificate_Arn" {
  value = aws_acm_certificate.FlaskPipeline_cert.arn
}
