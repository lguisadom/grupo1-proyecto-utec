terraform {
  backend "s3" {
    bucket         = "g1-terraform-state-utec"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "g1-terraform-state-lock"
    encrypt        = true
  }
} 