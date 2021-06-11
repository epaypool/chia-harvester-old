FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils apt nfs-common python-is-python3 vim tzdata
RUN apt install -y net-tools netcat

EXPOSE 8555
EXPOSE 8444

ENV plots_dir="/plots"
ENV testnet="false"
ENV LOG_LEVEL=INFO
ARG BRANCH=latest

RUN echo "cloning ${BRANCH}"
RUN git clone --branch ${BRANCH} https://github.com/Chia-Network/chia-blockchain.git \
&& cd chia-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh

WORKDIR /chia-blockchain
ADD ./entrypoint.sh entrypoint.sh
RUN mkdir -p ~/.chia/mainnet/ && echo ${BRANCH} >> branch

ENTRYPOINT ["bash", "./entrypoint.sh"]
