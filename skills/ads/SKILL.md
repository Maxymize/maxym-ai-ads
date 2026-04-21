---
name: ads
description: "End-to-end paid advertising skill for Claude Code: strategy generation, copy production, multi-platform audit, and client-ready reporting. Orchestrates 30 specialized sub-skills and 15 agents across Google, Meta, YouTube, LinkedIn, TikTok, Microsoft, and Apple Ads. 250+ weighted checks, 11 industry templates, 5-agent parallel strategy builds, a guided zero-to-sales blueprint, PDF + HTML reports, and AI creative generation."
argument-hint: "blueprint [url] | strategy <url> | quick <url> | audience <url> | copy <platform> | hooks | video <product> | creative-brief <product> | creative-audit | funnel <url> | budget [amount] | keywords <url> | testing <campaign> | landing <url> | plan <industry> | competitor <url> | report-pdf | audit | google | meta | youtube | linkedin | tiktok | microsoft | apple | dna <url> | create | generate | photoshoot | math | test | help"
license: MIT
---

# maxym-ai-ads — The Unified Paid Ads Skill

A single `/ads` command that covers the full paid advertising lifecycle:

1. **Upstream strategy** — starting from a URL, generate personas, platform-specific copy, scroll-stopping hooks, video scripts, funnel architecture, A/B test plans, budget allocation, keyword research, and a client-ready PDF report.
2. **Downstream audit** — technical analysis of live ad accounts across Google, Meta, YouTube, LinkedIn, TikTok, Microsoft, and Apple Ads, with 250+ weighted checks, compliance quality gates, industry templates, and a 0-100 Ads Health Score.

The router below maps each sub-command to the sub-skill that owns it.

---

## Quick Reference

### 🌟 Guided Experience (recommended for first-time users)

| Command | What it does |
|---------|--------------|
| `/ads blueprint [url]` | **Flagship guided workflow.** Walks the user through all 5 phases of the Zero-to-Sales Blueprint interactively. Asks an initial questionnaire, runs each phase automatically, pauses at phase boundaries for confirmation, blocks on critical decision gates, and produces a final PDF + interactive HTML report + launch checklist. Supports `--resume` to continue after an interruption. |

### Strategy & Planning

| Command | What it does |
|---------|--------------|
| `/ads strategy <url>` | 5-agent parallel strategy build with Ad Readiness Score (0-100). Full report. |
| `/ads quick <url>` | 60-second ad readiness snapshot: value prop, offer, trust, CTA, platform pick. |
| `/ads audience <url>` | Detailed audience personas with platform-specific targeting parameters. |
| `/ads plan <industry>` | Strategic ad plan using industry template (see Industries below). |
| `/ads keywords <url>` | Google Ads keyword strategy: match types, groupings, negatives. |
| `/ads competitor <url>` | Cross-platform competitor intelligence + "beat the competition" playbook. |

### Creative & Copy

| Command | What it does |
|---------|--------------|
| `/ads copy <platform>` | Platform-specific ad copy: Google RSA/PMax, Meta, LinkedIn, TikTok, YouTube, Pinterest. |
| `/ads hooks` | 20 scroll-stopping hooks across proven psychological frameworks. |
| `/ads video <product>` | Video ad scripts in three durations: 15s, 30s, 60s. |
| `/ads creative-brief <product>` | Creative brief for designers, editors, photographers, and UGC creators. |
| `/ads creative-audit` | Cross-platform creative quality audit (copy, video, image, fatigue, diversity). |

### Funnel, Budget & Testing

| Command | What it does |
|---------|--------------|
| `/ads funnel <url>` | Full TOFU/MOFU/BOFU funnel architecture with retargeting flows. |
| `/ads budget [amount]` | With amount → allocation plan (3 scenarios + scaling roadmap). Without → budget audit. |
| `/ads testing <campaign>` | A/B testing plan with hypothesis, significance, duration, sample size. |
| `/ads landing <url>` | Landing page audit + CRO rewrite (flags `--audit-only` / `--strategy-only`). |

