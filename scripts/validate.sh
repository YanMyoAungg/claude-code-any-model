#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────────────┐
# │ Validate your setup                                              │
# │ Checks: proxy health, config, Claude Code settings              │
# └─────────────────────────────────────────────────────────────────┘

set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0

echo "Checking setup..."
echo ""

# Check Python
if command -v python3 &>/dev/null || command -v python &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} Python"
else
    echo -e "  ${RED}✗${NC} Python not found"
    ((ERRORS++))
fi

# Resolve script directory to find config regardless of where we're invoked from
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Check config (look in multiple places)
CONFIG_FILE=""
for candidate in \
    "$REPO_DIR/litellm_config.yaml" \
    "$REPO_DIR/config.example.yaml" \
    "litellm_config.yaml" \
    "../litellm_config.yaml"; do
    if [ -f "$candidate" ]; then
        CONFIG_FILE="$candidate"
        break
    fi
done

if [ -n "$CONFIG_FILE" ]; then
    echo -e "  ${GREEN}✓${NC} Config found: $CONFIG_FILE"
else
    echo -e "  ${YELLOW}!${NC} No litellm_config.yaml found"
    echo "    Create one: cp config.example.yaml litellm_config.yaml"
    echo "    Then edit it with your API key"
fi

# Check proxy health
PROXY_RUNNING=false
if curl -sf http://localhost:4000/health > /dev/null 2>&1; then
    PROXY_RUNNING=true
    echo -e "  ${GREEN}✓${NC} LiteLLM proxy running on :4000"
else
    echo -e "  ${YELLOW}!${NC} LiteLLM proxy not running on :4000"
fi

# Check LiteLLM (proxy running is the best signal)
LITELLM_OK=false
if $PROXY_RUNNING; then
    LITELLM_OK=true
elif litellm --version &>/dev/null 2>&1; then
    LITELLM_OK=true
elif python3 -c "import litellm" 2>/dev/null; then
    LITELLM_OK=true
elif python -c "import litellm" 2>/dev/null; then
    LITELLM_OK=true
elif "$HOME/.local/bin/python3" -c "import litellm" 2>/dev/null; then
    LITELLM_OK=true
fi

if $LITELLM_OK; then
    echo -e "  ${GREEN}✓${NC} LiteLLM installed"
else
    echo -e "  ${RED}✗${NC} LiteLLM not installed. Run: pip install \"litellm[proxy]\""
    echo "    Or the one-command setup: bash setup"
    ((ERRORS++))
fi

# Check Claude Code settings
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
    echo -e "  ${GREEN}✓${NC} Claude Code settings found"

    # Base URL
    BASE_URL_LINE=$(grep "ANTHROPIC_BASE_URL" "$SETTINGS" | head -1 || true)
    if [ -n "$BASE_URL_LINE" ]; then
        URL=$(echo "$BASE_URL_LINE" | grep -oE 'http[^"]*' || true)
        echo "    Base URL: ${URL:-unknown}"
    else
        echo -e "    ${YELLOW}!${NC} ANTHROPIC_BASE_URL not set"
    fi

    # Model
    MODEL_LINE=$(grep '"model"' "$SETTINGS" | head -1 || true)
    if [ -n "$MODEL_LINE" ]; then
        MODEL=$(echo "$MODEL_LINE" | sed -n 's/.*"model"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' || true)
        echo "    Model: ${MODEL:-unknown}"
    fi
else
    echo -e "  ${YELLOW}!${NC} No Claude Code settings found at $SETTINGS"
    echo "    Run: bash scripts/configure-claude.sh"
fi

# Check Claude Code
if command -v claude &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} Claude Code CLI"
else
    echo -e "  ${YELLOW}!${NC} Claude Code CLI not in PATH"
    echo "    Install: brew install claude-code"
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo -e "${RED}$ERRORS issue(s) found.${NC}"
    exit 1
else
    echo -e "${GREEN}All checks passed!${NC}"
fi
