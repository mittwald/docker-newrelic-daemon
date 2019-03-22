#!/usr/bin/env bash

set -e

NEWRELIC_DAEMON="$(command -v newrelic-daemon)"

if [[ ! -f "${NEWRELIC_DAEMON_CONFIG_FILE}" ]] && [[ -f "${NEWRELIC_DAEMON_CONFIG_FILE_TEMPLATE}" ]]; then
    cp -a "${NEWRELIC_DAEMON_CONFIG_FILE_TEMPLATE}" "${NEWRELIC_DAEMON_CONFIG_FILE}"
    NEWRELIC_DAEMON_OPTS="-c ${NEWRELIC_DAEMON_CONFIG_FILE} --loglevel=${NEWRELIC_DAEMON_LOGLEVEL} --port=${NEWRELIC_DAEMON_PORT}"
elif [[ -f "${NEWRELIC_DAEMON_CONFIG_FILE}" ]]; then
    NEWRELIC_DAEMON_OPTS="-c ${NEWRELIC_DAEMON_CONFIG_FILE}"
else
    echo "ERROR: could neither find a valid config file nor a corresponding default template"
    exit 1
fi

echo "INFO: starting newrelic-daemon - listening for connections on port ${NEWRELIC_DAEMON_PORT}"
exec "${NEWRELIC_DAEMON}" ${NEWRELIC_DAEMON_DEFAULT_OPTS} ${NEWRELIC_DAEMON_OPTS} ${NEWRELIC_DAEMON_ADDITIONAL_OPTS} ${@}
