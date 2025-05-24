#DynamoDB
variable "group" {
  type = string
}

variable "env" {
  type = string
}

variable "prefix" {
  type = string
}

variable "dynamodb_table_name" {
  type    = string
  default = "dim_clienteg1"
}
