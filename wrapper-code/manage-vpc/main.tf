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

  #################### Security Groups ########################

  create_sg            = var.create_sg
  sg_names             = var.sg_names
  security_groups_rule = var.security_groups_rule

}
