provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

terraform {
  backend "s3" {}
}

module "aws_vpc" {
  source = "git@github.com:FoghornConsulting/m-vpc.git"
  nat_instances = 1
  az_width = 3
  cidr_block = "${var.cidr_block}"
}

# module sgs {
#   source = "./modules/sgs/"
#   environment = "${var.environment}"
#   vpc_id = "${module.aws_vpc}"
# }