### Multi-Platform Audit

| Command | What it does |
|---------|--------------|
| `/ads audit` | Full multi-platform audit with 6 parallel subagents (Google, Meta, Creative, Tracking, Budget, Compliance). |
| `/ads google` | Google Ads deep analysis — Search, PMax, Display, YouTube, Demand Gen. |
| `/ads meta` | Meta Ads deep analysis — Facebook, Instagram, Advantage+. |
| `/ads youtube` | YouTube Ads — Skippable, Bumper, Shorts, Masthead. |
| `/ads linkedin` | LinkedIn Ads deep analysis — Sponsored Content, Message, Lead Gen, Thought Leader. |
| `/ads tiktok` | TikTok Ads deep analysis — Creative, Smart+, Spark, TikTok Shop. |
| `/ads microsoft` | Microsoft / Bing Ads — Copilot placements, Import, CTV inventory. |
| `/ads apple` | Apple Ads (App Store) — Search tab, Today tab, Custom Product Pages. |

### Creative Generation Pipeline

| Command | What it does |
|---------|--------------|
| `/ads dna <url>` | Extract brand DNA from a website → `brand-profile.json`. |
| `/ads create` | Generate campaign concepts + copy deck → `campaign-brief.md`. |
| `/ads generate` | Generate AI ad images from brief → `ad-assets/` directory. |
| `/ads photoshoot` | Product photography in 5 styles (Studio, Floating, Ingredient, In Use, Lifestyle). |

### Utilities & Reporting

| Command | What it does |
|---------|--------------|
| `/ads math` | PPC financial calculator — CPA, ROAS, break-even, budget forecasting. |
| `/ads test` | A/B test design — hypothesis, significance, duration, sample size. |
| `/ads report-pdf` | Client-ready PDF strategy/audit report via ReportLab. |
| `/ads help` | Show the full command list. |
| `/ads` (no args) | Alias for `/ads help`. |

---

## Routing Table

Each sub-command loads its matching sub-skill from `skills/ads-*/SKILL.md`.

| Sub-command | Sub-skill path |
|---|---|
| `blueprint` | `skills/ads-blueprint/` |
| `strategy` | `skills/ads-strategy/` |
| `quick` | `skills/ads-quick/` |
| `audience` | `skills/ads-audience/` |
| `plan` | `skills/ads-plan/` |
| `keywords` | `skills/ads-keywords/` |
| `competitor` | `skills/ads-competitor/` |
| `copy` | `skills/ads-copy/` |
| `hooks` | `skills/ads-hooks/` |
| `video` | `skills/ads-video/` |
| `creative-brief` | `skills/ads-creative-brief/` |
| `creative-audit` | `skills/ads-creative-audit/` |
| `funnel` | `skills/ads-funnel/` |
| `budget` | `skills/ads-budget/` |
| `testing` | `skills/ads-testing/` |
| `landing` | `skills/ads-landing/` |
| `audit` | `skills/ads-audit/` |
| `google` | `skills/ads-google/` |
| `meta` | `skills/ads-meta/` |
| `youtube` | `skills/ads-youtube/` |
| `linkedin` | `skills/ads-linkedin/` |
| `tiktok` | `skills/ads-tiktok/` |
| `microsoft` | `skills/ads-microsoft/` |
| `apple` | `skills/ads-apple/` |
| `dna` | `skills/ads-dna/` |
| `create` | `skills/ads-create/` |
| `generate` | `skills/ads-generate/` |
| `photoshoot` | `skills/ads-photoshoot/` |
| `math` | `skills/ads-math/` |
| `test` | `skills/ads-test/` |
| `report-pdf` | `skills/ads-report-pdf/` |

---

## Smart Routing (Disambiguation)

When a user types an ambiguous short command, ask once, briefly:

