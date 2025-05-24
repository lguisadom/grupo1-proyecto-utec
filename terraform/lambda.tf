resource "aws_iam_role" "lmb_exec_role" {
  name = "rol-${var.group}-${var.env}-${var.lmb_get_clientes_name}-${var.prefix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lmb_logs" {
  role       = aws_iam_role.lmb_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lmb_get_clientes_policy" {
  name = "policy-${var.group}-${var.env}-${var.lmb_get_clientes_name}-${var.prefix}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["dynamodb:Scan"],
        Resource = aws_dynamodb_table.dim_clienteg1.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lmb_policy_attach" {
  name       = "attach-lmb-dynamodb"
  roles      = [aws_iam_role.lmb_exec_role.name]
  policy_arn = aws_iam_policy.lmb_get_clientes_policy.arn
}

resource "aws_lambda_function" "get_clientes" {
  function_name = "${var.lmb_get_clientes_name}"
  handler       = "get-clientes.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lmb_exec_role.arn
  timeout       = var.lmb_timeout
  memory_size   = var.lmb_memory_size

  filename         = var.lmb_zip_path
  source_code_hash = filebase64sha256(var.lmb_zip_path)
}
