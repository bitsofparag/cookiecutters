# Template code

resource "aws_route53_record" "service" {
  zone_id = var.domain_zone_id
  name    = var.environment == "prod" ? "{{cookiecutter.service_name}}.${var.domain_name}" : "${var.environment}-{{cookiecutter.service_name}}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = var.dns_records
}
