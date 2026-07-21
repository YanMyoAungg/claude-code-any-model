#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────────────┐
# │ Install LiteLLM                                                 │
# │ Uses uv if available (faster), falls back to pip                │
# └─────────────────────────────────────────────────────────────────┘

set -euo pipefail

echo "Installing LiteLLM..."

if command -v uv &>/dev/null; then
    echo "  Using: uv"
    uv pip install "litellm[proxy]"
elif command -v pip3 &>/dev/null; then
    echo "  Using: pip3"
    pip3 install "litellm[proxy]"
elif command -v pip &>/dev/null; then
    echo "  Using: pip"
    pip install "litellm[proxy]"
else
    echo "Error: Neither uv nor pip found."
    echo "Install Python: https://python.org"
    exit 1
fi

echo ""
echo "LiteLLM installed. Verify:"
litellm --version 2>/dev/null || echo "  (version check skipped — litellm CLI may need $PATH update)"
echo "Done."
