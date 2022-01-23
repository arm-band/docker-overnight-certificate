#!/bin/bash

sed -e "s/HOST_NAME/${2}/gi" -e "s/IP_ADDR/${4}/gi" /template/subjectnames-template.txt > /var/certtemp/subjectnames.txt

# prepare
## delete exists files
if [ -e /etc/ssl/private/${1} ]; then
    rm -Rf /etc/ssl/private/${1}
fi
## make cert directory
mkdir /etc/ssl/private/${1}
# gen key & certificate
## .env domain
# Generate private key for CA and Server.
openssl genrsa 2048 > /etc/ssl/private/${1}/server.key

# Generate certificate sigining requests from same key.
openssl req -new -key /etc/ssl/private/${1}/server.key -subj "/C=${5}/ST=${6}/L=${7}/O=${8}/OU=${9}/CN=${2}" > /etc/ssl/private/${1}/ca.csr
openssl req -new -key /etc/ssl/private/${1}/server.key -subj "/C=${5}/ST=${6}/L=${7}/O=${8}/OU=${9}/CN=${2}" > /etc/ssl/private/${1}/server.csr

# Generate CA certificate.
openssl ca -batch -extensions v3_ca -out /etc/ssl/private/${1}/ca.crt -in /etc/ssl/private/${1}/ca.csr -selfsign -keyfile /etc/ssl/private/${1}/server.key

# Generate server certificate with CA certificate.
openssl x509 -days 3650 -req -extfile /var/certtemp/subjectnames.txt -CA /etc/ssl/private/${1}/ca.crt -CAkey /etc/ssl/private/${1}/server.key -set_serial 1 < /etc/ssl/private/${1}/server.csr > /etc/ssl/private/${1}/server.crt
