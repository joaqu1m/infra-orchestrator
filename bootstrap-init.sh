#!/bin/bash

set -e

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

rm -f lambda_function.zip
cd ./src
GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o bootstrap
chmod +x bootstrap
chmod +x run-terraform.sh
zip -j ../lambda_function.zip bootstrap run-terraform.sh
cd ..

TEMP_DIR=$(mktemp -d -p . bootstrap-setup-XXXXXX)
trap 'cd .. && rm -rf ${TEMP_DIR}' EXIT

cp ./bootstrap.tf ${TEMP_DIR}/main.tf
cp ./lambda_function.zip ${TEMP_DIR}/lambda_function.zip

cd ${TEMP_DIR}

terraform init
terraform apply -auto-approve

rm -f ../../universal-key.pem
cp ./universal-key.pem ../../universal-key.pem
