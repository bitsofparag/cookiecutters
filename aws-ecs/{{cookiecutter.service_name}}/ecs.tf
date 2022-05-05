# ECS task and service definitions for {{cookiecutter.service_name}} api
locals {
  log_group_name   = "/ecs/{{cookiecutter.service_name}}"
  command          = split(" ", var.command)
  docker_image_url = var.ecr_repository_name != "" ? "${aws_ecr_repository.service[0].registry_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:${var.image_tag}" : "${var.dockerhub_repository_name}:${var.image_tag}"
}

resource "aws_cloudwatch_log_group" "service" {
  name              = local.log_group_name
  retention_in_days = var.ecs_log_retention_in_days
  tags              = merge(var.tags, { "Name" : "logs-${var.service_label}" })
}

# Role and policies for ec2 task execution
resource "aws_iam_role" "ecs_task" {
  name               = "role-${var.service_label}"
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(var.tags, { "Name" : "role-${var.service_label}" })
}

# Uses AmazonECSTaskExecutionRolePolicy. See AWS docs for details.
resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = data.aws_iam_policy.ecs_task_exec.arn
}

resource "aws_ecs_task_definition" "service" {
  family                   = "taskdef-${var.service_label}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task.arn
  memory                   = {{cookiecutter.service_memory}}
  cpu                      = {{cookiecutter.service_cpu}}
  task_role_arn            = aws_iam_role.ecs_task.arn

  # If you want to override the container entrypoint, add:
  # "entryPoint": ["bash", "-c"],
  #
  # Note that "user" is set as root. Remove that setting if
  # container can be run in rootless mode.
  #
  # TODO set variables below from aws secrets parameter store
  container_definitions = <<DEF
[
  {
    "name": "${var.environment}-{{cookiecutter.service_name}}",
    "image": "${local.docker_image_url}",
    "essential": true,
    "cpu": 0,
    "links": [],
    "volumesFrom": [],
    "mountPoints": [],
    "user": "root",
    "environment": [
      {
        "name": "ENVIRONMENT",
        "value": "${var.environment}"
      },
      {
        "name": "PROJECT_NAMESPACE",
        "value": "${var.project_namespace}"
      },
      {
        "name": "APP_SENTRY_DSN",
        "value": "${var.sentry_dsn}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "command": ${jsonencode(var.command != "" ? local.command : [])},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${local.log_group_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "${var.environment}"
      }
    }
  }
]
DEF

  tags = merge(var.tags, { "Name" : "taskdef-${var.service_label}" })
}

# Get the above task definition (if set) for reference in ecs_service
data "aws_ecs_task_definition" "service" {
  task_definition = aws_ecs_task_definition.service.family
  depends_on = [
    aws_ecs_task_definition.service
  ]
}

resource "aws_ecs_cluster" "service" {
  count = var.ecs_cluster_name == "" ? 1 : 0
  name  = "cluster-${var.cluster_label}"

  tags = merge(var.tags, { "Name" : "cluster-${var.cluster_label}" })
}

data "aws_ecs_cluster" "service" {
  count = var.ecs_cluster_name != "" ? 1 : 0
  cluster_name = var.ecs_cluster_name
  depends_on = [
    aws_ecs_cluster.service
  ]
}

resource "aws_ecs_service" "this" {
  name                               = var.service_label
  launch_type                        = "FARGATE"
  task_definition                    = "${aws_ecs_task_definition.service.family}:${max(aws_ecs_task_definition.service.revision, data.aws_ecs_task_definition.service.revision)}"
  cluster                            = var.ecs_cluster_name != "" ? data.aws_ecs_cluster.service[0].arn : aws_ecs_cluster.service[0].arn
  desired_count                      = var.ecs_desired_task_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = "${var.environment}-{{cookiecutter.service_name}}"
    container_port   = 80
  }

  tags = merge(var.tags, { "Name" : var.service_label })
}
