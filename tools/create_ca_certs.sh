#!/bin/bash
set -euo pipefail

# Common Name
CACN=python3-saml.local
SPCN=python3-saml.local

# CA file
CA_CRT=ca.crt
CA_KEY=ca.key

# Appache cert file
APACHE_SP_CRT=python3-saml.crt
APACHE_SP_CSR=python3-saml_cert.csr
APACHE_SP_KEY=python3-saml_cert.key

# SP cert file
SP_CRT=sp.crt
SP_KEY=sp.key

# CA 証明書作成
openssl req -new -x509 -sha256 -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Python3SAML/CN=${CACN}" -newkey rsa:2048 -nodes -out ${CA_CRT} -keyout ${CA_KEY} -days 1095

# APACHE SP CSR 作成
openssl req -new -nodes -sha256 -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Python3SAML/CN=${SPCN}" -keyout ${APACHE_SP_KEY} -out ${APACHE_SP_CSR}
# APACHE SP 用証明書作成および CA 署名
openssl x509 -req -sha256 -CA ${CA_CRT} -CAkey ${CA_KEY} -CAcreateserial -days 1095 -in ${APACHE_SP_CSR} -out ${APACHE_SP_CRT}

# SP 証明書 作成
openssl req -new -nodes -x509 -days 3652 -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Python3SAML/CN=${SPCN}" -keyout ${SP_KEY} -out ${SP_CRT}
