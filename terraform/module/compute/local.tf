###################### EKS Cluster  ####################

locals {
  eks_name = "${var.env}-${var.project_name}-eks-cluster"
}

###################### launch template  ####################

locals {
  app_lt_name = "${var.env}-${var.project_name}-${var.app_launch_template_name}-lt"
}

locals {
  db_lt_name = "${var.env}-${var.project_name}-${var.db_launch_template_name}-lt"
}


###################### Node Group  ####################

locals {
  node_group_name = "${var.env}-${var.project_name}-eks-node-group"
}
