# Shared vars
# _______________________
variable "region" {
  description = "Default region usually assigned on account creation."
  type        = string
  default     = "{{cookiecutter.aws_region}}"
}

variable "organization" {
  type        = string
  default     = ""
  description = "The organization name where this workspace is created."
}

variable "project_namespace" {
  type        = string
  default     = ""
  description = "Short project namespace (e.g `acme`)"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (e.g. `staging` or `prod`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags, for e.g. {\"network\" = \"vpc\"}."
}

variable "label" {
  type    = string
  default = ""
}


# Alb vars
# ______________________
variable "domain_name" {
  type        = string
  default     = ""
  description = "The root domain name or subdomain to load_balance."
}

variable "domain_zone_id" {
  type        = string
  default     = ""
  description = "The Route53 zone id for the hosted domain_name."
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "lb_security_groups" {
  type    = list(any)
  default = []
}

variable "lb_public_subnets" {
  type    = list(any)
  default = []
}

variable "lb_logs_prefix" {
  type    = string
  default = ""
}

variable "lb_log_retention_in_days" {
  type    = number
  default = 7
}

variable "service_health_check_enabled" {
  type        = bool
  default     = true
  description = "Set to false if health check needs to be disabled"
}

variable "service_health_check_path" {
  type    = string
  default = ""
}
