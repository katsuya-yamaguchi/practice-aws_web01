FROM ubuntu:latest

ENV ROOT_PATH /root
ARG AWS_ACCESS_KEY
ARG AWS_SECURITY_KEY

WORKDIR /var/tmp
RUN apt-get update && \
    apt-get install -y wget \
                       unzip \
                       python3.8 \
                       python3.8-distutils && \
    wget "https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip"  && \
    unzip terraform_0.12.24_linux_amd64.zip && \
    wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"  && \
    unzip awscli-exe-linux-x86_64.zip && \
    ./aws/install  && \
    wget "https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip" && \
    unzip packer_1.5.5_linux_amd64.zip && \
    wget "https://bootstrap.pypa.io/get-pip.py" && \
    python3.8 get-pip.py && \
    pip3.8 install ansible && \
    rm -f terraform_0.12.24_linux_amd64.zip \
          awscli-exe-linux-x86_64.zip \
          packer_1.5.5_linux_amd64.zip \
          get-pip.py

WORKDIR ${ROOT_PATH}
COPY .aws/config ${ROOT_PATH}/.aws/
COPY .aws/credentials ${ROOT_PATH}/.aws/
RUN sed -i "s/REPLACE_ACCESS_KEY/${AWS_ACCESS_KEY}/g" ${ROOT_PATH}/.aws/credentials && \
    sed -i "s/REPLACE_SECURITY_KEY/${AWS_SECURITY_KEY}/g" ${ROOT_PATH}/.aws/credentials
