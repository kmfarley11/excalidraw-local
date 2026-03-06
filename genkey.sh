#!/bin/bash
HOSTNAME=${HOSTNAME:?HOSTNAME must be set for this cert to generate appropriately!}
openssl req \
    -x509 -newkey rsa:4096 \
    -keyout local.key -out local.cert \
    -sha256 -days 3650 -nodes \
    -subj "/CN=${HOSTNAME}"

chmod 644 local.cert local.key
