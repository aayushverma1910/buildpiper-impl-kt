#################### VPC ########################
variable "region" {
  type        = string
  default     = ""
  description = "enter region name"
}
variable "env" {
  type        = string
  default     = ""
  description = "enter env name"
}

variable "owner" {
  type        = string
  default     = ""
  description = "enter vpc owner name"
}

variable "vpc_cidr" {
  type        = string
  default     = ""
  description = "enter vpc cidr"
}

variable "enable_dns_support" {
  type        = bool
  description = "enable dns support type"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostname type"
  default     = true
}

variable "instance_tenancy" {
  type        = string
  default     = ""
  description = "vpc tenancy 'default' for shared, 'dedicated' for single-tenant hardware."
}
variable "project_name" {
  description = "Project name identifier"
  type        = string
  default     = ""
}


#################### SUBNET ########################


variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
  default     = []
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
  default     = []
}

variable "subnet_azs" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = []
}

#################### NAT ########################

variable "Eip_Domain" {
  type        = string
  description = "Domain for Elastic IP"
  default     = ""
}

#################### Route Table ########################

variable "public_route_table" {
  type        = string
  default     = ""
  description = "enter public route name"
}


variable "private_route_table" {
  type        = string
  default     = ""
  description = "enter private route name"
}

variable "public_rt_cidr_block" {
  description = "cidr for route table"
  type        = string
  default     = ""
}

variable "private_rt_cidr_block" {
  description = "cidr for privte route table"
  type        = string
  default     = ""
}

variable "public_subnet_indexes" {
  description = "List of indexes from aws_subnet.subnets[] which are public"
  type        = list(number)
  default     = []
}

#################### VPC Peering ########################

variable "use_manage_vpc_data" {
  type    = bool
}

variable "peering_connection" {
  type = bool
}

variable "use_hardcoded_vpc_id" {
  type        = bool
  description = "Use hardcoded VPC ID instead of data source"
  default     = false
}

variable "hardcoded_vpc_id" {
  type        = string
  description = "Hardcoded VPC ID to use when use_hardcoded_vpc_id is true"
  default     = ""
}

variable "vpc_accept" {
  type    = bool
  default = true
}
variable "manage_vpc" {
  description = "Name tag of the VPC to lookup"
  type        = string
  default     = ""
}

variable "public_rt_name" {
  description = "Name tag of the public route table"
  type        = string
  default     = ""
}

variable "private_rt_name" {
  description = "Name tag of the private route table"
  type        = string
  default     = ""
}

variable "peer_owner_id" {
  description = "aws account id"
  type        = string
  default     = ""
}
variable "peer_region" {
  description = "enter the region for connetion of other vpc"
  type        = string
  default     = ""
}
variable "use_same_account" {
  type    = bool
  default = true
}

###################### EKS Cluster  ####################

variable "eks_cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = ""
}

variable "endpoint_private_access" {
  type = bool
}

variable "endpoint_public_access" {
  type = bool

}


variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

################# Policy

variable "eks_cluster_role_name" {
  type        = string
  description = "IAM Role name for EKS cluster"
  default     = ""
}

variable "eks_cluster_role_policy_arns" {
  type = map(string)
  default = {
    eks_cluster_node = ""
  }
}

variable "eks_node_role_policy_arns" {
  type = map(string)
  default = {
    eks_worker_node = ""
    eks_cni         = ""
    ec2_readonly    = ""
  }
}

variable "eks_node_role_name" {
  type        = string
  description = "IAM Role name for EKS cluster"
  default     = ""
}



#################### Security Groups ########################

#node sg

variable "sg_names" {
  description = "List of security group keys/names"
  type        = list(string)
  default     = []
}

variable "security_groups_rule" {
  description = "Map of security group rules"
  type = map(object({
    name = string
    ingress_rules = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      description     = string
      cidr_blocks     = optional(list(string), [])
      source_sg_names = optional(list(string), [])
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "sg_egress_type" {
  default = "egress"
  type    = string

}

variable "sg_ingress_type" {
  default = "ingress"
  type    = string

}

variable "create_sg" {
  description = "Set to true to create security groups"
  type        = bool
}



variable "eks_security_group_ids" {
  description = "List of security group IDs for the EKS cluster."
  type        = list(string)
  default     = []
}

### cluster sg

variable "eks_sg_rule" {
  description = "Rules for EKS cluster security group ingress from other SGs"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
}

###################### Node Group  ####################

variable "ami_type" {
  type        = string
  default     = ""
  description = "value of ami_type"

}

variable "key_pair" {
  description = "Optional key pair name for EC2 instances"
  type        = string
  default     = ""
}


####### App Node Group  ######

variable "application_subnet_ids" {
  type    = list(string)
  default = []

}

variable "app_capacity_type" {
  type        = string
  default     = ""
  description = "value of capacity_type for app"
}

####
variable "associate_public_ip_app" {
  type        = bool
  description = "value of associate_public_ip_address for app"
}

variable "delete_on_termination_app" {
  type        = bool
  description = "value of delete_on_termination for app"

}

variable "app_encrypted" {
  type        = bool
  description = "value of encrypted for app"
}

####

variable "app_instance_type" {
  type        = string
  default     = ""
  description = "EC2 instance type for app worker nodes"
}

variable "ebs_app_volume_size" {
  type        = string
  default     = ""
  description = "EBS volume size for app worker nodes"
}

variable "ebs_app_volume_type" {
  type        = string
  default     = ""
  description = "EBS volume type for app worker nodes"

}

variable "node_group_app_desired_size" {
  type = number
}

variable "node_group_app_max_size" {
  type = number
}

variable "node_group_app_min_size" {
  type = number

}


variable "app_taint_key" {
  type        = string
  default     = ""
  description = "value of taint_key for app"
}
variable "app_taint_value" {
  type        = string
  default     = ""
  description = "value of taint_value for app"
}

variable "app_taint_effect" {
  type        = string
  default     = ""
  description = "value of taint_effect for app"

}



####### DB Node Group  ######

variable "db_taint_key" {
  type        = string
  default     = ""
  description = "value of taint_key for db"
}
variable "db_taint_value" {
  type        = string
  default     = ""
  description = "value of taint_value for db"
}

variable "db_taint_effect" {
  type        = string
  default     = ""
  description = "value of taint_effect for db"

}

variable "db_capacity_type" {
  type        = string
  default     = ""
  description = "value of capacity_type for db"
}

###
variable "associate_public_ip_db" {
  type        = bool
  description = "value of associate_public_ip_address for db"
}

variable "delete_on_termination_db" {
  type        = bool
  description = "value of delete_on_termination for db"

}

variable "db_encrypted" {
  type        = bool
  description = "value of encrypted for db"
}

###
variable "db_instance_type" {
  type        = string
  default     = ""
  description = "EC2 instance type for db worker nodes"
}

variable "ebs_db_volume_size" {
  type        = string
  default     = ""
  description = "EBS volume size for app worker nodes"
}

variable "ebs_db_volume_type" {
  type        = string
  default     = ""
  description = "EBS volume type for db worker nodes"

}

variable "node_group_db_desired_size" {
  type = number
}

variable "node_group_db_max_size" {
  type = number
}

variable "node_group_db_min_size" {
  type = number
}

variable "database_subnet_ids" {
  type    = list(string)
  default = []

}
variable "vpc_id" {
  type    = string
  default = ""

}

