# Output value definitions
output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.hello_world.function_name
}

output "archive_file_output" {
  value = data.archive_file.lambda_hello_world.output_path
}

output "base_url" {
  value = "${aws_api_gateway_stage.lambda_gateway_stage.invoke_url}${aws_api_gateway_resource.lambda_gateway_resource.path}"
}
