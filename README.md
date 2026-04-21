<p align="center">
  <img src="assets/banner.png" alt="maxym-ai-ads — the all-in-one paid advertising skill for Claude Code" width="100%">
</p>

<h1 align="center">maxym-ai-ads</h1>

<p align="center">
  <strong>Advertising strategy, creative generation, and multi-platform audit — all in one Claude Code skill.</strong>
</p>

<p align="center">
  <a href="https://claude.ai/claude-code"><img src="https://img.shields.io/badge/Claude%20Code-Skill-6E44FF?logo=anthropic&logoColor=white" alt="Claude Code Skill"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/version-1.0.00-success" alt="Version 1.0.00">
  <img src="https://img.shields.io/badge/platforms-Google%20%7C%20Meta%20%7C%20LinkedIn%20%7C%20TikTok%20%7C%20Microsoft%20%7C%20YouTube%20%7C%20Apple-blue" alt="Supported platforms">
  <img src="https://img.shields.io/badge/audit%20checks-250%2B-brightgreen" alt="250+ audit checks">
  <img src="https://img.shields.io/badge/industry%20templates-11-blueviolet" alt="11 industry templates">
</p>

<p align="center">
  <a href="#installation">Install</a> ·
  <a href="#quick-start">Quick Start</a> ·
  <a href="#commands">Commands</a> ·
  <a href="#features">Features</a> ·
  <a href="#architecture">Architecture</a> ·
  <a href="#faq">FAQ</a> ·
  <a href="#uninstall">Uninstall</a>
</p>

---

## Why maxym-ai-ads

Most "ad tools" are either **upstream** (they help you plan campaigns from scratch) or **downstream** (they audit what is already running). `maxym-ai-ads` is both, behind a single `/ads` command in Claude Code:

- **From a URL** → personas, platform copy, scroll-stopping hooks, video scripts, funnel architecture, budget splits with CPM/CPC/CPA projections, A/B test plans, keyword research, and a client-ready PDF.
- **From a live account** → a 250+ check technical audit across Google, Meta, YouTube, LinkedIn, TikTok, Microsoft and Apple Ads, with 0–100 Ads Health Score, compliance quality gates, and a prioritized Quick Wins action list.
- **From a brand** → a complete creative pipeline (brand DNA → campaign brief → AI image generation → 5-style product photoshoot).

One orchestrator, **30 sub-commands**, 15 parallel subagents, 25 RAG reference files, 11 industry templates. MIT licensed.

---

## Installation

### Plugin install (recommended)

From inside Claude Code:

```shell
/plugin marketplace add Maxymize/maxym-ai-ads
/plugin install maxym-ai-ads@maxym-plugins
```

This registers `maxym-ai-ads` as a native Claude Code plugin with namespaced skills (for example, `/maxym-ai-ads:ads`), auto-updates via `/plugin marketplace update`, and version tracking.

### One-command install (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/Maxymize/maxym-ai-ads/main/install.sh | bash
```

### One-command install (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/Maxymize/maxym-ai-ads/main/install.ps1 | iex
```

### Manual install

```bash
git clone https://github.com/Maxymize/maxym-ai-ads.git
cd maxym-ai-ads
./install.sh           # macOS / Linux
# or
.\install.ps1          # Windows PowerShell
```

The installer copies the `/ads` orchestrator, 30 sub-skills, 15 subagents, 25 reference files, 11 industry templates, and Python helper scripts into `~/.claude/skills/` and `~/.claude/agents/`, then runs `pip install` for the Python dependencies.

> If your clone lives at a different GitHub path, set `MAXYM_ADS_REPO_URL` before running the installer.

---

## 🗺️ Zero-to-Sales Blueprint

Don't know where to start? Read the **[Zero-to-Sales Blueprint](docs/BLUEPRINT-ZERO-TO-SALES.md)** — the exact command sequence to go from "I have a product" to "my ads print money" in 8–12 days of prep, with zero wasted budget.

The blueprint covers all 5 phases: Reality Check → Intelligence → Budget/Funnel → Creative → Launch → Optimize, with flowcharts, decision gates, and the 3 sacred rules of paid ads optimization.

---

## Quick Start

