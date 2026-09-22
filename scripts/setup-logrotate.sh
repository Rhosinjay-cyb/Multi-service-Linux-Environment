#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common.sh"

require_root

cp "$PROJECT_DIR/config/webapp-logrotate" \
   /etc/logrotate.d/webapp

chmod 644 /etc/logrotate.d/webapp

log "Application log rotation configured."
