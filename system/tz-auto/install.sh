#!/bin/sh
# Install automatic timezone updates: runs on boot and on NetworkManager up events
set -eu

here=$(cd "$(dirname "$0")" && pwd)

sudo install -m755 "$here/tz-from-ip"     /usr/local/bin/tz-from-ip
sudo install -m644 "$here/tzupdate.service" /etc/systemd/system/tzupdate.service
sudo mkdir -p /etc/NetworkManager/dispatcher.d
sudo install -m755 "$here/90-tzupdate"    /etc/NetworkManager/dispatcher.d/90-tzupdate

sudo systemctl daemon-reload
sudo systemctl enable --now tzupdate.service

timedatectl status | head -5
