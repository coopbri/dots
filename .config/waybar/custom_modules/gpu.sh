#!/usr/bin/env bash
# Waybar custom module: NVIDIA GPU utilization, VRAM, and temperature as JSON
# Skips nvidia-smi while the dGPU is runtime-suspended so polling never wakes it

set -euo pipefail

pci_dev="/sys/bus/pci/devices/0000:01:00.0"
icon=$'\U000F08AE'

status="$(cat "$pci_dev/power/runtime_status" 2>/dev/null || echo unknown)"
if [[ "$status" == "suspended" ]]; then
  printf '{"text":"off %s","tooltip":"GPU suspended","class":"suspended","percentage":0}\n' "$icon"
  exit 0
fi

if ! out="$(nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total,temperature.gpu,power.draw \
  --format=csv,noheader,nounits 2>/dev/null)"; then
  printf '{"text":"n/a %s","tooltip":"nvidia-smi unavailable","class":"error","percentage":0}\n' "$icon"
  exit 0
fi

IFS=',' read -r name util mem_used mem_total temp power <<<"$out"
name="$(echo "$name" | xargs)"
util="$(echo "$util" | xargs)"
mem_used="$(echo "$mem_used" | xargs)"
mem_total="$(echo "$mem_total" | xargs)"
temp="$(echo "$temp" | xargs)"
temp="${temp%%.*}"
power="$(echo "$power" | xargs)"

class="normal"
if (( util >= 90 || temp >= 85 )); then
  class="critical"
elif (( util >= 70 || temp >= 75 )); then
  class="warning"
fi

tooltip="$name\\nUtil: ${util}%\\nVRAM: ${mem_used} / ${mem_total} MiB\\nTemp: ${temp}°C\\nPower: ${power} W"
printf '{"text":"%s%% %s","tooltip":"%s","class":"%s","percentage":%s}\n' \
  "$util" "$icon" "$tooltip" "$class" "$util"
