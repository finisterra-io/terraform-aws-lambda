data "aws_vpc" "default" {
  count = var.enabled && length(var.vpc_config) > 0 && try(var.vpc_config[0].vpc_name, null) != null ? 1 : 0
  tags = {
    Name = var.vpc_config[0].vpc_name
  }
}

data "aws_security_group" "default" {
  count  = var.enabled && length(var.vpc_config) > 0 && try(var.vpc_config[0].security_group_ids, null) != null ? 1 : 0
  name   = "default"
  vpc_id = lookup(var.vpc_config[0], "vpc_name", null) != null ? data.aws_vpc.default[0].id : var.vpc_config[0].vpc_id
}

data "aws_subnet" "default" {
  count  = var.enabled && length(var.vpc_config) > 0 && try(var.vpc_config[0].subnet_names, null) != null ? length(var.vpc_config[0].subnet_names) : 0
  vpc_id = lookup(var.vpc_config[0], "vpc_name", null) != null ? data.aws_vpc.default[0].id : var.vpc_config[0].vpc_id
  filter {
    name   = "tag:Name"
    values = [var.vpc_config[0].subnet_names[count.index]]
  }
}
