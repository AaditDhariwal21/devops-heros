#!/bin/bash
# journalctl basics

echo "--- last 5 log lines ---"
journalctl -n 5 --no-pager

echo "--- logs for one service (cron) ---"
systemctl restart cron
journalctl -u cron -n 8 --no-pager

echo "--- only errors ---"
journalctl -p err -b --no-pager | tail -5

echo "--- logs from last 5 minutes ---"
journalctl -u cron --since "5 minutes ago" --no-pager | tail -5

echo "--- how much space logs use ---"
journalctl --disk-usage
