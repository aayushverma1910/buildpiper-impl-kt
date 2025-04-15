output "vpc_id" {
  value       = aws_vpc.buildpiper_vpc.id
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

###################### Outputs for EKS Cluster ####################

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks.endpoint
}

###################### Outputs for Node Group ####################

output "eks_node_group_app" {
  description = "The name of the EKS node group"
  value       = aws_eks_node_group.app_node_group.node_group_name
}

output "eks_node_group_db" {
  description = "The name of the EKS node group"
  value       = aws_eks_node_group.db_node_group.node_group_name
}

output "eks_node_group_role_arn" {
  description = "The ARN of the node group role"
  value       = aws_iam_role.eks_node_role.arn
}

###################### Outputs for IAM Roles ####################

output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "The ARN of the EKS node role"
  value       = aws_iam_role.eks_node_role.arn
}
