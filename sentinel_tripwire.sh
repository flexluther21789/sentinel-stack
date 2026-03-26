#!/bin/bash
KNOWN_IPS="172.20.10.1|172.20.10.15"
echo "🛰️ Sentinel Audio Tripwire ACTIVE..."
say "Sentinel Tripwire Active"
while true; do
    current_devices=$(arp -a | grep "172.20.10" | grep -v "incomplete" | awk '{print $2}' | tr -d '()')
    for ip in $current_devices; do
        if [[ ! "$ip" =~ $KNOWN_IPS ]]; then
            echo "🚨 UNKNOWN: $ip" | sed "s/$(whoami)/USER/g"
            say "Warning. Unknown device at $ip"
        fi
    done
    sleep 10
done