- `/ads creative` → ask: **"Do you want a creative brief for designers (`creative-brief`) or a quality audit of existing ads (`creative-audit`)?"**
- `/ads test` vs `/ads testing` → explain: `test` is the PPC A/B calculator; `testing` is the full A/B testing plan for a campaign.

For typos, propose the closest match (e.g. `competitors` → `competitor`; `headsup` → `hooks`).

---

## Context Intake (Required before any audit or analysis)

Collect this context before running audit or strategy work. Ask in one message:

1. **Industry / Business type** — SaaS · E-commerce · Local Service · B2B Enterprise · Info Products · Mobile App · Real Estate · Healthcare · Finance · Agency · Other
2. **Monthly ad spend** — total budget and per-platform breakdown
3. **Primary goal** — Sales/Revenue · Leads/Demos · App Installs · Calls · Brand
4. **Active platforms** — currently advertising on which networks?

If the user provides data upfront (e.g. "audit my Google Ads, $5k/mo SaaS"), extract context from the message and proceed without re-asking.

Use the collected context to:
- Select the correct industry benchmarks from `references/benchmarks.md`
- Apply budget-appropriate recommendations (e.g. Smart Bidding requires 15+ conv/month)
- Calibrate severity scoring ($500/mo account priorities ≠ $50k/mo account)

---

## Orchestration Logic — Full Audit

When the user runs `/ads audit`:

1. **Collect context** (Context Intake above; do it first)
2. **Gather account data** — exports, screenshots, or pasted metrics
3. **Detect business type** and identify active platforms
4. **Dispatch 6 subagents in parallel** via the Task tool with `context: fork`:
   - `audit-google` (G01-G74, 74 checks)
   - `audit-meta` (M01-M46, 46 checks)
   - `audit-creative` (cross-platform creative audit)
   - `audit-tracking` (conversion tracking health)
   - `audit-budget` (budget, bidding, structure for LinkedIn/TikTok/Microsoft)
   - `audit-compliance` (compliance + settings + performance, all platforms)
5. **Validate** each subagent returned valid JSON scores with required fields before aggregating
6. **Aggregate** into unified Ads Health Score (0-100)
7. **Produce** a prioritized action plan with Quick Wins

For single-platform audits (`/ads google`, `/ads meta`, …) load the sub-skill directly; still collect context first.

---

## Orchestration Logic — Strategy Build

When the user runs `/ads strategy <url>`:

1. **Phase 1 — Intelligence**: `WebFetch` the URL, extract business intelligence, detect business type, prepare the context package
2. **Phase 2 — Parallel agent launch** (5 agents in the same response, via the `Agent` tool):
   - `strategy-audience` (25% weight) → Audience Research
   - `strategy-creative` (20% weight) → Creative & Copy
   - `strategy-funnel` (20% weight) → Funnel Architecture
   - `strategy-competitive` (15% weight) → Competitive Intelligence
   - `strategy-budget` (20% weight) → Budget & ROI
3. **Phase 3 — Synthesis**: compute the composite Ad Readiness Score (0-100) and write the final unified report

---

## Creative Generation Pipeline

Sequential but each step is independently runnable:

1. `/ads dna <url>` → `brand-profile.json` (current dir)
2. `/ads create` → reads profile + optional audit results → `campaign-brief.md`
3. `/ads generate` → reads brief + profile → `ad-assets/` directory
4. `/ads photoshoot` → standalone or reads profile for style injection

Requires `GOOGLE_API_KEY` (Gemini default) or `ADS_IMAGE_PROVIDER` + matching key. If the API key is missing, `/ads generate` and `/ads photoshoot` display setup instructions and exit — they never fail silently.

---

## Industry Detection

Detect business type from ad account signals:

