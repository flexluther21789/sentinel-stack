#!/bin/bash
REPORT="sentinel_report.txt"

{
  echo "=== SYSTEM CONTEXT OVERVIEW ==="
  echo "Date: $(date)"
  echo "Active Network Listeners (LSOF):"
  lsof -i -P -n | grep LISTEN | awk '{print $1, $9}'
  
  echo -e "\n=== CRITICAL EXTENSIONS ==="
  systemextensionsctl list | grep "enabled"
  
  echo -e "\n=== SCRIPT AUDIT START ==="
  for f in *.sh; do
    [[ "$f" == "sentinel_v2.sh" ]] && continue
    echo "FILE: $f"
    cat "$f"
    echo -e "\n---"
  done
} | ollama run llama3.1-64k "As a Senior Security Auditor, compare these running processes and extensions against the provided scripts. Are any scripts creating the network listeners I see? Is there anything suspicious? Be precise." > "$REPORT"

echo "🎯 Audit complete. Reviewing summary..."
cat "$REPORT"
