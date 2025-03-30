resource "aws_s3_bucket" "ci_cd_test_bucket" {
  bucket = "n8n-bucket-unique-try"

  tags = {
    Name        = "n8n-bucket-unique-try"
    Environment = "Test"
    Purpose     = "CI/CD Testing"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}
