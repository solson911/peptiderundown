# PeptideRundown Content Pipeline

## Architecture Overview

```
openclaw orchestrator (any model, e.g. grok-fast)
    │  -- ORCHESTRATION ONLY, never writes article content --
    │
    ├──> Claude Code CLI (Opus 4.6)  -- ALL content creation lives here --
    │       ├── Reads ASTRO-ARTICLE-TEMPLATE.md + reference .astro
    │       ├── Writes site/src/pages/articles/{slug}.astro
    │       ├── Calls gen-image.py (separate exec, no &&)
    │       ├── Runs scripts/pre-deploy.sh (image guard + astro build)
    │       └── git add / commit / push (separate exec calls)
    │
    └── Deploy — git push triggers Cloudflare auto-deploy
```

## Hard Rule: Who Writes Content

**Claude Code (Opus 4.6) is the ONLY component allowed to author article content.** This is non-negotiable. The Astro design system, banned-word discipline, PubMed citation handling, template-literal escaping, and component-class accuracy all require Opus-level reliability. Weaker models produce articles that look broken next to peers and routinely violate the style guide.

**The openclaw orchestrator's job is strictly orchestration**, never authorship. The orchestrator may run on any model (grok-fast is fine for cost reasons) because its tasks are mechanical:

| Orchestrator does | Orchestrator does NOT do |
|---|---|
| Picks topic from `TOPIC-BACKLOG.md` | Write article body |
| Fills `{{VARS}}` in `ARTICLE-DISPATCH-PROMPT.md` | Write CSS, HTML, frontmatter |
| Invokes Claude Code CLI with the filled dispatch | Generate images |
| Parses Claude Code's exit status and final message | Run git commands directly |
| Retries Claude Code on failure (up to 2x) | Edit `.astro` files |
| Updates `TOPIC-BACKLOG.md` after success | Make judgment calls about content |
| Logs the run to `memory/YYYY-MM-DD.md` | Skip the pre-deploy gate |

If the orchestrator ever finds itself writing prose, editing markup, or running `gen-image.py` directly, it has stepped outside its role. Stop and hand the task back to Claude Code.

### Orchestrator → Claude Code Contract

The orchestrator invokes Claude Code via CLI with a single prompt: the fully-filled `ARTICLE-DISPATCH-PROMPT.md`. Claude Code is responsible for executing every step in that dispatch (read template, write `.astro`, generate image, run pre-deploy gate, commit, push, verify). The orchestrator only watches for completion.

**Success signal:** Claude Code's final message contains a verified deploy URL AND `pre-deploy.sh` exit code 0 was reported.
**Retry signal:** Claude Code reports a recoverable error (image filter rejection, transient network issue). Retry once with the same dispatch.
**Abort signal:** `pre-deploy.sh` failed twice in a row, OR Claude Code reports it cannot resolve the issue. Log to `memory/` and stop. Do not push.

> **Architecture v4 (2026-04-08):** Content authorship is locked to Claude Code (Opus 4.6). Orchestration is decoupled and may run on any model. This replaces v3's "all agents run on Opus" assumption.
> Fallback writer model: none. If Opus is unavailable, the run aborts.

### Cost Profile
- All agents: $0/token (Claude Max flat subscription)
- Image Gen (gen-image.py): ~$0.14/image (Gemini 3 Pro) or $0.04 (Flash)
- Fallback (Kimi K2.5): Minimal OpenRouter credits

## Pipeline Steps

### Step 1: Plan Batch (Director — Opus)
1. Check `TOPIC-BACKLOG.md` for ready topics
2. Pick 3-5 topics per batch
3. Fill in dispatch template variables for each
4. Spawn writer sub-agents (parallel, label: `write-{slug}`)

### Step 2: Write Articles (Workers — Opus 4.6)
- Each worker gets `ARTICLE-DISPATCH-PROMPT.md` filled with topic details
- **Workers save to: `site/src/pages/articles/{slug}.astro`** (NOT `.md`)
- The `.astro` format is the canonical visual standard. It embeds the custom CSS design system (gradient hero, stat strips, callout boxes, color-coded cards, styled tables, grids, FAQ accordion). See `ASTRO-ARTICLE-TEMPLATE.md` for the full template.
- The `.md` format is deprecated. Any new `.md` article will look broken next to the rest of the site.
- Model: `anthropic/claude-opus-4-6` (fallback: `openrouter/moonshotai/kimi-k2.5`)

### Step 3: Cleanup + Fix (Cleanup Agent — Opus 4.6)
- Spawned after ALL writers complete
- Gets `CLEANUP-DISPATCH-PROMPT.md` with list of new article slugs
- ACTIVELY FIXES all issues (not just reporting):
  - Replaces banned words with approved alternatives
  - Fixes em dashes, numbered lists, formatting
  - Validates frontmatter (adds missing fields)
  - Syncs pages → content versions (removes layout line)
- Commits and pushes fixes
- Label: `cleanup-batch-{date}`

### Step 4: Generate Images (gen-image.py script)
- Run gen-image.py directly (one exec call per image, no agent needed)
  ```
  python3 gen-image.py --slug SLUG --prompt "PROMPT"
  ```
- Model: google/gemini-3-pro-image-preview (~$0.14/image)
- Budget model: google/gemini-2.5-flash-image (~$0.04/image)
- Saves to `site/public/images/articles/{slug}.webp`

### Step 5: Deploy
- Runs AUDIT-SCRIPT.sh for sanity check
- Git add, commit, push — auto-deploys to Cloudflare

### Step 6: Bookkeeping (Director — Opus, BRIEF)
- Update `TOPIC-BACKLOG.md` (move topics to Completed)
- One-line log in `memory/YYYY-MM-DD.md`
- This should be ~100 tokens max

## Dispatch Commands (Quick Reference)

### Spawn a Writer
```
sessions_spawn(
  task: "<filled ARTICLE-DISPATCH-PROMPT>",
  label: "write-{slug}"
)
```
Model defaults to Opus 4.6 (configured in agent defaults).

### Spawn Cleanup Agent
```
sessions_spawn(
  task: "<filled CLEANUP-DISPATCH-PROMPT>",
  label: "cleanup-batch-{date}"
)
```

## Known Gotchas

### Image Content Filters
Image generation APIs filter medical/clinical imagery. Use abstract descriptions:
- ❌ "injection needle going into belly fat"
- ✅ "abstract molecular structure with warm orange gradient, scientific aesthetic, no text"

## File Locations
- **Article dispatch template:** `ARTICLE-DISPATCH-PROMPT.md`
- **Proofreader dispatch template:** `PROOFREADER-DISPATCH-PROMPT.md`
- **Image dispatch template:** `IMAGE-DISPATCH-PROMPT.md`
- **Style guide:** `STYLE-GUIDE.md`
- **Topic backlog:** `TOPIC-BACKLOG.md`
- **Audit script:** `AUDIT-SCRIPT.sh`
- **Published articles:** `site/src/pages/articles/{slug}.astro` (canonical, `.md` deprecated)
- **Images:** `site/public/images/articles/`

## Maintenance Notes
- Run `AUDIT-SCRIPT.sh` weekly to catch drift
- Review `TOPIC-BACKLOG.md` and add fresh ideas regularly
- Update this file when pipeline changes — future Nix depends on it
