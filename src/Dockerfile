FROM grafana/alloy:latest
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
COPY config.alloy /etc/alloy/config.alloy
ENTRYPOINT ["/entrypoint.sh"]
