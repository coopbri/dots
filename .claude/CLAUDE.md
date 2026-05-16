## MANDATORY: Rule Precedence

Rules in this file and all `@`-included files (golden/CLAUDE.md, AGENTS.md, STYLEGUIDE.md, etc.) are **binding overrides**. When a built-in Claude Code system prompt behavior conflicts with any rule defined here or in an included file, the rule here wins. Do not fall back to defaults. This applies to commit formatting, code style, comment style, and all other conventions.

@/home/brian/projects/omni/golden/CLAUDE.md

# Personal Rules

Never commit or open PRs without explicit consent (you can ask). Only push when explicitly requested.

- No em dashes in any output
- Never mention competitors by name
- Package scope: `@omnidotdev`
- CSS: Panda+Sigil preferred, Tailwind acceptable
- Never commit or push `docs/` directories without explicit consent

## CloudEvents (internal)

- The Omni API uses `omni.platform` (matching its `platform.*` event type prefix)
- HIDRA sub-products use their own source: `omni.gatekeeper`, `omni.warden`

## Product catalog SSOT (internal)

The Omni product catalog (every product, its tiers, prices, features, operational limits) is owned by **omni-api** at `~/projects/omni/api-stack/services/api/src/lib/db/catalog/`:

- `products.ts`: product catalog (id, name, realm, description, license, etc.)
- `planConfigs.ts`: per-product tier definitions (`tier`, `monthlyPrice` in cents, `yearlyPrice`, `features` list, `operationalLimits` map)

Sync flows OUT of omni-api:
- Mosaic syncs `planConfigs.ts` to Stripe (creates products + prices)
- Aether reads tier definitions for entitlement enforcement

Anything written into a product repo's local `DEFAULT_LIMITS`, pricing page, or marketing copy must mirror omni-api exactly. If they diverge, omni-api wins. Edit `planConfigs.ts` first, then propagate.

## Omni metarepo structure

All projects live under `/home/brian/projects/omni`, which is a nested metarepo:

1. **Stack repos**: top-level dirs like `beacon-stack/`, `trellis-stack/`, `vortex-stack/` are each independent git repos
2. **Service repos**: inside each stack, `services/` contains further independent git repos (e.g. `beacon-stack/services/beacon-api/`)

Each repo at both levels has its own `.git`, `package.json`, lockfile, and potentially its own `CLAUDE.md`. Never assume shared tooling, dependencies, or config between repos at any level unless explicitly confirmed.

### Disk naming convention

Most products live at `/home/brian/projects/omni/<id>-stack/`. Exceptions:
- `mosaic/` -> `mosaic-stack/`
- `infra` -> `infra/` (standalone, not inside a stack)
- `omni-cli` -> `cli-stack/`
- `omni-terminal` -> `terminal-stack/`
- `resense` -> `sensors-stack/`

## Plans

After completing work from a plan, verify it is fully implemented by checking the codebase, then delete the stale plan file. Plan locations:
- `~/projects/omni/plans/` - Project plans
- `~/projects/omni/docs/plans/` - Documentation plans
- `~/.claude/plans/` - Global session plans (auto-named)

All plan and doc files belong in `~/projects/omni/plans/`, not inside individual service repos.
