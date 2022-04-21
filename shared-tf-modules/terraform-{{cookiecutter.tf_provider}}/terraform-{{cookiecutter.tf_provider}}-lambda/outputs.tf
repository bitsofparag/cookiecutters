output "function_arn" {
  value = join("", coalescelist(aws_lambda_function.default.*.arn, aws_lambda_function.container.*.arn))
}

output "function_name" {
  value = join("", coalescelist(aws_lambda_function.default.*.function_name, aws_lambda_function.container.*.function_name))
}

output "function_qualified_arn" {
  value = join("", coalescelist(aws_lambda_function.default.*.qualified_arn, aws_lambda_function.container.*.qualified_arn))
}

output "function_version" {
  value = join("", coalescelist(aws_lambda_function.default.*.version, aws_lambda_function.container.*.version))
}

output "function_size" {
  value = join("", coalescelist(aws_lambda_function.default.*.source_code_size, aws_lambda_function.container.*.source_code_size))
}

output "iam_role_name" {
  value = join("", aws_iam_role.lambda.*.id)
}

output "iam_role_arn" {
  value = join("", aws_iam_role.lambda.*.arn)
}

output "iam_role_id" {
  value = join("", aws_iam_role.lambda.*.id)
}

output "function_invoke_arn" {
  value = join("", coalescelist(aws_lambda_function.default.*.invoke_arn, aws_lambda_function.container.*.invoke_arn))
}
