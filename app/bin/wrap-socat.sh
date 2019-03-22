#!/usr/bin/env bash

if [[ "${NEWRELIC_DAEMON_PORT}" =~ "*.sock" ]]; then
    echo "ERROR: socat is not needed when using socket"
    tail -f /dev/stdout
fi

SOCAT="$(command -v socat)"
SOCAT_OPTIONS="fork"

echo "INFO: starting socat - forwarding port ${SOCAT_LISTEN_PORT} to ${NEWRELIC_DAEMON_PORT}"

exec ${SOCAT} TCP-LISTEN:${SOCAT_LISTEN_PORT},${SOCAT_OPTIONS} TCP:127.0.0.1:${NEWRELIC_DAEMON_PORT}
