#! /bin/sh
set -e

# Generate a MITM certificate and key
echo '{"CN":"CA","key":{"algo":"rsa","size":2048}}' | cfssl gencert -initca - | cfssljson -bare mitm
mkdir -p /certificates
cp mitm-key.pem /certificates/mitm.key
cp mitm.pem /certificates/mitm.crt
cp mitm.pem /usr/local/share/ca-certificates/mitm.crt

# This directory is for any custom certificates users want to mount
mkdir -p /certs
cp /certs/* /usr/local/share/ca-certificates

update-ca-certificates --fresh
