variable "project" {
  type        = string
  default     = "{{cookiecutter.project_label}}"
  description = "Project name, preferably namespace (e.g `acme`)"
}

variable "name" {
  type        = string
  default     = ""
  description = "Unique name to identify the resource or workspace (e.g. `webserver` or `consul-cluster`)."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (e.g. `dev`, `stg`, `prod`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["environment", "project"]
  description = "Label order of one or more of `name`, `project`, `environment`."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (for e.g. `<index number>` like 1 or 004)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags, for e.g. {\"network\" = \"vpc\"}."
}

variable "createdby" {
  type        = string
  default     = "terraform"
  description = "CreatedBy, eg 'terraform'"
}

variable "managedby" {
  type        = string
  default     = "bitsofparag"
  description = "ManagedBy e.g 'MyOrg'"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `project`, `name`, `environment` and `attributes`."
}
