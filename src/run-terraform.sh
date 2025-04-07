#!/bin/bash

set -e

git clone https://github.com/joaqu1m/infra-orchestrator.git

TERRAFORM_DIR="./infra-orchestrator/terraform"

if ! command -v terraform &> /dev/null; then
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
  sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo || true
  sudo yum install -y terraform || sudo apt-get install -y terraform
fi

TERRAFORM_STATE_DIR="$TERRAFORM_DIR/terraform-state"
mkdir -p $TERRAFORM_STATE_DIR

if ls *.tfstate 1> /dev/null 2>&1; then
  cp *.tfstate $TERRAFORM_STATE_DIR
fi
cd $TERRAFORM_DIR

terraform init
terraform plan -out=$TERRAFORM_STATE_DIR/plan.tfplan
terraform apply -auto-approve $TERRAFORM_STATE_DIR/plan.tfplan
