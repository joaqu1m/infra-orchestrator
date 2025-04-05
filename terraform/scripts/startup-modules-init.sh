#!/bin/bash

set -e

cd ./terraform

TEMP_DIR=$(mktemp -d -p . terraform-startup-XXXXXX)
trap 'cd .. && rm -rf ${TEMP_DIR}' EXIT

rm -rf ~/.aws/
mkdir ~/.aws/

cat <<EOL > ~/.aws/config
[default]
region = us-east-1
output = json
EOL

if [ -f ./terraform/.aws.env ]; then
    cat ./terraform/.aws.env > ~/.aws/credentials
else
    echo "Arquivo .aws.env não encontrado. Por favor, crie o arquivo ./terraform/.aws.env com suas credenciais AWS"
    exit 1
fi

cp ./main.tf ${TEMP_DIR}/
cp ./startup-modules.tf ${TEMP_DIR}/
cp ./variables.tf ${TEMP_DIR}/
cp -r ./modules ${TEMP_DIR}/

cd ${TEMP_DIR}

terraform init
terraform apply -auto-approve

rm -f ../../universal-key.pem
cp ./universal-key.pem ../../universal-key.pem
