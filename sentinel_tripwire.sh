#!/bin/bash
echo "🕵️ Tripwire: Checking file integrity..."
shasum -a 256 -c manifest.sha256
if [ $? -eq 0 ]; then
    echo "✅ Integrity Verified."
else
    echo "🚨 ALERT: Manifest Mismatch! Files may have been tampered with."
fi
