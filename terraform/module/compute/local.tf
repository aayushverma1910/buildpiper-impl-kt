###################### EKS Cluster  ####################

locals {
  eks_name = "${var.env}-${var.project_name}-eks-cluster"
}

###################### Node Group  ####################

locals {
  node_group_name = "${var.env}-${var.project_name}-eks-node-group"
}
