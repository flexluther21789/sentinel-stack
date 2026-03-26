#!/bin/bash
# ACTIVE_INGESTOR.SH - Real-time Forensic Ingestion Loop

LOG_FILE="/tmp/sentinel_active_log.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "📡 Starting Active Ingestion at $TIMESTAMP..."

# 1. Capture "Ground Truth" (ARP and Established Connections)
echo "--- Live Network State ($TIMESTAMP) ---" > $LOG_FILE
arp -a >> $LOG_FILE
echo "--- Established Tunnels ---" >> $LOG_FILE
netstat -atn | grep ESTABLISHED >> $LOG_FILE

# 2. AI Analysis: Feed the live state to the Sentinel
echo "🤖 Sentinel AI is analyzing the ingestion..."
ANALYSIS=$(cat $LOG_FILE | ollama run sentinel "Compare this live state against the hardwired forensic database (Sessions 3-6). Identify any Randomized MACs or suspicious ports like 62078 or 2968.")

# 3. Save the AI's Verdict to the Stack
echo "📝 Documenting AI Verdict..."
echo -e "\n--- AI VERDICT $TIMESTAMP ---\n$ANALYSIS" >> forensic_history.log

# 4. Push Evidence to GitHub
echo "☁️ Syncing Evidence to the Fortress..."
./rearm.sh
