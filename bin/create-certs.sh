#!/bin/bash

set -e

domain=${DOMAIN:-localhost}

mkdir -p certs

mkcert \
  -cert-file ./certs/"${domain}".pem \
  -key-file ./certs/"${domain}"-key.pem \
  -install "${domain}"
