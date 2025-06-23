#################### Data ########################

data "aws_vpc" "manage_vpc" {
  count = var.use_manage_vpc_data ? 1 : 0
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
