output "vpc_id" {
  value       = module.networking_module.vpc_id
  description = "id of the otms vpc "
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.networking_module.igw_id
}

output "NAT_Gateway" {
  value = module.networking_module.NAT_Gateway
}

output "public_rt_id" {
  value = module.networking_module.public_rt_id
}

output "privat_rt_id" {
  value = module.networking_module.privat_rt_id
}

output "public_subnet_ids" {
  value = module.networking_module.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking_module.private_subnet_ids
}
output "application_subnet_ids" {
  value = module.networking_module.application_subnet_ids
}
output "database_subnet_ids" {
  value = module.networking_module.database_subnet_ids
}
output "eks_security_group_ids" {
  value = module.networking_module.eks_security_group_ids
}


###################### Outputs for EKS Cluster ####################

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.compute_module.eks_cluster_name
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.compute_module.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.compute_module.eks_cluster_endpoint
}

###################### Outputs for Node Group ####################

output "eks_node_group_app" {
  description = "The name of the EKS node group"
  value       = module.compute_module.eks_node_group_app
}

output "eks_node_group_db" {
  description = "The name of the EKS node group"
  value       = module.compute_module.eks_node_group_app
}

output "eks_node_group_role_arn" {
  description = "The ARN of the node group role"
  value       = module.compute_module.eks_node_group_role_arn
}
