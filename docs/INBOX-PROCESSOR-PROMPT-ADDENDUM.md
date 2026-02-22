# Inbox Processor Addendum (2026-02-21)

## Source of truth

The deployed repo is:

- `/home/claw/.openclaw/workspace/projects/peptide-site/site`
- Remote: `https://github.com/solson911/peptiderundown.git`

Do not commit changes only in `/home/claw/.openclaw/workspace` or `/home/claw/.openclaw/workspace/projects/peptide-site` (those may be git repos locally but are not the Cloudflare deploy repo).

## Automation

Cron runs (currently every 10 minutes):

- `inbox-selfheal.sh` (requeues stuck items)
- `site/scripts/inbox-processor.sh` (real processor: pending HTML -> article+image -> commit/push -> verify -> delete inbox item)

Guardrail:
- Processor fails fast if both `{slug}.md` and `{slug}.astro` exist (route collision). Moves item to `inbox/failed/` with an `*.error.txt` explaining what to fix.

Full documentation:
- `site/docs/AUTO-DEPLOY.md`

Logs:
- `/tmp/openclaw/inbox-processor.log`
- `/tmp/openclaw/inbox-selfheal.log`
