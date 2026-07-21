# Contributing

PRs welcome! Here's how to help:

## Ways to Contribute

- **Bug reports** — open an issue with steps to reproduce
- **Provider configs** — add or fix provider examples in `docs/providers.md` and `config.example.yaml`
- **Documentation** — improve clarity, add examples, translate
- **Code** — fix bugs, improve the setup script, add features

## Setup for Development

```bash
git clone https://github.com/YanMyoAungg/claude-code-any-model
cd claude-code-custom-model
pip install "litellm[proxy]"
cp config.example.yaml litellm_config.yaml
# Edit litellm_config.yaml with your API key
```

## Guidelines

- Keep the setup script (`setup`) POSIX-compatible (no bashisms that break on macOS's ancient bash)
- Test on both macOS and Linux where possible
- The Docker entrypoint must work with just env vars — no mounted config files
- README changes should be reflected in the Burmese section too (or tag someone who can translate)
