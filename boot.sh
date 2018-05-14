#! /bin/sh

sh /generate_mitm_ca.sh
exec supervisord -c /supervisord.conf
