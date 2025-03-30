#!/bin/bash

if [ ! -f /var/log/first_boot_done ]; then

    yum update -y

    yum install -y docker git

    systemctl start docker
    systemctl enable docker

    usermod -aG docker ec2-user

    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    su - ec2-user -c "
        git clone https://github.com/joaqu1m/n8n-local-container.git
        cd ./n8n-local-container/src/

        docker volume create n8n_data
        docker volume create traefik_data

        docker-compose up -d
    "

    touch /var/log/first_boot_done
fi
