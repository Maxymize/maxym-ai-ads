<p align="center">
  <img src="../assets/banner.png" alt="maxym-ai-ads blueprint" width="100%">
</p>

<h1 align="center">🚀 Zero-to-Sales Blueprint</h1>

<p align="center">
  <strong>The complete playbook to go from "I have a product" to "my ads print money" — using only <code>maxym-ai-ads</code>.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Level-Beginner%20to%20Advanced-6E44FF?style=for-the-badge" alt="Level">
  <img src="https://img.shields.io/badge/Duration-8--12%20days%20prep%20%2B%20ongoing-success?style=for-the-badge" alt="Duration">
  <img src="https://img.shields.io/badge/Prerequisites-None-informational?style=for-the-badge" alt="Prerequisites">
</p>

<p align="center">
  <a href="#-two-ways-to-follow-this-blueprint">Guided vs Manual</a> ·
  <a href="#-after-the-plan-execute-it">Execution</a> ·
  <a href="#-overview">Overview</a> ·
  <a href="#-the-5-phases">5 Phases</a> ·
  <a href="#-phase-0--reality-check">Phase 0</a> ·
  <a href="#-phase-1--intelligence--strategy">Phase 1</a> ·
  <a href="#-phase-2--budget--funnel">Phase 2</a> ·
  <a href="#-phase-3--creative-production">Phase 3</a> ·
  <a href="#-phase-4--landing--test-prep">Phase 4</a> ·
  <a href="#-phase-5--launch-monitor-optimize">Phase 5</a> ·
  <a href="#-pitfalls">Pitfalls</a> ·
  <a href="#-quick-reference-card">Quick Ref</a>
</p>

---

## ⚡ Two ways to follow this Blueprint

> You don't have to follow this guide by hand. The plugin ships with a **guided mode** that runs the entire Blueprint for you, interactively.

<table>
<tr>
<td width="50%" valign="top">

### 🅰️ Guided mode (recommended)

Let the plugin drive. The skill asks you **one question at a time** (no copy-paste marathons) and then runs each of the 5 phases automatically, pausing only at phase boundaries and critical gates.

```shell
/ads blueprint                         # full flow
/ads blueprint <url>                   # pre-fills URL
/ads blueprint --resume                # resume an interrupted session
```

**Everything lives in a clean folder tree:**

```
ADS-Blueprint/
├── ADS-STRATEGY-REPORT.pdf
├── ADS-BLUEPRINT-REPORT.html
├── ADS-LAUNCH-CHECKLIST.md
└── Phase-0, Phase-1, … Phase-4/
```

**Plus — adaptive to your experience level:**

- 🎓 **Beginner**: every file has a `-Beginner.md` twin in plain language
- 📊 **Intermediate**: files end with a "📚 In plain English" section
- 🚀 **Expert**: technical files only, fastest output

✨ **Best for**: first-time users, non-technical founders, client deliverables, anyone who wants structure with minimum typing.

</td>
<td width="50%" valign="top">

### 🅱️ Manual mode (this document)

Read the rest of this document and run each command yourself, step by step. Same sequence, same outcome, full control at every checkpoint.

```shell
/ads quick <url>
/ads dna <url>
/ads audience <url>
/ads competitor <url>
# … and so on
```

**You get:**

- All the intermediate Markdown files
- Freedom to pause/adjust/re-run any step
- The same underlying logic as guided mode

✨ **Best for**: experienced users, teams running the workflow collaboratively, situations where you want to inspect/edit outputs between phases.

</td>
</tr>
</table>

> 💡 **Both paths produce identical results.** Pick guided if you're just getting started; pick manual when you want to fine-tune or learn the underlying commands.

---

## 🚀 After the plan: execute it

This document gives you the **plan**. Once the plan is ready, the companion skill `/ads blueprint-execution` takes you from **plan → launched campaigns → ongoing optimization**, without making you remember anything.

What it does:

