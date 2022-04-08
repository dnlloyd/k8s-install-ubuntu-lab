provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  backend "s3" {}
}

module "aws_vpc" {
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
  vpc_id = module.aws_vpc.vpc.id
}

module instances {
  instance_count_cp = var.instance_count_cp
  instance_type_cp = var.instance_type_cp
  instance_count_worker = var.instance_count_worker
  instance_type_worker = var.instance_type_worker
  source = "./modules/instances/"
  ec2_key_pair_name = var.ec2_key_pair_name
  subnet_id = module.aws_vpc.subnets["public"][0].id
  security_group_ids = [module.sgs.ec2_common_security_group.id]
}

module load_balancer {
  count = var.load_balancer

  source = "./modules/lb/"
  subnets = module.aws_vpc.subnets["public"]
  security_group_ids = [module.sgs.ec2_common_security_group.id]
  vpc_id = module.aws_vpc.vpc.id
  instance_ids_cp = module.instances.instance_ids_cp
  private_domain_name = var.private_domain_name
}
