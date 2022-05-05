# Shared vars
# _____________________
variable "organization" {
  type        = string
  default     = "{{cookiecutter.tfcloud_org_name}}"
  description = "The organization name where this workspace is created."
}

variable "project_namespace" {
  type        = string
  default     = "{{cookiecutter.project_namespace}}"
  description = "Short project namespace (e.g 'acme')"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (e.g. 'staging' or 'prod')"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for e.g. {\"network\" = \"vpc\"}."
}

variable "service_label" {
  type = string
  default = ""
  description = "All resources, except cluster and alb, will be labeled with the value provided."
}

variable cluster_label {
  type = string
  default = ""
  description = "Label for ECS cluster - service-specific or shared."
}

# AWS specific
# ____________________
variable "region" {
  type    = string
  default = "{{cookiecutter.aws_region}}"
}

variable "domain_name" {
  type    = string
  default = "{{cookiecutter.service_root_domain}}"
}


# Route 53 vars
# _____________________
variable "dns_records" {
  type        = list(any)
  default     = []
  description = "The uri of the load balancer, something like [aws_lb.{{cookiecutter.tfcloud_workspace_name}}.dns_name]"
}

variable "domain_zone_id" {
  type        = string
  default     = ""
  description = "The route53 primary zone id"
}


# LB and target groups
# _____________________
variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID where the target group of {{cookiecutter.service_name}} resides."
}

variable "alb_listener_https_arn" {
  type        = string
  default     = "{{cookiecutter.aws_alb_listener_arn}}"
  description = "The HTTPS listener ARN of the load balancer"
}


# ECR vars
# _____________________
variable "ecr_repository_name" {
  type        = string
  default     = {% if cookiecutter.registry_type == "ecr" %}"{{cookiecutter.image_repository_name}}"{% else %}""{% endif %}
  description = "User_provided name for the ECR. But the 'dockerhub_repository_name' variable takes precedence."
}

variable "ecr_tagged_image_max_count" {
  type    = number
  default = 3
}

variable "ecr_untagged_expiration_days" {
  type    = number
  default = 2
}


# ECS vars
# _____________________
variable "aws_access_key_id" {
  type    = string
  default = ""
}

variable "aws_secret_access_key" {
  type    = string
  default = ""
}

variable "ecs_log_retention_in_days" {
  type    = number
  default = 7
  description = "For `dev` environment, set to 7 days. Recommended days for `prod` is 30. Never set this to 0"
}

variable "ecs_desired_task_count" {
  type    = number
  default = 1
}

variable "ecs_cluster_name" {
  type        = string
  default     = "{{cookiecutter.aws_ecs_cluster_name}}"
  description = "If using an existing shared cluster, provide a value here."
}

variable "private_subnet_ids" {
  type    = list(any)
  default = []
}

variable "public_subnet_ids" {
  type    = list(any)
  default = []
}

variable "security_group_ids" {
  type    = list(any)
  default = []
}

# This service's config vars
# _____________________
variable "dockerhub_repository_name" {
  type    = string
  default = {% if cookiecutter.registry_type == "dockerhub" %}"{{cookiecutter.image_repository_name}}"{% else %}""{% endif %}
  description = "Ignored if ecr_repository_name is provided."
}

variable "image_tag" {
  type    = string
  default = "{{cookiecutter.image_tag}}"
}

variable "command" {
  type        = string
  default     = "{{cookiecutter.service_run_command}}"
  description = "The command or its args to start {{cookiecutter.service_name}}"
}

variable "sentry_dsn" {
  type    = string
  default = "{{cookiecutter.sentry_dsn}}"
}

variable "health_check_enabled" {
  type    = bool
  default = {{cookiecutter.service_health_check_enabled}}
}

variable "health_check_path" {
  type    = string
  default = "{{cookiecutter.service_health_check_path}}"
}

variable "health_check_interval" {
  type    = string
  default = "{{cookiecutter.service_health_check_interval}}"
}
