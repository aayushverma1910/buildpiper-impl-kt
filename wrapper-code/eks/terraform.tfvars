region       = "us-east-2"
project_name = "buildpiper"
env          = "dev"
owner        = "aayush"

#################### VPC ########################

vpc_cidr             = "192.168.0.0/24"
enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"
Eip_Domain           = "vpc"

#################### SUBNET ########################

subnet_names = ["public-sub1", "application-sub1", "application-sub2", "database-sub1", "database-sub1", "public-sub2"]

subnet_cidrs = ["192.168.0.0/28", "192.168.0.16/28", "192.168.0.64/27", "192.168.0.48/28", "192.168.0.96/28", "192.168.0.32/28"]

subnet_azs = ["us-east-2a", "us-east-2a", "us-east-2b", "us-east-2a", "us-east-2b", "us-east-2b"]

#################### Route Table ########################

public_route_table    = "public"
private_route_table   = "private"
public_rt_cidr_block  = "0.0.0.0/0"
private_rt_cidr_block = "0.0.0.0/0"
public_subnet_indexes = [0, 5]

#################### VPC Peering ########################

peering_connection = true
vpc_accept         = true
manage_vpc         = "manage-buildpiper-vpc"
public_rt_name     = "manage-buildpiper-public-rt"
private_rt_name    = "manage-buildpiper-private-rt"

#################### Security Groups ########################

create_sg = false
sg_names  = ["application-node", "database-node"]

########### application Security Groups ##########
security_groups_rule = {
  application-node = {
    name = "application-node"
    ingress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 22, to_port = 22, protocol = "tcp", description = "HTTPS access", cidr_blocks = ["192.168.0.0/24"] },
      { from_port = 1025, to_port = 65535, protocol = "tcp", description = "Allow control plane to node communication", cidr_blocks = ["0.0.0.0/0"] }, # Allow kubelet and control plane communication
      { from_port = 0, to_port = 65535, protocol = "-1", description = "Allow node-to-node communication", cidr_blocks = ["0.0.0.0/0"] },              # Node-to-node communication (pods can talk across nodes)
      { from_port = 3000, to_port = 3000, protocol = "tcp", description = "HTTP access", cidr_blocks = ["192.168.0.0/24"] },
      { from_port = 8080, to_port = 8080, protocol = "tcp", description = "HTTP access", cidr_blocks = ["192.168.0.0/24"] },
      { from_port = 8081, to_port = 8081, protocol = "tcp", description = "HTTP access", cidr_blocks = ["192.168.0.0/24"] },
      { from_port = 8082, to_port = 8082, protocol = "tcp", description = "HTTP access", cidr_blocks = ["192.168.0.0/24"] }

    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }

  ######### databse Security Groups ##########
  database-node = {
    name = "database-node"
    ingress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 22, to_port = 22, protocol = "tcp", description = "HTTPS access", cidr_blocks = ["192.168.0.0/24"] },
      { from_port = 1025, to_port = 65535, protocol = "tcp", description = "Allow control plane to node communication", cidr_blocks = ["0.0.0.0/0"] }, # Allow kubelet and control plane communication
      { from_port = 0, to_port = 65535, protocol = "-1", description = "Allow node-to-node communication", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 5432, to_port = 5432, protocol = "tcp", description = "HTTP access for postgresql", source_sg_names = ["application-node"] },
      { from_port = 6379, to_port = 6379, protocol = "tcp", description = "HTTP access for redis", source_sg_names = ["application-node"] },
      { from_port = 9042, to_port = 9042, protocol = "tcp", description = "HTTP access", source_sg_names = ["application-node"] }

    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }
}

################## EKS Cluster ##############################
eks_cluster_version = "1.32"

eks_cluster_role_name = "eks-cluster-roles"
eks_node_role_name    = "eks-node-roles"

app_launch_template_name = "eks-node-app"
db_launch_template_name  = "eks-node-db"

app_instance_type = "t3.medium"
db_instance_type  = "t3.medium"

ami_id   = ""
key_name = ""

eks_cluster_role_policy_arns = {
  eks_cluster_node = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

eks_node_role_policy_arns = {
  eks_worker_node = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  eks_cni         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ec2_readonly    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

endpoint_private_access = true
endpoint_public_access  = false

node_group_desired_size = 2
node_group_max_size     = 3
node_group_min_size     = 1

