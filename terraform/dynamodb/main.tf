resource "aws_dynamodb_table" "dim_clienteg1" {
  name           = "dyn-${var.group}-${var.env}-${var.dynamodb_table_name}-${var.prefix}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id_Cliente"

  attribute {
    name = "Id_Cliente"
    type = "S"
  }

  tags = {
    Environment = var.env
    Group      = var.group
  }
}
