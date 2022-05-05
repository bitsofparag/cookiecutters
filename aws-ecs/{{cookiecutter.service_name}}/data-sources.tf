data "aws_iam_policy" "ecs_task_exec" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Issue a wildcard certificate manually from the AWS console.
# The status can be pending or issued (for deployment tasks).
data "aws_acm_certificate" "wildcard_ssl" {
  domain      = "*.${var.domain_name}"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["PENDING_VALIDATION", "ISSUED"]
  most_recent = true
}
