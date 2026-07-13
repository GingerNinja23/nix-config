#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.nix-config

exec sudo darwin-rebuild switch --flake ~/.nix-config#personal
