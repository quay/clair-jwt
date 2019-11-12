#! /bin/sh
set -e

# Generate a MITM certificate and key
mkdir -p /certificates; cd /certificates
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=NY/L=NYC/O=Dis/CN=self-signed" \
    -keyout mitm.key  -out mitm.crt

cp mitm.crt  /etc/pki/ca-trust/source/anchors/mitm.crt

# This directory is for any custom certificates users want to mount
echo "Copying custom certs to trust if they exist"
if [ "$(ls -A $CLAIRDIR/certs)" ]; then
    cp $CLAIRDIR/certs/* /etc/pki/ca-trust/source/anchors/
fi

update-ca-trust extract