```bash
# 1. Start Claude Code
claude

# 2. Pick what you need
/ads help                                # all 30 sub-commands
/ads quick https://your-site.com         # 60-second ad readiness snapshot
/ads strategy https://your-site.com      # flagship: 5-agent parallel strategy build
/ads audit                               # full multi-platform audit, 6 agents in parallel
/ads plan saas                           # industry-specific ad plan (11 templates)
/ads budget 5000                         # $5K/mo allocation plan with 3 scenarios
/ads budget                              # no amount → audit existing spend
/ads landing https://your-site.com       # audit + CRO rewrite in one run
/ads competitor https://your-site.com    # cross-platform competitor intelligence
/ads dna https://your-site.com           # extract brand DNA → brand-profile.json
/ads create                              # campaign concepts + copy deck → campaign-brief.md
/ads generate                            # AI ad images → ad-assets/
/ads report-pdf                          # package everything into a client-ready PDF
```

Most sub-skills ask for context the first time (industry, monthly spend, goal, active platforms). Provide that context in the initial message and they skip the questions.

---

## Commands

### Strategy & Planning

| Command | What it does |
|---------|--------------|
| `/ads strategy <url>` | Flagship. 5-agent parallel strategy build with composite Ad Readiness Score (0–100). |
| `/ads quick <url>` | 60-second readiness snapshot: value prop, offer, trust, CTA, platform pick. |
| `/ads audience <url>` | Detailed personas with platform-specific targeting parameters. |
| `/ads plan <industry>` | Strategic ad plan using one of 11 industry templates. |
| `/ads keywords <url>` | Google Ads keyword strategy: match types, groupings, negatives. |
| `/ads competitor <url>` | Reconnaissance + gap analysis + "beat the competition" playbook. |

### Creative & Copy

| Command | What it does |
|---------|--------------|
| `/ads copy <platform>` | Platform-specific ad copy: Google RSA/PMax, Meta, LinkedIn, TikTok, YouTube, Pinterest. |
| `/ads hooks` | 20 scroll-stopping hooks across proven psychological frameworks. |
| `/ads video <product>` | Video ad scripts in 15s, 30s, and 60s lengths. |
| `/ads creative-brief <product>` | Creative brief for designers, editors, photographers, UGC creators. |
| `/ads creative-audit` | Cross-platform creative quality audit (copy, video, image, fatigue, diversity). |

### Funnel, Budget & Testing

| Command | What it does |
|---------|--------------|
| `/ads funnel <url>` | Full TOFU / MOFU / BOFU funnel architecture with retargeting flows. |
| `/ads budget [amount]` | With amount → allocation plan (Conservative / Balanced / Aggressive + scaling roadmap). Without → budget audit with 3× Kill Rule + learning-phase checks. |
| `/ads testing <campaign>` | A/B test design: hypothesis, significance, duration, sample size. |
| `/ads landing <url>` | Landing page audit **and** CRO rewrite. Flags: `--audit-only`, `--strategy-only`. |

### Multi-Platform Audit

| Command | What it does |
|---------|--------------|
| `/ads audit` | Full multi-platform audit via 6 parallel subagents (Google, Meta, Creative, Tracking, Budget, Compliance). Ads Health Score 0–100. |
| `/ads google` | Google Ads deep analysis — Search, PMax, Display, YouTube, Demand Gen (74 checks). |
| `/ads meta` | Meta Ads deep analysis — Facebook, Instagram, Advantage+ (46 checks). |
| `/ads youtube` | YouTube Ads — Skippable, Bumper, Shorts, Masthead. |
| `/ads linkedin` | LinkedIn Ads — Sponsored Content, Message, Lead Gen, Thought Leader (25 checks). |
| `/ads tiktok` | TikTok Ads — Creative, Smart+, Spark, TikTok Shop (25 checks). |
| `/ads microsoft` | Microsoft Ads — Copilot placements, Import, CTV inventory (20 checks). |
| `/ads apple` | Apple Ads (App Store) — Search tab, Today tab, Custom Product Pages. |

### Creative Generation Pipeline

| Command | What it does |
|---------|--------------|
| `/ads dna <url>` | Extract brand DNA from a website → `brand-profile.json`. |
| `/ads create` | Campaign concepts + platform copy deck → `campaign-brief.md`. |
| `/ads generate` | AI ad images from the brief → `ad-assets/` directory. |
| `/ads photoshoot` | Product photography in 5 styles (Studio, Floating, Ingredient, In Use, Lifestyle). |

### Utilities & Reporting

| Command | What it does |
|---------|--------------|
| `/ads math` | PPC financial calculator — CPA, ROAS, break-even, forecasting. |
| `/ads test` | A/B test design calculator. |
| `/ads report-pdf` | Client-ready PDF strategy/audit report via ReportLab. |
| `/ads help` | List every command with a short description. |

---

## Features

