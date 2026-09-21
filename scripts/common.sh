#!/bin/bash

set -euo pipefail

APP_NAME="webapp"
APP_USER="webapp"
APP_GROUP="webapp"

APP_DIR="/opt/webapp"
APP_LOG_DIR="/var/log/webapp"
APP_PORT="3000"
NGINX_PORT="80"

LOG_FILE="/var/log/webapp/provision.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

require_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "ERROR: This script must be run as root or with sudo."
        exit 1
    fi
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}
