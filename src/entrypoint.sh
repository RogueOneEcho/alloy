#!/usr/bin/env bash
set -euo pipefail

source /logging
source /file-env

file-env MAXMIND_LICENSE_KEY

INSTANCE="${INSTANCE:-}"
PROMETHEUS_URL="${PROMETHEUS_URL:-}"
LOKI_URL="${LOKI_URL:-}"
MAXMIND_LICENSE_KEY="${MAXMIND_LICENSE_KEY:-}"
GEOIP_DIR="/geoip"
GEOIP_DB="${GEOIP_DIR}/GeoLite2-City.mmdb"
GEOIP_ARCHIVE="/tmp/GeoLite2-City.tar.gz"
GEOIP_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=${MAXMIND_LICENSE_KEY}&suffix=tar.gz"

redact () {
  if [[ -n "$1" ]]
  then
    echo '[REDACTED]'
  else
    echo '[NOT SET]'
  fi
}

start-timer () {
  START_TIME=$(date +%s)
}

stop-timer () {
  TIMER=$(($(date +%s) - START_TIME))
  START_TIME=0
}

log-vars () {
  log-debug "INSTANCE: ${INSTANCE}"
  log-debug "PROMETHEUS_URL: ${PROMETHEUS_URL}"
  log-debug "LOKI_URL: ${LOKI_URL}"
  log-debug "MAXMIND_LICENSE_KEY: $(redact "${MAXMIND_LICENSE_KEY}")"
}

check-vars () {
  if [[ -z "${INSTANCE}" ]]
  then
    log-warning "INSTANCE must be set"
    return 1
  fi
  if [[ -z "${PROMETHEUS_URL}" ]]
  then
    log-warning "PROMETHEUS_URL must be set"
    return 1
  fi
  if [[ -z "${LOKI_URL}" ]]
  then
    log-warning "LOKI_URL must be set"
    return 1
  fi
  if [[ -z "${MAXMIND_LICENSE_KEY}" ]]
  then
    log-warning "MAXMIND_LICENSE_KEY must be set"
    return 1
  fi
}

# Download and extract the GeoLite2-City database.
# The URL is passed to curl on stdin so the license key is not in the process list.
download-geoip () {
  log-information "Downloading GeoLite2-City database"
  start-timer
  if ! printf 'url = "%s"\n' "${GEOIP_URL}" | curl --config - --fail --silent --show-error --location --output "${GEOIP_ARCHIVE}"
  then
    stop-timer
    log-error "Failed to download GeoLite2-City database (${TIMER}s)"
    log-error "Check MAXMIND_LICENSE_KEY is a valid license key"
    return 1
  fi
  if ! mkdir -p "${GEOIP_DIR}"
  then
    log-error "Failed to create directory: ${GEOIP_DIR}"
    return 1
  fi
  if ! tar -xzf "${GEOIP_ARCHIVE}" --strip-components=1 -C "${GEOIP_DIR}"
  then
    stop-timer
    log-error "Failed to extract GeoLite2-City database (${TIMER}s)"
    return 1
  fi
  rm -f "${GEOIP_ARCHIVE}"
  if [[ ! -f "${GEOIP_DB}" ]]
  then
    stop-timer
    log-error "GeoLite2-City archive did not contain: ${GEOIP_DB}"
    return 1
  fi
  stop-timer
  log-success "Downloaded GeoLite2-City database (${TIMER}s)"
}

log-vars
check-vars
download-geoip
log-information "Starting Alloy"
exec /bin/alloy run /etc/alloy/config.alloy --storage.path=/var/lib/alloy/data
