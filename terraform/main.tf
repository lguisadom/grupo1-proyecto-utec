provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.3"
  backend "local" {}
}
