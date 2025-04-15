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