- 📂 **Reads your `ADS-Blueprint/` folder** — knows exactly where you are
- 🔴 **Closes blocking gaps** — pixel missing, landing health <60, compliance — with step-by-step fixes
- 🛠️ **Pre-launch setup** — tracking, UTM templates, audience uploads, verification checks
- 🎯 **Campaign build** — click-by-click instructions for Meta, Google, LinkedIn, TikTok, Microsoft, Apple, with your actual copy/budgets/audiences pre-filled
- 🚀 **Launch day** — activation sequence and the 2h / 24h / 48h observation windows
- 📅 **Learning phase** — weekly check-ins, "do nothing for 14 days" enforcement
- 📊 **Bi-weekly optimization** — paste metrics / CSV / screenshot → the skill applies the 3× Kill Rule, the 20% Scaling Rule, and creative fatigue detection automatically, and gives you the exact edit instructions

```shell
/ads blueprint-execution              # auto-detect phase, show right menu
/ads blueprint-execution audit        # jump to bi-weekly audit
/ads blueprint-execution --fresh      # restart from gate check
```

**Outputs live in `ADS-Blueprint/Execution/`**:
- `live-dashboard.html` — interactive status, regenerated after every session
- `EXECUTION-LOG.md` — session-by-session diary of every action
- `meta-setup-instructions.md`, `google-setup-instructions.md`, etc. — re-readable without re-invoking the skill
- `live-data/` — where you drop CSV exports from ad platforms

> 💡 **The full loop**: `/ads blueprint` produces the plan. `/ads blueprint-execution` puts it into practice. They're designed to work together — same folder, same experience level, same language.

---

## 🎯 Overview

This is not a theoretical guide. It is the **exact command sequence** you should run in Claude Code to go from nothing → first paying customers from paid ads, with zero guesswork and zero wasted budget.

Every step maps to a specific `maxym-ai-ads` command. Every phase unlocks the next. Skip nothing, and the blueprint compresses **months of costly experimentation into 8–12 days of structured prep** plus a disciplined optimization loop.

```
┌─────────────┐   ┌──────────────┐   ┌─────────────┐   ┌──────────────┐   ┌──────────────┐
│             │   │              │   │             │   │              │   │              │
│  PHASE 0    │──▶│  PHASE 1     │──▶│  PHASE 2    │──▶│  PHASE 3     │──▶│  PHASE 4     │
│  Understand │   │  Intelligence│   │  Plan       │   │  Produce     │   │  Prep        │
│             │   │  & Strategy  │   │             │   │             │   │              │
└─────────────┘   └──────────────┘   └─────────────┘   └──────────────┘   └───────┬──────┘
                                                                                  │
                                                                                  ▼
                                                                          ┌──────────────┐
                                                                          │              │
                                                                          │  PHASE 5     │
                                                                          │  Launch &    │◀── Loop
                                                                          │  Optimize    │
                                                                          │              │
                                                                          └──────────────┘
```

### What you need before you start

| Requirement | Why it matters |
|---|---|
| ✅ A product (app, SaaS, info-product, e-commerce, service…) | Obvious. |
| ✅ A live URL (landing page / store / app store listing) | Almost every command starts from a URL. |
| ✅ Claude Code installed + `maxym-ai-ads` plugin | `/plugin marketplace add Maxymize/maxym-ai-ads` then `/plugin install maxym-ai-ads@maxym-plugins` |
| ✅ Ad budget — at least **$1,500–$3,000** for month 1 | Below $1,000/mo the signal is too weak to optimize. |
| ✅ 20 hours over 2 weeks for prep | Sequential, but interruptible. |

---

## 🗺️ The 5 Phases

| Phase | Duration | What you walk out with | Ad $ spent |
|---|---|---|---|
| **0 — Reality Check** | 1 day | Clear GO / NO-GO signal. Score 0–100. | $0 |
| **1 — Intelligence & Strategy** | 2–3 days | Personas, competitor gaps, chosen platforms, Ad Readiness Score. | $0 |
| **2 — Budget & Funnel Planning** | 1 day | Break-even CPA, 3 budget scenarios, funnel architecture. | $0 |
| **3 — Creative Production** | 3–5 days | Hooks, platform copy, video scripts, AI-generated images, brief for team. | $0 |
| **4 — Landing & Test Prep** | 1–2 days | Optimized landing page, A/B testing plan validated with statistical sample sizes. | $0 |
| **5 — Launch, Monitor, Optimize** | Continuous | Live campaigns, audited every 2 weeks, scaled with discipline. | Your budget |

