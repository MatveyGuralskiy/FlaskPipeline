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
  value       = aws_instance.Master_Instance.public_ip
  description = "Public IP of Master Instance"
}

output "Public_RouteTable_A_ID" {
  value       = aws_route_table.Public_RouteTable_A.id
  description = "Public Route Table A ID"
}

output "Public_RouteTable_B_ID" {
  value       = aws_route_table.Public_RouteTable_B.id
  description = "Public Route Table B ID"
}

output "Private_Route_Table_A_ID" {
  value       = aws_route_table.Private_Route_Table_A.id
  description = "Private Route Table A ID"
}

output "Private_Route_Table_B_ID" {
  value       = aws_route_table.Private_Route_Table_B.id
  description = "Private Route Table B ID"
}
