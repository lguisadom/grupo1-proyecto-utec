resource "aws_dynamodb_table" "dim_clienteg1" {
  name         = "${var.dynamodb_table_name}${var.prefix}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id_Cliente"

  attribute {
    name = "Id_Cliente"
    type = "S"
  }

  tags = {
    Environment = "dev"
  }
}
