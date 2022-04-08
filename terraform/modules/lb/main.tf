variable "subnets" {}
variable "security_group_ids" {}
variable "vpc_id" {}
variable "instance_ids_cp" {}
variable "private_domain_name" {}

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
  count = length(var.instance_ids_cp)

  target_group_arn = aws_lb_target_group.api_server.arn
  target_id = var.instance_ids_cp[count.index]
  # port = 6443
}

resource "aws_route53_zone" "k8s_private" {
  name = var.private_domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "api_server_endpoint_c" {
  zone_id = aws_route53_zone.k8s_private.zone_id
  name = "k8s-api-c.${var.private_domain_name}"
  type = "CNAME"
  ttl = "300"
  records = [aws_lb.api_server.dns_name]
}

resource "aws_route53_record" "api_server_endpoint_a" {
  zone_id = aws_route53_zone.k8s_private.zone_id
  name = "k8s-api-a.${var.private_domain_name}"
  type = "A"

  alias {
    name = aws_lb.api_server.dns_name
    zone_id = aws_lb.api_server.zone_id
    evaluate_target_health = true
  }
}
