# tz-auto

Automatic system timezone based on IP geolocation. Travel between zones and your clock follows, without `timedatectl set-timezone` calls.

## What it does

Four layers, all idempotent:

1. **`/usr/local/bin/tz-from-ip`** - a small shell script that queries `https://ipapi.co/timezone` (returns a bare IANA zone like `America/Phoenix`), falls back to `https://ipinfo.io/timezone`, and runs `timedatectl set-timezone` if the response looks like a valid `Region/City` string. It retries for ~1 minute so a not-yet-ready DNS resolver at boot does not leave the zone stale, no-ops if the zone already matches, and signals waybar (`SIGUSR2`) to redraw its clock after a change. Silent no-op if every request fails, so a flaky network never breaks boot.
2. **`/etc/systemd/system/tzupdate.timer`** - the scheduler. Runs the service ~20s after boot, then re-checks hourly. This is the layer that works on **every** host regardless of network stack, and is what keeps the zone correct as you move.
3. **`/etc/systemd/system/tzupdate.service`** - the `oneshot` unit the timer triggers. Ordered after `network-online.target`. Not enabled on its own (the timer owns scheduling, including the boot run).
4. **`/etc/NetworkManager/dispatcher.d/90-tzupdate`** - a NetworkManager hook that re-runs the script on `up` and `connectivity-change` events, for an instant update on network change. **Only fires on NetworkManager hosts.** Machines on `systemd-networkd`/`iwd` (no NetworkManager running) rely on the timer instead, which is why the timer exists.

## Install

```sh
~/system/tz-auto/install.sh
```

Requires: `curl`, `systemd`. NetworkManager is optional (its dispatcher hook is a bonus, not required). Asks for sudo once. Safe to re-run; `install(1)` overwrites cleanly and `systemctl enable --now` is a no-op when already enabled.

## Uninstall

```sh
sudo systemctl disable --now tzupdate.timer
sudo systemctl disable tzupdate.service 2>/dev/null || true
sudo rm /etc/systemd/system/tzupdate.timer \
        /etc/systemd/system/tzupdate.service \
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

## Why ipapi.co (with ipinfo.io fallback)

- Returns the zone directly at `/timezone` as plain text; no JSON parsing
- No API key for low-volume use
- Free tier handles the once-per-hour call rate easily
- `ipinfo.io/timezone` has the same plain-text shape and covers the rare ipapi.co outage

To swap providers, edit just the `get_zone` function in `tz-from-ip` - anything that returns a bare IANA zone string works.

## Files in this directory

| File | Installed to | Mode |
|------|--------------|------|
| `tz-from-ip` | `/usr/local/bin/tz-from-ip` | 755 |
| `tzupdate.timer` | `/etc/systemd/system/tzupdate.timer` | 644 |
| `tzupdate.service` | `/etc/systemd/system/tzupdate.service` | 644 |
| `90-tzupdate` | `/etc/NetworkManager/dispatcher.d/90-tzupdate` | 755 |
| `install.sh` | (not installed, just runs) | 755 |
