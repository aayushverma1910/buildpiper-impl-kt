###################### EKS Cluster  ####################

resource "aws_eks_cluster" "eks" {
  name     = local.eks_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }


  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

  tags = {
    Name  = local.eks_name
    env   = var.env
    owner = var.owner
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  for_each   = var.eks_cluster_role_policy_arns
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = each.value
}

resource "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachments" {
  for_each   = var.eks_node_role_policy_arns
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}


#################### Security Groups ########################

resource "aws_security_group" "sg" {
  for_each = var.create_sg ? local.security_group_config : {}

  name   = each.value.name
  vpc_id = var.vpc_id 

  tags = {
    Name  = each.value.name
    env   = var.env
    owner = var.owner
  }
  depends_on = [ aws_eks_cluster.eks ]
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.create_sg ? {
    for idx, rule in local.flattened_ingress_rules :
    idx => rule if rule.rule_type == "cidr" || rule.rule_type == "sg"
  } : {}

  type              = var.sg_ingress_type
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  description       = each.value.rule.description
  security_group_id = aws_security_group.sg[each.value.sg_name].id

  cidr_blocks              = each.value.rule_type == "cidr" ? each.value.rule.cidr_blocks : null
source_security_group_id = each.value.rule_type == "sg" ? (
  try(local.known_source_sgs[each.value.rule.source_sg_names[0]], aws_security_group.sg[each.value.rule.source_sg_names[0]].id)
) : null


  depends_on = [
    aws_security_group.sg
  ]
}

resource "aws_security_group_rule" "egress" {
  for_each = var.create_sg ? {
    for idx, rule in local.flattened_egress_rules :
    idx => rule if rule.rule_type == "cidr" || rule.rule_type == "sg"
  } : {}

  type              = var.sg_egress_type
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  description       = each.value.rule.description
  security_group_id = aws_security_group.sg[each.value.sg_name].id

  cidr_blocks              = each.value.rule_type == "cidr" ? each.value.rule.cidr_blocks : null
  source_security_group_id = each.value.rule_type == "sg" ? aws_security_group.sg[each.value.source_sg_names[0]].id : null

  depends_on = [
    aws_security_group.sg
  ]
}




resource "aws_security_group_rule" "sg_to_eks_ingress" {
  for_each = { for rule in local.eks_sg_rules_flat : rule.key => rule }

  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_sg_id
  security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id

  description              = "Allow ${each.key} SG to access EKS Cluster"
}


###################### APP Node Group  ####################



resource "aws_eks_node_group" "app_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.node_group_name}-app"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.application_subnet_ids

  ami_type = var.ami_type
  capacity_type = var.app_capacity_type
  instance_types = var.app_instance_type
  disk_size      = var.app_disk_size

  remote_access {
    ec2_ssh_key               = var.key_pair               
    source_security_group_ids = local.app_lt_sg
  }


  scaling_config {
    desired_size = var.node_group_app_desired_size
    max_size     = var.node_group_app_max_size
    min_size     = var.node_group_app_min_size
   }

  labels = {
  "Name" = "${local.node_group_name}-app"
}

  taint {
    key    =  var.app_taint_key
    value  = var.app_taint_value
    effect = var.app_taint_effect
  }

  tags = {
    Name  = "${local.node_group_name}-app"
    env   = var.env
    owner = var.owner
  }
}


###################### DB Node Group  ####################

resource "aws_eks_node_group" "db_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.node_group_name}-db"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.database_subnet_ids

  ami_type = var.ami_type
  capacity_type = var.db_capacity_type
  instance_types = var.db_instance_type
  disk_size      = var.db_disk_size

  remote_access {
    ec2_ssh_key               = var.key_pair               
    source_security_group_ids = local.db_lt_sg
  }
 
  scaling_config {
    desired_size = var.node_group_db_desired_size
    max_size     = var.node_group_db_max_size
    min_size     = var.node_group_db_min_size
  }

   labels = {
  "Name" = "${local.node_group_name}-db"
}

  taint {
    key    =  var.db_taint_key
    value  = var.db_taint_value
    effect = var.db_taint_effect
  }

  tags = {
    Name  = "${local.node_group_name}-db"
    env   = var.env
    owner = var.owner
  }
  depends_on = [ aws_security_group.sg ]
}
