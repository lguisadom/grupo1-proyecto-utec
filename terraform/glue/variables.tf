variable "group" {
  type = string
}

variable "env" {
  type = string
}

variable "prefix" {
  type = string
}

variable "job_name" {
  type = string
  default = "03_gold_dim_clientes"
}

variable "s3_glue_scripts_bucket" {
  type = string
}

variable "table_name" {
  description = "Nombre de la tabla que se pasará como parámetro al Glue Job"
  type = string
}

variable "aws_region" {
  type = string
}
