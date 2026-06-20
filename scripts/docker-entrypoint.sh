#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────────────┐
# │ Docker Entrypoint — generate litellm config from env vars        │
# │                                                                  │
# │ Set LITELLM_MODEL and one of the *_API_KEY vars below.           │
# │ No config file needed — everything comes from the environment.   │
# └─────────────────────────────────────────────────────────────────┘

set -euo pipefail

CONFIG_FILE="/app/litellm_config.yaml"
PORT="${LITELLM_PORT:-4000}"

# Default model if not set
MODEL="${LITELLM_MODEL:-deepseek/deepseek-v4-pro}"
MODEL_NAME="${LITELLM_MODEL_NAME:-deepseek-v4-pro}"

echo "==> Generating LiteLLM config..."
echo "    Model: $MODEL ($MODEL_NAME)"

cat > "$CONFIG_FILE" << EOF
# Auto-generated from environment variables
# See .env.example for all supported vars

model_list:
  - model_name: $MODEL_NAME
    litellm_params:
      model: $MODEL
EOF

# Add API key based on which env var is set
if [ -n "${DEEPSEEK_API_KEY:-}" ]; then
    echo "      api_key: $DEEPSEEK_API_KEY" >> "$CONFIG_FILE"
elif [ -n "${OPENAI_API_KEY:-}" ]; then
    echo "      api_key: $OPENAI_API_KEY" >> "$CONFIG_FILE"
elif [ -n "${GROQ_API_KEY:-}" ]; then
    echo "      api_key: $GROQ_API_KEY" >> "$CONFIG_FILE"
elif [ -n "${GEMINI_API_KEY:-}" ]; then
    echo "      api_key: $GEMINI_API_KEY" >> "$CONFIG_FILE"
elif [ -n "${OPENROUTER_API_KEY:-}" ]; then
    echo "      api_key: $OPENROUTER_API_KEY" >> "$CONFIG_FILE"
elif [ -n "${LITELLM_API_KEY:-}" ]; then
    echo "      api_key: $LITELLM_API_KEY" >> "$CONFIG_FILE"
elif [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    echo "      api_key: $ANTHROPIC_API_KEY" >> "$CONFIG_FILE"
fi

# Add optional api_base
if [ -n "${LITELLM_API_BASE:-}" ]; then
    echo "      api_base: $LITELLM_API_BASE" >> "$CONFIG_FILE"
fi

cat >> "$CONFIG_FILE" << EOF

litellm_settings:
  drop_params: true
EOF

# Optional master key
if [ -n "${LITELLM_MASTER_KEY:-}" ]; then
    cat >> "$CONFIG_FILE" << EOF

general_settings:
  master_key: $LITELLM_MASTER_KEY
EOF
fi

echo "==> Config written to $CONFIG_FILE"
echo "==> Starting LiteLLM on port $PORT..."

exec litellm --config "$CONFIG_FILE" --port "$PORT"
