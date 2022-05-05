# Issue a wildcard certificate manually from the AWS console.
# The status can be pending or issued (for deployment tasks).
data "aws_acm_certificate" "wildcard_ssl" {
  domain      = "*.${var.domain_name}"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["PENDING_VALIDATION", "ISSUED"]
  most_recent = true
}

# --------------------------------------------------
# Loadbalancer default listeners for port 443 ingress
resource "aws_lb_listener" "backend_https" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.wildcard_ssl.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Welcome to ${var.domain_name}"
      status_code  = "200"
    }
  }

  tags = merge(var.tags, { "Name" : "default-https-${var.label}" })
}

# ------------------------------------
# Loadbalancer default listeners for port 80 ingress
resource "aws_lb_listener" "backend_http" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  tags = merge(var.tags, { "Name" : "default-http-${var.label}" })
}
