#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/common.sh"

require_root

if ! command_exists ufw; then
    error "UFW is not installed."
    exit 1
fi

ufw default deny incoming
ufw default allow outgoing

# SSH
ufw allow 22/tcp

# HTTP
ufw allow 80/tcp

# Do NOT expose backend port 3000.
# It is accessed locally by Nginx.

ufw --force enable

log "UFW configured: SSH and HTTP allowed; backend port 3000 remains closed."
