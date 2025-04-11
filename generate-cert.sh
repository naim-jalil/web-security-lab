#!/bin/bash

cd
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr
openssl x509 -signkey server.key -in server.csr -req -days 365 -out server.crt
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -passout pass:Password
mkdir -p web-security-lab/certificates
cp ser* web-security-lab/certificates/
ls web-security-lab/certificates/ | grep serv