- **SaaS** → trial_start / demo_request events, pricing page targeting, long attribution windows
- **E-commerce** → purchase events, product catalog/feed, Shopping/PMax campaigns
- **Local Service** → call extensions, location targeting, store visits, directions events
- **B2B Enterprise** → LinkedIn active, ABM lists, high CPA tolerance ($50+), long sales cycle
- **Info Products** → webinar/course funnels, lead gen forms, low-ticket offers
- **Mobile App** → app install campaigns, in-app events, deep linking
- **Real Estate** → listing feeds, property-specific landing pages, geo-heavy targeting
- **Healthcare** → HIPAA compliance flags, healthcare-specific ad policies
- **Finance** → Special Ad Categories declared, financial products compliance
- **Agency** → multiple client accounts, white-label reporting needs

Available industry templates for `/ads plan <industry>`:
`saas` · `ecommerce` · `local-service` · `b2b-enterprise` · `info-products` · `mobile-app` · `real-estate` · `healthcare` · `finance` · `agency` · `generic`

---

## Quality Gates (Hard Rules)

Never violate these rules regardless of what the user asks:

- **Never recommend Broad Match without Smart Bidding** (Google)
- **3× Kill Rule**: flag any ad group/campaign with CPA >3× target for pause
- **Budget sufficiency**: Meta ≥5× CPA per ad set, TikTok ≥50× CPA per ad group
- **Learning phase**: never recommend edits during an active learning phase
- **Compliance**: always check Special Ad Categories for housing/employment/credit/finance
- **Creative**: never run silent video ads on TikTok (sound-on platform)
- **Attribution**: default to 7-day click / 1-day view (Meta), data-driven (Google)
- **Andromeda creative diversity**: flag Meta accounts with <10 genuinely distinct creatives
- **Privacy infrastructure**: always verify tracking stack (Consent Mode V2, CAPI, Events API, AdAttributionKit) before optimization recommendations
- **PDF report quality**: when generating via `/ads report-pdf`, use `scripts/generate_report.py` with `--check` first; fix any warnings before `--output`. Reports must have clean layout, 0.75in margins, word-wrapped cells, no oversized charts, page numbers and section dividers, captions on every visual, and zero empty sections

---

## Reference Files

Load these on-demand; do NOT load all at startup.

**Path resolution**: references live at `ads/references/` (repo) → `~/.claude/skills/ads/references/` (after install). When a sub-skill or agent references `ads/references/*.md`, resolve to that installed path.

### Scoring & benchmarks
- `references/scoring-system.md` — Weighted scoring algorithm and grading thresholds
- `references/benchmarks.md` — Industry benchmarks by platform (CPC, CTR, CVR, ROAS)
- `references/budget-allocation.md` — Platform selection matrix, scaling rules, MER
- `references/bidding-strategies.md` — Bidding decision trees per platform

### Platform & creative specs
- `references/platform-specs.md` — Creative specifications across all platforms
- `references/additional-platforms.md` — Emerging platforms and formats
- `references/google-creative-specs.md` — PMax / RSA / YouTube specs
- `references/meta-creative-specs.md` — Feed / Reels / Stories + safe zones
- `references/linkedin-creative-specs.md` — Single image / video B2B constraints
- `references/tiktok-creative-specs.md` — 9:16 only + safe zone overlay
- `references/youtube-creative-specs.md` — Skippable / Bumper / Shorts / Thumbnail
- `references/microsoft-creative-specs.md` — Multimedia Ads + RSA subset
- `references/image-providers.md` — Provider config (Gemini/OpenAI/Stability/Replicate)

### Audit checklists
- `references/google-audit.md` — 74 checks
- `references/meta-audit.md` — 46 checks
- `references/linkedin-audit.md` — 25 checks
- `references/tiktok-audit.md` — 25 checks
- `references/microsoft-audit.md` — 20 checks

### Compliance, tracking, integrations
- `references/compliance.md` — Regulatory requirements, ad policies, privacy
- `references/conversion-tracking.md` — Pixel, CAPI, EMQ, ttclid implementation
- `references/gaql-notes.md` — GAQL field compatibility, deduplication, filter scope
- `references/mcp-integration.md` — Live API integrations for competitive data