**Pre-launch total: 8–12 days of focused work, $0 spent on ads.**

---

## ⚡ Phase 0 — Reality Check

> **Goal**: decide in 60 seconds whether you should spend a single dollar on ads.

Before any strategy, verify the fundamentals: is your value prop clear? Is there a visible offer? Is the CTA obvious? Are there trust signals?

### Commands

```shell
/maxym-ai-ads:ads-quick <your-product-url>
```

### What you get

A score from 0 to 100 across 5 dimensions:

```
  AD READINESS SCORE: XX/100 — [Verdict]

  SCORECARD:
  Value Proposition ... XX/20
  Offer Clarity ....... XX/20
  CTA Quality ......... XX/20
  Landing Page ........ XX/20
  Trust Signals ....... XX/20
```

### Decision gate

| Score | What to do |
|---|---|
| **80–100** | 🟢 Ready. Proceed to Phase 1 today. |
| **60–79** | 🟡 Almost ready. Fix the top 2 gaps first (1–2 weeks). |
| **40–59** | 🟠 Needs work. Significant improvements before ads will convert (2–4 weeks). |
| **20–39** | 🔴 Not ready. Landing/offer fundamentals are missing (4–8 weeks). |
| **0–19** | ⛔ Rebuild required. Do not spend on ads yet. |

> 💡 **Why this phase is non-negotiable**: the #1 way new advertisers burn budget is skipping this check. A broken landing page doesn't get better by pointing paid traffic at it — it just fails faster, more expensively.

---

## 🔍 Phase 1 — Intelligence & Strategy

> **Goal**: know exactly **who** you target, **where**, **against whom**, and with **what message**.

This is the phase that separates amateurs from pros. Amateurs start producing creative. Pros produce intelligence first.

### Commands (run in this order)

```shell
# 1. Extract your brand identity from the website
/maxym-ai-ads:ads-dna <url>
    # → brand-profile.json

# 2. Build detailed personas
/maxym-ai-ads:ads-audience <url>
    # → ADS-AUDIENCE.md — 5-7 personas with targeting parameters per platform

# 3. Map the competitive landscape and find gaps
/maxym-ai-ads:ads-competitor <url>
    # → ADS-COMPETITORS.md — competitive intelligence + "beat the competition" playbook

# 4. Pull the industry-specific strategic template
/maxym-ai-ads:ads-plan <industry>
    # industry = saas | ecommerce | local-service | b2b-enterprise | info-products |
    #            mobile-app | real-estate | healthcare | finance | agency | generic

# 5. THE FLAGSHIP — consolidate everything with 5 parallel agents
/maxym-ai-ads:ads-strategy <url>
    # → ADS-STRATEGY-[Company].md with composite Ad Readiness Score (0-100)
```

### The 5 parallel agents behind `ads-strategy`

```
                 ┌─────────────────────────────────────┐
                 │       /ads-strategy <url>           │
                 │   (spawns 5 subagents in parallel)  │
                 └───────────────┬─────────────────────┘
                                 │
        ┌────────────┬───────────┼───────────┬────────────┐
        ▼            ▼           ▼           ▼            ▼
   ┌────────┐   ┌────────┐  ┌────────┐  ┌────────┐   ┌─────────┐
   │Audience│   │Creative│  │ Funnel │  │Competi-│   │ Budget  │
   │  25%   │   │  20%   │  │  20%   │  │tive 15%│   │  20%    │
   └────────┘   └────────┘  └────────┘  └────────┘   └─────────┘
        │            │           │           │            │
        └────────────┴───────────┼───────────┴────────────┘
                                 ▼
                      ┌──────────────────────┐
                      │  Composite Score     │
                      │  0–100 + grade A-F   │
                      └──────────────────────┘
```

### Deliverable at the end of Phase 1

- **5–7 personas** with demographics, psychographics, pain points, targeting parameters per platform
- **Competitor analysis** with positioning gaps you can own
- **Platform selection** — you know exactly where to advertise and where NOT to
- **Industry template** with baseline benchmarks (CPC, CTR, CVR, ROAS) for your vertical
- **Composite strategy report** ready to hand to a client or CEO

---

## 💰 Phase 2 — Budget & Funnel

