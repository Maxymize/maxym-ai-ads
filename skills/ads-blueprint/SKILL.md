---
name: ads-blueprint
description: "Guided, interactive end-to-end paid advertising blueprint. Walks the user through all 5 phases (Reality Check → Intelligence → Budget/Funnel → Creative → Landing/Test → Launch → Optimize) using checkpoint-style automation: asks an initial questionnaire, then runs each phase automatically, pausing only at phase boundaries and critical decision gates. Produces a final recap, client-ready PDF, and interactive HTML report. Use when user says start blueprint, guide me through ads, full ads setup, zero to sales, complete ad strategy from scratch, walk me through paid ads, or simply invokes /ads-blueprint."
user-invokable: true
---

<!-- maxym-ai-ads | ads-blueprint v1.0 -->

# Zero-to-Sales Guided Blueprint

This is the flagship **guided experience** of `maxym-ai-ads`. Instead of asking the user to remember 25 commands in the right order, this skill orchestrates the entire Zero-to-Sales Blueprint interactively: collects context once, runs each phase in sequence, pauses at phase boundaries for confirmation, blocks on critical gates, and produces a PDF + HTML deliverable at the end.

**Argument handling**:
- `/ads-blueprint` → full questionnaire
- `/ads-blueprint <url>` → pre-fills URL, asks remaining questions
- `/ads-blueprint --resume` → resumes from the last incomplete phase (if `ADS-BLUEPRINT-STATE.json` exists in CWD)

---

## Automation Model

**Checkpoint-per-phase**:
- Run all commands inside a phase automatically
- Pause at phase boundaries ("Phase N complete. Proceed to Phase N+1? / review / skip / stop")
- Block only on critical gates (Phase 0 score <40, Phase 2 break-even CPA impossible)

**Failure handling**:
- Non-critical failure → continue with a warning in the final recap
- Critical gate failure → stop and surface an actionable remediation plan

**State**: persist progress to `ADS-BLUEPRINT-STATE.json` in the current working directory so the user can resume with `--resume`.

---

## Initial Intake Questionnaire

If no `--resume` flag, always start here. Ask **all** questions in a single message to minimize back-and-forth. If the user provided a URL as argument, skip question 1.

```
Before we start, I need a few things (answer inline, one line each):

1. Product URL:                         [e.g. https://mysite.com]
2. Product type:                        [SaaS / E-commerce / Info-product / Mobile app / Local service / B2B service / Other]
3. Monthly ad budget (USD):             [minimum recommended: $1,500]
4. Primary goal:                        [Sales / Leads / Trials / Installs / Calls / Brand]
5. Industry:                            [saas | ecommerce | local-service | b2b-enterprise | info-products | mobile-app | real-estate | healthcare | finance | agency | generic]
6. Creative production capacity:        [solo / designer-team / external-agency / none-yet]
7. Existing platform experience:        [none / some / experienced]
8. Platforms to INCLUDE or EXCLUDE:     [e.g. "+google +meta -linkedin" or "any"]
9. Output language:                     [english / italian / spanish / french / german / portuguese / dutch / other]
10. Timeline urgency:                   [launch-in-1-week / standard-2-weeks / no-rush]
```

Parse the answers into a structured context object. Write it to `ADS-BLUEPRINT-STATE.json` immediately so the user can resume later.

**Validation rules before proceeding**:
- Budget < $1,000/mo → warn: "Below $1,000/mo produces signal too weak to optimize. Want to adjust, or proceed anyway?"
- Budget < $500/mo → block: "This workflow is designed for at least $500/mo. Please increase or cancel."
- Empty URL → block: "I need a live product URL to work. Please provide one."
- Unknown industry → fall back to `generic` and warn.

After validation, present the roadmap with time estimates:

```
Your Blueprint Roadmap:

  Phase 0 — Reality Check ............. ~2 min
  Phase 1 — Intelligence & Strategy ... ~15-20 min   (5 parallel subagents)
  Phase 2 — Budget & Funnel ........... ~5-8 min
  Phase 3 — Creative Production ....... ~20-30 min
  Phase 4 — Landing & Test Prep ....... ~8-10 min
  Phase 5 — Launch Checklist + Reports. ~5 min

  Total time to completion: ~60-75 minutes of command execution.

  You'll confirm at each phase boundary. Ready to start Phase 0?  [yes / no]
```

