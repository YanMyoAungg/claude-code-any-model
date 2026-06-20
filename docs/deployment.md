# Deployment Guide

Keep your LiteLLM proxy running 24/7 on a cloud platform. Then set `ANTHROPIC_BASE_URL` in your Claude Code settings to your deployment URL — no local proxy needed.

---

## Railway

[Railway](https://railway.app) — free tier includes $5 credit/month (enough for a LiteLLM proxy).

### Deploy

1. Fork/clone this repo to your GitHub
2. Go to [railway.app/new](https://railway.app/new) → Deploy from GitHub repo
3. Select your repo
4. Add environment variables in Railway dashboard:
   - `DEEPSEEK_API_KEY` (or your provider's key — see `.env.example` for all options)
   - `LITELLM_MODEL` — your model string, e.g. `deepseek/deepseek-v4-pro`
   - `LITELLM_MODEL_NAME` — the name shown in Claude Code, e.g. `deepseek-v4-pro`
5. Railway auto-detects the Dockerfile and deploys
6. Get your URL: `https://your-app.up.railway.app`

### Configure Claude Code

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-app.up.railway.app",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "deepseek-v4-pro"
}
```

### Notes
- Free tier sleeps after inactivity — first request may be slow
- To prevent sleep: set up a cron job that pings `/health` every 5 minutes
- The proxy is public — anyone who knows the URL can use it. Add a `master_key` if you want to lock it down.

---

## Render

[Render](https://render.com) — free tier for web services.

### Deploy

1. Push this repo to GitHub
2. Go to [dashboard.render.com](https://dashboard.render.com) → New → Web Service
3. Connect your repo
4. Settings:
   - **Runtime:** Docker
   - **Port:** 4000
5. Add environment variables:
   - `DEEPSEEK_API_KEY` (or your provider's key — see `.env.example` for all options)
   - `LITELLM_MODEL` and `LITELLM_MODEL_NAME` for your chosen model
6. Deploy
7. Your URL: `https://your-service.onrender.com`

### Configure Claude Code

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-service.onrender.com",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "deepseek-v4-pro"
}
```

### Notes
- Free tier sleeps after 15 minutes of inactivity
- Cold start takes ~30 seconds
- Use a cron job or uptime monitor to keep it warm

---

## HuggingFace Spaces

[HuggingFace Spaces](https://huggingface.co/spaces) — free Docker hosting.

### Deploy

1. Go to [huggingface.co/new-space](https://huggingface.co/new-space)
2. Choose **Docker** as the Space SDK
3. Upload or link this repo
4. Add secrets in Settings → Secrets:
   - `DEEPSEEK_API_KEY`, `LITELLM_MODEL`, `LITELLM_MODEL_NAME`
5. The Space builds and deploys automatically
6. Your URL: `https://your-username-your-space.hf.space`

### Configure Claude Code

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-username-your-space.hf.space",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "deepseek-v4-pro"
}
```

### Notes
- Free, but resource limits apply
- May sleep after inactivity
- Good for personal use and demos

---

## Fly.io

[Fly.io](https://fly.io) — pay-as-you-go, generous free allowance.

### Deploy

```bash
# Install flyctl
brew install flyctl   # macOS
# curl -L https://fly.io/install.sh | sh  # Linux

# Launch
fly launch --dockerfile Dockerfile

# Set secrets
fly secrets set DEEPSEEK_API_KEY=sk-your-key LITELLM_MODEL=deepseek/deepseek-v4-pro LITELLM_MODEL_NAME=deepseek-v4-pro

# Deploy
fly deploy
```

Your app will be at `https://your-app.fly.dev`.

### Configure Claude Code

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-app.fly.dev",
    "ANTHROPIC_API_KEY": "sk-anything"
  },
  "model": "deepseek-v4-pro"
}
```

### Notes
- Free allowance includes 3 shared-CPU VMs
- No cold starts — always running
- Good option for a permanent setup

---

## Cloudflare Tunnel (keep it local but accessible)

If you want the proxy on your own machine but accessible from anywhere:

```bash
# Install cloudflared
brew install cloudflared

# Start tunnel
cloudflared tunnel --url http://localhost:4000
```

You'll get a `*.trycloudflare.com` URL pointing to your local proxy.

**Note:** The tunnel dies when you close the terminal or your machine sleeps. Good for temporary access, not 24/7.

---

## Securing Your Deployment

If your proxy is publicly accessible, consider adding a master key.

**Via environment variable** (recommended for Docker/cloud):
```bash
LITELLM_MASTER_KEY=sk-your-secret-master-key
```

**Via config file** (local users):
```yaml
# litellm_config.yaml
general_settings:
  master_key: sk-your-secret-master-key
```

Then set `ANTHROPIC_API_KEY` in Claude Code to your master key:
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-proxy.example.com",
    "ANTHROPIC_API_KEY": "sk-your-secret-master-key"
  }
}
```

Without it, requests will be rejected. This prevents random people from using your proxy (and your API key).

---

## Multi-Model Setup (Docker / Cloud)

The entrypoint script generates a **single-model** config. For multiple models, use LiteLLM's pre-built image with a mounted config file:

1. Create `litellm_config.yaml` with all your models:
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

2. Mount it in your deployment:
```yaml
services:
  litellm:
    image: ghcr.io/berriai/litellm:main-latest
    volumes:
      - ./litellm_config.yaml:/app/config.yaml:ro
    command: ["--config", "/app/config.yaml", "--port", "4000"]
```
