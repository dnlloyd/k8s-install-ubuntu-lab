variable "subnets" {}
variable "security_group_ids" {}
variable "vpc_id" {}
variable "instance_ids" {}

resource "aws_lb" "api_server" {
  name = "api-server-lb"
  internal = true
  load_balancer_type = "network"
  security_groups = var.security_group_ids
  subnets = [for subnet in var.subnets : subnet.id]
}

resource "aws_lb_target_group" "api_server" {
  name = "api-server-tg"
  port = 6443
  protocol = "TCP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "TCP"
    port = 6443
  }
}

resource "aws_lb_listener" "api_server" {
  load_balancer_arn = aws_lb.api_server.arn
  port = "6443"
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_server.arn
  }
}

resource "aws_lb_target_group_attachment" "api_server" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.api_server.arn
  target_id = var.instance_ids[count.index]
  # port = 6443
}
