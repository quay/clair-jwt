#!/bin/sh

CLAIRENTRY=${CLAIRENTRY:=$1}
CLAIRENTRY=${CLAIRENTRY:=scanner}

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

display_usage() {
    echo "Usage: ${0} <scanner|shell|help>"
    echo
    echo "If the first argument isn't one of the above modes,"
    echo "the arguments will be exec'd directly, i.e.:"
    echo
    echo "  ${0} uptime"
}

if [[ "${CLAIRENTRY}" = "help" ]]
then
    display_usage
    exit 0
fi


cat << "EOF"

  ______   _         __      _   _____
 /  ____| | |       /  \    | | |     \
 | |      | |      / /\ \   | | |  /\ /
 | |____  | |__   / ____ \  | | |  __ \
 \______| |____| /_/    \_\ |_| |_|  \_\


EOF

case "$CLAIRENTRY" in
    "shell")
        echo "Entering shell mode"
        exec /bin/sh
        ;;
    "scanner")
        echo "Running scanner"
        /bin/sh ${CLAIRDIR}/generate_mitm_ca.sh
        supervisord -c ${CLAIRDIR}/supervisord.conf 2>&1
        ;;
    *)
        echo "Running '$CLAIRENTRY'"
        exec $CLAIRENTRY
        ;;
esac

