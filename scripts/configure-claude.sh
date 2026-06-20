#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────────────┐
# │ Configure Claude Code to use LiteLLM proxy                       │
# │                                                                 │
# │ Usage: bash configure-claude.sh [model-name] [base-url]          │
# │   model-name: default "deepseek-v4-pro"                         │
# │   base-url:   default "http://localhost:4000"                    │
# └─────────────────────────────────────────────────────────────────┘

set -euo pipefail

MODEL="${1:-deepseek-v4-pro}"
BASE_URL="${2:-http://localhost:4000}"

SETTINGS_FILE="$HOME/.claude/settings.json"

# Create or backup
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak"
    echo "Backed up existing settings to $SETTINGS_FILE.bak"
fi

mkdir -p "$(dirname "$SETTINGS_FILE")"

cat > "$SETTINGS_FILE" << EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "$BASE_URL",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "$MODEL"
}
EOF

echo ""
echo "Claude Code configured:"
echo "  Settings: $SETTINGS_FILE"
echo "  Base URL: $BASE_URL"
echo "  Model:    $MODEL"
echo ""
echo "Launch Claude Code with: claude"