---

## Phase 0 — Reality Check

**Automation**: run one command, evaluate the score, gate the rest of the workflow.

### Command sequence
```
Run: /ads-quick <url>
```

### Decision gate (CRITICAL)

| Score | Action |
|---|---|
| **80-100** | ✅ Proceed to Phase 1 automatically |
| **60-79** | ⚠️ Warn, list top 2 gaps, ask: "Fix first (recommended) or proceed?" |
| **40-59** | 🟠 Strong warn, list all gaps, ask explicit confirmation to proceed anyway |
| **<40** | ⛔ **BLOCK**. Print the 3 critical issues and the remediation steps. Do NOT run anything else. Offer: "Fix these, then re-run `/ads-blueprint --resume`." |

### State update
Write Phase 0 result to `ADS-BLUEPRINT-STATE.json`:
```json
{
  "phase_0": {
    "completed": true,
    "score": 78,
    "verdict": "Almost Ready",
    "top_gaps": ["Pricing not visible", "4 competing CTAs above fold"]
  }
}
```

### Checkpoint prompt
```
Phase 0 complete. Score: 78/100 — Almost Ready.
Top 2 gaps: [list from ads-quick output]

Options:
  • [proceed]  — continue to Phase 1 now, accept the gaps as known risk
  • [fix]      — I'll pause; you fix the gaps, then `/ads-blueprint --resume`
  • [review]   — show me the full Phase 0 report again
  • [stop]     — exit the blueprint workflow

Which?
```

---

## Phase 1 — Intelligence & Strategy

**Automation**: run 5 commands in sequence. Each produces a Markdown deliverable. At the end of the phase, show a summary of files generated.

### Command sequence (execute in this order, use context from Phase 0)

```
1. /ads-dna <url>              → brand-profile.json
2. /ads-audience <url>         → ADS-AUDIENCE.md
3. /ads-competitor <url>       → ADS-COMPETITORS.md
4. /ads-plan <industry>        → ADS-PLAN-[industry].md
5. /ads-strategy <url>         → ADS-STRATEGY-[Company].md (FLAGSHIP, 5 parallel subagents)
```

### Between commands
Show a one-line progress indicator:
```
  Phase 1 — Intelligence & Strategy
    [✓] Brand DNA extracted
    [✓] 7 personas built
    [✓] Competitor intelligence complete (4 competitors)
    [✓] SaaS industry template loaded
    [⏳] Running /ads-strategy (5 parallel agents)...
```

### Non-critical failure handling
If any one of the first 4 commands fails (network timeout, malformed URL response, etc.), **continue** with the remaining commands and record the failure in `ADS-BLUEPRINT-STATE.json` under `warnings[]`. Only `/ads-strategy` failure is phase-critical — if that fails, pause and ask the user for a retry or skip.

### Checkpoint prompt
```
Phase 1 complete. Files generated:
  • brand-profile.json
  • ADS-AUDIENCE.md (7 personas)
  • ADS-COMPETITORS.md (4 competitors analyzed)
  • ADS-PLAN-saas.md
  • ADS-STRATEGY-[Company].md (Ad Readiness Score: 84/100)

Options:
  • [proceed]   — continue to Phase 2 (Budget & Funnel)
  • [review]    — let me open one of the files
  • [regenerate] — re-run a specific command with different inputs
  • [stop]      — exit (state saved, resume later)
```

---

## Phase 2 — Budget & Funnel

**Automation**: 3 commands, 1 critical decision gate on break-even CPA viability.

### Command sequence
```
1. /ads-budget <monthly-amount>   → ADS-BUDGET.md (3 scenarios)
2. /ads-funnel <url>              → ADS-FUNNEL.md
3. /ads-math                      → calculates break-even CPA, target CPA, ROAS floor
```

### Decision gate (CRITICAL)

After `/ads-math` computes the break-even CPA, compare it to the platform benchmarks from `references/benchmarks.md` for the user's industry:

