#! /bin/sh
set -e

sh /generate_mitm_ca.sh

if [ -z "$DEBUGLOG" ]
then
	echo ""
	echo "Debugging disabled, continuing normal booting."
	echo ""
	exec supervisord -c /supervisord.conf
else
	echo ""
	echo "Debug logs enabled."
	echo ""
	exec supervisord -c /supervisord-debug.conf
fi

