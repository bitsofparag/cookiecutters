# Module {{cookiecutter.service_name}}

## Pre-requisites

1. The **Route53 hosted zone id** of your service's root domain/subdomain.
   _(For e.g id of example.com or apps.example.com, which means your service will be hosted as
   myservice.example.com or myservice.apps.example.com)_

2. One ACM certificate for that root domain under which this service will be hosted.
   _(You can manually create it at AWS ACM.)_

3. Networking is already setup (VPC, security groups, subnets etc).
   _(Or use AWS's default VPC - copy vpc id and subnet ids.)_

4. (Optional) if you're using an existing AWS load balancer and/or an existing ECS cluster,
   obtain the values of `alb_listener_https_arn` & `ecs_cluster_name` respectively.

## How-to

If NOT using an existing load balancer, configure the `alb` module like so:

```hcl
# replace values below with the correct ids from step 3. in pre-requisites
module "alb" {
  source = "./modules/alb"

  label             = "alb-{{cookiecutter.service_name}}-${var.environment}"
  tags              = { "Environment" : "${var.environment}" }
  organization      = var.organization
  project_namespace = var.project_namespace
  environment       = var.environment

  domain_name = var.domain_name

  lb_security_groups = [
    data.terraform_remote_state.networking.outputs.sg_http_public_this_id, # for incoming HTTP(S) only
    data.terraform_remote_state.networking.outputs.sg_all_this_public_id # for outgoing on all ports
  ]

  lb_public_subnets = data.terraform_remote_state.networking.outputs.public_subnets

  lb_logs_prefix           = "alb-logs"
  lb_log_retention_in_days = local.default_log_retention_in_days

  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
}
```

Finally, prepare the ECS module. Take note of the label variables.
The example below assumes the existence of a networking workspace:

```hcl
module "{{cookiecutter.service_name}}" {
  source = "./modules/{{cookiecutter.service_name}}"

  cluster_label     = "cluster-{{cookiecutter.service_name}}-${var.environment}" # or "shared-cluster-${var.environment}" if you want this to be a shared cluster
  service_label     = "{{cookiecutter.service_name}}-${var.environment}"
  tags              = { "Environment" : "${var.environment}" }
  organization      = var.organization
  project_namespace = var.project_namespace
  environment       = var.environment

  region            = var.default_region
  domain_name       = var.domain_name
  domain_zone_id    = data.terraform_remote_state.hosting.outputs.aws_route_53_zone_apps.id # or var.domain_name_zone_id
  dns_records       = [module.alb.alb_backend.dns_name]
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id # or var.vpc_id
  private_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets # or add your subnet ids
  security_group_ids = [ # or add your security group ids
    data.terraform_remote_state.networking.outputs.sg_http_public_this_id,
    data.terraform_remote_state.networking.outputs.sg_all_this_public_id,
    data.terraform_remote_state.networking.outputs.sg_all_subnets_id
  ]
{% if cookiecutter.aws_alb_listener_arn == "" %}
  alb_listener_https_arn = module.alb.alb_listener_https.arn # or var.alb_listener_https_arn
{% else %}
  alb_listener_https_arn = {{cookiecutter.aws_alb_listener_arn}} # or var.alb_listener_https_arn
{% endif %}
  ecs_cluster_name = {{cookiecutter.aws_ecs_cluster_name}} # or var.ecs_cluster_name

  # service-specific vars below
{% if cookiecutter.registry_type == 'ecr' %}
  ecr_repository_name       = "{{cookiecutter.image_repository_name}}"
{% else %}
  dockerhub_repository_name = "{{cookiecutter.image_repository_name}}"
{% endif %}
  image_tag = "{{cookiecutter.image_tag}}"
  command   = "{{cookiecutter.service_run_command}}"
  sentry_dsn = "{{cookiecutter.sentry_dsn}}"
  health_check_enabled  = {{cookiecutter.service_health_check_enabled}}
  health_check_path     = "{{cookiecutter.service_health_check_path}}"
  health_check_interval = "{{cookiecutter.service_health_check_interval}}"
}
```

If you wish to provide service-specific variables via Terraform Cloud or a secrets manager,
replace in the above example the following:

```hcl
{% if cookiecutter.registry_type == 'ecr' %}
  ecr_repository_name       = var.{{cookiecutter.service_namespace}}_ecr_repository_name
{% else %}
  dockerhub_repository_name = var.{{cookiecutter.service_namespace}}_dockerhub_repository_name
{% endif %}
  image_tag  = var.{{cookiecutter.service_namespace}}_version
  command    = var.{{cookiecutter.service_namespace}}_command
  sentry_dsn = var.{{cookiecutter.service_namespace}}_sentry_dsn
  health_check_enabled  = var.{{cookiecutter.service_namespace}}_health_check_enabled
  health_check_path     = var.{{cookiecutter.service_namespace}}_health_check_path
  health_check_interval = var.{{cookiecutter.service_namespace}}_health_check_interval
```