| Condition | Action |
|---|---|
| Break-even CPA ≥ 1.2× industry-average CPA | ✅ Healthy margin, proceed |
| Break-even CPA between 0.8× and 1.2× | ⚠️ Tight margin warning — continue but flag as risk |
| Break-even CPA < 0.8× industry-average CPA | ⛔ **BLOCK**. Surface message below. |

**Block message (when break-even too tight)**:
```
⛔ Break-even analysis blocked this workflow.

  Your break-even CPA:        $[X]
  Industry-average CPA:       $[Y]   (source: references/benchmarks.md)
  Viability threshold (0.8×): $[Z]

Your margins don't leave room for profitable paid ads at typical industry CPA.
You need one of:
  1. Higher AOV or LTV (upsells, subscription, bundles)
  2. Better margins (cost reduction, premium tier)
  3. A niche with materially lower CPA (different industry angle)

Blueprint paused. Re-run with `/ads-blueprint --resume` after adjusting unit economics.
```

### Checkpoint prompt
```
Phase 2 complete. Files generated:
  • ADS-BUDGET.md (Conservative / Balanced / Aggressive scenarios)
  • ADS-FUNNEL.md (TOFU/MOFU/BOFU architecture)

Key numbers:
  • Break-even CPA: $[X]
  • Target CPA:     $[Y]   (50% of break-even, conservative)
  • ROAS floor:     [Z]×
  • Recommended monthly budget split: [platform breakdown]

Options: [proceed] / [review] / [adjust-budget] / [stop]
```

---

## Phase 3 — Creative Production

**Automation**: up to 8 commands, skip the non-applicable ones based on context.

### Conditional logic (decide which commands to run)

| Command | Run when |
|---|---|
| `/ads-keywords <url>` | Google Search is in platform mix |
| `/ads-hooks` | Always |
| `/ads-copy <platform>` | Run once per platform in the active mix (Google, Meta, LinkedIn, TikTok, YouTube, Pinterest) |
| `/ads-video <product>` | Always (video scripts useful even for still-image campaigns) |
| `/ads-create` | Always (consolidation step) |
| `/ads-generate` | User has image provider OR `creative_production == "solo"` |
| `/ads-photoshoot` | Product has physical form factor OR intake answer = e-commerce / mobile-app |
| `/ads-creative-brief <product>` | `creative_production == "designer-team"` OR `"external-agency"` |

### Before running, show the plan
```
Phase 3 plan (based on your context: solo, Google+Meta, $5K/mo, SaaS):

  [✓] ads-keywords (Google Search included)
  [✓] ads-hooks (20 scroll-stoppers)
  [✓] ads-copy google
  [✓] ads-copy meta
  [✓] ads-video (15s / 30s / 60s)
  [✓] ads-create (master brief consolidation)
  [✓] ads-generate (AI images, ~10 variants per platform)
  [ ] ads-photoshoot — SKIPPED (SaaS, no physical product)
  [ ] ads-creative-brief — SKIPPED (solo production)

Proceed? [yes / customize / stop]
```

### Execute with progress indicator
```
  Phase 3 — Creative Production
    [✓] ads-keywords      — 147 keywords, 12 ad groups, 58 negatives
    [✓] ads-hooks         — 20 hooks across 5 psychological angles
    [✓] ads-copy google   — 18 RSA headlines, 12 PMax assets
    [✓] ads-copy meta     — 10 primary texts, 8 headlines, 6 descriptions
    [⏳] ads-video        — generating 15s / 30s / 60s scripts...
    [ ] ads-create
    [ ] ads-generate
```

### Non-critical failure handling
- `ads-generate` failure (no image provider configured): show the configuration guide and continue — the user can run it separately later
- All other failures: warn and continue

### Checkpoint prompt
```
Phase 3 complete. Files generated:
  • ADS-KEYWORDS.md (147 keywords, 12 ad groups)
  • ADS-HOOKS.md (20 hooks)
  • ADS-COPY-Google.md, ADS-COPY-Meta.md
  • ADS-VIDEO-SCRIPTS.md (15s / 30s / 60s)
  • campaign-brief.md (master brief)
  • ad-assets/ directory (if ads-generate ran)

Options: [proceed] / [review] / [regenerate-single-file] / [stop]
```

