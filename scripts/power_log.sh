#!/bin/bash

LOG="${1:-power-log.csv}"
INTERVAL=2   # segundos

# detectar batería automáticamente
BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)

if [ -z "$BAT_PATH" ]; then
  echo "No se encontró batería (BAT*)"
  exit 1
fi

POWER_FILE="$BAT_PATH/power_now"

if [ ! -f "$POWER_FILE" ]; then
  echo "$POWER_FILE no existe"
  exit 1
fi

# cabecera
if [ ! -f "$LOG" ]; then
  echo "timestamp,power_w" > "$LOG"
fi

echo "📈 Logging consumo cada ${INTERVAL}s → $LOG"
echo "Ctrl+C para parar"

while true; do
  TS=$(date +%s)
  POWER_UW=$(cat "$POWER_FILE")
  POWER_W=$(awk "BEGIN {printf \"%.3f\", $POWER_UW/1000000}")
  echo "$TS,$POWER_W" >> "$LOG"
  sleep "$INTERVAL"
done
