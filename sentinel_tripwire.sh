#!/bin/bash
# Monitor the home directory for hidden file events
echo "📡 Tripwire Active: Monitoring for hidden file changes..."

fswatch -0 -l 1 -i "^\." ~/ | while read -d "" event; do
    # Filter for files that still exist (to avoid delete-event noise)
    if [[ -f "$event" ]]; then
        NOTIFICATION="⚠️ ALERT: Hidden file detected: $(basename "$event")"
        echo "$NOTIFICATION"
        
        # macOS Native Desktop Notification
        osascript -e "display notification \"$event\" with title \"Sentinel Tripwire\" subtitle \"Hidden File Activity Detected\""
        
        # Log it for the 64k Auditor to review later
        echo "$(date): $event" >> ~/.sentinel_tripwire.log
    fi
done
