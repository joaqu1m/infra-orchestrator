#!/bin/bash

set -e

rm -rf ~/.aws/
mkdir ~/.aws/

cat <<EOL > ~/.aws/config
[default]
region = us-east-1
output = json
EOL

if [ -f ./.aws.env ]; then
    cat ./.aws.env > ~/.aws/credentials
else
    echo "Arquivo .aws.env não encontrado. Por favor, crie o arquivo ./.aws.env com suas credenciais AWS"
    exit 1
fi

TEMP_DIR=$(mktemp -d -p . bootstrap-setup-XXXXXX)
trap 'cd .. && rm -rf ${TEMP_DIR}' EXIT

cp ./bootstrap.tf ${TEMP_DIR}/main.tf

cd ${TEMP_DIR}

terraform init
terraform apply -auto-approve

rm -f ../../universal-key.pem
cp ./universal-key.pem ../../universal-key.pem
