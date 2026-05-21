# tz-auto

Automatic system timezone based on IP geolocation. Travel between zones and your clock follows, without `timedatectl set-timezone` calls.

## What it does

Three layers, all idempotent:

1. **`/usr/local/bin/tz-from-ip`** - a 5-line shell script that queries `https://ipapi.co/timezone` (returns a bare IANA zone like `America/Phoenix`) and runs `timedatectl set-timezone` if the response looks like a valid `Region/City` string. Silent no-op if the request fails or the response is malformed, so a flaky network never breaks boot.
2. **`/etc/systemd/system/tzupdate.service`** - a `oneshot` unit ordered after `network-online.target`. Fires once on every boot, after the network is reachable.
3. **`/etc/NetworkManager/dispatcher.d/90-tzupdate`** - a NetworkManager hook that re-runs the script on `up` and `connectivity-change` events. This is what handles moving between zones without a reboot (suspend/resume to a new WiFi, switching from cellular tether to hotel WiFi, etc).

## Install

```sh
~/system/tz-auto/install.sh
```

Requires: `curl`, `systemd`, `NetworkManager`. Asks for sudo once. Safe to re-run; `install(1)` overwrites cleanly and `systemctl enable --now` is a no-op when already enabled.

## Uninstall

```sh
sudo systemctl disable --now tzupdate.service
sudo rm /etc/systemd/system/tzupdate.service \
        /etc/NetworkManager/dispatcher.d/90-tzupdate \
        /usr/local/bin/tz-from-ip
sudo systemctl daemon-reload
```

## Gotcha: never `export TZ` in your shell rc

The `$TZ` env var **overrides the system zone** for any process started from that shell, including waybar, your terminal's clock, `date`, etc. If `TZ` is set, this whole setup looks broken because the system zone updates correctly but your visible clocks don't follow.

If waybar shows the wrong time after install, check:

```sh
echo "$TZ"                    # should be empty
grep -rn '^export TZ' ~/.zshenv ~/.zshrc ~/.profile ~/.bashrc
```

Remove any hits, then restart waybar (`pkill -USR2 waybar` or `killall waybar && waybar &disown`) and open a fresh terminal.

## Why ipapi.co

- Returns the zone directly at `/timezone` as plain text; no JSON parsing
- No API key for low-volume use
- Free tier handles the once-per-network-change call rate easily

To swap providers, edit just the `curl` line in `tz-from-ip` - anything that returns a bare IANA zone string works.

## Files in this directory

| File | Installed to | Mode |
|------|--------------|------|
| `tz-from-ip` | `/usr/local/bin/tz-from-ip` | 755 |
| `tzupdate.service` | `/etc/systemd/system/tzupdate.service` | 644 |
| `90-tzupdate` | `/etc/NetworkManager/dispatcher.d/90-tzupdate` | 755 |
| `install.sh` | (not installed, just runs) | 755 |
