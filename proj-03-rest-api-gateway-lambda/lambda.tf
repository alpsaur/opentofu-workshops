resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello_world.key
  # runtime is the runtime environment for the lambda function. 
  # a runtime is a combination of an operating system, programming language runtime, and AWS runtime environment
  runtime = "nodejs20.x"
  # handler is the entry point for the lambda function
  handler = "hello.handler"

  role = aws_iam_role.lambda_exec_role.arn

  #     ephemeral_storage {
  #     size = 10240 # Min 512 MB and the Max 10240 MB
  #   }
  #  ephemeral storage is the amount of storage available to the lambda function. Can be ommited to use default of 512 MB.
  #  using more sotrage can add to the cold boot time of the lambda function.
}