---

## Phase 4 — Landing & Test Prep

**Automation**: 3 commands, no blocking gates.

### Command sequence
```
1. /ads-landing <url>                      → ADS-LANDING.md (audit + rewrite)
2. /ads-testing "[campaign-name]"          → ADS-TESTING-PLAN.md
3. /ads-test                               → statistical validation of each test
```

### Derive `campaign-name` automatically
Use the Company name from `brand-profile.json` + month/year. Example: `"TiimoApp-Launch-Apr2026"`.

### Warning gate (non-blocking)

After `/ads-landing`, if the landing page Health Score < 60:
```
⚠️ Landing page health: 56/100

  Your ads will convert worse than they should. Top 3 fixes identified:
  1. [fix 1]
  2. [fix 2]
  3. [fix 3]

  Recommendation: pause the Blueprint, apply fixes, resume with `--resume`.
  You can also proceed and fix the landing later (not recommended).

Options: [fix-first] / [proceed-anyway] / [stop]
```

### Checkpoint prompt
```
Phase 4 complete. Files generated:
  • ADS-LANDING.md (audit + CRO rewrite, score: 78/100)
  • ADS-TESTING-PLAN.md (8 tests prioritized)

Options: [proceed] / [review] / [stop]

Next: Phase 5 will generate the final deliverables (PDF + HTML + launch checklist).
```

---

## Phase 5 — Launch Checklist + Final Reports

**Automation**: generates the 3 output artifacts and prints the launch checklist.

### Step 5.1 — PDF report
```
Run: /ads-report-pdf
```
Produces `ADS-STRATEGY-REPORT.pdf` in the CWD. Uses `scripts/generate_ads_pdf.py` behind the scenes with ReportLab.

### Step 5.2 — HTML report (NEW — specific to this skill)

Generate a standalone interactive HTML report at `ADS-BLUEPRINT-REPORT.html`. The HTML template lives at `skills/ads-blueprint/assets/report-template.html`. The skill:

1. Reads the HTML template (self-contained, all CSS + JS inline, no external dependencies)
2. Loads `ADS-BLUEPRINT-STATE.json` (progress + all phase results)
3. Loads each phase's Markdown output files if present
4. Performs token substitution (see **HTML Template Variables** below)
5. Converts Markdown sections to HTML snippets for the interactive view
6. Writes `ADS-BLUEPRINT-REPORT.html` to the CWD

The output file opens in any browser with zero dependencies. It is designed to be sharable, printable, and presentable to a client.

#### HTML Template Variables (substitution tokens)

Use double-brace Jinja-style syntax. The skill replaces each token before writing the file.

| Token | Source | Example |
|---|---|---|
| `{{COMPANY_NAME}}` | `brand-profile.json > company.name` | "Tiimo" |
| `{{COMPANY_URL}}` | intake.url | "https://www.tiimoapp.com/" |
| `{{INDUSTRY}}` | intake.industry | "SaaS" |
| `{{MONTHLY_BUDGET}}` | intake.budget | "$5,000" |
| `{{PRIMARY_GOAL}}` | intake.goal | "Trials" |
| `{{GENERATED_AT}}` | current timestamp (ISO) | "2026-04-21T18:42:00Z" |
| `{{READINESS_SCORE}}` | phase_0.score | "78" |
| `{{READINESS_VERDICT}}` | phase_0.verdict | "Almost Ready" |
| `{{STRATEGY_SCORE}}` | ads-strategy composite score | "84" |
| `{{BREAK_EVEN_CPA}}` | phase_2.break_even_cpa | "$40" |
| `{{TARGET_CPA}}` | phase_2.target_cpa | "$20" |
| `{{LANDING_SCORE}}` | phase_4.landing_health_score | "78" |
| `{{TOP_3_STRENGTHS}}` | HTML `<ul>` with 3 `<li>` from phase_0.strengths | |
| `{{TOP_3_GAPS}}` | HTML `<ul>` with 3 `<li>` from phase_0.gaps | |
| `{{PERSONAS_CARDS}}` | rendered HTML cards (loop personas from ADS-AUDIENCE.md) | |
| `{{PLATFORM_ALLOCATION}}` | HTML pie-chart-like bars (from ADS-BUDGET.md) | |
| `{{FUNNEL_DIAGRAM}}` | static TOFU/MOFU/BOFU stages filled with user data | |
| `{{COMPETITOR_TABLE}}` | HTML table rendered from ADS-COMPETITORS.md | |
| `{{CREATIVE_SAMPLES}}` | grid of hooks + copy snippets + video script highlights | |
| `{{TESTING_PLAN_TABLE}}` | sortable table from ADS-TESTING-PLAN.md | |
| `{{LAUNCH_CHECKLIST}}` | checkbox list (pre-launch + launch-day + week-1 + week-2) | |
| `{{ACTION_PLAN_90D}}` | quarterly roadmap table (month 1, 2, 3) | |
| `{{OUTPUT_LANG}}` | intake.language | "english" |

