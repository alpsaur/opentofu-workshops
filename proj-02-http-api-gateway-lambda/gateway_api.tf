# Steps to create an HTTP API Gateway with Lambda integration:
# 1. Create the API Gateway (aws_apigatewayv2_api)
# 2. Create a stage for the API (aws_apigatewayv2_stage)
# 3. Create an integration between the API and Lambda (aws_apigatewayv2_integration)
# 4. Create a route for the API (aws_apigatewayv2_route)
# 5. Grant permission for API Gateway to invoke the Lambda function (aws_lambda_permission)

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api

resource "aws_apigatewayv2_api" "lambda_gateway_api" {
  name        = "lambda-gateway-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_gateway_stage" {
  api_id = aws_apigatewayv2_api.lambda_gateway_api.id
  name        = "lambda-gateway-stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_gateway_integration" {
  api_id = aws_apigatewayv2_api.lambda_gateway_api.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_apigatewayv2_route" "lambda_gateway_route" {
  api_id = aws_apigatewayv2_api.lambda_gateway_api.id
  route_key = "GET /hello"
  target = "integrations/${aws_apigatewayv2_integration.lambda_gateway_integration.id}"
}


resource "aws_lambda_permission" "lambda_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_gateway_api.execution_arn}/*/*"
  # More: http://docs.aws.amazon.com/lambda/latest/dg/API_AddPermission.html
}