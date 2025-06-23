#################### VPC ########################
variable "region" {
  type        = string
  default     = "us-east-2"
  description = "enter region name"
}
variable "env" {
  type        = string
  default     = "dev"
  description = "enter env name"
}

variable "owner" {
  type        = string
  default     = "aayush"
  description = "enter vpc owner name"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/24"
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
  default     = "default"
  description = "vpc tenancy 'default' for shared, 'dedicated' for single-tenant hardware."
}
variable "project_name" {
  description = "Project name identifier"
  type        = string
  default     = "otms"
}


#################### SUBNET ########################


variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
  default     = ["public", "frontend", "application", "database", "public-2"]
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
  default     = ["192.168.0.0/28", "192.168.0.16/28", "192.168.0.64/27", "192.168.0.48/28", "192.168.0.32/28"]
}

variable "subnet_azs" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2a", "us-east-2a", "us-east-2a", "us-east-2b"]
}

#################### NAT ########################

variable "Eip_Domain" {
  type        = string
  description = "Domain for Elastic IP"
  default     = "vpc"
}

#################### Route Table ########################

variable "public_route_table" {
  type        = string
  default     = "public"
  description = "enter public route name"
}


variable "private_route_table" {
  type        = string
  default     = "private"
  description = "enter private route name"
}

variable "public_rt_cidr_block" {
  description = "cidr for route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_rt_cidr_block" {
  description = "cidr for privte route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_subnet_indexes" {
  description = "List of indexes from aws_subnet.subnets[] which are public"
  type        = list(number)
  default     = [0]
}

#################### NACL ########################


variable "nacl_names" {
  description = "List of subnet names"
  type        = list(string)
  default     = ["public", "frontend", "application", "database"]
}

variable "nacl_rules" {
  description = "Map of NACL configurations"
  type = map(object({
    subnet_index = list(number)
    ingress_rules = list(object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))
    egress_rules = list(object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))
  }))
}

variable "create_nacl" {
  description = "Set to true to create NACLs"
  type        = bool
  default     = true
}

#################### Security Groups ########################


variable "sg_names" {
  description = "List of security group keys/names"
  type        = list(string)
  default     = ["openvpn", "alb", "frontend", "attendance", "employee", "salary", "postgresql", "redis", "scylla"]
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

#################### VPC Peering ########################

variable "peering_connection" {
  type    = bool
  default = true
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

#################### Application Load Balancer ########################

variable "alb_name" {
  type        = string
  default     = "alb"
  description = "enter load balancer name"
}
variable "lb_internal" {
  type        = bool
  default     = false
  description = "enter load balancer internal"
}
variable "lb_tpye" {
  type        = string
  default     = "application"
  description = "enter load balancer type"
}

variable "lb_enable_deletion" {
  type        = bool
  default     = false
  description = "enter load balancer enable deletion protection"
}

variable "create_alb" {
  description = "Set to true to create Application Load Balancer"
  type        = bool
  default     = true
}

#################### Route 53 DNS Records ########################

variable "record_name" {
  description = "The name/subdomain for the CNAME record (e.g., 'api' for api.example.com)"
  type        = string
}

variable "record_type" {
  description = "The DNS record type - should typically be 'CNAME' for canonical name records"
  type        = string
  default     = "A"
}

variable "create_route53" {
  description = "Set to true to create Route 53 resources"
  type        = bool
  default     = true
}
