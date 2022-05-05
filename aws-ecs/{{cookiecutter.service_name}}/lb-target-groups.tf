# Template code

# Target group(s) in the load balancer
# group 1 - {{cookiecutter.service_name}}
resource "aws_lb_target_group" "service" {
  name                          = "tg-1-${var.service_label}"
  protocol                      = "HTTP"
  port                          = 80
  target_type                   = "ip"
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = "least_outstanding_requests"
  deregistration_delay          = 30

  health_check {
    enabled  = var.health_check_enabled
    path     = var.health_check_path
    port     = "traffic-port"
    timeout  = 60
    interval = var.health_check_interval
    matcher  = "200"
  }

  tags = merge(var.tags, { "Name" : "tgrp-${var.service_label}" })
}
