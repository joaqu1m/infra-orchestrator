variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "example-key"
}

variable "ami_id" {
  default = "ami-08b5b3a93ed654d19" // Amazon Linux 2023 AMI
}

variable "iam_role_id" {
  default = "LabRole"
}
