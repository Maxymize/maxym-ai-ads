# Maxymize ADS — SaaS Handoff Document

> **Purpose**: this document is the complete, self-contained handoff for spinning up **Maxymize ADS**, a web-based SaaS that wraps the `maxym-ai-ads` engine and sells it as a service to non-technical users (founders, marketers, small agencies). Target folder: `/Users/maximiliangiurastante/Sviluppo/Claude/maxymize-ads/`.
>
> **Status**: pre-MVP. Nothing has been built yet for the SaaS. The engine (`maxym-ai-ads`) is complete at v1.0.04 and publicly available at https://github.com/Maxymize/maxym-ai-ads.
>
> **Audience**: future-you (or a co-founder / contractor) starting the project in the next days/weeks/months.

---

## Table of contents

1. [Executive summary](#1-executive-summary)
2. [Relation with maxym-ai-ads](#2-relation-with-maxym-ai-ads)
3. [Tech stack](#3-tech-stack)
4. [Architecture](#4-architecture)
5. [Database schema (preliminary)](#5-database-schema-preliminary)
6. [API costs breakdown](#6-api-costs-breakdown)
7. [MVP feature set vs roadmap](#7-mvp-feature-set-vs-roadmap)
8. [Pricing & unit economics](#8-pricing--unit-economics)
9. [Risks & mitigations](#9-risks--mitigations)
10. [Operational plan](#10-operational-plan)
11. [First-two-weeks checklist](#11-first-two-weeks-checklist)

---

## 1. Executive summary

### What we're building

**Maxymize ADS** is a web SaaS that delivers, through a browser interface, everything the `maxym-ai-ads` Claude Code plugin does today — but for users who don't code, don't know Claude Code, and just want outcomes.

The user:
1. Signs up on `maxymize.ads` (or whatever the final domain is)
2. Connects their ad accounts (Meta, Google Ads) via OAuth
3. Runs the **guided blueprint** via a web wizard (same 11 questions, same 5 phases)
4. Gets all deliverables (PDF, interactive HTML, checklist) in their dashboard
5. Launches campaigns using the platform's step-by-step execution companion
6. Pastes metrics / CSVs / exports for bi-weekly audits, which apply the 3× Kill Rule, 20% Scaling Rule, and creative fatigue detection automatically

**The web app is a wrapper around the same LLM engine** that powers the CLI plugin today, exposed through a beautiful UI with account integrations, billing, and collaboration features.

### Positioning

Not another ad automation tool like Madgicx or Revealbot. **A paid-ads strategist on demand, as a service.** The user never needs to know what CPC or ROAS means — the platform adapts its output to their experience level (beginner / intermediate / expert) and walks them through both strategy and execution.

### Target customer

Primary ICP at launch:

- **Solopreneur / indie SaaS founder** running their first paid campaigns ($500-$3k/mo budget)
- **E-commerce store owner** who wants structured ad strategy without hiring an agency
- **Small marketing freelancer** who wants leverage for 3-5 clients

Secondary ICP (v2):

- **Small agency (2-5 people)** using Maxymize ADS as their delivery backbone
- **In-house marketer** in a growing SMB who needs a second opinion / audit

### Brand connection

- Part of the **maxym.ai** family (main site being built separately by you)
- Maxymize ADS is the "advertising agency-in-a-box" service within the broader maxym.ai ecosystem
- Positioned either as a standalone product or as a service tile on maxym.ai

### Provisional pricing (4 tiers)

| Plan | Price | Target |
|---|---:|---|
| **Free** | €0/mo | Blueprint demo (Phase 0 + sample of Phase 1), no account connections, lead magnet |
| **Starter** | €49/mo | Solopreneurs, 1 brand, 1 blueprint/mo, Meta + Google, weekly audit |
| **Pro** | €149/mo | Founders with 1-3 brands, 3 blueprints/mo, all platforms, bi-weekly audit |
| **Agency** | €399/mo | Small agencies, unlimited blueprints, white-label PDF, 10 workspaces, 10 users |

Validate pricing during pre-launch call campaign (see [§10](#10-operational-plan)).

### Revenue target

- Year 1 post-launch: **50-150 paying customers** = €6k-€22k MRR
- Year 2: **200-400 customers** = €25k-€55k MRR
- Year 3: **500-1000 customers** + enterprise deals = €80k-€200k MRR

---

## 2. Relation with maxym-ai-ads

### The architectural split

```
┌─────────────────────────────────────────────────────────────┐
│  maxym-ai-ads (THIS REPO — kept open-source, MIT)           │
│  https://github.com/Maxymize/maxym-ai-ads                   │
│                                                             │
│  • 32 SKILL.md files (the prompts + methodology)            │
│  • 15 subagent definitions                                  │
│  • 25 RAG reference files (benchmarks, specs, compliance)   │
│  • 11 industry templates                                    │
│  • 2 HTML templates (blueprint report + execution dashboard)│
│  • Python helper scripts (PDF generation)                   │
│  • Docs (README, BLUEPRINT-ZERO-TO-SALES.md)                │
│                                                             │
│  Purpose: THE ENGINE. The reusable, open-source methodology │
│  that any Claude Code user can install and run locally.     │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  │ The SaaS imports/references these files
                  │ as agent system prompts.
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│  maxymize-ads (NEW REPO — proprietary, closed)              │
│  Target: /Users/maximiliangiurastante/Sviluppo/Claude/      │
│          maxymize-ads/                                      │
│                                                             │
│  • Next.js frontend (user dashboard, wizard, settings)      │
│  • API routes (auth, workspace, billing, jobs)              │
│  • BullMQ workers (run Claude Agent SDK)                    │
│  • OAuth integrations (Meta, Google Ads, LinkedIn, ...)     │
│  • Stripe billing                                           │
│  • Postgres schema (users, workspaces, projects, audits)    │
│  • Rendering pipelines (PDF, HTML, email notifications)     │
│  • Copies of the SKILL.md files as system prompts           │
│                                                             │
│  Purpose: THE WRAPPER. The paid, multi-tenant web service   │
│  that turns the engine into a SaaS experience.              │
└─────────────────────────────────────────────────────────────┘
```

### What the SaaS ports from maxym-ai-ads

| From maxym-ai-ads | To maxymize-ads | How |
|---|---|---|
| `skills/*/SKILL.md` | `src/agents/prompts/` | Git submodule OR periodic sync via script |
| `skills/ads/references/*.md` | `src/agents/references/` | Same (static assets) |
| `skills/ads-plan/assets/*.md` | `src/agents/industry-templates/` | Same |
| `skills/ads-blueprint/assets/report-template.html` | `src/templates/blueprint-report.html` | Copy, extend with branding |
| `skills/ads-blueprint-execution/assets/live-dashboard-template.html` | `src/templates/execution-dashboard.html` | Copy |
| `scripts/generate_ads_pdf.py`, `generate_report.py` | `src/rendering/pdf/` | Port to Node.js or keep as Python microservice |
| 11 SKILL routing logic | Inngest / BullMQ workflow orchestration | Each SKILL.md becomes a workflow step |

**Key decision**: should maxym-ai-ads be a **Git submodule** of maxymize-ads, or a **sync-on-release** mechanism?

- **Git submodule** (recommended): maxymize-ads includes maxym-ai-ads at a pinned commit. Updates happen on explicit bumps. Pro: clean separation. Con: minor submodule UX friction.
- **Copy + sync script**: `npm run sync-engine` copies files from the open-source repo to `src/agents/prompts/`. Pro: zero submodule complexity. Con: easier to drift.

Both work. Start with submodule for discipline.

### What stays ONLY in maxym-ai-ads (open-source)

- Install scripts (`install.sh`, `install.ps1`) — irrelevant for SaaS
- `.claude-plugin/plugin.json` + `marketplace.json` — only for CLI distribution
- CLI-specific documentation (NOTICES.md, INTEGRITY.md at current form)

### What stays ONLY in maxymize-ads (closed-source)

- All frontend code (Next.js)
- API routes, auth logic
- Database migrations
- Business logic (billing, workspaces, RBAC)
- OAuth token handling
- Anthropic API key, Stripe secret, all credentials
- Custom branding, landing page copy

### The licensing gotcha

`maxym-ai-ads` is MIT-licensed. You can use it in a commercial SaaS without any obligation beyond attribution. `NOTICES.md` in the open-source repo already handles upstream attribution.

**The SaaS repo can be fully proprietary.** You just need to include the MIT license + NOTICES.md content somewhere (e.g. in the web app's `/legal/credits` page).

---

## 3. Tech stack

### Chosen stack (Railway-centric, one-provider simplicity)

Based on the conversations that led to this document, and your preference for Railway + one-provider simplicity with minimal ops overhead:

```
Hosting & compute:     Railway (frontend + worker + DB + Redis in one project)
Frontend:              Next.js 15 (App Router) + shadcn/ui + Tailwind
Backend API:           Next.js API routes + tRPC or REST
Database:              Railway Postgres (1-click addon, private networking)
Queue & cache:         Railway Redis (1-click addon)
Background workflow:   BullMQ (Node.js, self-hosted on worker service)
Agent engine:          @anthropic-ai/claude-agent-sdk (Node.js library)
Auth:                  Stack Auth (works with Next.js + Postgres, has plugin skill)
Payments:              Stripe (has `stripe-code-exec` skill)
Email transactional:   Resend
Monitoring:            Sentry (has `sentry-code-exec` skill)
Analytics:             PostHog (has plugin skill)
File storage:          Railway Volume OR Cloudflare R2 (for generated PDFs, CSVs)
CDN + WAF:             Cloudflare (free tier in front of Railway)
```

### Why Railway over Vercel for this project

| Factor | Railway | Vercel |
|---|---|---|
| Agent execution timeout | **Unlimited** (always-on container) | 5-15 min hard limit |
| Single-provider simplicity | **Yes** (compute + DB + Redis) | Needs external DB + external queue |
| Cost at MVP scale | ~$20-65/mo total | ~$40-100/mo (+ Inngest/external Postgres) |
| Latency DB ↔ app | <1ms (private network) | 20-50ms (external providers) |
| Dev experience | Good (container-based) | Excellent (serverless-first) |
| Scaling | Manual / autoscale configurable | Automatic |

**Verdict**: Railway for this case because long-running agent workflows (ads-blueprint full run = 15-30 min) break Vercel's function timeouts. Railway's always-on containers eliminate this entirely.

### Agent SDK choice

**Claude Agent SDK** (NPM: `@anthropic-ai/claude-agent-sdk`).

Reasons:
- Direct porting of existing SKILL.md files (zero rewrite)
- Native parallel subagent support (for ads-strategy's 5-agent fan-out)
- Built-in tool calling, prompt caching, skill loading
- Conceptually identical to how Claude Code runs the skills today

**Runs where?** In the Node.js container of the Railway "worker" service. Not a daemon, not a separate service — just a library imported in your worker code. Communicates with `api.anthropic.com` via HTTPS.

### Python alternative (if preferred)

If, at any point, Python becomes preferable (e.g. heavy data analysis, LangChain/DSPy integration):

- Backend: FastAPI
- Queue: Celery + Redis
- Agent SDK: `claude-agent-sdk` (Python pip package)
- Frontend stays Next.js (runs separately)

Not recommended unless there's a concrete Python-only requirement. End-to-end TypeScript is cleaner.

### Image & video generation

- **Images**: Gemini 3 Flash Image (via `nanobanana-image-code-exec` skill pattern) as default. OpenAI gpt-image-1 or FLUX.1 Pro as premium.
- **Video**: Optional, Pro+ only. ByteDance Seedance 2.0 (economic) or Google Veo 3.1 (premium). Can be deferred to v2.

### External scraping

- **Firecrawl** or **Scrapling** API for competitor scraping
- **SerpAPI** or **DataForSEO** for keyword research
- **Playwright Cloud** or **BrowserBase** for screenshot capture

These keep costs variable and quality high. Scraping is hard to self-host reliably.

---

## 4. Architecture

### System diagram

```
┌──────────────────────────────────────────────────────────────────────┐
│                       User (browser)                                 │
│    Landing (maxymize.ads) → Signup → Dashboard → Wizard → Reports    │
└───────────────────┬──────────────────────────────────────────────────┘
                    │  HTTPS + WebSocket/SSE for live updates
                    ▼
┌──────────────────────────────────────────────────────────────────────┐
│                 Cloudflare (DNS + CDN + WAF)                         │
└───────────────────┬──────────────────────────────────────────────────┘
                    │
                    ▼
┌──────────────────────────────────────────────────────────────────────┐
│                   Railway project: maxymize-ads                      │
│                                                                      │
│   ┌────────────────────────────────────────────────────────────┐     │
│   │  Service 1: Next.js (frontend + API routes)                │     │
│   │  - User UI, wizard, dashboard                              │     │
│   │  - Auth (Stack Auth) middleware                            │     │
│   │  - tRPC/REST API endpoints                                 │     │
│   │  - Stripe webhook handler                                  │     │
│   │  - OAuth callbacks (Meta, Google)                          │     │
│   │  - Enqueues jobs → Redis                                   │     │
│   └────────────────────────────────────────────────────────────┘     │
│                                                                      │
│   ┌────────────────────────────────────────────────────────────┐     │
│   │  Service 2: Worker (Node.js)                               │     │
│   │  - BullMQ consumer                                         │     │
│   │  - Imports Claude Agent SDK                                │     │
│   │  - Loads SKILL.md files as agent system prompts            │     │
│   │  - Executes agent workflows (blueprint, execution, audit)  │     │
│   │  - Writes results back to Postgres                         │     │
│   │  - Fires WebSocket notifications via Redis pub/sub         │     │
│   │  - Can scale to 2-3 instances under load                   │     │
│   └────────────────────────────────────────────────────────────┘     │
│                                                                      │
│   ┌────────────────────────────────────────────────────────────┐     │
│   │  Addon: Railway Postgres                                   │     │
│   │  - Users, workspaces, projects, audits, campaigns          │     │
│   │  - Agent run logs, cost tracking                           │     │
│   │  - pgvector for future semantic search on past audits      │     │
│   └────────────────────────────────────────────────────────────┘     │
│                                                                      │
│   ┌────────────────────────────────────────────────────────────┐     │
│   │  Addon: Railway Redis                                      │     │
│   │  - BullMQ queues (one per job type)                        │     │
│   │  - Session cache, rate limits                              │     │
│   │  - Pub/sub for live updates                                │     │
│   └────────────────────────────────────────────────────────────┘     │
│                                                                      │
└────────────┬─────────────────────────────────────────────────────────┘
             │
    ┌────────┼────────────────────────┬──────────────────────┐
    │        │                        │                      │
    ▼        ▼                        ▼                      ▼
┌────────┐ ┌──────────┐  ┌──────────────────────┐  ┌──────────────────┐
│Stripe  │ │Resend    │  │ Anthropic API        │  │ Meta / Google    │
│Billing │ │Email     │  │ (Claude models)      │  │ Ads APIs         │
└────────┘ └──────────┘  └──────────────────────┘  └──────────────────┘
                          ┌──────────────────────┐  ┌──────────────────┐
                          │ Gemini 3 Flash Image │  │ Firecrawl /      │
                          │ (image generation)   │  │ SerpAPI          │
                          └──────────────────────┘  └──────────────────┘
```

### Data flow: "User runs a Blueprint"

1. **User on dashboard** clicks "New Blueprint"
2. Frontend shows **multi-step wizard** (11 questions, one per screen, with progress bar)
3. On submit, frontend calls `POST /api/blueprint/start` with user answers
4. API route:
   - Validates input (Zod)
   - Checks user's plan quota (e.g. Starter = 1 blueprint/month)
   - Inserts `blueprint_projects` row with `status='queued'`
   - Enqueues BullMQ job `{ projectId, userId, intake }` on queue `blueprint-jobs`
   - Returns `{ projectId, status: 'queued' }` to client
5. Frontend opens **WebSocket or SSE** to `/api/projects/:id/live` for real-time updates
6. **Worker service** picks up the job:
   - Updates `blueprint_projects.status = 'running'`
   - Publishes Redis event `project:123:phase_0:started`
   - Loads `skills/ads-blueprint/SKILL.md` as system prompt
   - Instantiates Claude Agent SDK session
   - Runs Phase 0 (ads-quick) → writes score to DB → publishes `phase_0:completed`
   - If score ≥ 60 → runs Phase 1 (5 parallel agents via `Promise.all()` + `agent.spawn()`)
   - ... proceeds through all 5 phases
   - Renders final PDF + HTML report → uploads to Cloudflare R2 → stores URLs in DB
   - Updates `status = 'completed'`
   - Sends email notification via Resend
7. **Frontend** receives WebSocket events, updates the dashboard live:
   - Progress bar fills phase by phase
   - "Download PDF" button appears when ready
   - Deliverables shown inline

### Agent workflow abstraction

Each SKILL.md becomes a **workflow function** in the worker:

```ts
// workers/blueprint-worker.ts
import { Worker } from 'bullmq'
import { Agent } from '@anthropic-ai/claude-agent-sdk'
import fs from 'fs'

const blueprintSkill = fs.readFileSync('src/agents/prompts/ads-blueprint/SKILL.md', 'utf8')

new Worker('blueprint-jobs', async (job) => {
  const { projectId, intake } = job.data
  const agent = new Agent({
    apiKey: process.env.ANTHROPIC_API_KEY!,
    model: 'claude-sonnet-4-6',
    systemPrompt: blueprintSkill,
    tools: [
      webFetchTool,
      dbReadTool(projectId),
      dbWriteTool(projectId),
      publishEventTool(projectId),
    ],
    maxTurns: 50,
  })

  const result = await agent.run({
    userMessage: `Start blueprint. Intake: ${JSON.stringify(intake)}`,
  })

  return result
})
```

Custom tools replace file I/O with DB I/O:

- `Read` (file) → `dbRead` (DB row)
- `Write` (file) → `dbWrite` (DB row + event publish for UI)
- `WebFetch` → unchanged
- `Task` (sub-agent) → `agent.spawn()` or `Promise.all()` for parallel

### Resume & state persistence

The `ADS-BLUEPRINT-STATE.json` concept becomes a `blueprint_projects.state` JSONB column. `--resume` logic becomes "continue from `current_phase` if `status != 'completed'`".

---

## 5. Database schema (preliminary)

Postgres, with Drizzle ORM recommended for type-safety. This is a **starter schema** — expect to iterate.

### Core tables

```sql
-- Users (Stack Auth handles auth, this is app-level data)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stack_auth_id TEXT UNIQUE NOT NULL,         -- external auth ID
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workspaces (for team/agency use cases; free users have 1 default workspace)
CREATE TABLE workspaces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
  plan TEXT NOT NULL DEFAULT 'free',          -- 'free' | 'starter' | 'pro' | 'agency'
  stripe_customer_id TEXT,
  stripe_subscription_id TEXT,
  subscription_status TEXT,                   -- 'active' | 'trialing' | 'past_due' | 'canceled'
  current_period_end TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workspace members (many-to-many)
CREATE TABLE workspace_members (
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role TEXT NOT NULL,                         -- 'owner' | 'admin' | 'member' | 'viewer'
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (workspace_id, user_id)
);

-- Connected ad accounts (OAuth tokens)
CREATE TABLE ad_account_connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  platform TEXT NOT NULL,                     -- 'meta' | 'google_ads' | 'linkedin' | 'tiktok' | 'microsoft' | 'apple'
  external_account_id TEXT NOT NULL,
  account_name TEXT,
  access_token TEXT,                          -- encrypted at rest
  refresh_token TEXT,                         -- encrypted at rest
  token_expires_at TIMESTAMPTZ,
  scopes TEXT[],
  is_active BOOLEAN DEFAULT TRUE,
  connected_at TIMESTAMPTZ DEFAULT NOW()
);

-- Blueprint projects (one per full /ads blueprint run)
CREATE TABLE blueprint_projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  created_by UUID REFERENCES users(id),
  name TEXT NOT NULL,                         -- "LeavePilot-Launch-May2026"
  url TEXT NOT NULL,                          -- source URL analyzed
  intake JSONB NOT NULL,                      -- the 11 answers
  experience_level TEXT,                      -- 'beginner' | 'intermediate' | 'expert'
  status TEXT NOT NULL DEFAULT 'queued',      -- 'queued' | 'running' | 'paused' | 'blocked' | 'completed' | 'failed'
  current_phase INT DEFAULT 0,
  state JSONB DEFAULT '{}',                   -- full phase results (phase_0, phase_1, ...)
  score INT,                                  -- final composite Ad Readiness score
  pdf_url TEXT,
  html_url TEXT,
  checklist_url TEXT,
  total_tokens_used INT DEFAULT 0,            -- cost tracking
  total_cost_usd NUMERIC(10,4) DEFAULT 0,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Execution projects (the /ads blueprint-execution companion)
CREATE TABLE execution_projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blueprint_project_id UUID REFERENCES blueprint_projects(id) ON DELETE CASCADE,
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  current_stage TEXT NOT NULL DEFAULT 'gate_check',
  state JSONB DEFAULT '{}',                   -- 6 stages of execution
  live_dashboard_url TEXT,
  launched_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Audits (bi-weekly optimization check)
CREATE TABLE audits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  execution_project_id UUID REFERENCES execution_projects(id) ON DELETE CASCADE,
  audit_type TEXT NOT NULL,                   -- 'scheduled' | 'on_demand'
  source TEXT NOT NULL,                       -- 'paste' | 'csv' | 'api' | 'screenshot'
  raw_data JSONB NOT NULL,                    -- what the user pasted / uploaded
  parsed_metrics JSONB,                       -- normalized metrics
  decisions JSONB NOT NULL,                   -- kill/scale/refresh/hold per ad set
  next_audit_due TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Agent runs (log of every Claude API call, for cost tracking + debugging)
CREATE TABLE agent_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id),
  project_id UUID,                            -- references blueprint_projects or execution_projects
  project_type TEXT,                          -- 'blueprint' | 'execution' | 'audit' | 'quick' | ...
  skill_name TEXT NOT NULL,                   -- 'ads-blueprint' | 'ads-quick' | ...
  model_used TEXT NOT NULL,                   -- 'claude-sonnet-4-6'
  input_tokens INT,
  output_tokens INT,
  cached_tokens INT,
  cost_usd NUMERIC(10,6),
  duration_ms INT,
  status TEXT,                                -- 'success' | 'error' | 'timeout'
  error_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Usage quotas (per workspace, reset monthly)
CREATE TABLE usage_quotas (
  workspace_id UUID PRIMARY KEY REFERENCES workspaces(id),
  month TEXT NOT NULL,                        -- '2026-05'
  blueprints_used INT DEFAULT 0,
  audits_used INT DEFAULT 0,
  images_generated INT DEFAULT 0,
  total_cost_usd NUMERIC(10,4) DEFAULT 0,
  reset_at TIMESTAMPTZ NOT NULL
);

-- Scheduled jobs (for bi-weekly audits, email reminders, etc.)
CREATE TABLE scheduled_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  job_type TEXT NOT NULL,                     -- 'biweekly_audit' | 'creative_fatigue_check' | ...
  target_id UUID,                             -- execution_project_id typically
  run_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  last_run_at TIMESTAMPTZ,
  last_result JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Indexes to add

```sql
CREATE INDEX idx_blueprint_projects_workspace ON blueprint_projects(workspace_id, status);
CREATE INDEX idx_audits_execution_project ON audits(execution_project_id, created_at DESC);
CREATE INDEX idx_agent_runs_cost_tracking ON agent_runs(workspace_id, created_at DESC);
CREATE INDEX idx_scheduled_jobs_due ON scheduled_jobs(run_at, status) WHERE status = 'pending';
```

Expect to add more as usage patterns emerge.

---

## 6. API costs breakdown

### Per-user costs (monthly, typical usage)

| Resource | Starter user | Pro user | Agency user |
|---|---:|---:|---:|
| **Claude API** (blueprint + audits) | €2.50 | €6.00 | €15.00 |
| **Gemini 3 Flash Image** (creative) | €0.60 | €2.00 | €10.00 |
| **Seedance 2.0** (video, Pro+) | €0 | €7-18 | €24-60 |
| **Firecrawl/Scrapling** (competitor scraping) | €1 | €2 | €5 |
| **SerpAPI** (keywords) | €0.50 | €1.50 | €4 |
| **Email (Resend)** | €0.05 | €0.15 | €0.40 |
| **Total variable cost/user** | **€4.65** | **€18.65** | **€34.40 – €94.40** |

### Fixed infrastructure (per month, independent of users at MVP scale)

| Service | Cost |
|---|---:|
| Railway (Next.js + worker + Postgres + Redis) | €20-60 |
| Stack Auth or Clerk | €0-25 (free tier covers MVP) |
| Sentry | €0-29 (free 5k errors/mo) |
| PostHog | €0-50 (free 1M events/mo) |
| Resend base | €0-20 (free 3k emails/mo) |
| Cloudflare R2 storage | €0-10 |
| Cloudflare DNS + CDN | €0 (free) |
| Domain + misc | €10 |
| **Total fixed** | **€30-200** |

### Scenario: 100 paying customers

Assumption: 50 Starter, 40 Pro, 10 Agency.

| Item | Monthly cost |
|---|---:|
| Starter variable (50 × €4.65) | €232 |
| Pro variable (40 × €18.65) | €746 |
| Agency variable (10 × €64 avg) | €640 |
| Fixed infrastructure | €150 |
| Stripe fees (2.9% + €0.30) | ~€550 |
| **Total operational cost** | **€2.318** |
| **Revenue (50×49 + 40×149 + 10×399)** | **€12.420** |
| **Gross margin** | **~81%** |

Very healthy. Break-even on fixed costs at ~8-10 customers. Real profitability kicks in around 30-50 customers.

### Prompt caching is critical

Claude prompt caching can reduce input token costs by 90%. The 25 reference files, 11 industry templates, and brand-profile.json should be cached. This is why Claude API costs per blueprint stay below €3 even for complex full-flow runs.

**Action item**: implement cache-optimized prompt construction from day 1 (use the `claude-api` skill pattern from the Claude Code plugin).

---

## 7. MVP feature set vs roadmap

### MVP (v0.1 — first paying customer)

Must-have for MVP launch:

- [x] Landing page with waitlist capture
- [ ] Account signup + single workspace per user
- [ ] **OAuth integration: Meta + Google Ads** (LinkedIn, TikTok, Microsoft, Apple → v2)
- [ ] Guided Blueprint web wizard (11 questions, one per screen, progress bar)
- [ ] Phase 0-5 execution via agent workflow
- [ ] Dashboard with blueprint project list + status
- [ ] PDF + HTML report generation + download
- [ ] Launch Checklist download
- [ ] Blueprint Execution companion (read-only metrics input: paste + CSV)
- [ ] Bi-weekly audit workflow (scheduled + on-demand)
- [ ] Live HTML dashboard rendering
- [ ] Basic email notifications (blueprint done, audit ready)
- [ ] Stripe billing (3 tiers: Starter, Pro, Agency — no Free tier at MVP)
- [ ] Adaptive mode (beginner / intermediate / expert, from intake)
- [ ] English only at launch

### v1.0 (first 3 months post-launch)

- [ ] Free tier (Phase 0 + partial Phase 1, lead magnet)
- [ ] LinkedIn Ads OAuth
- [ ] TikTok Ads OAuth
- [ ] Italian + Spanish localization
- [ ] Team members per workspace (up to 3 in Pro, 10 in Agency)
- [ ] White-label PDF (remove Maxymize branding, add client's — Agency only)
- [ ] Creative image generation inline (Gemini 3 Flash)
- [ ] Automated audit from connected ad accounts (no manual paste needed)
- [ ] Email digest (weekly performance summary)

### v2.0 (6-12 months)

- [ ] Video creative generation (Seedance 2.0)
- [ ] Microsoft Ads + Apple Search Ads OAuth
- [ ] API-side automation (execute kill/scale via OAuth, with user confirmation)
- [ ] Slack/email alert webhooks (creative fatigue, budget overspend)
- [ ] Multi-workspace dashboard (agency overview)
- [ ] Reseller / white-label program
- [ ] Public API

### v3.0+ (12+ months)

- [ ] SSO (SAML, Enterprise)
- [ ] Custom domain for white-label
- [ ] On-premise / dedicated cloud (Enterprise)
- [ ] Benchmarks database (aggregate anonymized data across customers for better recommendations)
- [ ] AI-driven A/B test results analysis

### Explicitly OUT of scope

- Meta / Google campaign automation (Madgicx / Revealbot territory) — positioning is "strategist, not robot"
- Organic social scheduling — scope creep
- Email marketing / CRM — out of scope, partner instead

---

## 8. Pricing & unit economics

### Tier structure

| Plan | Price | Blueprints/mo | Audits | Platforms | Workspaces | Users | White-label |
|---|---:|:---:|---|---|:---:|:---:|:---:|
| **Free** | €0 | 1 (Phase 0-1 only) | None | 0 connected | 1 | 1 | ❌ |
| **Starter** | €49/mo | 1 | Weekly (1/wk) | Meta + Google | 1 | 1 | ❌ |
| **Pro** | €149/mo | 3 | Bi-weekly | All platforms | 3 | 3 | ❌ |
| **Agency** | €399/mo | Unlimited | Bi-weekly | All | 10 | 10 | ✅ |
| **Enterprise** | Custom | Unlimited | Custom SLA | All + custom | Unlimited | SSO | ✅ + custom domain |

### Annual plans

Offer 20% discount (2 months free) on annual: Starter €490/yr, Pro €1490/yr, Agency €3990/yr.

### Free trial

14-day Pro trial with card required (reduces churn from unqualified signups). Free tier always available as limited forever-plan.

### Unit economics per tier

| Metric | Starter | Pro | Agency |
|---|---:|---:|---:|
| Revenue/month | €49 | €149 | €399 |
| Variable COGS | €4.65 | €18.65 | €64 |
| Stripe fee (2.9% + €0.30) | €1.72 | €4.62 | €11.87 |
| Gross contribution | €42.63 | €125.73 | €323.13 |
| Gross margin | 87% | 84% | 81% |

### CAC targets

Healthy SaaS benchmark: CAC < 3× monthly revenue for annual plans.

- Starter: CAC ≤ €150 (3 months payback)
- Pro: CAC ≤ €450
- Agency: CAC ≤ €1200

Realistic channels for these CAC targets:
- Content marketing / SEO (long-term, low CAC)
- LinkedIn organic + ads
- Reddit / Indie Hackers / X for Starter/Pro
- Direct outreach for Agency

### LTV projection

Conservative churn (bad case): 10%/mo → avg lifetime 10 months → LTV = 10 × gross contrib
- Starter LTV: €426
- Pro LTV: €1257
- Agency LTV: €3231

Optimistic churn (good case for SaaS with sticky workflows): 3%/mo → lifetime 33 mo
- Starter LTV: €1407
- Pro LTV: €4150
- Agency LTV: €10663

### Break-even scenarios

Assuming €3k/mo fixed costs (infra + tools + basic marketing):

- **Minimum viable**: 65 Starter customers OR 20 Pro customers OR 7 Agency customers
- **Comfortable (5k MRR)**: 100 Starter, 30 Pro, 10 Agency, or any blended mix
- **Real traction signal**: €10-15k MRR within 6 months of launch

---

## 9. Risks & mitigations

### Risk 1 — API approval delays (Meta, Google)

**Scenario**: you build the MVP, but Meta app review takes 4 weeks, and Google Ads developer token approval takes 6 weeks. You can't launch.

**Impact**: 1-2 months of blocked revenue.

**Mitigation**:
- Start API applications **immediately**, not at launch time
- Build against test accounts while approvals pend
- Launch initially in "manual paste mode" (user exports CSV, uploads it) to bypass OAuth entirely
- Only require OAuth in v1.0, not MVP

### Risk 2 — Anthropic API pricing / availability changes

**Scenario**: Anthropic 2x the pricing, or throttles API access, or deprecates a model you rely on.

**Impact**: margin compression or service outage.

**Mitigation**:
- Prompt caching everywhere possible (90% cost reduction)
- Abstract the agent layer behind an adapter (swap providers without rewrite)
- Keep GPT-4.1, Gemini 3, or local Llama 3.3 as fallback ready to activate
- Monitor Claude model versions and Anthropic roadmap closely

### Risk 3 — Regulated verticals (Finance, Healthcare)

**Scenario**: a Finance customer gets banned from Meta due to a Special Ad Categories violation, blames you, demands refund.

**Impact**: reputation + legal exposure.

**Mitigation**:
- Clear TOS: platform "suggests, doesn't decide". User is responsible for applying.
- Hard block in compliance-critical industries at MVP (require manual Ops check)
- Don't auto-apply any edits via API until v2.0, and only with explicit user confirmation

### Risk 4 — Liability for bad recommendations

**Scenario**: platform says "scale +20%", user loses €5k in a week, threatens lawsuit.

**Impact**: legal costs, negative reviews.

**Mitigation**:
- Disclaimer on every decision output: "based on the data you provided, this is the recommendation; verify before applying"
- No auto-application of changes (user manually executes)
- Strong ToS with limitation of liability
- Insurance (E&O / Professional Liability) once revenue justifies

### Risk 5 — Differentiation vs Madgicx, Revealbot, Motion Ads

**Scenario**: incumbent lowers prices, adds similar "AI strategist" feature, squeezes you out.

**Impact**: slow sales, high CAC.

**Mitigation**:
- Position on methodology + guided experience, not automation
- Open-source the engine (maxym-ai-ads already is) as moat → credibility + community
- Target underserved ICP: solopreneurs / first-time advertisers (incumbent focus is agencies / mature advertisers)
- Build brand via content (the BLUEPRINT-ZERO-TO-SALES.md is evergreen SEO gold)

### Risk 6 — Solo founder burnout

**Scenario**: you're building alone, 6 months in, no traction, exhausted.

**Impact**: project dies not because of market, but because of you.

**Mitigation**:
- Validate before building (see §10, step 1) — if validation calls are lukewarm, pivot or pause
- Set a clear 6-month "go/no-go" milestone (e.g. 50 paying customers by month 6)
- Keep `maxym.ai` as your broader platform — Maxymize ADS is one product, not the only one
- Budget ≤20 hrs/week from non-product work if at all possible

### Risk 7 — Legal structure

**Scenario**: Italian founder, EU VAT rules, B2C/B2B customer mix globally. Bookkeeping and tax setup nightmare.

**Impact**: admin overhead, potential fines.

**Mitigation**:
- Company structure: SRL (Italy) or LLC (Delaware via Stripe Atlas) — decide before first paying customer
- Use Stripe Billing for EU VAT handling (automatic)
- Get a commercialista familiar with SaaS EU digital services

---

## 10. Operational plan

### 6-month roadmap, solo founder

| Month | Focus | Deliverables |
|---|---|---|
| **1** | Validation + positioning | 20 validation calls, landing page up, 200 waitlist signups, Meta/Google API applications submitted |
| **2** | Foundation | Repo skeleton, auth, workspace, Stripe setup, DB schema, design system |
| **3** | Core MVP | Blueprint wizard + Phase 0-2 agent workflows, basic dashboard |
| **4** | Full MVP | Phase 3-5 workflows, PDF/HTML rendering, bi-weekly audit, manual data input |
| **5** | Closed beta | 10-20 waitlist users invited, iterate based on feedback, fix critical bugs |
| **6** | Public launch | ProductHunt, LinkedIn announcement, SEO articles live, first paying customers |

### Critical early milestones

1. **Month 1 go/no-go gate**: 10+ out of 20 validation calls say "yes, I'd pay €149/mo with enthusiasm". If <5 → pivot.
2. **Month 3 gate**: working end-to-end Phase 0 + Phase 1 demo. If not → scope cut.
3. **Month 6 gate**: 5 paying customers from closed beta. If not → reassess product-market fit.

### Validation call script (use in month 1)

Brief template for 20 calls with potential customers:

1. "Tell me about your current approach to paid ads (ICP, platforms, budget, who manages)"
2. Show recorded demo (5 min) of Maxymize ADS concept
3. "What's valuable here? What's missing?"
4. "If this existed today at €149/mo, would you pay? Honestly?"
5. "What would make you a 'yes for sure' in 60 seconds?"
6. "What would a must-have feature look like for you?"
7. "Do you know 2-3 others who might also benefit? Can you intro?"

Log all calls in a Notion/Airtable. Decide at end of month 1.

### Go-to-market at launch

Channels in priority order:

1. **LinkedIn organic** (founder brand) — founder posts blueprint content 3×/week, tags early users
2. **SEO / content** — the `BLUEPRINT-ZERO-TO-SALES.md` is already public. Write 5-10 companion articles optimized for "paid ads blueprint", "ads strategy framework", etc.
3. **ProductHunt launch** — target top 5 of the day
4. **Indie Hackers / Reddit r/SaaS / r/marketing** — community posts
5. **Direct outreach** to connections via LinkedIn + warm intros

Paid acquisition: skip for first 3 months, then €500/mo test on LinkedIn + Google Ads once product-market fit signals are strong.

---

## 11. First-two-weeks checklist

When you decide to start. **Don't code for the first 2 weeks.**

### Week 1 — Validation + foundation

- [ ] Decide legal entity type (SRL vs Delaware LLC)
- [ ] Register domain: likely `maxymize.ads` or similar
- [ ] Create landing page on Framer or Vercel (hero + waitlist form + featured blueprint preview)
- [ ] Set up ConvertKit / Resend audience for waitlist
- [ ] Write 3-5 LinkedIn posts about the vision (no coding yet, just marketing)
- [ ] Get on 20 validation calls (LinkedIn DMs + warm intros to your network)
- [ ] Start Meta Developer account + submit app review for Marketing API
- [ ] Start Google Ads Developer Token application
- [ ] Create GitHub repo `maxymize-ads` (private)
- [ ] Create Railway project `maxymize-ads`
- [ ] Create Stripe account, enable test mode
- [ ] Create Anthropic Console account, get commercial API key
- [ ] Document brand: logo, colors, typography — use existing `maxym.ai` brand identity

### Week 2 — Setup without coding core

- [ ] Finalize validation call findings: decide pricing, pivot or proceed
- [ ] Scaffold monorepo with Turborepo or basic Next.js 15 app
- [ ] Initialize Drizzle ORM + run first migration (users, workspaces, ad_account_connections)
- [ ] Integrate Stack Auth (test: signup + login flow works)
- [ ] Integrate Stripe Customer + Subscription (test: create subscription via API)
- [ ] Set up Railway Postgres + Redis + deploy skeleton app at staging URL
- [ ] Add maxym-ai-ads as git submodule in `src/agents/engine/`
- [ ] Write first proof-of-concept: API route that runs `ads-quick` via Agent SDK, logs to DB, returns score. No UI, just Postman test.
- [ ] Deploy PoC to Railway, run it, verify end-to-end with real Claude API call

**End of Week 2**: you should have a deployed skeleton that accepts a URL, runs Claude Agent SDK with the `ads-quick` SKILL.md, persists to Postgres, returns the score. No UI yet — just the core tech validated. From here, everything else is iteration.

### What NOT to do in the first 2 weeks

- ❌ Don't build the dashboard UI
- ❌ Don't build the wizard UI
- ❌ Don't implement Stripe webhooks beyond basic subscription create
- ❌ Don't worry about multi-workspace / team features
- ❌ Don't implement OAuth integrations
- ❌ Don't start the content marketing engine
- ❌ Don't spend more than 2 days on design system

These come later. Weeks 1-2 are about **validating and proving the core tech works**.

---

## Appendix A — Stack reference quick links

- **Railway**: https://railway.app/docs
- **Claude Agent SDK docs**: https://docs.claude.com/en/agent-sdk/overview
- **Anthropic API pricing**: https://www.anthropic.com/pricing
- **Gemini API (image gen)**: https://ai.google.dev/gemini-api/docs/image-generation
- **Stripe Billing**: https://stripe.com/docs/billing
- **Stack Auth**: https://stack-auth.com/docs
- **BullMQ**: https://docs.bullmq.io/
- **Drizzle ORM**: https://orm.drizzle.team/
- **Next.js 15**: https://nextjs.org/docs
- **shadcn/ui**: https://ui.shadcn.com/
- **Meta Marketing API**: https://developers.facebook.com/docs/marketing-apis
- **Google Ads API**: https://developers.google.com/google-ads/api/docs/start

## Appendix B — Files to copy from this repo

When you start the new project, reference these files from `maxym-ai-ads`:

| File | Why |
|---|---|
| `README.md` | Product narrative + positioning language |
| `docs/BLUEPRINT-ZERO-TO-SALES.md` | Core methodology — word-for-word for SEO + sales enablement |
| `CHANGELOG.md` | Release history context |
| `skills/ads/SKILL.md` | Router logic — becomes the orchestrator in the SaaS |
| `skills/ads-blueprint/SKILL.md` + `assets/` | Blueprint flow + HTML template |
| `skills/ads-blueprint-execution/SKILL.md` + `assets/` | Execution flow + HTML template |
| `skills/ads-*/SKILL.md` (all 32) | Sub-skill prompts — import as agent system prompts |
| `skills/ads/references/*.md` (25 files) | RAG context for agents |
| `skills/ads-plan/assets/*.md` (12 files) | Industry templates |
| `NOTICES.md` | Attribution (reproduce in SaaS legal page) |
| `LICENSE` | MIT permits commercial SaaS use |

---

## Appendix C — Questions to answer before starting

Open questions that need answers before/during month 1:

1. **Solo or co-founder**? If co-founder, technical or commercial split?
2. **Italian SRL or US Delaware LLC**? VAT / legal implications.
3. **English-only at launch or Italian too**? (affects validation call pool)
4. **Domain**: `maxymize.ads`, `maxymize-ads.com`, `maxymize.agency`, subdomain of `maxym.ai`?
5. **Branding**: reuse maxym.ai identity, or create distinct Maxymize ADS brand?
6. **Pricing in USD or EUR** at launch? (EUR makes more sense for EU ICP, USD for global)
7. **Customer support**: Crisp / Intercom / email-only for MVP?
8. **Data retention policy**: how long keep user ad data? GDPR implications.
9. **Partner integration**: any agency or influencer you can co-launch with?
10. **Success criteria**: how do you define "this worked" at 6 / 12 / 24 months?

---

## Document metadata

- **Created**: 2026-04-22
- **Author**: Maximilian Giurastante
- **Last updated**: 2026-04-22
- **Version**: 1.0
- **Source reference**: https://github.com/Maxymize/maxym-ai-ads (engine, MIT)
- **Target project location**: `/Users/maximiliangiurastante/Sviluppo/Claude/maxymize-ads/`

---

**Next step when you're ready to start**: re-read this document, answer [Appendix C](#appendix-c--questions-to-answer-before-starting), then follow the [Week 1 checklist](#week-1--validation--foundation).
