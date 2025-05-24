variable "env" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "lmb_zip_path" {
  default = "../build/get-clientes.zip"
}

variable "group" {
  default = "g1"
}

variable "prefix" {
  default = "test"
}

#DynamoDB
variable "dynamodb_table_name" {
  default = "dim_clienteg1"
}

#lmb Functions
variable "lmb_get_clientes_name" {
  default = "get-clientes"
}

variable "lmb_timeout" {
  default = 60
}
variable "lmb_memory_size" {
  default = 128
}

#ApiGateway
variable "api_name" {
  default = "apigateway-siniestros"
}
