#!/usr/bin/env bash
set -euo pipefail

CPU_LOAD=$(awk '{print $1, $2, $3}' /proc/loadavg)
MEMORY_USAGE=$(free -m | awk '/^Mem:/ {printf "Used: %sMB / Total: %sMB", $3, $2}')
PROCESS_COUNT=$(ps -e --no-headers | wc -l)

LOG_FILE="/var/log/sysmonitor/metrics.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') | CPU Load: ${CPU_LOAD} | Mem: ${MEMORY_USAGE} | Procs: ${PROCESS_COUNT}" >> "$LOG_FILE"