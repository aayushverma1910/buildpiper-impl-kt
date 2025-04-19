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


}

module "compute_module" {
  source       = "git::https://github.com/aayushverma1910/buildpiper-impl-kt.git//terraform/module/compute?ref=terraform-module"
  env          = var.env
  owner        = var.owner
  project_name = var.project_name

  # cluster  

  eks_cluster_version          = var.eks_cluster_version
  eks_cluster_role_name        = var.eks_cluster_role_name
  eks_node_role_name           = var.eks_node_role_name
  endpoint_private_access      = var.endpoint_private_access
  endpoint_public_access       = var.endpoint_public_access
  eks_cluster_role_policy_arns = var.eks_cluster_role_policy_arns
  eks_node_role_policy_arns    = var.eks_node_role_policy_arns

  # Security Groups 

  create_sg            = var.create_sg
  sg_names             = var.sg_names
  security_groups_rule = var.security_groups_rule
  eks_sg_rule          = var.eks_sg_rule

  ## Node Group

  ami_type = var.ami_type
  key_pair = var.key_pair

  #App node group

  app_capacity_type           = var.app_capacity_type
  app_instance_type           = var.app_instance_type
  associate_public_ip_app     = var.associate_public_ip_app
  delete_on_termination_app   = var.delete_on_termination_app
  app_encrypted               = var.app_encrypted
  ebs_app_volume_size         = var.ebs_app_volume_size
  ebs_app_volume_type         = var.ebs_app_volume_type
  node_group_app_desired_size = var.node_group_app_desired_size
  node_group_app_max_size     = var.node_group_app_max_size
  node_group_app_min_size     = var.node_group_app_min_size
  app_taint_key               = var.app_taint_key
  app_taint_value             = var.app_taint_value
  app_taint_effect            = var.app_taint_effect



  #DB node group

  db_capacity_type           = var.db_capacity_type
  db_instance_type           = var.db_instance_type
  associate_public_ip_db     = var.associate_public_ip_db
  delete_on_termination_db   = var.delete_on_termination_db
  db_encrypted               = var.db_encrypted
  ebs_db_volume_size         = var.ebs_db_volume_size
  ebs_db_volume_type         = var.ebs_db_volume_type
  node_group_db_desired_size = var.node_group_db_desired_size
  node_group_db_max_size     = var.node_group_db_max_size
  node_group_db_min_size     = var.node_group_db_min_size
  db_taint_key               = var.db_taint_key
  db_taint_value             = var.db_taint_value
  db_taint_effect            = var.db_taint_effect


  vpc_id                 = module.networking_module.vpc_id
  private_subnet_ids     = module.networking_module.private_subnet_ids
  application_subnet_ids = module.networking_module.application_subnet_ids
  database_subnet_ids    = module.networking_module.database_subnet_ids

}
