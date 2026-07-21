# FAQ

## Is this against the Claude Code terms of service?

Claude Code is [open source](https://github.com/anthropics/claude-code) (MIT license). Using it with a custom endpoint is not prohibited. You're using your own API keys for the model provider — Anthropic isn't involved in that part.

## Does everything work like normal Claude Code?

Most things, yes. But there are caveats:

- **Tool use** (file reads, bash, edits) — works on capable models (GPT-4o, DeepSeek V4, Claude via OpenRouter)
- **Multi-turn conversations** — works
- **Extended thinking** — **does not work** on non-Anthropic models (it's an Anthropic-specific feature). `drop_params: true` silently removes these params
- **Image/vision** — works if the provider supports it
- **Context management** — handled by Claude Code client-side, so this works regardless of model

## Is my data safe?

It's as safe as your LiteLLM deployment. If running locally (`localhost:4000`), your code never leaves your machine except to the model provider (DeepSeek, OpenAI, etc.). If deployed to the cloud, traffic goes through your cloud instance.

**Your API key** lives in the LiteLLM config. Don't commit it to git. The `.gitignore` already excludes `litellm_config.yaml`.

## Can I use multiple models?

Yes. Add them all to `model_list` in your config, then use `/model` in Claude Code to switch.

## Which model works best with Claude Code?

From community reports:

| Model | Rating | Notes |
|-------|--------|-------|
| DeepSeek V3 | ⭐⭐⭐⭐ | Strong tool use, good value |
| GPT-4o | ⭐⭐⭐⭐⭐ | Most reliable tool use |
| Claude Sonnet 4.5 (via OpenRouter) | ⭐⭐⭐⭐⭐ | Native Anthropic, best compat |
| Llama 4 Maverick (Groq) | ⭐⭐⭐ | Fast but less reliable tool use |
| Local models (Ollama) | ⭐⭐ | Depends heavily on model size |

## Why do I need `drop_params: true`?

Claude Code sends Anthropic-specific parameters (`context_management`, `thinking`, etc.) that other providers don't understand. Without `drop_params`, the proxy fails with `UnsupportedParamsError`. With it, those params are silently removed.

## Can I run this on a server and share with my team?

Yes, but be careful. Everyone sharing the proxy shares the API key. Consider:

1. **Master key** — require a shared key in `ANTHROPIC_API_KEY`
2. **Rate limiting** — configure in LiteLLM to prevent one user from exhausting credits
3. **Separate instances** — each user runs their own with their own key

## What's the latency like?

LiteLLM adds negligible overhead (~10-50ms). The main latency is:
- Your model provider's response time
- Network round-trips

Running the proxy locally minimizes latency. Cloud deployments add ~50-200ms depending on region.

## Can I use Anthropic models through this?

If you want to use Anthropic models (Claude), you don't need this proxy at all — Claude Code talks to Anthropic natively. But if you want to use Anthropic models **alongside** other models with one proxy, add:

```yaml
  - model_name: claude-sonnet-4-6
    litellm_params:
      model: anthropic/claude-sonnet-4-6
      api_key: sk-ant-your-anthropic-key
```

Or use OpenRouter for Claude models without a separate Anthropic account.

## Does this work with Claude Code's IDE extensions (VS Code, JetBrains)?

Yes. The IDE extensions use the same `~/.claude/settings.json` configuration.
