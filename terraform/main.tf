provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  backend "s3" {}
}

module "aws_vpc" {
  source = "git@github.com:FoghornConsulting/m-vpc.git"
  nat_instances = 1
  az_width = 3
  cidr_block = var.cidr_block
}

module sgs {
  source = "./modules/sgs/"
  environment = var.environment
  vpc_id = module.aws_vpc.vpc.id
}

module instances {
  source = "./modules/instances/"
  ec2_key_pair_name = var.ec2_key_pair_name
  subnet_id = module.aws_vpc.subnets["public"][0].id
  security_group_ids = [module.sgs.ec2_common_security_group.id]
}
