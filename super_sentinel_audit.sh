#!/bin/bash
REPORT_FILE="security_audit_report.txt"

echo "⚡ Gathering intelligence from all .sh files..."
{
  echo "CONTEXT: The following are various bash scripts from a local environment."
  echo "TASK: Perform a holistic security audit. Identify backdoors, suspicious network calls, or hardcoded credentials."
  echo "--- START SCRIPTS ---"
  
  for f in *.sh; do
    [[ "$f" == "super_sentinel_audit.sh" ]] && continue
    echo "FILE: $f"
    cat "$f"
    echo -e "\n--- END OF $f ---\n"
  done
} | ollama run llama3.1-64k > "$REPORT_FILE"

echo "✅ Audit complete. Results saved to: $REPORT_FILE"
cat "$REPORT_FILE"
