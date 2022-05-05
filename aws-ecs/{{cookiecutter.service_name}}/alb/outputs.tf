output "alb_backend" {
  value = aws_lb.backend
}

output "alb_listener_https" {
  value = aws_lb_listener.backend_https
}

output "alb_listener_http" {
  value = aws_lb_listener.backend_http
}
