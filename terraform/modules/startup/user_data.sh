#!/bin/bash

if [ ! -f /var/log/first_boot_done ]; then

    yum update -y

    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum install -y terraform

    su - ec2-user -c "
        git clone https://github.com/joaqu1m/infra-orchestrator-example.git
        cd ./infra-orchestrator-example/

        ./terraform/scripts/modules-init.sh
    "

    touch /var/log/first_boot_done
fi
