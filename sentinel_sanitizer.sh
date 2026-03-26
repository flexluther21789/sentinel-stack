#!/bin/bash
echo "🧹 Sanitizing Environment..."
rm -f /tmp/sentinel_report.txt
history -c
clear
echo "✨ Session Cleaned."
