resource "aws_apigatewayv2_api" "clientes_api" {
  name          = "${var.group}-${var.env}-${var.api_name}-${var.prefix}"
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowInvokeByAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_clientes.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.clientes_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.clientes_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.get_clientes.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.clientes_api.id
  route_key = "GET /clientes"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.clientes_api.id
  name        = "dev"
  auto_deploy = true
}

output "api_url" {
  value = "${aws_apigatewayv2_stage.dev.invoke_url}/clientes"
}
