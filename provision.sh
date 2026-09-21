
#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/scripts/common.sh"

require_root

# --------------------------------------------------
# 1. Validate prerequisites and inputs
# --------------------------------------------------

REQUIRED_COMMANDS=(
    bash
    curl
    systemctl
)

for command in "${REQUIRED_COMMANDS[@]}"; do
    if ! command_exists "$command"; then
        error "Required command not found: $command"
        exit 1
    fi
done

echo "Prerequisite validation passed."

# --------------------------------------------------
# 2. Initialize logging
# --------------------------------------------------

mkdir -p "$APP_LOG_DIR"
touch "$LOG_FILE"
chmod 640 "$LOG_FILE"

log "Starting web application environment provisioning."

# --------------------------------------------------
# 3. Create application/service user
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-user.sh"

# --------------------------------------------------
# 4. Deploy/configure backend application
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-backend.sh"

# --------------------------------------------------
# 5. Create systemd service
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-systemd.sh"

# --------------------------------------------------
# 6. Configure application log rotation
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-logrotate.sh"

# --------------------------------------------------
# 7. Configure Nginx reverse proxy
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-nginx.sh"

# --------------------------------------------------
# 8. Configure UFW firewall
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-firewall.sh"

# --------------------------------------------------
# 9. Configure fail2ban
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/setup-fail2ban.sh"

# --------------------------------------------------
# 10–12. Verification
# --------------------------------------------------

bash "$SCRIPT_DIR/scripts/verify.sh"

# --------------------------------------------------
# 13. Log successful completion
# --------------------------------------------------

log "Provisioning complete!"
