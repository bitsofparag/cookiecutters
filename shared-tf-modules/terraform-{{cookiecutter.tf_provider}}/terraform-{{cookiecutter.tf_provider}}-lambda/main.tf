/**
* # Lambda module files
*
* ## Usage
*
*
* Here, the Lambda module creates the IAM roles and policies by default, so that
* the user need not worry about them.
*
* 1. Create a `lambda_foo` module in your project Tf files (say in `foo` folder)
*
* 2. Add a proper labels module.
*
* 3. Invoke the module, assuming networking and packages are ready, something like so:
*
* ```hcl
*    module "lambda_foo" {
*      source             = "app.terraform.io/foo/lambda/aws"
*      label              = "${module.labels.id}-foo"
*      tags               = merge(module.labels.tags, { "Name" : "${module.labels.id}-foo" })
*      has_layers         = false
*      runtime            = "python3.10"
*      filename           = "path/to/dist/payload.zip"
*      function_name      = "my_module"
*      handler            = "handler.handle"
*
*      vpc_configuration = {
*        security_group_ids = [
*          data.terraform_remote_state.networking.outputs.sg_all_subnets_id,
*          data.terraform_remote_state.networking.outputs.sg_all_this_public_id,
*        ],
*        subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets
*      }
*
*      env_vars = {
*        variables = {
*          "ENVIRONMENT" : "prod",
*          "VERSION" : "0.1.0"
*        }
*      }
*   }
* ```
*/

# If iam_role_arn is not provided by user, create one here.
resource "aws_iam_role" "lambda" {
  count = var.iam_role_arn == "" ? 1 : 0
  name  = var.iam_role_arn == "" ? "rol-${var.label}" : var.iam_role_id

  tags = var.tags

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "default" {
  count                          = var.enabled && var.image_uri == "" ? 1 : 0
  filename                       = var.filename
  function_name                  = var.function_name
  architectures                  = var.architectures
  role                           = var.iam_role_arn == "" ? aws_iam_role.lambda[0].arn : var.iam_role_arn
  handler                        = var.handler
  reserved_concurrent_executions = var.reserved_concurrent_executions
  source_code_hash               = filebase64sha256(var.filename)
  package_type                   = "Zip"
  publish                        = true

  memory_size = var.memory_size
  runtime     = var.runtime
  timeout     = var.timeout

  layers = var.layers

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "environment" {
    for_each = var.env_vars == null ? [] : [var.env_vars]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  tags = var.tags
}

resource "aws_lambda_function" "container" {
  count                          = var.enabled && var.image_uri != "" ? 1 : 0
  image_uri                      = var.image_uri
  function_name                  = var.function_name
  architectures                  = var.architectures
  role                           = var.iam_role_arn == "" ? aws_iam_role.lambda[0].arn : var.iam_role_arn
  handler                        = var.handler
  reserved_concurrent_executions = var.reserved_concurrent_executions
  package_type                   = "Image"
  publish                        = true

  memory_size = var.memory_size
  runtime     = var.runtime
  timeout     = var.timeout

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "environment" {
    for_each = var.env_vars == null ? [] : [var.env_vars]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "image_config" {
    for_each = var.image_config == null ? [] : [var.image_config]
    content {
      command           = image_config.value.command
      entry_point       = image_config.value.entry_point
      working_directory = image_config.value.working_directory
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  tags = var.tags
}

# ------- enable cloudwatch logging for the lambda -------
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_days
  tags              = merge(var.tags, { "Name" : "log-grp-${var.label}" })
}

resource "aws_iam_role_policy" "allow_logging_cloudwatch" {
  name   = "rol-pol-allow-logging-${var.label}"
  role   = var.iam_role_arn == "" ? aws_iam_role.lambda[0].id : var.iam_role_id
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
