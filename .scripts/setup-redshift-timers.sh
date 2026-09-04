#!/usr/bin/env bash
set -euo pipefail

SYSTEMD_DIR="$HOME/.config/systemd/user"

mkdir -p "$SYSTEMD_DIR"

############################
# Night service
############################
cat > "$SYSTEMD_DIR/redshift-night.service" <<'EOF'
[Unit]
Description=Redshift night temperature

[Service]
Type=oneshot
ExecStart=/usr/bin/redshift -O 4200
ExecStartPost=/bin/sleep 2
ExecStartPost=/usr/bin/redshift -O 4200
EOF

############################
# Day service
############################
cat > "$SYSTEMD_DIR/redshift-day.service" <<'EOF'
[Unit]
Description=Redshift reset temperature

[Service]
Type=oneshot
ExecStart=/usr/bin/redshift -x
ExecStartPost=/bin/sleep 2
ExecStartPost=/usr/bin/redshift -x
EOF

############################
# Night timer
############################
cat > "$SYSTEMD_DIR/redshift-night.timer" <<'EOF'
[Unit]
Description=Redshift night timer

[Timer]
OnCalendar=*-*-* 18:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

############################
# Day timer
############################
cat > "$SYSTEMD_DIR/redshift-day.timer" <<'EOF'
[Unit]
Description=Redshift day timer

[Timer]
OnCalendar=*-*-* 07:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

############################
# Enable timers
############################
systemctl --user daemon-reload
systemctl --user enable --now redshift-night.timer
systemctl --user enable --now redshift-day.timer

echo "✅ Redshift systemd user timers installed."
echo
systemctl --user list-timers | grep redshift || true