- **250+ weighted audit checks** across Google, Meta, YouTube, LinkedIn, TikTok, Microsoft, and Apple Ads
- **Ads Health Score (0–100)** and **Ad Readiness Score (0–100)** with clear A→F grading
- **5-agent parallel strategy build** — audience, creative, funnel, competitive, budget — in a single shot
- **6-agent parallel audit** — Google, Meta, Creative, Tracking, Budget, Compliance — running concurrently
- **11 industry templates**: SaaS, e-commerce, local service, B2B enterprise, info products, mobile app, real estate, healthcare, finance, agency, generic
- **Platform-native copy** that respects character limits, safe zones, and platform best practices
- **Dual-mode landing, budget, competitor** — audit an existing situation or build from scratch with the same command
- **AI image generation pipeline** — brand DNA → brief → image generation → 5-style product photoshoot
- **Quality gates** that refuse anti-patterns: 3× Kill Rule, learning-phase protection, Special Ad Categories enforcement, Andromeda creative diversity, Consent Mode V2 verification, silent-video-on-TikTok block
- **2026-current benchmarks** for CPC, CPM, CTR, CVR, ROAS per platform and industry
- **Client-ready PDF reports** with quality-checked layout (margins, word-wrapped cells, captions, page numbers)
- **Cross-platform install** — macOS, Linux, Windows, with uninstaller
- **MIT license** — use it in your agency, your startup, or your own workflow

---

## Architecture

```
                         ┌──────────────────┐
                         │     /ads         │   ← router, context intake, quality gates
                         │  (orchestrator)  │
                         └────────┬─────────┘
                                  │
           ┌──────────────────────┼──────────────────────────┐
           │                      │                          │
    ┌──────▼──────┐        ┌──────▼───────┐          ┌───────▼────────┐
    │  Strategy   │        │    Audit     │          │    Creative    │
    │  sub-skills │        │  sub-skills  │          │   sub-skills   │
    │   (6 + 4)   │        │    (8)       │          │    (4 + 2)     │
    └──────┬──────┘        └──────┬───────┘          └────────┬───────┘
           │                      │                           │
           ▼                      ▼                           ▼
   ┌─────────────┐        ┌───────────────┐          ┌────────────────┐
   │ strategy-*  │        │   audit-*     │          │  creative-*    │
   │  agents (5) │        │  agents (6)   │          │  agents (4)    │
   └─────────────┘        └───────────────┘          └────────────────┘

                         ┌────────────────────┐
                         │  references/ (25)  │  benchmarks · bidding · specs
                         │   — on-demand RAG  │  compliance · tracking · copy
                         └────────────────────┘
```

- **1** top-level orchestrator (`ads/SKILL.md`)
- **29** sub-skills under `skills/ads-*/`
- **15** subagents under `agents/` (6 audit, 4 creative pipeline, 5 strategy)
- **25** reference files under `ads/references/` (loaded on-demand)
- **11** industry templates under `skills/ads-plan/assets/`
- Python scripts under `scripts/` for landing page analysis, screenshots, image generation, and PDF reporting

---

## How it analyzes your account

1. **Context intake** — industry, monthly spend, primary goal, active platforms (asked once, reused across every command)
2. **Business-type detection** — SaaS vs e-commerce vs local-service vs B2B enterprise vs 7 more, from ad-account signals (trial_start events, product catalogs, call extensions, LinkedIn activity, HIPAA flags, Special Ad Categories, …)
3. **Parallel subagent dispatch** — every audit subagent runs concurrently with `context: fork`, validates its own JSON output, and emits a weighted category score
4. **Aggregation** — per-platform scores are combined into a single Ads Health Score weighted by budget share:
   `Aggregate = Σ(Platform_Score × Platform_Budget_Share)`
5. **Quality gates** — hard rules that refuse unsafe advice (3× Kill Rule, learning-phase protection, Consent Mode V2, Andromeda diversity, Special Ad Categories)
6. **Prioritized output** — Critical / High / Medium / Low action plan with Quick Wins at the top

## How it builds a strategy from a URL

1. **Phase 1 — Intelligence**: `WebFetch` the URL, extract business intelligence, detect business type, prepare a shared context package
2. **Phase 2 — Parallel agent launch**: 5 agents in a single response
   - `strategy-audience` (25 %) — personas, targeting
   - `strategy-creative` (20 %) — copy, hooks, video
   - `strategy-funnel` (20 %) — campaign structure, retargeting
   - `strategy-competitive` (15 %) — positioning, gaps
   - `strategy-budget` (20 %) — allocation, ROI projection
3. **Phase 3 — Synthesis**: composite Ad Readiness Score (0–100) + unified strategy report with client-ready formatting

