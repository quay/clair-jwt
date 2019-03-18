#! /bin/sh
set -e

# Generate a MITM certificate and key
echo '{"CN":"CA","key":{"algo":"rsa","size":2048}}' | cfssl gencert -initca - | cfssljson -bare mitm
mkdir -p /certificates
cp mitm-key.pem /certificates/mitm.key
cp mitm.pem /certificates/mitm.crt
cp mitm.pem /etc/pki/ca-trust/source/anchors/mitm.crt

# This directory is for any custom certificates users want to mount
echo "Copying custom certs to trust"
ls /certs/ || true
cp /certs/* /etc/pki/ca-trust/source/anchors/ || true

update-ca-trust extract
