#!/bin/bash
# REARM.SH - The Sentinel Stack Automation Tool
# Purpose: Automates the Unlock, Hash, Git Sync, and Re-Lock cycle.

echo "🔓 Unlocking the Fortress..."
chflags nouchg .
chflags nouchg *.sh manifest.sha256 README.md 2>/dev/null

echo "📑 Updating Integrity Manifest..."
shasum -a 256 *.sh > manifest.sha256

echo "☁️ Syncing with GitHub..."
git add .
read -p "Enter commit message (default: 'update'): " msg
msg=${msg:-"update"}
git commit -m "$msg"
git push

echo "🔒 Sealing the Vault (Applying uchg)..."
chmod +x *.sh
chflags uchg *.sh manifest.sha256 README.md
chflags uchg .

echo "✅ System Re-Armed and Synced."
