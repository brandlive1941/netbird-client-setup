#!/bin/bash
# Installs the NetBird client on macOS and creates one profile per environment.
# Usage: ./mac-setup.sh <yourname>
set -euo pipefail

URL="https://netbird.brandlive.cloud"
NAME="${1:?usage: $0 <yourname>}"
ENVS=("dev-qa" "staging") # add "prod" only if you have been given prod access

command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
brew list --cask netbird-ui >/dev/null 2>&1 || brew install --cask netbirdio/tap/netbird-ui

for e in "${ENVS[@]}"; do
  existing="$(netbird profile list)"
  grep -q "^${e} " <<<"$existing" || netbird profile add "$e"
  netbird login --profile "$e" --management-url "$URL" --hostname "${NAME}-${e}"
done

netbird profile select dev-qa
netbird up
echo "Done. Switch environments with: netbird profile select <dev-qa|staging>"
