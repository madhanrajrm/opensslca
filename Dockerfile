FROM almalinux:8
MAINTAINER madhraje version: 1

ENV CA_PATH /opt/ca
VOLUME      /opt/ca
ENV CNFFILE /root/openssl.cnf

RUN yum -y install openssl curl

COPY ./files/ /root/
WORKDIR /root/
CMD tail -f /dev/null