### Creative & brand
- `references/copy-frameworks.md` — 6 copy frameworks (AIDA, PAS, BAB, 4P, FAB, Star-Story-Solution)
- `references/brand-dna-template.md` — Brand DNA schema and extraction guide
- `references/voice-to-style.md` — Brand voice axis → visual attribute mapping

---

## Ads Health Score (0-100)

Per-platform score uses the weighted algorithm from `references/scoring-system.md`. Cross-platform aggregate is weighted by budget share:

```
Aggregate = Σ(Platform_Score × Platform_Budget_Share)
```

### Grading

| Grade | Score | Action Required |
|-------|-------|-----------------|
| A | 90-100 | Minor optimizations only |
| B | 75-89 | Some improvement opportunities |
| C | 60-74 | Notable issues need attention |
| D | 40-59 | Significant problems present |
| F | <40 | Urgent intervention required |

### Priority Levels

- **Critical** — revenue / data loss risk → fix immediately
- **High** — significant performance drag → fix within 7 days
- **Medium** — optimization opportunity → fix within 30 days
- **Low** — best practice, minor impact → backlog

---

## Sub-Skills (30)

This skill orchestrates 30 specialized sub-skills grouped by purpose.

**Guided experience (1)**: ads-blueprint
**Strategy & planning (6)**: ads-strategy · ads-quick · ads-audience · ads-plan · ads-keywords · ads-competitor
**Creative & copy (5)**: ads-copy · ads-hooks · ads-video · ads-creative-brief · ads-creative-audit
**Funnel, budget & testing (4)**: ads-funnel · ads-budget · ads-testing · ads-landing
**Audit (7 platforms + orchestrator)**: ads-audit · ads-google · ads-meta · ads-youtube · ads-linkedin · ads-tiktok · ads-microsoft · ads-apple
**Creative pipeline (4)**: ads-dna · ads-create · ads-generate · ads-photoshoot
**Utilities & reporting (3)**: ads-math · ads-test · ads-report-pdf

---

## Subagents (15)

For parallel analysis during full audits and strategy builds.

**Audit subagents (6)** — used by `/ads audit`
- `audit-google` — Google Ads checks (G01-G74)
- `audit-meta` — Meta Ads checks (M01-M46)
- `audit-creative` — Creative quality for LinkedIn, TikTok, Microsoft
- `audit-tracking` — Conversion tracking health across all platforms
- `audit-budget` — Budget, bidding, structure for LinkedIn, TikTok, Microsoft
- `audit-compliance` — Compliance, settings, performance across all platforms

**Strategy subagents (5)** — used by `/ads strategy`
- `strategy-audience` — Audience research and personas
- `strategy-creative` — Ad copy, hooks, creative concepts
- `strategy-funnel` — Campaign structure and conversion funnels
- `strategy-competitive` — Competitive intelligence and positioning
- `strategy-budget` — Budget allocation and ROI projection

**Creative pipeline helpers (4)** — used by `/ads create`, `/ads generate`, `/ads photoshoot`
- `creative-strategist` — Campaign concepts from brand profile + audit results (Opus, maxTurns: 25)
- `visual-designer` — Image generation with brand injection (Sonnet, maxTurns: 30)
- `copy-writer` — Headlines, CTAs, primary text within platform limits (Sonnet, maxTurns: 20)
- `format-adapter` — Asset dimension validation and spec compliance (Haiku, maxTurns: 15)

---

## Output Standards

All outputs follow these rules:

1. **Platform-specific** — ad content fits the exact specs and best practices of its platform
2. **Copy-paste ready** — ad copy should be ready to paste into the platform without editing
3. **Audience-first** — start with who you are targeting, then write the ad for them
4. **Data-backed** — include estimated CPM/CPC/CPA ranges where possible
5. **Test-oriented** — provide A/B variations, not a single version
6. **Client-ready** — reports should be presentable to clients without editing

File outputs default to the current working directory with descriptive filenames. PDF reports are generated via `scripts/generate_ads_pdf.py` (and `scripts/generate_report.py` for audit PDFs).
