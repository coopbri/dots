#!/bin/sh
# Install automatic timezone updates from IP geolocation.
# Two trigger layers, both idempotent:
#   - systemd timer: ~20s after boot, then re-checks hourly (works on every host)
#   - NetworkManager dispatcher: instant re-check on network change (NM hosts only)
# Hosts on systemd-networkd/iwd (no NetworkManager) rely on the timer.
set -eu

here=$(cd "$(dirname "$0")" && pwd)

sudo install -m755 "$here/tz-from-ip"       /usr/local/bin/tz-from-ip
sudo install -m644 "$here/tzupdate.service" /etc/systemd/system/tzupdate.service
sudo install -m644 "$here/tzupdate.timer"   /etc/systemd/system/tzupdate.timer
sudo mkdir -p /etc/NetworkManager/dispatcher.d
sudo install -m755 "$here/90-tzupdate"      /etc/NetworkManager/dispatcher.d/90-tzupdate

sudo systemctl daemon-reload
# The timer owns scheduling (including the boot run), so the bare service no
# longer auto-starts on its own; the timer triggers it
sudo systemctl disable tzupdate.service 2>/dev/null || true
sudo systemctl enable --now tzupdate.timer
# Apply immediately rather than waiting for the first timer tick
sudo /usr/local/bin/tz-from-ip || true

timedatectl status | head -5
