ARG     DEBIAN_RELEASE="8.11"
FROM    debian:${DEBIAN_RELEASE}-slim

ARG     NEWRELIC_DAEMON_VERSION="${NEWRELIC_DAEMON_VERSION:-8.6.0.238}"
ENV     NEWRELIC_APT_REPO="deb http://apt.newrelic.com/debian/ newrelic non-free" \
        NEWRELIC_GPG_KEY="https://download.newrelic.com/548C16BF.gpg" \
        NEWRELIC_GPG_KEY_ID="548C16BF" \
        NEWRELIC_DAEMON_VERSION="${NEWRELIC_DAEMON_VERSION}" \
        NEWRELIC_DAEMON_CONFIG_FILE="/etc/newrelic/newrelic.cfg" \
        NEWRELIC_DAEMON_CONFIG_FILE_TEMPLATE="/etc/newrelic/newrelic.cfg.template" \
        NEWRELIC_DAEMON_DEFAULT_OPTS="-f" \
        NEWRELIC_DAEMON_ADDITIONAL_OPTS="" \
        NEWRELIC_DAEMON_PORT="/tmp/.newrelic.sock" \
        NEWRELIC_DAEMON_LOGLEVEL="info"

RUN     set -x && \
        apt-get -qq update && \
        apt-get -qq upgrade && \
        apt-get -qq install gnupg2 ca-certificates && \
        echo "${NEWRELIC_APT_REPO}" | tee /etc/apt/sources.list.d/newrelic.list && \
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "${NEWRELIC_GPG_KEY_ID}" && \
        apt-get -qq update && \
        apt-get -qq install newrelic-php5="${NEWRELIC_DAEMON_VERSION}" && \
        apt-get -qq purge gnupg2 && \
        apt-get -qq autoclean && \
        apt-get -qq autoremove && \
        rm -rf /tmp/* /var/cache/apt/*

COPY    bin/ /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]