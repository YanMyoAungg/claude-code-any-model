# Provider Setup Guides

Detailed setup for each supported provider. All configs go in `litellm_config.yaml`.

---

## DeepSeek

[DeepSeek Platform](https://platform.deepseek.com) | [API Keys](https://platform.deepseek.com/api_keys) | [Pricing](https://platform.deepseek.com/pricing)

```yaml
model_list:
  - model_name: deepseek-chat
    litellm_params:
      model: deepseek/deepseek-chat
      api_key: sk-your-deepseek-key

litellm_settings:
  drop_params: true
```

**Available models:**
- `deepseek/deepseek-chat` — Latest (V3/V4 capabilities)
- `deepseek/deepseek-reasoner` — R1 (reasoning)

**Notes:**
- DeepSeek platform provides $0.50 free credit for new accounts
- `deepseek-chat` points to DeepSeek's latest model — no need for version-specific IDs
- Reasoning models (R1) may have different response formats — test thoroughly

---

## OpenAI

[OpenAI Platform](https://platform.openai.com) | [API Keys](https://platform.openai.com/api-keys)

```yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: sk-your-openai-key

litellm_settings:
  drop_params: true
```

**Available models:**
- `openai/gpt-4o` — Best all-around
- `openai/gpt-4.1` — Latest
- `openai/gpt-4o-mini` — Budget, fast

**Notes:**
- GPT-4o works well as a Claude Code driver. Responses are similar quality.
- Tool use (the ability to call functions) works correctly through the proxy.
- o-series models (o3, o4) may require the Responses API — not suitable for Claude Code

---

## Groq

[Groq Console](https://console.groq.com) | [API Keys](https://console.groq.com/keys)

```yaml
model_list:
  - model_name: llama-4-maverick
    litellm_params:
      model: groq/meta-llama/llama-4-maverick-17b-128e-instruct
      api_key: gsk_your-groq-key

litellm_settings:
  drop_params: true
```

**Available models:**
- `groq/meta-llama/llama-4-maverick-17b-128e-instruct` — Latest Llama
- `groq/meta-llama/llama-4-scout-17b-16e-instruct` — Faster variant
- `groq/llama-3.3-70b-versatile` — Proven, reliable

**Notes:**
- Groq offers very fast inference — great for latency-sensitive use
- Free tier available with rate limits
- Some models may struggle with complex tool use patterns

---

## Google Gemini

[Google AI Studio](https://aistudio.google.com) | [API Key](https://aistudio.google.com/apikey)

```yaml
model_list:
  - model_name: gemini-2.5-pro
    litellm_params:
      model: gemini/gemini-2.5-pro
      api_key: your-gemini-api-key

litellm_settings:
  drop_params: true
```

**Available models:**
- `gemini/gemini-2.0-flash` — Free tier, most reliable
- `gemini/gemini-2.5-flash-preview-09-2025` — Faster (preview)
- `gemini/gemini-2.5-flash-lite-preview-09-2025` — Cheaper 2.5 variant (preview)

**Notes:**
- Google AI Studio is free for development use
- 2.5 models are preview — IDs include versioned date suffixes which may change
- Bare IDs like `gemini-2.5-flash` do NOT exist as Google AI Studio models — use the full versioned string
- Check [LiteLLM Gemini docs](https://docs.litellm.ai/docs/providers/gemini) for the latest model IDs

---

## Ollama (Local)

[Ollama](https://ollama.com) — run models locally, no API key needed.

```yaml
model_list:
  - model_name: llama3
    litellm_params:
      model: ollama/llama3
      api_base: http://localhost:11434

litellm_settings:
  drop_params: true
```

**Setup:**
```bash
# Install Ollama
brew install ollama           # macOS
# curl -fsSL https://ollama.com/install.sh | sh  # Linux

# Pull a model
ollama pull llama3
ollama pull mistral
ollama pull codellama

# Start Ollama (usually runs as a service automatically)
ollama serve
```

**Available models:** Any model you've pulled in Ollama. Popular ones:
- `ollama/llama3` — Good all-around
- `ollama/mistral` — Strong code performance
- `ollama/codellama` — Code-focused
- `ollama/deepseek-r1:8b` — Reasoning (small)

**Notes:**
- No network latency — everything is local
- Quality depends on your hardware and model size
- Tool use may be less reliable with smaller models (< 8B params)
- To use a different Ollama host: change `api_base`

---

## OpenRouter

[OpenRouter](https://openrouter.ai) | [Keys](https://openrouter.ai/keys) — 200+ models through one API.

```yaml
model_list:
  - model_name: claude-sonnet-4-6
    litellm_params:
      model: openrouter/anthropic/claude-sonnet-4-6
      api_key: sk-or-your-key

litellm_settings:
  drop_params: true
```

**Available models:** Browse at [openrouter.ai/models](https://openrouter.ai/models). Any model works with the format `openrouter/<provider>/<model>`.

**Notes:**
- Unified billing — one key, many providers
- Pay-per-token, no subscriptions
- Good for trying different models without signing up for each provider

---

## Custom / Any LiteLLM Provider

LiteLLM supports [100+ providers](https://docs.litellm.ai/docs/providers). The format is always:

```yaml
model_list:
  - model_name: my-model           # name for Claude Code
    litellm_params:
      model: provider/model-id     # LiteLLM provider string
      api_key: your-key
      # Additional params as needed:
      api_base: https://custom-endpoint  # for self-hosted
      api_version: "2024-02-01"          # for versioned APIs

litellm_settings:
  drop_params: true
```

### Anthropic-compatible APIs

If you're using an API that already speaks Anthropic's format (like Amazon Bedrock with Anthropic models, or a self-hosted vLLM with Anthropic compatibility), you don't need LiteLLM at all. Just set `ANTHROPIC_BASE_URL` directly in `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-anthropic-compatible-api.com",
    "ANTHROPIC_API_KEY": "your-key"
  }
}
```

### Self-hosted / vLLM

For self-hosted models with an OpenAI-compatible API:

```yaml
model_list:
  - model_name: my-local-model
    litellm_params:
      model: openai/my-model-name
      api_base: http://localhost:8000/v1
      api_key: not-needed
```

---

## Multiple Providers

Run them all at once — switch in Claude Code with `/model`:

```yaml
model_list:
  - model_name: deepseek-v4-pro
    litellm_params:
      model: deepseek/deepseek-v4-pro
      api_key: sk-deepseek-key

  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: sk-openai-key

  - model_name: llama-4-maverick
    litellm_params:
      model: groq/meta-llama/llama-4-maverick-17b-128e-instruct
      api_key: gsk_groq-key

  - model_name: gemini-2.5-pro
    litellm_params:
      model: gemini/gemini-2.5-pro-exp-03-25
      api_key: your-gemini-key

litellm_settings:
  drop_params: true
```
