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
