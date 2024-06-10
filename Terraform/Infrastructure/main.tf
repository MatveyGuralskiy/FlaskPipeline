#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

provider "aws" {
  region = var.Region
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

# Remote State sends on S3 Bucket
terraform {
  backend "s3" {
    bucket  = "flaskpipeline-project-bucket"
    key     = "Production/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

#------------Route53 DNS and ACM-----------------

# Create ACM Request
resource "aws_acm_certificate" "FlaskPipeline_cert" {
  domain_name       = "web.matveyguralskiy.com"
  validation_method = "DNS"
}

# Route53 Zone information
data "aws_route53_zone" "Application_Zone" {
  name         = "matveyguralskiy.com"
  private_zone = false
}

# Create DNS Record in Route53
resource "aws_route53_record" "FlaskPipeline_cert_validation" {
  # Dynamic Record
  for_each = {
    # Domain Validation Option for ACM
    for dvo in aws_acm_certificate.FlaskPipeline_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.Application_Zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# DNS Validation of ACM
resource "aws_acm_certificate_validation" "FlaskPipeline_cert_validation" {
  certificate_arn         = aws_acm_certificate.FlaskPipeline_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.FlaskPipeline_cert_validation : record.fqdn]
}
