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

###################### App Node Group  ####################

resource "aws_launch_template" "eks_app_launch_template" {
  name_prefix   = local.app_lt_name
  instance_type = var.app_instance_type
  image_id      = var.ami_id != "" ? var.key_name : null

  key_name = var.key_name != "" ? var.key_name : null

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.create_sg && length(var.eks_security_group_ids) > 0 ? [var.eks_security_group_ids[0]] : []
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = local.node_group_name
      env   = var.env
      owner = var.owner
    }
  }
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


resource "aws_eks_node_group" "app_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.node_group_name}-app"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.application_subnet_ids

  launch_template {
    id      = aws_launch_template.eks_app_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  tags = {
    Name  = "${local.node_group_name}-app"
    env   = var.env
    owner = var.owner
  }
}


###################### DB Node Group  ####################

resource "aws_launch_template" "eks_db_launch_template" {
  name_prefix   = local.db_lt_name
  instance_type = var.db_instance_type
  image_id      = var.ami_id != "" ? var.key_name : null

  key_name = var.key_name != "" ? var.key_name : null

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.create_sg && length(var.eks_security_group_ids) > 1 ? [var.eks_security_group_ids[1]] : []
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = local.node_group_name
      env   = var.env
      owner = var.owner
    }
  }
}


resource "aws_eks_node_group" "db_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.node_group_name}-db"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.database_subnet_ids

  launch_template {
    id      = aws_launch_template.eks_db_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  tags = {
    Name  = "${local.node_group_name}-db"
    env   = var.env
    owner = var.owner
  }
}
