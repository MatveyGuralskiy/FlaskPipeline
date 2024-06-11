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

output "Public_Subnet_ID" {
  value       = aws_subnet.Public_Subnet.id
  description = "Public Subnets ID of VPC"
}

output "Master_Instance_Public_IP" {
  value = aws_instance.Master_Instance.public_ip
}

output "Database_Public_IP" {
  value = aws_instance.Postgres_Database.public_ip
}