#### Fallback if a file is missing
If a phase output is missing (e.g., user stopped before Phase 4), render the corresponding HTML section with a muted placeholder: "Phase not completed — run `/ads-blueprint --resume` to finish."

### Step 5.3 — Launch checklist (markdown)

Write `ADS-LAUNCH-CHECKLIST.md` with tasks organized into 4 groups. Derive items dynamically based on platforms chosen in intake.

```markdown
# Launch Checklist — [Company]

## 🔧 Pre-Launch (before turning on any campaign)
- [ ] Verify pixel / Conversions API installed on site
- [ ] Verify Consent Mode V2 (if EU/EEA traffic)
- [ ] Upload audience lists (Customer Match / Matched Audiences)
- [ ] Configure UTM parameter template per platform
- [ ] Set up conversion tracking events (ideally enhanced conversions)
- [ ] Configure auto-apply recommendations to OFF (you decide, not the platform)
- [ ] Attach negative keyword lists (Google)
- [ ] Set account-level Special Ad Categories (if applicable)
- [ ] Verify budget alerts and daily caps

## 🚀 Launch Day
- [ ] Launch in order: Search (highest intent) → Retargeting → Prospecting
- [ ] Start each campaign at recommended daily budget (see ADS-BUDGET.md)
- [ ] Set bidding strategies per ADS-STRATEGY.md (not platform defaults)
- [ ] Schedule a check-in for 48h later (just to verify delivery, no edits)

## 📅 Week 1 (learning phase — DO NOT EDIT)
- [ ] Day 2: verify ads are serving and pixel fires are clean
- [ ] Day 4: sanity check — any policy violations or disapprovals?
- [ ] Day 7: Ads Health Score quick-check via `/ads-audit` (observe only)
- [ ] Do NOT change bids, budgets, or creative this week

## 📅 Week 2 (learning phase continues)
- [ ] Day 10: observe, do not edit
- [ ] Day 14: learning phase should be complete; run `/ads-audit` for first review

## 📅 Week 3+ (optimization loop starts)
- [ ] Apply 3× Kill Rule on any CPA ≥ 3× target
- [ ] Apply 20% Scaling Rule on winners
- [ ] Run `/ads-creative-audit` weekly for fatigue detection
- [ ] Run `/ads-audit` every 2 weeks
- [ ] Run `/ads-competitor <url>` monthly
- [ ] Run `/ads-report-pdf` monthly for stakeholder reporting
```

### Final summary (printed in terminal)

