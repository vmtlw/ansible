#!/bin/sh
# Fallback-скрипт для установки SSH-ключей на хосты без Python 3.8+.
# Вызывается из playbooks/ssh_copy_id.yml, ключи передаются аргументами.
set -e

AUTHORIZED_KEYS="/root/.ssh/authorized_keys"

mkdir -p /root/.ssh
chmod 700 /root/.ssh
touch "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"
chown root:root /root/.ssh "$AUTHORIZED_KEYS" 2>/dev/null || true

for key in "$@"; do
  grep -qxF "$key" "$AUTHORIZED_KEYS" || echo "$key" >> "$AUTHORIZED_KEYS"
done
