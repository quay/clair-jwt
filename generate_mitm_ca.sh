#! /bin/bash
set -e

mkdir /certificates
echo '{"CN":"CA","key":{"algo":"rsa","size":2048}}' | cfssl gencert -initca - | cfssljson -bare mitm
cp mitm-key.pem /certificates/mitm.key
cp mitm.pem /certificates/mitm.crt
cp mitm.pem /usr/local/share/ca-certificates/mitm.crt

update-ca-certificates
