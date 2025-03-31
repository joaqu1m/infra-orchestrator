resource "aws_security_group" "n8n_sg" {
  name = "n8n_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "HTTP"
  # }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "n8n-sg"
  }
}

resource "aws_iam_instance_profile" "n8n_instance_profile" {
  name = "n8n-instance-profile"
  role = var.iam_role_id
}

resource "aws_instance" "n8n" {
  ami                  = var.ami_id
  key_name             = var.key_name
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.n8n_instance_profile.name

  security_groups = [aws_security_group.n8n_sg.name]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name        = "n8n-ec2"
    Environment = "production"
    Managed-by  = "terraform"
  }

  user_data = file("${path.module}/user_data.sh")
}

resource "aws_eip" "n8n_eip" {
  instance   = aws_instance.n8n.id
  depends_on = [aws_instance.n8n]
}

output "n8n_elastic_ip" {
  value = aws_eip.n8n_eip.public_ip
}
