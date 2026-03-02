# <p style="text-align: center">alloy</p>

<p align="center">
  <a href="https://github.com/RogueOneEcho/alloy/actions/workflows/ci-on-push.yml"><img alt="CI status" src="https://img.shields.io/github/actions/workflow/status/RogueOneEcho/alloy/ci-on-push.yml"></a>
  <a href="https://github.com/RogueOneEcho/alloy/releases"><img alt="Latest release" src="https://img.shields.io/github/v/release/RogueOneEcho/alloy"></a>
  <a href="LICENSE.md"><img alt="License" src="https://img.shields.io/github/license/RogueOneEcho/alloy"></a>
</p>

Grafana Alloy telemetry collector with GeoIP enrichment.

```bash
docker pull ghcr.io/rogueoneecho/alloy
```

## Features

- Automatic [GeoLite2-City](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data) download at container startup
- Pre-configured host metrics, container metrics, and journal log collection
- GeoIP enrichment of SSH and UFW log entries
- Configurable via environment variables

## Build

- amd64 and arm64 images available on [GHCR](https://github.com/RogueOneEcho/alloy/pkgs/container/alloy)
- Signed with [Cosign](https://github.com/sigstore/cosign) via keyless Sigstore OIDC
- SBOM attestation in CycloneDX format
- Vulnerability scanned with [Grype](https://github.com/anchore/grype)

## Usage

See [docker-compose.yml](docker-compose.yml) for an example.

Copy `.env.example` to `.env` and set:
- `INSTANCE` — hostname label for metrics and logs
- `MAXMIND_LICENSE_KEY` — [MaxMind](https://www.maxmind.com/en/accounts/current/license-key) license key
- `PROMETHEUS_URL` — Prometheus remote write endpoint
- `LOKI_URL` — Loki push endpoint

## Releases and Changes

Releases and a full changelog are available via [GitHub Releases](https://github.com/RogueOneEcho/alloy/releases).
