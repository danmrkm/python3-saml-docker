from python:3.8
ENV PYTHONUNBUFFERED 1

WORKDIR /var/python3-saml

# RUN apt-get update && apt-get install -y xmlsec1

ADD requirements.txt /var/python3-saml
RUN pip install -r requirements.txt;
