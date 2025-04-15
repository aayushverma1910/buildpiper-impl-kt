region       = "us-east-1"
project_name = "buildpiper"
env          = "dev"
owner        = "aayush"

#################### VPC ########################

vpc_cidr             = "192.168.0.0/24"
enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"

#################### SUBNET ########################

subnet_names = ["public-sub1", "application-sub1", "application-sub2", "database-sub1", "database-sub1", "public-sub2"]

subnet_cidrs = ["192.168.0.0/28", "192.168.0.16/28", "192.168.0.64/27", "192.168.0.48/28", "192.168.0.96/28", "192.168.0.32/28"]

subnet_azs = ["us-east-1a", "us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b", "us-east-1b"]

#################### Route Table ########################

public_route_table    = "public"
private_route_table   = "private"
public_rt_cidr_block  = "0.0.0.0/0"
private_rt_cidr_block = "0.0.0.0/0"
public_subnet_indexes = [0, 5]

#################### Security Groups ########################

create_sg = true
sg_names  = ["public", "application", "database"]

########### Public Security Groups ##########
security_groups_rule = {
  public = {
    name = "public"
    ingress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }

  ########### application Security Groups ##########
  application = {
    name = "application"
    ingress_rules = [
      { from_port = 22, to_port = 22, protocol = "tcp", description = "HTTPS access", source_sg_names = ["public"] },
      { from_port = 3000, to_port = 3000, protocol = "tcp", description = "HTTP access", source_sg_names = ["public"] },
      { from_port = 8080, to_port = 8080, protocol = "tcp", description = "HTTP access", source_sg_names = ["public"] },
      { from_port = 8081, to_port = 8081, protocol = "tcp", description = "HTTP access", source_sg_names = ["public"] },
      { from_port = 8082, to_port = 8082, protocol = "tcp", description = "HTTP access", source_sg_names = ["public"] }

    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }

  ######### database Security Groups ##########
  database = {
    name = "database"
    ingress_rules = [
      { from_port = 22, to_port = 22, protocol = "tcp", description = "HTTPS access", source_sg_names = ["public"] },
      { from_port = 5432, to_port = 5432, protocol = "tcp", description = "HTTP access for postgresql", source_sg_names = ["application"] },
      { from_port = 6379, to_port = 6379, protocol = "tcp", description = "HTTP access for redis", source_sg_names = ["application"] },
      { from_port = 9042, to_port = 9042, protocol = "tcp", description = "HTTP access", source_sg_names = ["application"] }

    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }
}


eks_cluster_version     = "1.32"
eks_cluster_role_name   = "eks-cluster-roles"

eks_addons = [
  "vpc-cni",
  "coredns",
  "kube-proxy",
  "aws-ebs-csi-driver",
  "aws-efs-csi-driver"
]

launch_template_name_prefix = "eks-node-launch-template"
instance_type               = "t3.medium"

eks_node_role_policy_arns = {
  eks_worker_node = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  eks_cni         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ec2_readonly    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

node_group_desired_size = 2
node_group_max_size     = 3
node_group_min_size     = 1
