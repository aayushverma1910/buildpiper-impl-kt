#################### VPC ########################

locals {
  vpc_name = "${var.env}-${var.project_name}-vpc"
}

#################### SUBNET ########################

locals {
  subnets = [
    for i in range(length(var.subnet_names)) : {
      name       = "${var.env}-${var.project_name}-${var.subnet_names[i]}"
      cidr       = var.subnet_cidrs[i]
      avail_zone = var.subnet_azs[i]
    }
  ]
  public_subnet_indexes = [
    for idx, name in var.subnet_names :
    idx if can(regex("public", name))
  ]

  public_subnet_ids = [
    for i in local.public_subnet_indexes :
    aws_subnet.subnets[i].id
  ]

  private_subnet_indexes = [
    for idx, name in var.subnet_names :
    idx if !can(regex("public", name))
  ]

  private_subnet_ids = [
    for i in local.private_subnet_indexes :
    aws_subnet.subnets[i].id
  ]

}

locals {
  application_subnet_ids = [
    for i, subnet in aws_subnet.subnets :
    subnet.id if can(regex("application", var.subnet_names[i]))
  ]

  database_subnet_ids = [
    for i, subnet in aws_subnet.subnets :
    subnet.id if can(regex("database", var.subnet_names[i]))
  ]
}

#################### IGW ########################

locals {
  InternetGateway = "${var.env}-${var.project_name}-igw"
}

#################### NAT ########################

locals {
  NAT_GW_Name = "${var.env}-${var.project_name}-nat-gateway"
  Eip_Name    = "${var.env}-${var.project_name}-EIP"

  common_tags = {
    env   = var.env
    owner = var.owner
  }
}

#################### Route Table ########################

locals {
  public_rt_name  = "${var.env}-${var.project_name}-${var.public_route_table}-rt"
  private_rt_name = "${var.env}-${var.project_name}-${var.private_route_table}-rt"

}

