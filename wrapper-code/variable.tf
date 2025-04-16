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

#################### Security Groups ########################


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
  default     = true
}

################################

variable "eks_cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = ""
}
variable "eks_cluster_role_name" {
  type        = string
  description = "IAM Role name for EKS cluster"
  default     = ""
}

variable "launch_template_name_prefix" {
  type        = string
  description = "Prefix for launch template"
  default     = ""
}
variable "eks_node_role_name" {
  type        = string
  description = "IAM Role name for EKS cluster"
  default     = ""
}

variable "app_instance_type" {
  type        = string
  default     = ""
  description = "EC2 instance type for worker nodes"
}
variable "db_instance_type" {
  type        = string
  default     = ""
  description = "EC2 instance type for db worker nodes"
}

variable "eks_node_role_policy_arns" {
  type = map(string)
  default = {
    eks_worker_node = ""
    eks_cni         = ""
    ec2_readonly    = ""
  }
}

variable "eks_cluster_role_policy_arns" {
  type = map(string)
  default = {
    eks_cluster_node = ""
  }
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_max_size" {
  type    = number
  default = 3
}

variable "node_group_min_size" {
  type    = number
  default = 1
}

variable "eks_security_group_ids" {
  description = "List of security group IDs for the EKS cluster."
  type        = list(string)
  default     = []
}

variable "endpoint_private_access" {
  type    = bool
  default = true

}

variable "endpoint_public_access" {
  type    = bool
  default = false

}
