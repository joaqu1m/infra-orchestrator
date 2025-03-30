FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN sudo apt-get upgrade -y && sudo apt-get update -y

RUN sudo apt-get install awscli -y

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update && apt-get install -y \
    terraform \
    && rm -rf /var/lib/apt/lists/*
