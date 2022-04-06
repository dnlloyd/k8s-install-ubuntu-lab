variable "environment" {}
variable "vpc_id" {}

resource "aws_security_group" "ec2_common" {
  name_prefix = "${var.environment}-common"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "egress_all" {
  type = "egress"

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2_common.id
}

resource "aws_security_group_rule" "ssh_ingress_all" {
  type = "ingress"

  from_port = 22
  to_port = 22
  protocol = "6"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2_common.id
}

resource "aws_security_group_rule" "vpc_ingress_all" {
  type = "ingress"

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["10.0.0.0/16"]

  security_group_id = aws_security_group.ec2_common.id
}

output "ec2_common_security_group" {
  description = "The Security Group created by this module"
  value = aws_security_group.ec2_common
}
