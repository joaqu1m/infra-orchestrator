resource "aws_route53_zone" "iagiliza_zone" {
  name = "iagiliza.com"

  tags = {
    Name        = "iagiliza-zone"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

output "iagiliza_name_servers" {
  value = aws_route53_zone.iagiliza_zone.id
}
