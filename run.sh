#!/bin/sh

if [ "$#" -ne 1 ] || ! [ -f "$1" ]; then
  echo "Usage: $0 <config-file>" >&2
  exit 1
fi

jwtproxy -config $1 &
clair -config $1