> **Goal**: know **exactly how much** you can pay to acquire a customer and still profit, and **how they'll move** through your funnel.

### Commands

```shell
# 6. Allocation plan with 3 scenarios + scaling roadmap $1K → $10K
/maxym-ai-ads:ads-budget <monthly-amount>
    # → ADS-BUDGET.md with Conservative / Balanced / Aggressive scenarios

# 7. Full TOFU / MOFU / BOFU funnel architecture
/maxym-ai-ads:ads-funnel <url>
    # → ADS-FUNNEL.md

# 8. The single most important number in all of paid ads
/maxym-ai-ads:ads-math
    # Calculate break-even CPA, target CPA, ROAS floor
```

### The Break-Even CPA formula

```
Break-Even CPA = AOV × Profit Margin %            (one-time purchase)
Break-Even CPA = LTV × Profit Margin %            (recurring revenue)

Example: AOV = $100, Profit Margin = 40%
  → Break-Even CPA = $40
  → You can spend up to $40 to acquire a customer and still break even
```

### Funnel structure blueprint

```
    ┌─────────────────────────────────────────────────────────┐
    │                       TOFU                              │
    │   Awareness · Video views · Brand · "They don't know    │
    │              you, they don't know they have a problem"  │
    └───────────────────────────┬─────────────────────────────┘
                                │
    ┌───────────────────────────▼─────────────────────────────┐
    │                       MOFU                              │
    │  Consideration · Lead magnets · Free trials · Education │
    │        "They know you, they're evaluating options"      │
    └───────────────────────────┬─────────────────────────────┘
                                │
    ┌───────────────────────────▼─────────────────────────────┐
    │                       BOFU                              │
    │   Conversion · Demo · Pricing · Offers · Close          │
    │         "They're comparing you against competitors"     │
    └───────────────────────────┬─────────────────────────────┘
                                │
    ┌───────────────────────────▼─────────────────────────────┐
    │                  RETARGETING / LTV                      │
    │  Upsell · Cross-sell · Loyalty · Referral               │
    │       "They bought, now maximize their lifetime value"  │
    └─────────────────────────────────────────────────────────┘
```

### The 3 budget scenarios

| Scenario | Platforms | Split | When to choose |
|---|---|---|---|
| **Conservative** | 1–2 | 60% BOFU · 25% MOFU · 15% TOFU | New advertiser, unproven offer |
| **Balanced** ⭐ | 2–3 | 30% TOFU · 35% MOFU · 25% BOFU · 10% retargeting | Moderate budget, some pixel data |
| **Aggressive** | 3+ | 35% TOFU · 30% MOFU · 20% BOFU · 15% retargeting | Proven funnel, strong margins, $5K+/mo |

> 💡 **Golden rule**: never advertise on **LinkedIn under $1,000/month** or on more than **2 platforms under $2,000/month**. You'll spread too thin to see signal.

---

## 🎨 Phase 3 — Creative Production

> **Goal**: produce every piece of creative material the campaigns will need.

### Commands (run in this order)

```shell
# 9. ONLY if Google Search is in your platform mix
/maxym-ai-ads:ads-keywords <url>
    # → ADS-KEYWORDS.md with match types, ad groups, negatives

# 10. 20 scroll-stopping hooks organized by psychological angle
/maxym-ai-ads:ads-hooks
    # → ADS-HOOKS.md

# 11. Platform-specific copy (repeat for every platform in your mix)
/maxym-ai-ads:ads-copy google
/maxym-ai-ads:ads-copy meta
/maxym-ai-ads:ads-copy linkedin
/maxym-ai-ads:ads-copy tiktok
/maxym-ai-ads:ads-copy youtube
    # → ADS-COPY-[Platform].md per platform

# 12. Video scripts in 3 durations
/maxym-ai-ads:ads-video <product>
    # → ADS-VIDEO-SCRIPTS.md with 15s, 30s, 60s breakdowns

# 13. Consolidate concepts + copy deck
/maxym-ai-ads:ads-create
    # → campaign-brief.md (the master document for production)

# 14. AI-generated ad images
/maxym-ai-ads:ads-generate
    # → ad-assets/ directory with platform-sized images
    # Requires banana-claude or alternative provider

# 15. Product photography in 5 styles (skip if purely digital product)
/maxym-ai-ads:ads-photoshoot
    # → 5 professional styles: Studio, Floating, Ingredient, In Use, Lifestyle

# 16. Creative brief for designers / editors (skip if working solo)
/maxym-ai-ads:ads-creative-brief <product>
    # → ADS-CREATIVE-BRIEF.md
```

