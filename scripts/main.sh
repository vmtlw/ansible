#!/bin/sh
# Пример скрипта для модуля script: краткая диагностика хоста.
set -e

echo "hostname: $(hostname)"
echo "uptime: $(uptime -p 2>/dev/null || uptime)"
echo "kernel: $(uname -r)"
df -h / | tail -1 | awk '{print "root fs: " $3 " used / " $2 " total (" $5 ")"}'
