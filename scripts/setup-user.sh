#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

require_root

if id "$APP_USER" >/dev/null 2>&1; then
    log "Service user '$APP_USER' already exists."
else
    useradd \
        --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        "$APP_USER"

    log "Created service user '$APP_USER'."
fi

mkdir -p "$APP_DIR"
mkdir -p "$APP_LOG_DIR"

chown -R "$APP_USER:$APP_GROUP" "$APP_DIR"
chown -R "$APP_USER:$APP_GROUP" "$APP_LOG_DIR"

log "Configured ownership for $APP_USER."
