provider "aws" {
  region = "us-east-1"
}

variable "iam_role_name" {
  default = "LabRole"
}

# Bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "iagiliza-terraform-state-orchestrator"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Function
resource "aws_lambda_function" "terraform_orchestrator" {
  function_name = "terraform_orchestrator"
  filename      = "lambda_function.zip"
  handler       = "main"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role_name}"
  runtime       = "provided.al2023"
  timeout       = 30
  memory_size   = 256

  environment {
    variables = {
      TERRAFORM_STATE_BUCKET = aws_s3_bucket.terraform_state.bucket
    }
  }
}
