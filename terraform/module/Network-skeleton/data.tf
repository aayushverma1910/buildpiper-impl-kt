#################### Data ########################

data "aws_vpc" "manage_vpc" {
  count = var.peering_connection ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.manage_vpc]
  }
}

data "aws_route_table" "manage_public_rt" {
  count = var.peering_connection ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.public_rt_name]
  }
}

data "aws_route_table" "manage_private_rt" {
  count = var.peering_connection ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.private_rt_name]
  }
}

################### Route 53 ########################

data "aws_route53_zone" "public_zone" {
  count      = var.create_route53 ? 1 : 0
  name         = "aman-dw.in"
  private_zone = false
}
