# Auto Deploy (Inbox → Cloudflare)

This doc explains the **automated deployment pipeline** that watches an “inbox”, converts files into published articles, commits to GitHub, and lets Cloudflare deploy.

## Source of truth (what Cloudflare builds)

Cloudflare builds from the git repo at:

- Local: `/home/claw/.openclaw/workspace/projects/peptide-site/site`
- Remote: `https://github.com/solson911/peptiderundown.git`

Anything not committed/pushed to that repo **will not deploy**.

## Trigger: cron

Auto-deploy is triggered by cron (user `claw`). Current schedule:

- Every 10 minutes: `inbox-selfheal.sh`
- Every 10 minutes: `site/scripts/inbox-processor.sh`

View/edit with:

```bash
crontab -l
crontab -e
```

## Inbox directories

The inbox lives outside the deploy repo:

- Root: `/home/claw/.openclaw/workspace/projects/peptide-site/inbox`
- Pending: `inbox/pending/*.html` (work queue)
- Processing: `inbox/processing/` (in-flight)
- Failed: `inbox/failed/` (needs manual attention)

### What you drop into the inbox

Drop an **HTML file** into `inbox/pending/`.

- Filename (minus `.html`) becomes the **slug**.
  - Example: `performance-stack-cjc1295-ipamorelin-bpc157.html` → slug `performance-stack-cjc1295-ipamorelin-bpc157`

## The processor script

Main automation script:

- `/home/claw/.openclaw/workspace/projects/peptide-site/site/scripts/inbox-processor.sh`

High-level flow per file:

1. Move `pending/*.html` → `processing/`
2. Detect whether the HTML includes SVG (`<svg ...>`)
3. Convert HTML → published article in `site/src/pages/articles/`:
   - If SVG present → writes `{slug}.astro` (rich article)
   - Else → writes `{slug}.md` (standard markdown article)
4. Remove the opposite extension to avoid duplicates
   - If writing `.astro`, remove `{slug}.md`
   - If writing `.md`, remove `{slug}.astro`
5. **Image handling**
   - If updating an existing article, reuse its existing `image:` path
   - If the referenced image does not exist, generate one
6. Build locally: `npm run build`
7. Git commit + push to GitHub (Cloudflare deploys from that)
8. Verify deployment: `../scripts/verify-deploy.sh {slug}`
9. Delete the inbox HTML from `processing/`

## Update vs New behavior (expected)

### Workflow 1 — new article
- Drop `slug.html`
- Processor generates article + image (if missing)
- Commit + push
- Cloudflare deploys new route

### Workflow 2 — updated article (replace)
- Drop `slug.html` with the *same slug*
- Processor overwrites the article file and commits the change
- Processor reuses the existing hero image (unless it’s missing)
- Commit + push
- Cloudflare deploys updated content at the same URL

## Guardrails (important)

### Route collision protection

If both of these exist at the same time:

- `site/src/pages/articles/{slug}.md`
- `site/src/pages/articles/{slug}.astro`

…Astro can serve the wrong one (looks like “deploy succeeded” but old content renders).

The processor now **fails fast** if it detects this state:

- Moves the inbox item to `inbox/failed/`
- Writes `inbox/failed/{slug}.error.txt` explaining what to fix

Fix by deleting one of the two files (choose the intended source of truth), then requeue the HTML.

## Logs

- Processor: `/tmp/openclaw/inbox-processor.log`
- Selfheal: `/tmp/openclaw/inbox-selfheal.log`

## Manual runbook

### Run the processor once (debug)

```bash
/home/claw/.openclaw/workspace/projects/peptide-site/site/scripts/inbox-processor.sh
```

### Verify a specific slug is live

```bash
/home/claw/.openclaw/workspace/projects/peptide-site/scripts/verify-deploy.sh {slug}
```

### If an item lands in failed/

1. Open the error text: `inbox/failed/{slug}.error.txt`
2. Fix the issue in the deploy repo (`site/src/pages/articles/`)
3. Move the HTML back to pending:

```bash
mv inbox/failed/{slug}.html inbox/pending/
```

## Related docs

- `FILE-LOCATIONS.md` (single source of truth for where content lives)
- `docs/INBOX-PROCESSOR-PROMPT-ADDENDUM.md` (quick notes)
