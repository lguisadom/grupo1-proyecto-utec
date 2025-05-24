# Rol común para las funciones Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "rol-${var.group}-${var.env}-lambda-${var.prefix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Política base para logs
resource "aws_iam_role_policy" "lambda_base_policy" {
  name = "policy-${var.group}-${var.env}-lambda-base-${var.prefix}"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem"
        ],
        Resource = var.dynamodb_table_arn
      }
    ]
  })
} 