# Troubleshooting

Common issues and how to fix them.

---

## Proxy Issues

### `UnsupportedParamsError: does not support parameters: ['context_management', ...]`

You're missing `drop_params: true` in your config.

**Fix:** Add to `litellm_config.yaml`:
```yaml
litellm_settings:
  drop_params: true
```

### `Invalid model name passed in model=...`

Claude Code is requesting a model the proxy doesn't know about.

**Fix:** Make sure the `"model"` in `~/.claude/settings.json` exactly matches a `model_name` in `litellm_config.yaml`:
```json
{ "model": "deepseek-v4-pro" }  // Must match config exactly
```

### `Authentication Fails, Your api key is invalid`

The API key in your config is wrong or expired.

**Checklist:**
1. Hardcode the key in `litellm_config.yaml` (don't use env vars like `${VAR}`)
2. Verify the key works directly:
   ```bash
   # DeepSeek
   curl https://api.deepseek.com/v1/models \
     -H "Authorization: Bearer YOUR_KEY"

   # OpenAI
   curl https://api.openai.com/v1/models \
     -H "Authorization: Bearer YOUR_KEY"
   ```
3. Check if you've hit rate limits or run out of credits

### Proxy returns 401 to Claude Code

**Checklist:**
1. Is the proxy running? `curl http://localhost:4000/health`
2. Is `ANTHROPIC_API_KEY` set to any non-empty value in `~/.claude/settings.json`?
3. Check the LiteLLM terminal for error details

### `Connection refused` when Claude Code starts

The proxy isn't running or isn't on the port Claude Code expects.

**Fix:**
```bash
# Check if proxy is running
curl http://localhost:4000/health

# Start it if not
litellm --config litellm_config.yaml --port 4000
```

### Python 3.9 guardrail errors (harmless)

Errors like:
```
unsupported operand type(s) for |: '_TypedDictMeta'
```
These are Python 3.9 compatibility issues in LiteLLM's guardrail modules. They're **non-fatal** — the proxy works fine despite them.

**Fix:** Upgrade to Python 3.10+ to eliminate them, or ignore them.

---

## Claude Code Issues

### Claude Code shows "Anthropic" model instead of my custom one

Your `settings.json` isn't being read.

**Checklist:**
1. Is the file at `~/.claude/settings.json`? (not `~/claude.json` or `~/.claude.json`)
2. Is the JSON valid? `cat ~/.claude/settings.json | python3 -m json.tool`
3. Restart Claude Code after changing settings

### `/model` doesn't show my models

Claude Code has already started with the wrong model.

**Fix:** Restart Claude Code. `/model` reads from the proxy on startup.

### Claude Code acts strange / gives bad responses

The custom model may not handle Claude Code's complex tool-use patterns well.

**Things to try:**
1. Use a more capable model (larger models handle tool use better)
2. Try a different provider
3. Some features (thinking, extended thinking) may not work on non-Anthropic models

---

## Provider-Specific

### DeepSeek: Rate limiting

DeepSeek has rate limits. If you see 429 errors:

```yaml
router_settings:
  num_retries: 3
  timeout: 600
```

### OpenAI: Billing issues

Make sure you have credits. OpenAI requires pre-paid credits for API access (not the same as ChatGPT subscription).

### Ollama: Model not found

```bash
# List installed models
ollama list

# Pull if missing
ollama pull llama3

# Make sure Ollama is running
ollama serve
```

### Groq: Rate limits on free tier

The free tier has strict rate limits. Consider upgrading or adding retries:

```yaml
router_settings:
  num_retries: 2
```

---

## Still Stuck?

1. Check LiteLLM logs — they're usually quite detailed
2. [LiteLLM Discord](https://discord.gg/berriai) — active community
3. [File an issue](https://github.com/YanMyoAungg/claude-code-any-model/issues) on this repo
