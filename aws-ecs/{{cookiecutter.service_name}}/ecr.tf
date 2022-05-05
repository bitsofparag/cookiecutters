# ECR for images in this service
# ------------------------------------------------------------
resource "aws_ecr_repository" "service" {
  count = var.dockerhub_repository_name == "" ? 1 : 0
  name  = var.ecr_repository_name != "" ? var.ecr_repository_name : "ecr-${var.service_label}"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(var.tags, { "Name" : "ecr-${var.service_label}" })
}

resource "aws_ecr_lifecycle_policy" "service" {
  count      = var.dockerhub_repository_name == "" ? 1 : 0
  repository = aws_ecr_repository.service[0].name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last ${var.ecr_tagged_image_max_count} images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v", "latest"],
        "countType": "imageCountMoreThan",
        "countNumber": ${var.ecr_tagged_image_max_count}
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Expire images older than ${var.ecr_untagged_expiration_days} days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.ecr_untagged_expiration_days}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
