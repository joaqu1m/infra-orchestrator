provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "${var.solution_name}-terraform-lock"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "${var.solution_name}-terraform-lock"
    encrypt        = true
  }
}
