resource "aws_lb_listener_rule" "service_https" {
  listener_arn = var.alb_listener_https_arn

  dynamic "condition" {
    for_each = var.environment == "prod" ? [1] : []
    content {
      host_header {
        values = ["{{cookiecutter.service_name}}.${var.domain_name}"]
      }
    }
  }

  dynamic "condition" {
    for_each = var.environment == "stg" || var.environment == "dev" ? [1] : []
    content {
      host_header {
        values = ["${var.environment}-{{cookiecutter.service_name}}.${var.domain_name}"]
      }
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
}
