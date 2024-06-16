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
  value = aws_eks_cluster.EKS.id
}

output "Public_Subnet_A" {
  value = aws_subnet.Public_A.cidr_block
}

output "Public_Subnet_B" {
  value = aws_subnet.Public_B.cidr_block
}
