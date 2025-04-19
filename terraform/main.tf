provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "iagiliza-terraform-lock"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "iagiliza-terraform-lock"
    encrypt        = true
  }
}
 