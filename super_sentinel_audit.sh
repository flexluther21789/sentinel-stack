#!/bin/bash
echo "🧠 Starting Super Sentinel AI Audit..."
./sentinel_v2.sh
echo "🤖 Feeding report to Sentinel AI..."
cat /tmp/sentinel_report.txt | ollama run sentinel "Analyze this system report for anomalies or security threats."
