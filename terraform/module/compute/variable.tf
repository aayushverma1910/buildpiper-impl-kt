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
variable "project_name" {
  description = "Project name identifier"
  type        = string
  default     = ""
}
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
variable "eks_node_role_name" {
  type        = string
  description = "IAM Role name for EKS cluster"
  default     = ""
}

variable "app_launch_template_name" {
  type        = string
  description = "Prefix for launch template"
  default     = ""
}
variable "db_launch_template_name" {
  type        = string
  description = "Prefix for launch template"
  default     = ""
}

variable "app_instance_type" {
  type        = string
  default     = ""
  description = "EC2 instance type for app worker nodes"
}

variable "db_instance_type" {
  type        = string
  default     = ""
  description = "EC2 instance type for db worker nodes"
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

variable "database_subnet_ids" {
  type    = list(string)
  default = []

}

variable "application_subnet_ids" {
  type    = list(string)
  default = []

}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}
