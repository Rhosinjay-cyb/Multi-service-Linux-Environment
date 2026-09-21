#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common.sh"

require_root

cp "$PROJECT_DIR/config/webapp.service" \
   /etc/systemd/system/webapp.service

chmod 644 /etc/systemd/system/webapp.service

systemctl daemon-reload
systemctl enable webapp.service
systemctl restart webapp.service

if systemctl is-active --quiet webapp.service; then
    log "Web application systemd service is running."
else
    error "Web application systemd service failed to start."
    systemctl status webapp.service --no-pager
    exit 1
fi
