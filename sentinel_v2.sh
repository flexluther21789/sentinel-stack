#!/bin/bash
echo "🛡️ Sentinel V2: System Audit Initiated..."
REPORT="/tmp/sentinel_report.txt"
echo "--- Network Listeners ---" > $REPORT
lsof -i -P -n | grep LISTEN >> $REPORT
echo "--- System Extensions ---" >> $REPORT
systemextensionsctl list >> $REPORT
echo "🔍 Scanning for Base64 or eval obfuscation..."
for file in *.sh; do
    if grep -qE "base64|eval" "$file"; then
        echo "⚠️ WARNING: Potential obfuscation detected in: $file"
        grep -nE "base64|eval" "$file"
    fi
done
echo "🎯 Audit complete. Report saved to $REPORT"
(sleep 300 && rm -f $REPORT) &
