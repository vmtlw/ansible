#!/bin/sh
# Проверка сетевой доступности: шлюз и внешний адрес.
set -e

GATEWAY=$(ip route 2>/dev/null | awk '/^default/ {print $3; exit}')

if [ -n "$GATEWAY" ]; then
  ping -c 1 -W 2 "$GATEWAY" >/dev/null && echo "gateway $GATEWAY: OK" || echo "gateway $GATEWAY: FAIL"
else
  echo "gateway: not found"
fi

ping -c 1 -W 2 8.8.8.8 >/dev/null && echo "8.8.8.8: OK" || echo "8.8.8.8: FAIL"
