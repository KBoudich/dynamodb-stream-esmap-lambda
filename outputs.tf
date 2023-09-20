
output "insert_lambda_function_name" {
  description = "The name of the insert Lambda Function"
  value       = module.insert_lambda_function.lambda_function_name
}

output "update_lambda_function_name" {
  description = "The name of the update Lambda Function"
  value       = module.update_lambda_function.lambda_function_name
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

