#!/bin/bash

set -e

trap 'mv -f ./modules.txt ./modules.tf 2>/dev/null || true' EXIT

rm -rf ~/.aws/
mkdir ~/.aws/

cat <<EOL > ~/.aws/config
[default]
region = us-east-1
output = json
EOL

if [ -f ./terraform/aws.env ]; then
    cat ./terraform/aws.env > ~/.aws/credentials
else
    echo "Arquivo aws.env não encontrado. Por favor, crie o arquivo ./terraform/aws.env com suas credenciais AWS"
    exit 1
fi

cd ./terraform

rm -rf ./terraform-state
rm -rf ./.terraform
rm -f ./.terraform.lock.hcl
rm -f ./universal-key.pem

mv ./modules.tf ./modules.txt

terraform init
terraform apply -auto-approve