### The creative production pipeline

```
     brand-profile.json          ADS-STRATEGY report
            │                             │
            └──────────┬──────────────────┘
                       ▼
              ┌─────────────────┐
              │   ads-create    │──────▶ campaign-brief.md (master doc)
              └─────────────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
    ┌─────────┐  ┌──────────┐  ┌──────────┐
    │  hooks  │  │   copy   │  │  video   │
    └─────────┘  └──────────┘  └──────────┘
          │            │            │
          └────────────┼────────────┘
                       ▼
              ┌─────────────────┐
              │  ads-generate   │──────▶ ad-assets/
              └─────────────────┘         (platform-sized images)
                       │
                       ▼
              ┌─────────────────┐
              │ ads-photoshoot  │──────▶ 5 product photos
              └─────────────────┘         (optional)
```

### Creative diversity rule (Meta Andromeda)

Meta suppresses ads with >60% similarity. You need **at least 10 genuinely distinct creatives** before launching on Meta — different hooks, different visuals, different angles, not just color swaps. `/ads-creative-audit` checks this for you after launch.

---

## 🧪 Phase 4 — Landing & Test Prep

> **Goal**: make sure your landing page doesn't waste the paid traffic you're about to send, and plan exactly what you'll A/B test in month 1.

### Commands

```shell
# 17. Technical audit + CRO rewrite of your landing page
/maxym-ai-ads:ads-landing <url>
    # → ADS-LANDING.md with BEFORE/AFTER rewrites and priority action plan

# 18. Full A/B testing plan for month 1
/maxym-ai-ads:ads-testing <campaign-name>
    # → ADS-TESTING-PLAN.md

# 19. Statistical validation — does each test have enough sample size?
/maxym-ai-ads:ads-test
    # Significance, duration, minimum detectable effect
```

### Why the landing page matters MORE than the ads

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   Great ads + broken landing = wasted money             │
│   OK ads + great landing = profitable campaigns         │
│                                                         │
│   The landing page is where 50%+ of success happens.    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

For every 1 second of landing page delay, conversion drops **~7%**. The landing audit catches:

- Message match (ad headline vs page H1)
- Page speed (LCP, INP, CLS thresholds)
- Mobile experience (≥48×48px tap targets, ≥16px body text)
- Trust signal placement
- Form friction (every extra field = –7–10% completion)
- Consent banner blocking the CTA (common EU/EEA issue)

---

## 🚀 Phase 5 — Launch, Monitor, Optimize

> **Goal**: launch, don't panic, and improve with discipline.

### Launch week — the "do nothing" rule

> ⚠️ **Weeks 1–2 are learning phase**. Do NOT touch your campaigns. Do NOT change budgets. Do NOT pause ads that look "bad". The platforms need 50+ conversions per campaign to exit learning phase. If you edit during learning, you reset the clock.

### Bi-weekly optimization cycle (starting week 3)

```shell
# 20. Full multi-platform audit — 6 agents in parallel
/maxym-ai-ads:ads-audit
    # → Ads Health Score 0-100 + action plan (Critical / High / Medium / Low)

# 21. Per-platform deep dives for platforms you're actually spending on
/maxym-ai-ads:ads-google
/maxym-ai-ads:ads-meta
/maxym-ai-ads:ads-linkedin
/maxym-ai-ads:ads-tiktok
/maxym-ai-ads:ads-microsoft
/maxym-ai-ads:ads-youtube
/maxym-ai-ads:ads-apple

# 22. Detect creative fatigue BEFORE it kills CTR
/maxym-ai-ads:ads-creative-audit

# 23. Audit budget with 3× Kill Rule + 20% Scaling Rule (no amount = audit mode)
/maxym-ai-ads:ads-budget
```

### Monthly cadence

