#################### VPC ########################

locals {
  vpc_name = "${var.env}-${var.project_name}-vpc"
}

#################### SUBNET ########################

locals {
  subnets = [
    for i in range(length(var.subnet_names)) : {
      name       = "${var.env}-${var.project_name}-${var.subnet_names[i]}-subnet"
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

#################### Security Groups ########################

locals {
  security_groups = {
    for i in range(length(var.sg_names)) :
    var.sg_names[i] => "${var.env}-${var.project_name}-${var.sg_names[i]}-sg"
  }

  security_group_config = {
    for sg_key, sg_value in var.security_groups_rule :
    sg_key => {
      name    = local.security_groups[sg_key]
      ingress = sg_value.ingress_rules
      egress  = sg_value.egress_rules
    }
  }
}


locals {
  flattened_ingress_rules = flatten([
    for sg_key, sg_value in local.security_group_config : [
      for rule in sg_value.ingress : [
        rule.source_sg_names != null && length(rule.source_sg_names) > 0 ? {
          sg_name   = sg_key
          rule_type = "sg"
          rule      = rule
          } : {
          sg_name   = sg_key
          rule_type = "cidr"
          rule      = rule
        }
      ]
    ]
  ])
}


locals {
  flattened_egress_rules = flatten([
    for sg_key, sg_value in local.security_group_config : [
      for rule in sg_value.egress : [
        length(try(rule.source_sg_names, [])) > 0 ? {
          sg_name   = sg_key
          rule_type = "sg"
          rule      = rule
          } : {
          sg_name   = sg_key
          rule_type = "cidr"
          rule      = rule
        }
      ]
    ]
  ])
}
