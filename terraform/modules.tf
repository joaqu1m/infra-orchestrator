module "n8n" {
  source          = "./modules/n8n"
  ami_id          = var.ami_id
  key_name        = var.key_name
  iam_role_id     = var.iam_role_id
  route53_zone_id = aws_route53_zone.iagiliza_zone.zone_id
}
