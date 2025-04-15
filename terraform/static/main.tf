#################### VPC ########################

resource "aws_vpc" "otms_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name  = local.vpc_name
    env   = var.env
    owner = var.owner
  }
}

#################### Subnets ########################

resource "aws_subnet" "subnets" {
  count = length(local.subnets)

  vpc_id                  = aws_vpc.otms_vpc.id
  cidr_block              = local.subnets[count.index].cidr
  availability_zone       = local.subnets[count.index].avail_zone
  #map_public_ip_on_launch = contains(var.public_subnet_indexes, count.index)


  tags = {
    Name        = local.subnets[count.index].name
    Environment = var.env
    owner       = var.owner
  }
}
#################### IGW ########################

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.otms_vpc.id

  tags = {
    Name  = local.InternetGateway
    env   = var.env
    owner = var.owner
  }
}

#################### NAT ########################

resource "aws_eip" "OT_EIP" {
  domain = var.Eip_Domain
  tags = merge(local.common_tags, {
    Name = local.Eip_Name
  })
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.OT_EIP.id
  subnet_id     = aws_subnet.subnets[0].id
  tags = merge(local.common_tags, {
    Name = local.NAT_GW_Name
  })
}

#################### Route Table ########################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.otms_vpc.id
  route {
    cidr_block = var.public_rt_cidr_block
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name  = local.public_rt_name
    env   = var.env
    owner = var.owner
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.otms_vpc.id
  route {
    cidr_block     = var.private_rt_cidr_block
    nat_gateway_id = aws_nat_gateway.NAT_GW.id
  }

  tags = {
    Name  = local.private_rt_name
    env   = var.env
    owner = var.owner
  }
}

resource "aws_route_table_association" "public_rt_association" {
  for_each = { for idx in var.public_subnet_indexes : idx => aws_subnet.subnets[idx].id }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  for_each = {
    for idx, subnet in aws_subnet.subnets : idx => subnet.id
    if !(contains(var.public_subnet_indexes, idx))
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}

#################### Security Groups ########################

resource "aws_security_group" "sg" {
  for_each = var.create_sg ? local.security_group_config : {}

  name   = each.value.name
  vpc_id = aws_vpc.otms_vpc.id

  tags = {
    Name  = each.value.name
    env   = var.env
    owner = var.owner
  }
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
  source_security_group_id = each.value.rule_type == "sg" ? aws_security_group.sg[each.value.rule.source_sg_names[0]].id : null
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
  source_security_group_id = each.value.rule_type == "sg" ? aws_security_group.sg[each.value.rule.source_sg_names[0]].id : null
}



###################### EKS Cluster  ####################

resource "aws_eks_cluster" "eks" {
  name     = local.eks_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = local.private_subnet_ids #### subnet id
    security_group_ids = [
      for sg_key, sg in aws_security_group.sg : sg.id
      if sg_key != "public"
    ]
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
  name = "eks-cluster-roles"
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
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


###################### Node Group  ####################

resource "aws_launch_template" "eks_launch_template" {
  name_prefix   = "eks-node-launch-template"
  instance_type = "t3.medium"

  network_interfaces {
    associate_public_ip_address = false
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

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = local.private_subnet_ids

  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name  = local.node_group_name
    env   = var.env
    owner = var.owner
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-roles"

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
