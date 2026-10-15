#!/bin/bash
# Installs the NetBird client on macOS and creates one profile per environment.
# Usage: ./mac-setup.sh <yourname>
set -euo pipefail

URL="https://netbird.brandlive.cloud"
NAME="${1:?usage: $0 <yourname>}"
ENVS=("dev-qa" "staging") # add "prod" only if you have been given prod access

if ! command -v netbird >/dev/null; then
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/netbird.pkg" https://pkgs.netbird.io/macos/universal
  # Install only a package signed by NetBird GmbH (Apple team TA739QLA7A) and notarized by Apple.
  sig="$(pkgutil --check-signature "$tmp/netbird.pkg")"
  if ! { grep -q "TA739QLA7A" <<<"$sig" && grep -q "Notarization: trusted" <<<"$sig"; }; then
    echo "NetBird package signature check failed; not installing."; exit 1
  fi
  sudo installer -pkg "$tmp/netbird.pkg" -target /
  rm -rf "$tmp"
fi

for e in "${ENVS[@]}"; do
  existing="$(netbird profile list)"
  grep -q "^${e} " <<<"$existing" || netbird profile add "$e"
  netbird login --profile "$e" --management-url "$URL" --hostname "${NAME}-${e}"
done

netbird profile select dev-qa
netbird up
echo "Done. Switch environments with: netbird profile select <dev-qa|staging>"
