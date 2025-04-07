provider "aws" {
  region = "us-east-1"
}

variable "iam_role_name" {
  default = "LabRole"
}
variable "aws_region" {
  default = "us-east-1"
}
variable "key_name" {
  default = "universal-key"
}
variable "aws_account_id" {}

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
  function_name                  = "terraform_orchestrator"
  filename                       = "lambda_function.zip"
  handler                        = "main"
  role                           = "arn:aws:iam::${var.aws_account_id}:role/${var.iam_role_name}"
  runtime                        = "provided.al2023"
  architectures                  = ["arm64"]
  timeout                        = 30
  memory_size                    = 256
  reserved_concurrent_executions = 1

  environment {
    variables = {
      TERRAFORM_STATE_BUCKET = aws_s3_bucket.terraform_state.bucket
    }
  }
}

resource "null_resource" "invoke_lambda" {
  depends_on = [aws_lambda_function.terraform_orchestrator]

  provisioner "local-exec" {
    command = "aws lambda invoke --function-name ${aws_lambda_function.terraform_orchestrator.function_name} --region ${var.aws_region} /dev/null"
  }
}

# Keypair
resource "aws_key_pair" "terraform_runner_key" {
  key_name   = var.key_name
  public_key = tls_private_key.terraform_runner_tls.public_key_openssh
}

resource "tls_private_key" "terraform_runner_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "terraform_runner_pem" {
  content         = tls_private_key.terraform_runner_tls.private_key_pem
  filename        = "${path.root}/${var.key_name}.pem"
  file_permission = "0400"
}
