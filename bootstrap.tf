provider "aws" {
  region = "us-east-1"
}

# Bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-lock"

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

# DynamoDB Table
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Default Keypair
resource "aws_key_pair" "terraform_runner_key" {
  key_name   = "universal-key"
  public_key = tls_private_key.terraform_runner_tls.public_key_openssh
}

resource "tls_private_key" "terraform_runner_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "terraform_runner_pem" {
  content         = tls_private_key.terraform_runner_tls.private_key_pem
  filename        = "${path.root}/universal-key.pem"
  file_permission = "0400"
}
