variable "key_name" {}

variable "ami_id" {}

variable "iam_role_id" {}

variable "route53_zone_id" {}

variable "domain_name" {
  default = "n8n.iagiliza.com"
}
