resource "aws_glue_job" "my_job" {
  name     = "glue-${var.group}-${var.env}-${var.job_name}-${var.prefix}"
  role_arn = aws_iam_role.glue_execution_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_glue_scripts_bucket}/scripts/${var.job_name}/script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--tableName"      = var.table_name
    "--job-language"   = "python"
    "--TempDir"        = "s3://${var.s3_glue_scripts_bucket}/temp/"
    "--enable-metrics" = "true"
  }

  glue_version      = "5.0"
  number_of_workers = 10
  worker_type       = "G.1X"

  depends_on = [null_resource.upload_glue_script]
}

resource "aws_iam_role" "glue_execution_role" {
  name = "role-${var.group}-${var.env}-${var.job_name}-${var.prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "glue_dynamodb_access" {
  name = "glue-dynamodb-access"
  role = aws_iam_role.glue_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.table_name}"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy_attachment" "glue_policy" {
  role       = aws_iam_role.glue_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.glue_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "null_resource" "upload_glue_script" {
  provisioner "local-exec" {
    command = "aws s3 cp glue/${var.job_name}/script.py s3://${var.s3_glue_scripts_bucket}/scripts/${var.job_name}/script.py"
  }

  triggers = {
    script_hash = filesha1("glue/${var.job_name}/script.py")
    bucket_name = var.s3_glue_scripts_bucket
  }
}
