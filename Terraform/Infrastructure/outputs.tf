#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

output "VPC_ID" {
  value       = aws_vpc.VPC_FlaskPipeline.id
  description = "My VPC ID"
}

output "VPC_cidr" {
  value       = aws_vpc.VPC_FlaskPipeline.cidr_block
  description = "My VPC CIDR Block"
}

output "EKS_ID" {
  value       = aws_eks_cluster.EKS.id
  description = "EKS Cluster Id"
}

output "Public_Subnet_A" {
  value       = aws_subnet.Public_A.cidr_block
  description = "Public Subnet A USA CIDR Block"
}

output "Public_Subnet_B" {
  value       = aws_subnet.Public_B.cidr_block
  description = "Public Subnet B USA CIDR Block"
}

output "Private_Subnet_A" {
  value       = aws_subnet.Private_A.id
  description = "Private Subnet A USA CIDR Block"
}

output "Private_Subnet_A" {
  value       = aws_subnet.Private_B.id
  description = "Private Subnet B USA CIDR Block"
}

output "Certificate_Arn" {
  value = aws_acm_certificate.FlaskPipeline_cert.arn
}
