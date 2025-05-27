provider "aws" {
  region = var.aws_region
}

module "dynamodb" {
  source = "./dynamodb"

  group  = var.group
  env    = var.env
  prefix = var.prefix
}

module "lambda" {
  source = "./lambda"
  
  group  = var.group
  env    = var.env
  prefix = var.prefix

  # Pasamos los valores del módulo dynamodb
  dynamodb_table_arn  = module.dynamodb.table_arn
  dynamodb_table_name = module.dynamodb.table_name
}

module "glue" {
  source = "./glue"

  group = var.group
  env = var.env
  prefix = var.prefix
  aws_region = var.aws_region

  s3_glue_scripts_bucket = module.s3.s3_glue_scripts_bucket
  table_name = module.dynamodb.table_name
}

module "s3" {
  source = "./s3"

  group = var.group
  env = var.env
  prefix = var.prefix
}

terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
