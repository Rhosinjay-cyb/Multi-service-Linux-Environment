#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common.sh"

require_root

if ! command_exists nginx; then
    error "Nginx is not installed."
    exit 1
fi

cp "$PROJECT_DIR/config/nginx-webapp.conf" \
   /etc/nginx/sites-available/webapp

ln -sf \
   /etc/nginx/sites-available/webapp \
   /etc/nginx/sites-enabled/webapp

rm -f /etc/nginx/sites-enabled/default

nginx -t

systemctl enable nginx
systemctl restart nginx

log "Nginx reverse proxy configured and started."
