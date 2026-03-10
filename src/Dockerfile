ARG ALLOY_VERSION=v1.14.0
FROM grafana/alloy:${ALLOY_VERSION}
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
COPY config.alloy /etc/alloy/config.alloy
ENTRYPOINT ["/entrypoint.sh"]
