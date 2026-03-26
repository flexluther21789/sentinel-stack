#!/bin/bash
echo "🧹 Sanitizing environment..."
rm -f .tmp* .session_delta.tmp .zshrc.save ~/.sentinel_tripwire.log
echo "✅ Cleanup complete."
