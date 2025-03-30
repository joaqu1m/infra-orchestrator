#!/bin/bash

set -e

trap 'mv -f ./startup-modules.txt ./startup-modules.tf 2>/dev/null || true' EXIT

cd ./terraform

mv ./startup-modules.tf ./startup-modules.txt

terraform plan -out=./terraform-state/plan.tfplan
terraform apply -auto-approve ./terraform-state/plan.tfplan
