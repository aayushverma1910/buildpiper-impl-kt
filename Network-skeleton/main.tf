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

  vpc_id            = aws_vpc.otms_vpc.id
  cidr_block        = local.subnets[count.index].cidr
  availability_zone = local.subnets[count.index].avail_zone

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
