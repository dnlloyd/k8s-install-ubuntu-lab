variable "environment" {}
variable "vpc_id" {}

resource "aws_security_group" "ec2_common" {
  name_prefix = "${var.environment}-common"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "common_egress" {
  type = "egress"

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ec2_common.id}"
}

resource "aws_security_group_rule" "common_ingress" {
  type = "ingress"

  from_port = "22"
  to_port   = "22"
  protocol  = "6"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ec2_common.id}"
}
