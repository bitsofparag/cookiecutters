output "repository_url" {
  value = join("", coalescelist(aws_ecr_repository.service.*.repository_url, [var.dockerhub_repository_name]))
}

output "cluster_arn" {
  value = join("", coalescelist(aws_ecs_cluster.service.*.arn, [aws_ecs_service.this.cluster]))
}
