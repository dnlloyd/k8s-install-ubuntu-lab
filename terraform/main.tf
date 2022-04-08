provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  backend "s3" {}
}

locals {
  subnet_ids = var.vpc_id == "" ? [for subnet in module.aws_vpc[0].subnets["public"] : subnet.id] : var.subnets["public"]
  vpc_id = var.vpc_id == "" ? module.aws_vpc[0].vpc.id : var.vpc_id
}

module "aws_vpc" {
  count = var.vpc_id == "" ? 1 : 0

  source = "git@github.com:FoghornConsulting/m-vpc.git"
  nat_instances = var.nat_instances
  az_width = var.az_width
  cidr_block = var.cidr_block
  subnet_map = var.subnet_map
  tag_map = var.tag_map
}

module sgs {
  source = "./modules/sgs/"
  environment = var.environment
  vpc_id = local.vpc_id
}

module instances {
  source = "./modules/instances/"
  instance_count_cp = var.instance_count_cp
  instance_type_cp = var.instance_type_cp
  instance_count_worker = var.instance_count_worker
  instance_type_worker = var.instance_type_worker
  ec2_key_pair_name = var.ec2_key_pair_name
  subnet_ids = local.subnet_ids
  security_group_ids = [module.sgs.ec2_common_security_group.id]
}

module load_balancer {
  count = var.load_balancer

  source = "./modules/lb/"
  subnet_ids = local.subnet_ids
  security_group_ids = [module.sgs.ec2_common_security_group.id]
  vpc_id = local.vpc_id
  instance_ids_cp = module.instances.instance_ids_cp
  private_domain_name = var.private_domain_name
}
