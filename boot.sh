#! /bin/bash

/generate_mitm_ca.sh
supervisord -c /supervisord.conf
