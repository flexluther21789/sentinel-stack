#!/bin/bash
# Sentinel Stack: Hardened Audio & Log Tripwire (2026-03-26)
LOG_FILE="$HOME/sentinel-stack/forensic_history.log"
KNOWN_IPS="172.20.10.1|172.20.10.15"

echo "🛰️ Sentinel Audio & Log Tripwire ACTIVE..."
say "Sentinel Recording Active"

while true; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    current_devices=$(arp -a | grep "172.20.10" | grep -v "incomplete")
    
    # Log the full scan state (Sanitized)
    echo "[$TIMESTAMP] Scan: $current_devices" | sed "s/$(whoami)/USER/g" >> "$LOG_FILE"
    
    # Check for Unknowns
    for ip in $(echo "$current_devices" | awk '{print $2}' | tr -d '()'); do
        if [[ ! "$ip" =~ $KNOWN_IPS ]]; then
            echo "🚨 ALERT: Unknown Device $ip detected at $TIMESTAMP" >> "$LOG_FILE"
            say "Warning. Unknown device at $ip"
        fi
    done
    sleep 30
done
