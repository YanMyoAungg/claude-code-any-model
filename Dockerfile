# ┌─────────────────────────────────────────────────────────────────┐
# │ LiteLLM Proxy Docker Image for Claude Code                       │
# │                                                                  │
# │ Build: docker build -t claude-code-proxy .                       │
# │                                                                  │
# │ Config is auto-generated from environment variables at startup   │
# │ — no config file needed. See .env.example for all options.      │
# └─────────────────────────────────────────────────────────────────┘

FROM python:3.12-slim

WORKDIR /app

# Install LiteLLM
RUN pip install --no-cache-dir litellm

# Copy entrypoint script
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 4000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:4000/health')" || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
