variable "group" {}
variable "env" {}
variable "prefix" {}

variable "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "lambda_source_dir" {
  description = "Ruta al directorio de código fuente de las funciones Lambda"
  default     = "../functions"
}

variable "lmb_timeout" {
  default = 60
}

variable "lmb_memory_size" {
  default = 128
}

variable "lmb_get_clientes_name" {
  default = "listar-clientes"
}

variable "lmb_get_cliente_by_id_name" {
  default = "obtener-cliente"
}

variable "lmb_get_clientes_zip_path" {
  default = "../build/get-clientes.zip"
}

variable "lmb_get_cliente_by_id_zip_path" {
  default = "../build/get-cliente-by-id.zip"
} 