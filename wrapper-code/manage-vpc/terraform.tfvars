region       = "eu-north-1"
project_name = "buildpiper"
env          = "manage"
owner        = "aayush"

#################### VPC ########################

vpc_cidr             = "10.0.0.0/21"
enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"

#################### SUBNET ########################

subnet_names = ["public", "private"]
subnet_cidrs = ["10.0.0.0/22", "10.0.4.0/22"]
subnet_azs   = ["us-east-2a", "us-east-2a"]

#################### Route Table ########################

public_route_table    = "public"
private_route_table   = "private"
public_rt_cidr_block  = "0.0.0.0/0"
private_rt_cidr_block = "0.0.0.0/0"
public_subnet_indexes = [0]


#################### NACL ########################

create_nacl = true
nacl_names  = ["public", "frontend", "application", "database"]

nacl_rules = {
  public = {
    subnet_index = [0]
    ingress_rules = [
      { protocol = "-1", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
    ]
    egress_rules = [
      { protocol = "-1", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
    ]
  }
}
#################### Security Groups ########################

create_sg = true
sg_names  = ["openvpn", "private"]

########### Openvpn Security Groups ##########

security_groups_rule = {
  openvpn = {
    name = "openvpn"
    ingress_rules = [
      { from_port = 1194, to_port = 1194, protocol = "udp", description = "Allow OpenVPN", cidr_blocks = ["0.0.0.0/0"], source_sg_names = [] },
      { from_port = 80, to_port = 80, protocol = "tcp", description = "Allow OpenVPN", cidr_blocks = ["0.0.0.0/0"], source_sg_names = [] },
      { from_port = 22, to_port = 22, protocol = "tcp", description = "Allow OpenVPN", cidr_blocks = ["0.0.0.0/0"], source_sg_names = [] },
      { from_port = 443, to_port = 443, protocol = "tcp", description = "Allow OpenVPN", cidr_blocks = ["0.0.0.0/0"], source_sg_names = [] },
      { from_port = 943, to_port = 943, protocol = "tcp", description = "Allow OpenVPN", cidr_blocks = ["0.0.0.0/0"], source_sg_names = [] },
      { from_port = 945, to_port = 945, protocol = "tcp", description = "Allow OpenVPN", cidr_blocks = ["0.0.0.0/0"], source_sg_names = [] }
    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }

  ########### private Security Groups ##########

  private = {
    name = "private"
    ingress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
    egress_rules = [
      { from_port = 0, to_port = 0, protocol = "-1", description = "Allow all outbound", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }
}

#################### VPC Peering ########################

peering_connection = false
vpc_accept         = true


#################### Application Load Balancer ########################

create_alb         = false
alb_name           = "alb"
lb_internal        = false
lb_tpye            = "application"
lb_enable_deletion = false


#################### Route 53 DNS Records ########################

create_route53 = false
record_name    = "opstree.aman-dw.in"
record_type    = "A"

