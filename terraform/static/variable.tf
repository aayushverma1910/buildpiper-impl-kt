#################### VPC ########################
variable "region" {
  type        = string
  default     = "us-east-1"
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
  default     = ""
}


#################### SUBNET ########################


variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
  default     = ["public-sub1", "application-sub1", "application-sub2", "database-sub1", "database-sub1", "public-sub2"]
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
  default     = ["192.168.0.0/28", "192.168.0.16/28", "192.168.0.64/27", "192.168.0.48/28", "192.168.0.96/28", "192.168.0.32/28"]
}

variable "subnet_azs" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b", "us-east-1b"]
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

#########################################

variable "eks_cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.32"
}
variable "eks_cluster_role_name" {
  type        = string
  description = "IAM Role name for EKS cluster"
  default     = "eks-cluster-roles"
}

variable "launch_template_name_prefix" {
  type        = string
  description = "Prefix for launch template"
  default     = "eks-node-launch-template"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "EC2 instance type for worker nodes"
}

variable "eks_node_role_policy_arns" {
  type = map(string)
  default = {
    eks_worker_node = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    eks_cni         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ec2_readonly    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
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

