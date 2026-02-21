# Inbox Processor Addendum (2026-02-21)

## Source of truth

The deployed repo is:

- `/home/claw/.openclaw/workspace/projects/peptide-site/site`
- Remote: `https://github.com/solson911/peptiderundown.git`

Do not commit changes only in `/home/claw/.openclaw/workspace` or `/home/claw/.openclaw/workspace/projects/peptide-site` (those may be git repos locally but are not the Cloudflare deploy repo).

## Automation

Cron runs:

- `inbox-selfheal.sh` (requeues stuck items)
- `site/scripts/inbox-processor.sh` (real processor: pending HTML -> article+image -> commit/push -> verify -> delete inbox item)

Logs:
- `/tmp/openclaw/inbox-processor.log`
- `/tmp/openclaw/inbox-selfheal.log`
