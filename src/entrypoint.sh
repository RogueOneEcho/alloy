#!/bin/sh
mkdir -p /geoip
curl -sSL "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=${MAXMIND_LICENSE_KEY}&suffix=tar.gz" |
    tar -xz --strip-components=1 -C /geoip
exec /bin/alloy run /etc/alloy/config.alloy --storage.path=/var/lib/alloy/data
