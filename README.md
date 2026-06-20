# Claude Code with Custom Models

> Use **any LLM** — DeepSeek V4, GPT-4o, Gemini, Llama 4, or local models — with Claude Code via a [LiteLLM](https://github.com/BerriAI/litellm) proxy.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

<img width="2940" height="1910" alt="image" src="https://github.com/user-attachments/assets/a2ce4836-d839-4770-b6c7-4e04eba00983" />

> 📖 **မြန်မာဘာသာပြန်** — ဤ README ၏ မြန်မာဘာသာပြန်ကို [အောက်တွင်](#မြန်မာဘာသာပြန်) ကြည့်ရှုနိုင်ပါသည်။  
> 📖 **Burmese translation** available [below](#မြန်မာဘာသာပြန်).



```
┌──────────────┐     Anthropic API      ┌──────────────┐     Native API      ┌──────────────┐
│              │ ──────────────────────> │              │ ──────────────────> │              │
│  Claude Code │     /v1/messages       │   LiteLLM    │  chat/completions   │  DeepSeek    │
│              │ <────────────────────── │    Proxy     │ <────────────────── │  OpenAI      │
└──────────────┘     JSON response      └──────────────┘     JSON response    │  Groq        │
     :4000?                                localhost:4000                     │  Gemini      │
                                                                              │  Ollama      │
                                                                              │  ...and more │
                                                                              └──────────────┘
```

## Why?

- Claude Code only talks to Anthropic's API. LiteLLM acts as a translator, converting Anthropic-format requests into whatever format your chosen model expects.
- **You keep full control** — your API keys, your deployment, your data.
- **One setup** — switch between providers anytime with `/model`.

## Supported Providers

| Provider | Models | Setup Guide |
|----------|--------|-------------|
| [DeepSeek](https://platform.deepseek.com) | V3, V4, R1 | [→ deepseek](./docs/providers.md#deepseek) |
| [OpenAI](https://platform.openai.com) | GPT-4o, o3/o4-mini | [→ openai](./docs/providers.md#openai) |
| [Groq](https://console.groq.com) | Llama 4, Mixtral | [→ groq](./docs/providers.md#groq) |
| [Google](https://aistudio.google.com) | Gemini 2.5 Pro/Flash | [→ gemini](./docs/providers.md#gemini) |
| [Ollama](https://ollama.com) | Any local model | [→ ollama](./docs/providers.md#ollama) |
| [OpenRouter](https://openrouter.ai) | 200+ models | [→ openrouter](./docs/providers.md#openrouter) |
| Any [LiteLLM-supported](https://docs.litellm.ai/docs/providers) provider | ∞ | [→ custom](./docs/providers.md#custom) |

## Quick Start

### One command

```bash
curl -fsSL https://raw.githubusercontent.com/YanMyoAungg/claude-code-any-model/main/setup | bash
```

The script asks which provider you want, takes your API key, installs LiteLLM, configures everything, and starts the proxy. Done in under a minute.

### Or do it manually

#### 1. Install LiteLLM

```bash
pip install litellm
# or: uv pip install litellm
```

#### 2. Create config

```bash
cp config.example.yaml litellm_config.yaml
# Edit litellm_config.yaml → replace the API key with yours
```

#### 3. Start the proxy

```bash
litellm --config litellm_config.yaml --port 4000
```

#### 4. Configure Claude Code

Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "deepseek-v4-pro"
}
```

`ANTHROPIC_API_KEY` can be any non-empty value — your real key lives in the LiteLLM config.

#### 5. Launch

```bash
claude
```

You should see your model name in the header. Type `/model` to switch between configured models.

## Docker

```bash
cp .env.example .env
# Edit .env → add your API key + choose model

docker compose up
```

No Python needed. No config file needed — everything is set via environment variables. The proxy runs on `localhost:4000`.

## Deploy to the Cloud

Keep the proxy running 24/7 on a free cloud tier. Push the repo, set the same env vars in your platform's dashboard, and the Dockerfile handles the rest. Then set `ANTHROPIC_BASE_URL` to your deployment URL.

| Platform | Free Tier | Guide |
|----------|-----------|-------|
| Railway | Yes | [→ railway](./docs/deployment.md#railway) |
| Render | Yes | [→ render](./docs/deployment.md#render) |
| HuggingFace Spaces | Yes | [→ huggingface](./docs/deployment.md#huggingface-spaces) |
| Fly.io | Pay-as-you-go | [→ fly](./docs/deployment.md#fly-io) |

## How It Works

1. Claude Code sends **Anthropic-format** requests to `ANTHROPIC_BASE_URL`
2. **LiteLLM proxy** receives them at `/v1/messages`
3. LiteLLM **translates** the request into the target provider's native format
4. The provider responds → LiteLLM **translates back** to Anthropic format
5. Claude Code receives a response it understands
6. `drop_params: true` silently removes any Anthropic-specific params the target model doesn't support

## Switching Models

Add multiple models to `litellm_config.yaml`:

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

litellm_settings:
  drop_params: true
```

Then in Claude Code: `/model` → pick your model.

## Documentation

- [Provider Setup Guides](./docs/providers.md) — detailed config for each provider
- [Deployment Guide](./docs/deployment.md) — cloud deployment walkthroughs
- [Troubleshooting](./docs/troubleshooting.md) — common issues and fixes
- [FAQ](./docs/faq.md) — frequently asked questions

## Requirements

- **Claude Code** — `brew install claude-code` or `npm install -g @anthropic-ai/claude-code`
- **Python 3.9+** — for LiteLLM (or use Docker)
- **API key** from your chosen provider

## License

MIT — see [LICENSE](LICENSE).

---

---

# မြန်မာဘာသာပြန်

> Claude Code ကို DeepSeek V4, GPT-4o, Gemini, Llama 4 စတဲ့ **ဘယ် LLM နဲ့မဆို** [LiteLLM](https://github.com/BerriAI/litellm) ကြားခံဆာဗာကနေတစ်ဆင့် အသုံးပြုနိုင်ပါတယ်။

```
┌──────────────┐     Anthropic API      ┌──────────────┐     Native API      ┌──────────────┐
│              │ ──────────────────────> │              │ ──────────────────> │              │
│  Claude Code │     /v1/messages       │   LiteLLM    │  chat/completions   │  DeepSeek    │
│              │ <────────────────────── │    Proxy     │ <────────────────── │  OpenAI      │
└──────────────┘     JSON response      └──────────────┘     JSON response    │  Groq        │
     :4000?                                localhost:4000                     │  Gemini      │
                                                                              │  Ollama      │
                                                                              │  ...နှင့် အခြား  │
                                                                              └──────────────┘
```

## ဘာကြောင့်လဲ?

- Claude Code က Anthropic ရဲ့ API နဲ့ပဲ စကားပြောနိုင်ပါတယ်။ LiteLLM က ဘာသာပြန်တစ်ယောက်လို Anthropic format ကနေ သင်ရွေးချယ်တဲ့ model ရဲ့ format ကို ပြောင်းပေးပါတယ်။
- **သင် အပြည့်အဝ ထိန်းချုပ်နိုင်ပါတယ်** — သင့် API ကီး၊ သင့် deployment၊ သင့် data။
- **တစ်ခါတည်း setup** — `/model` နဲ့ provider တွေ အချိန်မရွေး ပြောင်းနိုင်ပါတယ်။

## ထောက်ပံ့သော Provider များ

| Provider | Models | Setup လမ်းညွှန် |
|----------|--------|-------------------|
| [DeepSeek](https://platform.deepseek.com) | V3, V4, R1 | [→ deepseek](./docs/providers.md#deepseek) |
| [OpenAI](https://platform.openai.com) | GPT-4o, o3/o4-mini | [→ openai](./docs/providers.md#openai) |
| [Groq](https://console.groq.com) | Llama 4, Mixtral | [→ groq](./docs/providers.md#groq) |
| [Google](https://aistudio.google.com) | Gemini 2.5 Pro/Flash | [→ gemini](./docs/providers.md#gemini) |
| [Ollama](https://ollama.com) | ဘယ် local model မဆို | [→ ollama](./docs/providers.md#ollama) |
| [OpenRouter](https://openrouter.ai) | model ၂၀၀+ | [→ openrouter](./docs/providers.md#openrouter) |
| [LiteLLM ထောက်ပံ့သော](https://docs.litellm.ai/docs/providers) provider များ | ∞ | [→ custom](./docs/providers.md#custom) |

## အမြန်စတင်ရန်

### တစ်ကြောင်းတည်းနဲ့

```bash
curl -fsSL https://raw.githubusercontent.com/YanMyoAungg/claude-code-any-model/main/setup | bash
```

ဒီ script က ဘယ် provider သုံးမလဲ မေးပါမယ်၊ API ကီး တောင်းပါမယ်၊ LiteLLM ထည့်ပေးပါမယ်၊ အားလုံး configure လုပ်ပေးပြီး proxy စဖွင့်ပေးပါမယ်။ တစ်မိနစ်အတွင်း ပြီးပါတယ်။

### ကိုယ်တိုင်လုပ်မယ်ဆိုရင်

#### ၁။ LiteLLM ထည့်သွင်းပါ

```bash
pip install litellm
# သို့မဟုတ်: uv pip install litellm
```

#### ၂။ Config ဖိုင် ဖန်တီးပါ

```bash
cp config.example.yaml litellm_config.yaml
# litellm_config.yaml ကိုဖွင့်ပြီး API ကီးကို သင့်ဟာနဲ့ အစားထိုးပါ
```

#### ၃။ Proxy စဖွင့်ပါ

```bash
litellm --config litellm_config.yaml --port 4000
```

#### ၄။ Claude Code ကို ချိန်ညှိပါ

`~/.claude/settings.json` ထဲတွင် ထည့်ပါ:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "deepseek-v4-pro"
}
```

`ANTHROPIC_API_KEY` က ဘာပဲဖြစ်ဖြစ် ရပါတယ် (ဗလာမဖြစ်ရုံပဲ) — တကယ့် API ကီးက LiteLLM config ထဲမှာ ရှိပါတယ်။

#### ၅။ စတင်ပါ

```bash
claude
```

Header မှာ သင့် model နာမည် ပေါ်လာပါလိမ့်မယ်။ `/model` ရိုက်ပြီး တခြား model တွေကို ပြောင်းနိုင်ပါတယ်။

## Docker

```bash
cp .env.example .env
# .env ကိုဖွင့်ပြီး API ကီး + model ထည့်ပါ

docker compose up
```

Python မလိုပါ။ Config ဖိုင်လည်း မလိုပါ — အားလုံးကို environment variables ကနေ auto-generate လုပ်ပါတယ်။ Proxy က `localhost:4000` မှာ မောင်းပါလိမ့်မယ်။

## Cloud ပေါ်တင်ခြင်း

Repo ကို push လုပ်ပါ၊ သင့် platform dashboard မှာ environment variables တွေ ထည့်ပါ။ Dockerfile က ကျန်တာကို ဆက်လုပ်ပေးပါလိမ့်မယ်။ ပြီးရင် `ANTHROPIC_BASE_URL` ကို သင့် deployment URL နဲ့ ချိန်းပေးရုံပါပဲ။

| Platform | Free Tier | လမ်းညွှန် |
|----------|-----------|-------------|
| Railway | ရှိ | [→ railway](./docs/deployment.md#railway) |
| Render | ရှိ | [→ render](./docs/deployment.md#render) |
| HuggingFace Spaces | ရှိ | [→ huggingface](./docs/deployment.md#huggingface-spaces) |
| Fly.io | Pay-as-you-go | [→ fly](./docs/deployment.md#fly-io) |

## အလုပ်လုပ်ပုံ

၁။ Claude Code က **Anthropic format** request တွေကို `ANTHROPIC_BASE_URL` ဆီ ပို့ပါတယ်  
၂။ **LiteLLM proxy** က `/v1/messages` မှာ လက်ခံပါတယ်  
၃။ LiteLLM က request ကို ရွေးချယ်ထားတဲ့ provider ရဲ့ format နဲ့ **ဘာသာပြန်**ပေးပါတယ်  
၄။ Provider က ပြန်ဖြေ → LiteLLM က Anthropic format ကို **ပြန်ဘာသာပြန်**ပေးပါတယ်  
၅။ Claude Code က သူနားလည်တဲ့ response ကို လက်ခံရရှိပါတယ်  
၆။ `drop_params: true` က Anthropic သီးသန့် parameter တွေကို တိတ်တိတ်လေး ဖယ်ပေးပါတယ်  

## Model ပြောင်းခြင်း

`litellm_config.yaml` ထဲမှာ model အများကြီး ထည့်ပါ:

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

litellm_settings:
  drop_params: true
```

ပြီးရင် Claude Code မှာ `/model` ရိုက်ပြီး ကြိုက်တဲ့ model ကို ရွေးပါ။

## စာရွက်စာတမ်းများ

- [Provider Setup လမ်းညွှန်](./docs/providers.md) — provider တစ်ခုချင်းအတွက် config အသေးစိတ်
- [Deployment လမ်းညွှန်](./docs/deployment.md) — cloud ပေါ်တင်နည်း
- [ပြဿနာဖြေရှင်းနည်း](./docs/troubleshooting.md) — အဖြစ်များတဲ့ ပြဿနာများနဲ့ ဖြေရှင်းနည်း
- [FAQ](./docs/faq.md) — မေးလေ့ရှိသော မေးခွန်းများ

## လိုအပ်ချက်များ

- **Claude Code** — `brew install claude-code` သို့မဟုတ် `npm install -g @anthropic-ai/claude-code`
- **Python 3.9+** — LiteLLM အတွက် (သို့မဟုတ် Docker သုံးပါ)
- **API ကီး** — သင်ရွေးချယ်တဲ့ provider မှ ရယူပါ

## လိုင်စင်

MIT — [LICENSE](LICENSE) တွင်ကြည့်ပါ။
