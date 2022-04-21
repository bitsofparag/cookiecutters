variable "label" {
  default     = ""
  type        = string
  description = "User-provided label used in the auto-generated names"
}

variable "tags" {
  default     = {}
  type        = map(any)
  description = "Tags for this resource"
}

# ---- Cloudwatch variables ----
variable "cloudwatch_logs_retention_days" {
  type        = number
  default     = 5
  description = <<-EOS
Specifies the number of days you want to retain log events in the specified log group.
Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653.
EOS
}

# ---- Lambda function important/required variables ----
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false if you want to disable the Lambda execution or creation."
}

variable "layers" {
  default     = []
  type        = list(any)
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
}

variable "function_name" {
  default = ""
  type    = string
}

variable "filename" {
  default     = "Path to the function's deployment package within the local filesystem. Conflicts with `image_uri`."
  type        = string
  description = "Full path to the zipped file of the src code"
}

variable "image_uri" {
  default     = ""
  type        = string
  description = "ECR image URI containing the function's deployment package. Conflicts with `filename`."
}

variable "architectures" {
  default     = ["x86_64"]
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]"
  type        = list(string)
}

variable "reserved_concurrent_executions" {
  default     = -1
  description = "Set value for reserved concurrent executions of the function."
  type        = number
}

variable "memory_size" {
  default     = 128
  type        = number
  description = "Memory size allocated to the Lambda function"
}

variable "runtime" {
  default     = ""
  type        = string
  description = "The runtime to use to run the code on"
}


variable "timeout" {
  default     = 30
  type        = number
  description = "Default function execution timeout"
}

variable "handler" {
  default     = "handler"
  type        = string
  description = "The exported function name"
}

# ---- Lambda optional variables
variable "iam_role_arn" {
  default     = ""
  type        = string
  description = <<-EOS
User-provided IAM assume role ARN. Include `iam_role_id` variable as well.
_(If not provided, the Lambda module will create an iam role internally)_
EOS
}

variable "iam_role_id" {
  default     = ""
  type        = string
  description = <<-EOS
User-provided IAM assume role ID. Include `iam_role_arn` variable as well.
_(If not provided, the Lambda module will create an iam role internally)_
EOS
}

variable "env_vars" {
  type = object({
    variables = map(string)
  })
  default     = null
  description = "Map of environment variables to be used in the code"
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default     = null
  description = "Map of vpc configuration where the Lambda is hosted."
}

variable "dead_letter_config" {
  type = object({
    target_arn = string
  })
  default     = null
  description = <<-EOS
The ARN of an SNS topic or SQS queue to notify when an invocation fails.
If this option is used, the function's IAM role must be granted suitable access to write to
the target object, which means allowing either the sns:Publish or sqs:SendMessage action on
this ARN, depending on which service is targeted.
EOS
}

variable "tracing_config" {
  type = object({
    mode = string
  })
  default     = null
  description = <<-EOS
Can be either PassThrough or Active. If PassThrough, Lambda will only trace
the request from an upstream service if it contains a tracing header with 'sampled=1'.
If Active, Lambda will respect any tracing header it receives from an upstream service.
If no tracing header is received, Lambda will call X-Ray for a tracing decision.
EOS
}

variable "image_config" {
  type = object({
    command           = string
    entry_point       = string
    working_directory = string
  })
  default     = null
  description = <<-EOS
Container image configuration values that override the values in the container image Dockerfile.
EOS
}
