# Application Load Balancer
resource "aws_lb" "backend" {
  name                       = "alb-${var.label}"
  load_balancer_type         = "application"
  internal                   = false
  ip_address_type            = "ipv4"
  drop_invalid_header_fields = true
  security_groups            = var.lb_security_groups
  subnets                    = var.lb_public_subnets

  access_logs {
    bucket  = aws_s3_bucket.lb_access_logs.id
    prefix  = var.lb_logs_prefix
    enabled = true
  }

  tags = merge(var.tags, { "Name" : "alb-${var.label}" })
}
