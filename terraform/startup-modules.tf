module "startup" {
  source      = "./modules/startup"
  ami_id      = var.ami_id
  key_name    = var.key_name
  iam_role_id = var.iam_role_id
}
