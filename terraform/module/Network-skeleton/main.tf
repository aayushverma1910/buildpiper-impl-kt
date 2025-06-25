#################### VPC ########################

resource "aws_vpc" "otms_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name                                                               = local.vpc_name
    env                                                                = var.env
    owner                                                              = var.owner
    "kubernetes.io/cluster/${var.env}-${var.project_name}-eks-cluster" = "owned"
  }
}

#################### Subnets ########################

resource "aws_subnet" "subnets" {
  count = length(local.subnets)

  vpc_id            = aws_vpc.otms_vpc.id
  cidr_block        = local.subnets[count.index].cidr
  availability_zone = local.subnets[count.index].avail_zone

  tags = {
    Name                                                               = local.subnets[count.index].name
    env                                                                = var.env
    owner                                                              = var.owner
    "kubernetes.io/cluster/${var.env}-${var.project_name}-eks-cluster" = "owned"
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
  dynamic "route" {
    for_each = var.peering_connection ? [1] : []
    content {
      cidr_block = var.use_hardcoded_value ? var.hardcoded_vpc_cidr : (
  length(data.aws_vpc.manage_vpc) > 0 ? data.aws_vpc.manage_vpc[0].cidr_block : ""
)
      #cidr_block = var.use_hardcoded_value ? var.hardcoded_vpc_cidr : try(data.aws_vpc.manage_vpc[0].cidr_block, "")
      #cidr_block                = data.aws_vpc.manage_vpc[0].cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
    }
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
  dynamic "route" {
    for_each = var.peering_connection ? [1] : []
    content {
      cidr_block = var.use_hardcoded_value ? var.hardcoded_vpc_cidr : (
  length(data.aws_vpc.manage_vpc) > 0 ? data.aws_vpc.manage_vpc[0].cidr_block : ""
)
      
      #cidr_block = var.use_hardcoded_value ? var.hardcoded_vpc_cidr : try(data.aws_vpc.manage_vpc[0].cidr_block, "")
      #cidr_block                = data.aws_vpc.manage_vpc[0].cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
    }
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

#################### VPC Peering ######################## 

resource "aws_vpc_peering_connection" "vpc_peering" {
  count         = var.peering_connection ? 1 : 0
  peer_owner_id = var.use_same_account ? data.aws_caller_identity.requester.account_id : var.peer_owner_id
  peer_vpc_id   = aws_vpc.otms_vpc.id
  vpc_id        = var.use_hardcoded_value ? var.hardcoded_vpc_id : try(data.aws_vpc.manage_vpc[0].id, "")
  #vpc_id      = var.use_hardcoded_value ? var.hardcoded_vpc_id : data.aws_vpc.manage_vpc[0].id
  peer_region = var.peer_region
  auto_accept = var.vpc_accept
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
  auto_accept               = true
}

resource "aws_route" "peer_public_rt" {
  count          = var.peering_connection ? 1 : 0
  route_table_id = var.use_hardcoded_value ? var.hardcoded_public_rt : try(data.aws_route_table.manage_public_rt[0].id, "")
  #route_table_id            = data.aws_route_table.manage_public_rt[0].id
  destination_cidr_block    = aws_vpc.otms_vpc.cidr_block
  vpc_peering_connection_id = var.peering_connection ? aws_vpc_peering_connection.vpc_peering[0].id : null
  depends_on                = [aws_vpc_peering_connection.vpc_peering]
}

resource "aws_route" "peer_private_rt" {
  count = var.peering_connection ? 1 : 0
  #route_table_id            = data.aws_route_table.manage_private_rt[0].id
  route_table_id = var.use_hardcoded_value ? var.hardcoded_private_rt : try(data.aws_route_table.manage_private_rt[0].id, "")

  destination_cidr_block    = aws_vpc.otms_vpc.cidr_block
  vpc_peering_connection_id = var.peering_connection ? aws_vpc_peering_connection.vpc_peering[0].id : null
  depends_on                = [aws_vpc_peering_connection.vpc_peering]
}

