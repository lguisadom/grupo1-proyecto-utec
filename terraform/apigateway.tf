locals {
  swagger_template = templatefile("${path.module}/openapi/swagger.yaml", {
    region    = var.aws_region
    lambdaArn = aws_lambda_function.get_clientes.arn
  })
}

resource "aws_api_gateway_rest_api" "clientes_api" {
  name = "${var.group}-${var.env}-${var.api_name}-${var.prefix}"
  body = local.swagger_template

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowInvokeByAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_clientes.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.clientes_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.clientes_api.id

  triggers = {
    redeployment = sha256(jsonencode(aws_api_gateway_rest_api.clientes_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_rest_api.clientes_api]
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id  = aws_api_gateway_rest_api.clientes_api.id
  stage_name   = "dev"
}

output "api_url" {
  value = "${aws_api_gateway_stage.dev.invoke_url}/clientes"
}
