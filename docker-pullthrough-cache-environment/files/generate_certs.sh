#!/bin/bash

mkdir -p /home/almalinux/certs

openssl req -x509 -newkey rsa:4096 -keyout /home/almalinux/certs/domain.key -out /home/almalinux/certs/domain.crt -sha256 -days 3650 -nodes -subj "/CN=${1}" -addext "subjectAltName = IP:${1}"