```
═══════════════════════════════════════════════════════════
  🎉 BLUEPRINT COMPLETE — [Company]
═══════════════════════════════════════════════════════════

  Ad Readiness Score:    84/100 (Grade B)
  Break-even CPA:        $40
  Target CPA:            $20
  Landing Health:        78/100

  Files generated in current directory:
    📄 ADS-STRATEGY-REPORT.pdf        ← client-ready deliverable
    🌐 ADS-BLUEPRINT-REPORT.html      ← open in any browser
    ✅ ADS-LAUNCH-CHECKLIST.md        ← your pre/post-launch tasks

  Supporting files:
    • brand-profile.json
    • ADS-AUDIENCE.md
    • ADS-COMPETITORS.md
    • ADS-PLAN-saas.md
    • ADS-STRATEGY-[Company].md
    • ADS-BUDGET.md
    • ADS-FUNNEL.md
    • ADS-KEYWORDS.md
    • ADS-HOOKS.md
    • ADS-COPY-*.md
    • ADS-VIDEO-SCRIPTS.md
    • campaign-brief.md
    • ADS-LANDING.md
    • ADS-TESTING-PLAN.md
    • ad-assets/ (AI-generated images)

  Recommended next steps:
    1. Review ADS-STRATEGY-REPORT.pdf with stakeholders
    2. Address any ADS-LANDING.md recommendations before launch
    3. Complete the Pre-Launch section of ADS-LAUNCH-CHECKLIST.md
    4. Launch per the 3 sacred rules (3× Kill · 20% Scaling · No edits in learning)

  Every 2 weeks after launch, run:  /ads-audit

═══════════════════════════════════════════════════════════
```

---

## Resume Behavior (`--resume` flag)

When invoked with `--resume`:
1. Read `ADS-BLUEPRINT-STATE.json` from CWD
2. If missing → error: "No saved blueprint in this directory. Start fresh with `/ads-blueprint`."
3. Identify the last completed phase
4. Print a 3-line recap: "Resuming from Phase N. Context loaded. Ready? [yes/no]"
5. Continue from the next incomplete phase

---

## State File Format (`ADS-BLUEPRINT-STATE.json`)

```json
{
  "version": "1.0",
  "started_at": "2026-04-21T18:00:00Z",
  "last_updated": "2026-04-21T19:30:00Z",
  "intake": {
    "url": "https://mysite.com",
    "product_type": "SaaS",
    "budget": 5000,
    "goal": "Trials",
    "industry": "saas",
    "creative_production": "solo",
    "experience": "some",
    "platforms_include": ["google", "meta"],
    "platforms_exclude": ["linkedin"],
    "language": "english",
    "urgency": "standard-2-weeks"
  },
  "phases": {
    "phase_0": {"completed": true, "score": 78, "verdict": "Almost Ready", "gaps": [...]},
    "phase_1": {"completed": true, "files": [...], "strategy_score": 84},
    "phase_2": {"completed": true, "break_even_cpa": 40, "target_cpa": 20},
    "phase_3": {"completed": false, "failed_on": "ads-generate", "warnings": [...]},
    "phase_4": {"completed": false},
    "phase_5": {"completed": false}
  },
  "warnings": [
    {"phase": 3, "message": "ads-generate skipped — no image provider configured"}
  ]
}
```

---

## Language Handling

If `intake.language != "english"`, localize:
- All user-facing questions in the intake
- All checkpoint prompts
- The final summary
- Section headers in `ADS-LAUNCH-CHECKLIST.md`
- HTML report labels (data remains in source language)

PDF report content follows `/ads-report-pdf` language (already supported).

For Italian specifically, use the exact phrasing the user sees in the Blueprint document (`docs/BLUEPRINT-ZERO-TO-SALES.md` section headings translated as needed) for consistency.

---

## Invocation examples (user perspective)

```shell
# Full interactive flow from scratch
/maxym-ai-ads:ads-blueprint

# Pre-fill URL
/maxym-ai-ads:ads-blueprint https://www.mysite.com

# Resume after an interruption
/maxym-ai-ads:ads-blueprint --resume
```

---

## Hard Rules

1. **NEVER skip the initial questionnaire** unless `--resume` is passed
2. **NEVER proceed past a critical decision gate** without explicit user confirmation
3. **ALWAYS persist state** to `ADS-BLUEPRINT-STATE.json` after each phase
4. **ALWAYS generate all 3 final deliverables** (PDF + HTML + checklist) at end of Phase 5 — if any one fails, warn and continue with the others
5. **NEVER run `/ads-generate` silently if no image provider is configured** — show setup instructions and skip the step with a warning
6. **RESPECT `intake.language`** for all user-facing text in subsequent phases
7. **OBEY the critical gates**: Phase 0 score <40 blocks, Phase 2 break-even <0.8× industry CPA blocks
