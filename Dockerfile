from python:3.8
ENV PYTHONUNBUFFERED 1

WORKDIR /var/python3-saml

# パッケージのインストール
RUN apt-get update && \
	apt-get -y install --no-install-recommends \
	curl \
	apache2 \
	apache2-dev \
	libxmlsec1-dev \
	&& \
	rm -r /var/lib/apt/lists/*

# pip インストール
ADD requirements.txt /var/python3-saml
RUN pip install -r requirements.txt;

# Apache の設定
COPY ./apache2_conf/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2_conf/envvars /etc/apache2/envvars
COPY ./apache2_conf/ports.conf /etc/apache2/ports.conf
COPY ./apache2_conf/sites-available/* /etc/apache2/sites-available/
COPY ./apache2_conf/conf-available/* /etc/apache2/conf-available/
COPY ./apache2_conf/mods-available/* /etc/apache2/mods-available/
RUN a2enmod authz_host rewrite ssl headers alias &&\
    a2disconf serve-cgi-bin && \
    a2dissite 000-default.conf && \
    a2ensite python3-saml.conf

# 証明書の設定
COPY ./pki/apache/*.crt /etc/ssl/certs/
COPY ./pki/apache/*.key /etc/ssl/private/

# demo-django のコピー
COPY ./demo-django /var/python3-saml/demo-django

# SP 証明書の配置
COPY ./pki/sp/* /var/python3-saml/demo-django/saml/certs/

# IDP 証明書の配置
COPY ./pki/idp/*.crt /var/python3-saml/
COPY ./tools/certs_convert_string.sh /var/python3-saml/
RUN IDP_CERT_STRING=`/var/python3-saml/certs_convert_string.sh /var/python3-saml/*.crt` && sed -i -e "s%SAML20_IDP_X509_CERT_STRING%${IDP_CERT_STRING}%g" /var/python3-saml/demo-django/saml/settings.json
