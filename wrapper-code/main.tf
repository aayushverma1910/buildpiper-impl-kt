module "networking_module" {
  source = "git::https://github.com/aayushverma1910/buildpiper-impl-kt.git//terraform/module/Network-skeleton?ref=terraform-module"

  # Region and environment
  region               = var.region
  env                  = var.env
  owner                = var.owner
  vpc_cidr             = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  project_name         = var.project_name

  # Subnets
  subnet_names = var.subnet_names
  subnet_cidrs = var.subnet_cidrs
  subnet_azs   = var.subnet_azs

  # NAT
  Eip_Domain = var.Eip_Domain

  # Route Tables
  public_route_table    = var.public_route_table
  private_route_table   = var.private_route_table
  public_rt_cidr_block  = var.public_rt_cidr_block
  private_rt_cidr_block = var.private_rt_cidr_block
  public_subnet_indexes = var.public_subnet_indexes

  # VPC Peering 
  peering_connection = var.peering_connection
  vpc_accept         = var.vpc_accept
  manage_vpc         = var.manage_vpc
  public_rt_name     = var.public_rt_name
  private_rt_name    = var.private_rt_name

  # Security Groups 

  create_sg            = var.create_sg
  sg_names             = var.sg_names
  security_groups_rule = var.security_groups_rule
}

module "compute_module" {
  source                       = "git::https://github.com/aayushverma1910/buildpiper-impl-kt.git//terraform/module/compute?ref=terraform-module"
  env                          = var.env
  owner                        = var.owner
  project_name                 = var.project_name
  eks_cluster_version          = var.eks_cluster_version
  eks_cluster_role_name        = var.eks_cluster_role_name
  eks_node_role_name           = var.eks_node_role_name
  endpoint_private_access      = var.endpoint_private_access
  endpoint_public_access       = var.endpoint_public_access
  launch_template_name_prefix  = var.launch_template_name_prefix
  app_instance_type            = var.app_instance_type
  db_instance_type             = var.db_instance_type
  eks_cluster_role_policy_arns = var.eks_cluster_role_policy_arns
  eks_node_role_policy_arns    = var.eks_node_role_policy_arns
  node_group_desired_size      = var.node_group_desired_size
  node_group_max_size          = var.node_group_max_size
  node_group_min_size          = var.node_group_min_size
  private_subnet_ids           = module.networking_module.private_subnet_ids
  application_subnet_ids       = module.networking_module.application_subnet_ids
  database_subnet_ids          = module.networking_module.database_subnet_ids
  eks_security_group_ids       = module.networking_module.eks_security_group_ids

}