```shell
# 24. Re-check competitive landscape (new entrants, new creatives)
/maxym-ai-ads:ads-competitor <url>

# 25. Client-ready PDF report
/maxym-ai-ads:ads-report-pdf
    # → ADS-STRATEGY-REPORT.pdf
```

### The 3 sacred rules of optimization

| Rule | What it means | Why |
|---|---|---|
| **3× Kill Rule** | Pause any campaign where CPA > 3× target | Prevents continuous bleeding |
| **20% Scaling Rule** | Never increase budget by more than +20% every 3–5 days | Preserves algorithm learning |
| **Learning-phase protection** | No edits during the first 50 conversions | Prevents resetting the algorithm |

### Optimization loop visualized

```
       ┌────────────────────────┐
       │    Week 1-2: Launch    │
       │   (do not touch)       │
       └───────────┬────────────┘
                   │
                   ▼
       ┌────────────────────────┐
   ┌──▶│   Week 3: First audit  │
   │   │    ads-audit           │
   │   └───────────┬────────────┘
   │               │
   │               ▼
   │   ┌────────────────────────┐
   │   │   Apply 3× Kill Rule   │
   │   │   Scale winners +20%   │
   │   └───────────┬────────────┘
   │               │
   │               ▼
   │   ┌────────────────────────┐
   │   │  Week 5: Re-audit      │
   │   │  + ads-creative-audit  │
   │   └───────────┬────────────┘
   │               │
   │               ▼
   │   ┌────────────────────────┐
   │   │  Refresh creatives if  │
   │   │  fatigue detected      │
   └───┴───────────┬────────────┘
                   │
                   ▼
         (continue every 2 weeks)
```

---

## ⚠️ Pitfalls

The 6 most expensive mistakes, in order of frequency:

### 1. Skipping Phase 0 (`ads-quick`)

**Symptom**: burning $3K–$5K in 2 weeks with no conversions.
**Cause**: the landing page or offer was broken from day one.
**Fix**: always run `ads-quick` first. Always.

### 2. Starting creative production before strategy

**Symptom**: beautiful ads, zero conversions.
**Cause**: you made ads for the wrong persona on the wrong platform.
**Fix**: strategy (Phase 1) before creative (Phase 3). No exceptions.

### 3. Not knowing your break-even CPA

**Symptom**: "the ads are working, I think?" — no real way to judge.
**Cause**: skipped `ads-math`.
**Fix**: calculate break-even CPA **before launch**. It's the single most important number in the entire funnel.

### 4. Editing campaigns during learning phase

**Symptom**: CPA skyrockets, algorithm seems "broken".
**Cause**: you paused ads / changed budgets before the platform got its 50 conversions.
**Fix**: 14 days of no-touch. If an ad looks bad in week 1, **it's too early to tell**.

### 5. Scaling too aggressively

**Symptom**: campaign was profitable at $50/day, doubling to $100/day tanked performance.
**Cause**: you violated the 20% rule.
**Fix**: max +20% every 3–5 days. Let the algorithm re-optimize between steps.

### 6. Not refreshing creatives

**Symptom**: after 2–3 weeks CTR drops 30%+, CPA rises.
**Cause**: creative fatigue — your audience has seen your ads too many times.
**Fix**: `ads-creative-audit` every 2 weeks. Rotate in 3–5 new creatives per ad set monthly.

---

## 📋 Quick Reference Card

Print this. Pin it to your wall.

