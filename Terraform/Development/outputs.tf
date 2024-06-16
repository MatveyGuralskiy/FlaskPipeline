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

output "Public_A_ID" {
  value       = aws_subnet.Public_A.id
  description = "Public Subnets ID of VPC"
}

output "Public_B_ID" {
  value       = aws_subnet.Public_B.id
  description = "Public Subnets ID of VPC"
}

output "Master_Instance_Public_IP" {
  value = aws_instance.Master_Instance.public_ip
}
