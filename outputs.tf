output "function_arn" {
  description = "ARN of the lambda function"
  value       = var.enabled ? aws_lambda_function.this[0].arn : null
}

output "invoke_arn" {
  description = "Invoke ARN of the lambda function"
  value       = var.enabled ? aws_lambda_function.this[0].invoke_arn : null
}

output "qualified_arn" {
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via publish = true)"
  value       = var.enabled ? aws_lambda_function.this[0].qualified_arn : null
}

output "function_name" {
  description = "Lambda function name"
  value       = var.enabled ? aws_lambda_function.this[0].function_name : null
}

output "role_name" {
  description = "Lambda IAM role name"
  value       = var.enabled ? data.aws_iam_role.this[0].name : null
}

output "role_arn" {
  description = "Lambda IAM role ARN"
  value       = var.enabled ? data.aws_iam_role.this[0].arn : null
}