```
╔══════════════════════════════════════════════════════════════════╗
║                  MAXYM-AI-ADS BLUEPRINT                          ║
║                  Zero → First Sales in 8-12 days                 ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  ⚡ GUIDED MODE (run the whole blueprint automatically):         ║
║     /maxym-ai-ads:ads-blueprint                                  ║
║                                                                  ║
║  — or — follow each phase manually below:                        ║
║                                                                  ║
║  PHASE 0 — Reality Check (1 day)                                 ║
║   └─ /maxym-ai-ads:ads-quick <url>                               ║
║                                                                  ║
║  PHASE 1 — Intelligence & Strategy (2-3 days)                    ║
║   ├─ /maxym-ai-ads:ads-dna <url>                                 ║
║   ├─ /maxym-ai-ads:ads-audience <url>                            ║
║   ├─ /maxym-ai-ads:ads-competitor <url>                          ║
║   ├─ /maxym-ai-ads:ads-plan <industry>                           ║
║   └─ /maxym-ai-ads:ads-strategy <url>          ⭐ FLAGSHIP       ║
║                                                                  ║
║  PHASE 2 — Budget & Funnel (1 day)                               ║
║   ├─ /maxym-ai-ads:ads-budget <amount>                           ║
║   ├─ /maxym-ai-ads:ads-funnel <url>                              ║
║   └─ /maxym-ai-ads:ads-math              ⭐ BREAK-EVEN CPA       ║
║                                                                  ║
║  PHASE 3 — Creative Production (3-5 days)                        ║
║   ├─ /maxym-ai-ads:ads-keywords <url>    (Google Search only)    ║
║   ├─ /maxym-ai-ads:ads-hooks                                     ║
║   ├─ /maxym-ai-ads:ads-copy <platform>   (per platform)          ║
║   ├─ /maxym-ai-ads:ads-video <product>                           ║
║   ├─ /maxym-ai-ads:ads-create                                    ║
║   ├─ /maxym-ai-ads:ads-generate                                  ║
║   ├─ /maxym-ai-ads:ads-photoshoot        (if physical/packshot)  ║
║   └─ /maxym-ai-ads:ads-creative-brief    (if external team)      ║
║                                                                  ║
║  PHASE 4 — Landing & Test Prep (1-2 days)                        ║
║   ├─ /maxym-ai-ads:ads-landing <url>                             ║
║   ├─ /maxym-ai-ads:ads-testing <campaign>                        ║
║   └─ /maxym-ai-ads:ads-test                                      ║
║                                                                  ║
║   ════════ 🚀 LAUNCH — DO NOT TOUCH FOR 14 DAYS ════════         ║
║                                                                  ║
║  PHASE 5 — Optimize Loop (every 2 weeks)                         ║
║   ├─ /maxym-ai-ads:ads-audit                                     ║
║   ├─ /maxym-ai-ads:ads-<platform>        (per active platform)   ║
║   ├─ /maxym-ai-ads:ads-creative-audit                            ║
║   └─ /maxym-ai-ads:ads-budget            (no amount = audit)     ║
║                                                                  ║
║  Monthly:                                                        ║
║   ├─ /maxym-ai-ads:ads-competitor <url>                          ║
║   └─ /maxym-ai-ads:ads-report-pdf                                ║
║                                                                  ║
║  THE 3 SACRED RULES                                              ║
║   1. 3× Kill Rule — pause if CPA > 3× target                     ║
║   2. 20% Rule — max +20% budget every 3-5 days                   ║
║   3. No edits during learning phase (first 50 conversions)       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🎯 What good looks like at the end

After 30 days of following this blueprint, you should have:

- ✅ An **Ads Health Score ≥ 75** across your active platforms
- ✅ **CPA below break-even** on at least one platform/campaign
- ✅ A **repeatable creative refresh cycle** (new creatives every 2 weeks)
- ✅ A **documented A/B test pipeline** (you know what you're testing next)
- ✅ **Client-ready monthly PDF reports** via `/ads-report-pdf`
- ✅ A system, not a guess

After 90 days, you should be **scaling a profitable campaign** — carefully, using the 20% rule — not gambling with your budget.

---

## 🚀 Ready to start?

<table>
<tr>
<td align="center" width="50%">

### Want it guided?

Run this one command and follow along:

```shell
/ads blueprint
```

The skill will ask a short questionnaire, then run everything you just read above — automatically.

</td>
<td align="center" width="50%">

### Want to do it manually?

Start with Phase 0:

```shell
/ads quick https://your-site.com
```

Then follow the commands in each phase of this document.

</td>
</tr>
</table>

---

## 💬 Get help

- 🐛 Issues & feature requests → [github.com/Maxymize/maxym-ai-ads/issues](https://github.com/Maxymize/maxym-ai-ads/issues)
- 📘 Plugin README → [README.md](../README.md)
- 📝 Full changelog → [CHANGELOG.md](../CHANGELOG.md)

<p align="center">
  <strong>Built by <a href="https://github.com/Maxymize">@Maxymize</a> · Released under the <a href="../LICENSE">MIT License</a></strong>
</p>
