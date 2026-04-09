# PeptideRundown Content Pipeline

This directory holds the process docs for writing and deploying articles to peptiderundown.com. The companion deploy-time scripts live in `tools/` at the repo root.

## Read these in order

1. **`PIPELINE.md`** — high-level architecture. Who does what (orchestrator vs. Claude Code), the orchestrator/writer contract, success/retry/abort signals.
2. **`ARTICLE-DISPATCH-PROMPT.md`** — the exact prompt the orchestrator fills in and sends to Claude Code. This is the writer's contract: required visual components, formatting rules, deployment steps, and the pre-deploy gate.
3. **`ASTRO-ARTICLE-TEMPLATE.md`** — the canonical `.astro` file structure: frontmatter, full CSS design system to copy verbatim, HTML component reference, recommended section order, and the `<Base>` wrapper.
4. **`STYLE-GUIDE.md`** — prose-level rules (banned words, sentence style, tone) that apply *inside* the article body.
5. **`IMAGE-DISPATCH-PROMPT.md`** — guidance for hero image prompts (abstract style, content-filter avoidance).

## Hard rules

- **Claude Code (Opus 4.6) is the only component allowed to write article content.** The openclaw orchestrator (which may run grok-fast or any lightweight model) is strictly an orchestrator. See `PIPELINE.md` "Hard Rule: Who Writes Content."
- **All new articles are `.astro`**, never `.md`. The `.md` format is deprecated and any new `.md` article will look broken next to peers.
- **`tools/pre-deploy.sh` is the single hard gate before commit.** It runs the image guard and a full Astro build. If it fails, do not push.
- **Do not chain commands with `&&` when calling `tools/gen-image.py`** or other interpreters. The openclaw exec sandbox rejects chained interpreter invocations.

## Tools (at repo root, not in this directory)

- `tools/gen-image.py` — hero image generator (OpenRouter / Gemini 3 Pro Image, ~$0.14/image)
- `tools/pre-deploy.sh` — image guard + Astro build gate (the only required pre-push check)
- `tools/check-article-images.sh` — standalone image guard (also called by `pre-deploy.sh`)
- `tools/verify-deploy.sh` — post-push live-URL verification
