module "n8n" {
  source      = "./modules/n8n"
  ami_id      = var.ami_id
  key_name    = var.key_name
  iam_role_id = var.iam_role_id
}
