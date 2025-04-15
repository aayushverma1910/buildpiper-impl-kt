output "vpc_id" {
  value       = aws_vpc.otms_vpc.id
  description = "id of the otms vpc "
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}

output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.IGW.id
}

output "NAT_Gateway" {
  value = aws_nat_gateway.NAT_GW.id
}

output "public_rt_id" {
  value = aws_route_table.public_rt.id
}
output "privat_rt_id" {
  value = aws_route_table.private_rt.id
}
output "application_subnet_ids" {
  value = local.application_subnet_ids
}
output "database_subnet_ids" {
  value = local.database_subnet_ids
}
output "eks_security_group_ids" {
  value = [
    for sg_key, sg in aws_security_group.sg : sg.id
    if sg_key != "public"
  ]
}
