#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
output "ASG_Name" {
  value = aws_autoscaling_group.Database-PostgreSQL-ASG.name
}

output "VPC_ID" {
  value       = aws_vpc.VPC_FlaskPipeline.id
  description = "My VPC ID"
}

output "VPC_cidr" {
  value       = aws_vpc.VPC_FlaskPipeline.cidr_block
  description = "My VPC CIDR Block"
}

output "Public_Subnets_ID" {
  value       = aws_subnet.Public_Subnets[*].id
  description = "Public Subnets ID's"
}

output "Private_Subnets_ID" {
  value       = aws_subnet.Private_Subnets[*].id
  description = "Private Subnets ID's"
}

output "Certificate_Arn" {
  value = aws_acm_certificate.FlaskPipeline_cert.arn
}

output "EKS_Security_Group_ID" {
  description = "Security group of EKS Cluster and Worker Nodes"
  value       = aws_security_group.EKS_SG.id
}
