#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/common.sh"

require_root

# --------------------------------------------------
# 10. Verify DNS resolution
# --------------------------------------------------

log "Verifying DNS resolution."

if getent hosts localhost >/dev/null 2>&1; then
    log "DNS resolution check passed."
else
    error "DNS resolution check failed."
    exit 1
fi

# --------------------------------------------------
# 11. Verify backend health endpoint
# --------------------------------------------------

log "Checking backend health endpoint."

if curl --fail --silent http://127.0.0.1:3000/health >/dev/null; then
    log "Backend health check passed."
else
    error "Backend health check failed."
    exit 1
fi

# --------------------------------------------------
# 12. Verify Nginx → backend connectivity
# --------------------------------------------------

log "Checking Nginx reverse proxy."

if curl --fail --silent http://127.0.0.1/health >/dev/null; then
    log "Nginx reverse proxy check passed."
else
    error "Nginx reverse proxy check failed."
    exit 1
fi

log "All verification checks passed."
