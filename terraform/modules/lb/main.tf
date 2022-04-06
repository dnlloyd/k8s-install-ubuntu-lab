variable "subnets" {}
variable "security_group_ids" {}

resource "aws_lb" "api_server" {
  name = "api-server-lb"
  internal = true
  load_balancer_type = "network"
  security_groups = var.security_group_ids
  subnets = [for subnet in var.subnets : subnet.id]
}
