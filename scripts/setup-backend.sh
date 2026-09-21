#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common.sh"

require_root

mkdir -p "$APP_DIR"
mkdir -p "$APP_LOG_DIR"

cp "$PROJECT_DIR/backend/app.py" "$APP_DIR/app.py"

chown "$APP_USER:$APP_GROUP" "$APP_DIR/app.py"
chmod 750 "$APP_DIR/app.py"

log "Backend application deployed to $APP_DIR."

if ! command_exists python3; then
    error "Python 3 is not installed."
    exit 1
fi

if ! python3 -c "import flask" >/dev/null 2>&1; then
    error "Flask is not installed. Install Flask before provisioning."
    exit 1
fi

log "Backend prerequisites validated."
