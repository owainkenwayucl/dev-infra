#!/bin/bash

openssl req -x509 -newkey rsa:4096 -keyout /home/jhrole/jh.key -out /home/jhrole/jh.crt -sha256 -days 3650 -nodes -subj "/CN=${1}" -addext "subjectAltName = IP:${1}"
