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

terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
