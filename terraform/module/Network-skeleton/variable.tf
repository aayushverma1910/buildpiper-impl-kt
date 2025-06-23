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
  default     = "default"
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
