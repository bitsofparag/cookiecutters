# Lambda module files

## Usage

Here, the Lambda module creates the IAM roles and policies by default, so that
the user need not worry about them.

1. Create a `lambda_foo` module in your project Tf files (say in `foo` folder)

2. Add a proper labels module.

3. Invoke the module, assuming networking and packages are ready, something like so:

```hcl
   module "lambda_foo" {
     source             = "app.terraform.io/foo/lambda/aws"
     label              = "${module.labels.id}-foo"
     tags               = merge(module.labels.tags, { "Name" : "${module.labels.id}-foo" })
     has_layers         = false
     runtime            = "python3.10"
     filename           = "path/to/dist/payload.zip"
     function_name      = "my_module"
     handler            = "handler.handle"

     vpc_configuration = {
       security_group_ids = [
         data.terraform_remote_state.networking.outputs.sg_all_subnets_id,
         data.terraform_remote_state.networking.outputs.sg_all_this_public_id,
       ],
       subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets
     }

     env_vars = {
       variables = {
         "ENVIRONMENT" : "prod",
         "VERSION" : "0.1.0"
       }
     }
  }
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.allow_logging_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.container](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function. Valid values are ["x86\_64"] and ["arm64"] | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group.<br>Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `5` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | The ARN of an SNS topic or SQS queue to notify when an invocation fails.<br>If this option is used, the function's IAM role must be granted suitable access to write to<br>the target object, which means allowing either the sns:Publish or sqs:SendMessage action on<br>this ARN, depending on which service is targeted. | <pre>object({<br>    target_arn = string<br>  })</pre> | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false if you want to disable the Lambda execution or creation. | `bool` | `true` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map of environment variables to be used in the code | <pre>object({<br>    variables = map(string)<br>  })</pre> | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Full path to the zipped file of the src code | `string` | `"Path to the function's deployment package within the local filesystem. Conflicts with `image\_uri`."` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | n/a | `string` | `""` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The exported function name | `string` | `"handler"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | User-provided IAM assume role ARN. Include `iam_role_id` variable as well.<br>\_(If not provided, the Lambda module will create an iam role internally)\_ | `string` | `""` | no |
| <a name="input_iam_role_id"></a> [iam\_role\_id](#input\_iam\_role\_id) | User-provided IAM assume role ID. Include `iam_role_arn` variable as well.<br>\_(If not provided, the Lambda module will create an iam role internally)\_ | `string` | `""` | no |
| <a name="input_image_config"></a> [image\_config](#input\_image\_config) | Container image configuration values that override the values in the container image Dockerfile. | <pre>object({<br>    command           = string<br>    entry_point       = string<br>    working_directory = string<br>  })</pre> | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI containing the function's deployment package. Conflicts with `filename`. | `string` | `""` | no |
| <a name="input_label"></a> [label](#input\_label) | User-provided label used in the auto-generated names | `string` | `""` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. | `list(any)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size allocated to the Lambda function | `number` | `128` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Set value for reserved concurrent executions of the function. | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime to use to run the code on | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for this resource | `map(any)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Default function execution timeout | `number` | `30` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Can be either PassThrough or Active. If PassThrough, Lambda will only trace<br>the request from an upstream service if it contains a tracing header with 'sampled=1'.<br>If Active, Lambda will respect any tracing header it receives from an upstream service.<br>If no tracing header is received, Lambda will call X-Ray for a tracing decision. | <pre>object({<br>    mode = string<br>  })</pre> | `null` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Map of vpc configuration where the Lambda is hosted. | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_function_qualified_arn"></a> [function\_qualified\_arn](#output\_function\_qualified\_arn) | n/a |
| <a name="output_function_size"></a> [function\_size](#output\_function\_size) | n/a |
| <a name="output_function_version"></a> [function\_version](#output\_function\_version) | n/a |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | n/a |
| <a name="output_iam_role_id"></a> [iam\_role\_id](#output\_iam\_role\_id) | n/a |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | n/a |
