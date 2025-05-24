resource "aws_lambda_function" "get_clientes" {
  function_name = "${var.group}-${var.env}-${var.lmb_get_clientes_name}-${var.prefix}"
  handler       = "get-clientes.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = var.lmb_timeout
  memory_size   = var.lmb_memory_size

  filename         = var.lmb_get_clientes_zip_path
  source_code_hash = filebase64sha256(var.lmb_get_clientes_zip_path)

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }

  depends_on = [null_resource.lambda_builds]
} 