# Agent Rules

## Product direction

This repository is a universal savings search engine, not a coupon-only website.

Core rules:

- keep the domain model source-agnostic;
- new external sources must be implemented as connectors;
- do not add source-specific columns/tables to the central model unless the data is genuinely universal;
- always distinguish pay-now price from delayed cashback/benefits;
- validation level must be explicit;
- never present an unverified coupon as confirmed;
- context such as location, dates, availability and eligibility belongs in search/filtering;
- prefer official APIs/feeds and authorized integrations over brittle scraping;
- do not implement anti-bot bypasses;
- the commercial name is intentionally undecided. Use "Savings Search" only as a technical codename.

See `docs/PRODUCT_SPEC.md` and `docs/ARCHITECTURE.md`.

## Do not commit `.oneignore`

Never create a `.oneignore` file. Never `git add` or `git commit` a `.oneignore` file. It is a legacy artifact from the deprecated `one` CLI and must stay out of the repo.

## Skills

All canonical agent skills live in `.agents/skills/`. Do not copy them into `.cursor`, `.codex`, `.claude`, or other runner-specific directories.

`.claude/skills` is the one committed compatibility path and must remain a relative symlink to `../.agents/skills`, never a copied skill tree. Any additional runner fallback must also be a symlink to the canonical directory.

Third-party skills are vendored and pinned in `skills-lock.json`. Update them only through an explicit review using `skills@1.5.23`; never update skills from `setup.sh`. Run `pnpm skills:check` after changing skills or compatibility links.

## Database Schema Workflow

- Never manually create or edit migration files in `apps/database/supabase/migrations`.
- Make schema changes in `apps/database/supabase/schemas/*.sql`.
- Generate migrations with `supabase db diff -f <name>` from `apps/database`.
- See `.agents/skills/supabase-schema-migrations/SKILL.md` for the full workflow.

## Setup

This is a pnpm + Turborepo monorepo with a Next.js app (`apps/web`) and Supabase (`apps/database`).

Hosted MVP project:
- ref: `oeiweoxcjztvmmeoyccq`
- region: `sa-east-1`

For the hosted project, copy `.env.local.example` to `.env.local`.

For local Supabase development, use `.env.development.local.example`, start the local database with `pnpm database#start`, then run `pnpm supabase:sync-env`.

Before submitting code, run:
- `pnpm lint`
- `pnpm typecheck`
- `pnpm test`