---

## Image generation

The creative generation pipeline (`/ads create` → `/ads generate` → `/ads photoshoot`) uses a pluggable provider layer. The default integration is [banana-claude](https://github.com/) for Gemini-grade Flash image generation; fallback providers (OpenAI `gpt-image-1`, Stability AI, Replicate / FLUX.1) can be enabled by setting `ADS_IMAGE_PROVIDER` and the matching API key.

If no provider is configured, `/ads generate` and `/ads photoshoot` print setup instructions and exit — they never fail silently and never produce stock images masquerading as AI output.

---

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI
- Git ≥ 2.30
- Python ≥ 3.10 with `pip`
- Python packages (installed automatically): `reportlab`, `matplotlib`, `Pillow`, `requests`, `urllib3`, and optionally `playwright` for live landing-page analysis
- **Optional** — an image generation provider for the creative pipeline

---

## Uninstall

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Maxymize/maxym-ai-ads/main/uninstall.sh | bash

# Windows PowerShell
irm https://raw.githubusercontent.com/Maxymize/maxym-ai-ads/main/uninstall.ps1 | iex
```

This removes the `ads` orchestrator, every `ads-*` sub-skill, every `audit-*` / `creative-*` / `strategy-*` subagent, and the installed reference and script files.

---

## FAQ

**Do I need API keys?**
No keys are required for strategy, audit, planning, copy, budget, keywords, testing, landing, competitor, hooks, video, PDF reporting, or the PPC math/test calculators. An image-generation provider is only needed for `/ads generate` and `/ads photoshoot`.

**Can I use this on a client account?**
Yes — the skill works from exports, screenshots, or pasted metrics. You do not need to connect any account. An optional MCP integration path for live API access is documented in `references/mcp-integration.md`.

**Does it handle regulated verticals (housing, employment, credit, finance, healthcare)?**
Yes. A dedicated compliance quality gate enforces Special Ad Categories and HIPAA-adjacent checks as hard rules — the skill will refuse to recommend a strategy that violates them.

**What happens during a learning phase?**
`maxym-ai-ads` refuses to recommend budget or targeting changes while a campaign is in its active learning phase. The audit flags it explicitly and tells you when you can safely intervene.

**Can I customize the industry templates?**
Yes. Industry templates live at `skills/ads-plan/assets/*.md`. Drop in a new file (e.g. `assets/crypto.md`), and `/ads plan crypto` will pick it up automatically.

---

## Project layout

```
maxym-ai-ads/
├── ads/
│   ├── SKILL.md                  # /ads orchestrator
│   ├── references/               # 25 RAG reference files
│   └── research-sources/         # platform research notes
├── skills/
│   ├── ads-strategy/             # flagship 5-agent strategy build
│   ├── ads-quick/                # 60-second snapshot
│   ├── ads-audience/             # persona generation
│   ├── ads-plan/                 # 11 industry templates
│   ├── ads-keywords/             # Google keyword research
│   ├── ads-competitor/           # competitor intelligence
│   ├── ads-copy/                 # platform-native copy
│   ├── ads-hooks/                # 20 scroll-stopping hooks
│   ├── ads-video/                # 15s/30s/60s video scripts
│   ├── ads-creative-brief/       # creative briefs for designers/editors
│   ├── ads-creative-audit/       # creative quality audit
│   ├── ads-funnel/               # TOFU/MOFU/BOFU architecture
│   ├── ads-budget/               # audit + allocation, two modes
│   ├── ads-testing/              # A/B testing plans
│   ├── ads-landing/              # audit + CRO rewrite
│   ├── ads-audit/                # full multi-platform orchestrator
│   ├── ads-google/ ads-meta/ …   # per-platform deep analysis
│   ├── ads-dna/ ads-create/ …    # creative pipeline
│   ├── ads-math/ ads-test/ …     # utilities
│   └── ads-report-pdf/           # PDF reporting
├── agents/
│   ├── audit-*.md                # 6 audit subagents
│   ├── creative-strategist.md    # + 3 creative pipeline agents
│   └── strategy-*.md             # 5 strategy subagents
├── scripts/                      # Python helpers (PDF, screenshots, image gen)
├── requirements.txt
├── install.sh / install.ps1
├── uninstall.sh / uninstall.ps1
├── README.md
├── CHANGELOG.md
├── LICENSE
└── NOTICES.md
```

---

## License

Released under the [MIT License](LICENSE). Use it, fork it, ship it.

## Credits

Portions of this work derive from prior MIT-licensed projects; see [NOTICES.md](NOTICES.md) for attribution.
