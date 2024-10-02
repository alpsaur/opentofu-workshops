# Steps to create an API Gateway with Lambda integration:
# 1. Create the API Gateway REST API || "aws_api_gateway_rest_api"
# 2. Create a resource in the API Gateway || "aws_api_gateway_resource"
# 3. Create a method for the resource (e.g., GET) || "aws_api_gateway_method"
# 4. Create an integration between the API Gateway and Lambda || "aws_api_gateway_integration"
# 5. Set up Lambda permission to allow API Gateway to invoke the function || "aws_lambda_permission"
# 6. Create a deployment for the API Gateway || "aws_api_gateway_deployment"
# note use depends_on to ensure the api gateway is created before the deployment
# 7. Create a stage for the API Gateway || "aws_api_gateway_stage"  

resource "aws_api_gateway_rest_api" "lambda_gateway_api" {
  name        = "lambda-gateway-api"
  description = "API Gateway for Lambda"
}

# create a stage for the api gateway
resource "aws_api_gateway_stage" "lambda_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.lambda_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.lambda_gateway_api.id
  stage_name    = "lambda-stage"
}

resource "aws_api_gateway_resource" "lambda_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gateway_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_gateway_api.root_resource_id
  path_part   = "hello"
}

# create a method for the api gateway
resource "aws_api_gateway_method" "lambda_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_gateway_api.id
  resource_id   = aws_api_gateway_resource.lambda_gateway_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# create an integration for the api gateway
resource "aws_api_gateway_integration" "lambda_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_gateway_api.id
  resource_id             = aws_api_gateway_resource.lambda_gateway_resource.id
  http_method             = aws_api_gateway_method.lambda_gateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_lambda_permission" "lambda_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.lambda_gateway_api.execution_arn}/*/*"
  # More: http://docs.aws.amazon.com/lambda/latest/dg/API_AddPermission.html
}

resource "aws_api_gateway_deployment" "lambda_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lambda_gateway_api.id

  # triggers a redeployment of the api gateway when the body of the rest api changes
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.lambda_gateway_api))
  }

  # this is a list of resources that the deployment depends on. 
  # tofu does not know about the dependencies between the api gateway and the lambda function
  # and will always try to create the deployment first, which will fail because the lambda function is not ready yet
  depends_on = [
    aws_api_gateway_method.lambda_gateway_method,
    aws_api_gateway_integration.lambda_gateway_integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}