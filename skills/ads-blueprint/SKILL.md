---
name: ads-blueprint
description: "Guided, interactive end-to-end paid advertising blueprint. Walks the user through all 5 phases (Reality Check → Intelligence → Budget/Funnel → Creative → Landing/Test → Launch → Optimize) using one-question-at-a-time intake, checkpoint-style automation, adaptive explanations (beginner / intermediate / expert), and a clean folder-per-phase output structure. Produces a final recap, client-ready PDF, interactive HTML report, and a launch checklist. Use when user says start blueprint, guide me through ads, full ads setup, zero to sales, complete ad strategy from scratch, walk me through paid ads, or simply invokes /ads-blueprint."
user-invokable: true
---

<!-- maxym-ai-ads | ads-blueprint v1.0.03 -->

# Zero-to-Sales Guided Blueprint

This is the flagship **guided experience** of `maxym-ai-ads`. It orchestrates the entire Zero-to-Sales Blueprint interactively with three hallmarks:

1. **One question at a time** — the intake surveys the user progressively, with an upfront preview so they know what's coming
2. **Adaptive explanations** — every deliverable is tailored to the user's declared experience level (beginner / intermediate / expert); beginners receive a parallel, jargon-free twin file
3. **Clean folder structure** — every phase writes into its own `Phase-N-Name/` subdirectory, the final deliverables live at the `ADS-Blueprint/` root

**Argument handling**:
- `/ads-blueprint` → full questionnaire
- `/ads-blueprint <url>` → pre-fills URL (skip Q1), still asks the other 10
- `/ads-blueprint --resume` → resumes from the last incomplete phase (if `ADS-Blueprint/ADS-BLUEPRINT-STATE.json` exists in CWD)

---

## Automation Model

**Checkpoint-per-phase**:
- Run all commands inside a phase automatically
- Pause at phase boundaries ("Phase N complete. Proceed to Phase N+1? / review / skip / stop")
- Block only on critical gates (Phase 0 score <40, Phase 2 break-even CPA impossible)

**Failure handling**:
- Non-critical failure → continue with a warning recorded in the state file
- Critical gate failure → stop and surface an actionable remediation plan

**State**: persist progress to `ADS-Blueprint/ADS-BLUEPRINT-STATE.json` so the user can resume with `--resume`.

---

## Directory Structure

All outputs are organized under a single `ADS-Blueprint/` directory in the user's CWD:

```
<cwd>/
└── ADS-Blueprint/
    ├── ADS-BLUEPRINT-STATE.json            ← persistent state (created first)
    ├── ADS-BLUEPRINT-REPORT.html           ← final deliverable (Phase 5)
    ├── ADS-STRATEGY-REPORT.pdf             ← final deliverable (Phase 5)
    ├── ADS-LAUNCH-CHECKLIST.md             ← final deliverable (Phase 5)
    ├── Phase-0-Reality-Check/
    │   ├── ads-quick-output.md
    │   └── ads-quick-output-Beginner.md    ← if experience = beginner
    ├── Phase-1-Intelligence/
    │   ├── brand-profile.json
    │   ├── ADS-AUDIENCE.md
    │   ├── ADS-AUDIENCE-Beginner.md        ← if experience = beginner
    │   ├── ADS-COMPETITORS.md
    │   ├── ADS-COMPETITORS-Beginner.md     ← if experience = beginner
    │   ├── ADS-PLAN-[industry].md
    │   ├── ADS-PLAN-[industry]-Beginner.md ← if experience = beginner
    │   ├── ADS-STRATEGY-[Company].md
    │   └── ADS-STRATEGY-[Company]-Beginner.md ← if experience = beginner
    ├── Phase-2-Budget-Funnel/
    │   ├── ADS-BUDGET.md
    │   ├── ADS-BUDGET-Beginner.md          ← if experience = beginner
    │   ├── ADS-FUNNEL.md
    │   ├── ADS-FUNNEL-Beginner.md          ← if experience = beginner
    │   ├── ADS-MATH.md
    │   └── ADS-MATH-Beginner.md            ← if experience = beginner
    ├── Phase-3-Creative/
    │   ├── ADS-KEYWORDS.md
    │   ├── ADS-HOOKS.md
    │   ├── ADS-COPY-[Platform].md          ← one per active platform
    │   ├── ADS-VIDEO-SCRIPTS.md
    │   ├── campaign-brief.md
    │   ├── ad-assets/                      ← AI-generated images
    │   └── *-Beginner.md                   ← beginner twins if applicable
    └── Phase-4-Landing-Test/
        ├── ADS-LANDING.md
        ├── ADS-TESTING-PLAN.md
        └── *-Beginner.md                   ← beginner twins if applicable
```

**Before writing any phase output**, always ensure the directory exists:
```bash
mkdir -p ADS-Blueprint/Phase-N-[Name]
```

---

## Initial Intake — ONE QUESTION AT A TIME

Never dump all questions in a single prompt expecting the user to answer in one go. That is the #1 usability failure of previous blueprint skills. Instead follow this exact pattern:

### Step 1 — Preview (read-only)

Present the full list first, so the user knows what to expect, but tell them explicitly you will ask each one individually:

```
Hi! Before we start, I need to learn a few things about you and your product.

I'll ask you **one question at a time** — no copy-paste marathons. You can
read the full list below to get mentally prepared; I'll walk you through
each one right after.

┌──────────────────────────────────────────────────────────────────────┐
│  1. Product URL                                                      │
│  2. Product type                                                     │
│  3. Monthly ad budget (USD)                                          │
│  4. Primary goal                                                     │
│  5. Industry                                                         │
│  6. Creative production capacity                                     │
│  7. Existing platform experience                                     │
│  8. Platforms to include or exclude                                  │
│  9. Output language                                                  │
│ 10. Timeline urgency                                                 │
│ 11. Your paid-advertising experience level ★ NEW                     │
└──────────────────────────────────────────────────────────────────────┘

There are 11 questions. Most take 5-10 seconds to answer.

Ready? Let's start. 👇
```

### Step 2 — Ask each question individually

For **every** question, you must:

1. **State the question clearly**, as the only thing in the assistant message
2. **Provide suggestions / examples / inspiration** so the user can answer even if unsure
3. **Wait for the user's reply** before moving on — never dump two questions in the same message
4. **Echo back** the parsed answer briefly ("Got it — $5,000/month.") and proceed to the next

**Example pattern for Question 1 (URL)**:
```
**Question 1/11 — What is your product's live URL?**

This is the website / landing page / app-store page where your paying customers land.

Examples:
  • A SaaS:            https://myapp.com
  • A shop:            https://shop.mybrand.com
  • An App Store page: https://apps.apple.com/us/app/...
  • A consultancy:     https://mycompany.com/services

If you don't have one yet, type `no-url` and I'll flag this as a blocker
(we really need a live page to proceed).

Your answer?
```

Then wait. When the user answers, validate and move on:
```
✓ Got it — https://mysite.com

**Question 2/11 — What type of product is it?**
...
```

### Question reference (use these prompts verbatim, adapt suggestions as needed)

**Q1 — Product URL**
```
This is the website / landing page / app-store page where your paying customers land.

Examples:
  • A SaaS:            https://myapp.com
  • A shop:            https://shop.mybrand.com
  • An App Store page: https://apps.apple.com/us/app/...
  • A consultancy:     https://mycompany.com/services

Type `no-url` if you don't have one (we'll need to stop).
```

**Q2 — Product type**
```
How would you categorize your product?

  1. SaaS               → software subscription (e.g. Notion, Figma)
  2. E-commerce         → physical or digital products sold one-off
  3. Info-product       → course / ebook / membership
  4. Mobile app         → iOS / Android with in-app monetization
  5. Local service      → plumber, dentist, restaurant, gym
  6. B2B service        → agency, consultancy, enterprise software
  7. Other              → tell me what best describes it

You can answer with the number or the name.
```

**Q3 — Monthly ad budget (USD)**
```
How much can you invest in ads every month?

Guidelines:
  • Under $1,000/mo  → not recommended, signal is too weak to optimize
  • $1,000–$3,000    → small but workable for 1-2 platforms
  • $3,000–$10,000   → typical sweet spot for SMBs
  • $10,000+         → allows full-funnel strategy across 3+ platforms

Just type the amount (e.g. `5000` or `$5k`).
```

**Q4 — Primary goal**
```
What are you trying to achieve with paid ads?

  1. Sales / Revenue     → direct purchase conversions (most e-commerce)
  2. Leads / Demos       → form fills, demo bookings (B2B, services)
  3. Trials / Signups    → free trial or account creation (SaaS)
  4. App installs        → mobile app acquisition
  5. Calls               → phone calls to your business (local services)
  6. Brand awareness     → reach and recognition (rarely a great first goal)

Answer with the number or the name.
```

**Q5 — Industry**
```
Which industry template best fits your business?
(This lets me load the right benchmarks for CPC, CTR, CVR, and ROAS.)

  • saas                → software-as-a-service
  • ecommerce           → physical/digital products at scale
  • local-service       → dentist, plumber, gym, restaurant, auto
  • b2b-enterprise      → high-ticket B2B with long sales cycle
  • info-products       → courses, memberships, info funnels
  • mobile-app          → consumer apps, games, app store
  • real-estate         → agents, brokerages, property tech
  • healthcare          → clinics, providers (HIPAA-sensitive)
  • finance             → fintech, lending, insurance (Special Ad Categories)
  • agency              → marketing/creative/dev agencies
  • generic             → doesn't fit any of the above

Pick the closest match.
```

**Q6 — Creative production capacity**
```
Who will produce the creative assets (images, videos, copy)?

  1. solo               → just me, I'll use AI-generated images and the copy you produce
  2. designer-team      → I have a designer/editor I'll brief
  3. external-agency    → I work with an external creative agency
  4. none-yet           → I don't know yet, help me figure it out

This affects Phase 3 — for instance, solo users get AI-image generation,
teams get a detailed creative brief document instead.
```

**Q7 — Existing platform experience**
```
How experienced are you with the ad platforms you'll use?

  1. none               → first time running paid ads
  2. some               → I've run campaigns but don't feel confident
  3. experienced        → I've managed many campaigns before

This changes how much hand-holding the final checklist provides.
```

**Q8 — Platforms to include or exclude**
```
Any preferences on which platforms to use (or NOT to use)?

Examples:
  • `any`                       → let me pick based on your business type
  • `+google +meta`             → include these two, decide the rest for me
  • `+google +meta -linkedin`   → include these, exclude LinkedIn explicitly
  • `only-meta`                 → single-platform test

If you're not sure, type `any` and I'll recommend the optimal mix.
```

**Q9 — Output language**
```
What language should the generated reports be in?

  • english
  • italian
  • spanish
  • french
  • german
  • portuguese
  • dutch
  • other (specify)

All deliverables (Markdown files, checklist, HTML/PDF reports) will be
produced in the language you pick.
```

**Q10 — Timeline urgency**
```
How much time do you have before launching?

  1. launch-in-1-week   → compressed plan, essential creative only
  2. standard-2-weeks   → recommended pace, full blueprint
  3. no-rush            → take time, iterate creative, test more

This influences how much creative volume we produce in Phase 3.
```

**Q11 — Paid-advertising experience level (★ NEW in v1.0.03)**
```
Last question! How would you describe your current knowledge of paid advertising?

Your answer tells me how to format the output files — from "just the numbers"
to "explain everything like I'm new to this".

  🎓  beginner       → "I don't really know CPC, ROAS, funnels, audiences.
                       Give me everything with plain-language explanations."

  📊  intermediate   → "I know the basics but I'm still learning. Keep the
                       technical output, but drop a plain-language section
                       at the end of each file."

  🚀  expert         → "I'm a marketer/agency/power-user. Just the technical
                       files, skip any explainers."

Pick one: beginner / intermediate / expert.
```

### Step 3 — Summary & confirmation

After Q11, show a clean summary in a single message:

```
Perfect, here's everything I captured:

  Product URL:               https://mysite.com
  Product type:              SaaS
  Monthly budget:            $5,000
  Primary goal:              Trials
  Industry:                  saas
  Creative production:       solo
  Platform experience:       some
  Platforms include/exclude: +google +meta
  Output language:           english
  Timeline urgency:          standard-2-weeks
  Experience level:          intermediate

Looks right? Type `yes` to start Phase 0, or `edit N` to change answer N
(e.g. `edit 3` to change the budget).
```

Handle `edit N` by re-asking only that question (one-at-a-time rule still applies). Then re-show the summary.

When the user confirms:

1. Create `ADS-Blueprint/` directory (and subfolders lazily per phase)
2. Write initial state to `ADS-Blueprint/ADS-BLUEPRINT-STATE.json`
3. Show the roadmap:

```
Your Blueprint Roadmap:

  Phase 0 — Reality Check ............. ~2 min
  Phase 1 — Intelligence & Strategy ... ~15-20 min   (5 parallel subagents)
  Phase 2 — Budget & Funnel ........... ~5-8 min
  Phase 3 — Creative Production ....... ~20-30 min
  Phase 4 — Landing & Test Prep ....... ~8-10 min
  Phase 5 — Launch Checklist + Reports. ~5 min

  Files will be saved under:  ADS-Blueprint/Phase-N-Name/
  Final deliverables at:      ADS-Blueprint/*.pdf/html/md

  Total command execution time: ~60-75 minutes.

  Ready? Type `start` to begin Phase 0.
```

---

## Adaptive Output — The Three Experience Modes

The `experience_level` answer drives HOW files are written from Phase 0 onward.

### 🎓 BEGINNER mode

For every phase output file, produce **two files**:

1. **The technical file** (same as always: `ADS-AUDIENCE.md`, `ADS-BUDGET.md`, etc.)
2. **A parallel beginner file** with suffix `-Beginner.md` (e.g. `ADS-AUDIENCE-Beginner.md`)

The beginner file is **NOT a summary** of the technical one. It's a complete, standalone rewrite that:
- Covers every concept in the technical file
- Uses plain language, everyday analogies, and examples
- Defines every acronym on first use ("CPC means Cost Per Click — how much you pay each time someone clicks your ad")
- Swaps jargon-heavy tables for narrative paragraphs where possible
- Ends with "What to do next" section in human terms

**Template header for beginner files**:
```markdown
# [Topic] — for beginners

> This file explains everything from `[ADS-TOPIC].md` in plain language.
> You don't need marketing experience to follow along.
> If you want the quick technical version, read `[ADS-TOPIC].md`.

---

[Body in beginner language, covering the same ground as the technical file]

---

## 📚 Glossary (quick reference)

- **[Term 1]** — [plain definition + example]
- **[Term 2]** — [plain definition + example]
- ...

## ✅ What to do next

[Step-by-step plain-language checklist]
```

**Tone guide for beginner mode**:
- Write like you're explaining to a friend at a coffee shop
- Never assume prior knowledge
- Use concrete numbers in examples ("Imagine you spend $100/day and get 50 clicks...")
- Replace tables with short lists + prose when tables feel intimidating
- Add encouragement: "Don't worry if this feels like a lot — you'll see how it fits together as we go."

### 📊 INTERMEDIATE mode

For every phase output file, produce **one file** (the technical one), but append a section at the bottom:

```markdown
---

## 📚 In plain English

*A quick refresher for anyone who wants to make sure they've understood everything above.*

[3-6 paragraphs summarizing the file in plain language, defining any non-obvious
terms that appeared, and translating any key numbers into real-world implications.]

**Key takeaways**:
- [Takeaway 1 in plain words]
- [Takeaway 2 in plain words]
- [Takeaway 3 in plain words]
```

This section must:
- Start with the `---` separator
- Use the exact heading `## 📚 In plain English`
- Be 200-500 words (not too long, it's a refresher)
- Define any acronym that appeared in the file
- End with 3 "Key takeaways" in plain language

### 🚀 EXPERT mode

No changes. Technical files only, no plain-language additions, no beginner twin files. Fastest to produce, smallest output. This is the pre-v1.0.03 behavior.

---

## Phase 0 — Reality Check

**Directory**: `ADS-Blueprint/Phase-0-Reality-Check/`

### Command sequence
```
mkdir -p ADS-Blueprint/Phase-0-Reality-Check
Run: /ads-quick <url>
# Save output to:  ADS-Blueprint/Phase-0-Reality-Check/ads-quick-output.md
# If beginner:     also write ads-quick-output-Beginner.md
# If intermediate: append "In plain English" section to the main file
```

### Decision gate (CRITICAL)

| Score | Action |
|---|---|
| **80-100** | ✅ Proceed to Phase 1 automatically |
| **60-79** | ⚠️ Warn, list top 2 gaps, ask: "Fix first (recommended) or proceed?" |
| **40-59** | 🟠 Strong warn, list all gaps, ask explicit confirmation to proceed anyway |
| **<40** | ⛔ **BLOCK**. Print the 3 critical issues and remediation steps. Offer: "Fix these, then re-run `/ads-blueprint --resume`." |

When asking the user's choice at a gate, ask **one question**, not a multi-option menu. Example:

> ⚠️ Your readiness score is 56/100 (Needs Work).
>
> Top 3 issues:
>   1. Pricing not visible above the fold
>   2. No social proof on the homepage
>   3. CTA is buried below the fold
>
> Recommendation: pause here, fix these three, then resume.
> Do you want to **fix-first** or **proceed-anyway**? (reply with one word)

Wait for the reply before continuing.

### State update
```json
{
  "phase_0": {
    "completed": true,
    "score": 78,
    "verdict": "Almost Ready",
    "top_gaps": ["Pricing not visible", "4 competing CTAs above fold"],
    "files": ["Phase-0-Reality-Check/ads-quick-output.md"]
  }
}
```

### Checkpoint prompt
```
Phase 0 complete. Score: 78/100 — Almost Ready.
Top 2 gaps: [list from ads-quick output]

Files saved to:
  ADS-Blueprint/Phase-0-Reality-Check/
    ├── ads-quick-output.md
    └── ads-quick-output-Beginner.md   (beginner mode)

Ready to proceed to Phase 1 (Intelligence & Strategy)?
Options: proceed / fix / review / stop  (reply with one word)
```

---

## Phase 1 — Intelligence & Strategy

**Directory**: `ADS-Blueprint/Phase-1-Intelligence/`

### Command sequence (execute in this order, save outputs into the phase folder)

```
mkdir -p ADS-Blueprint/Phase-1-Intelligence
1. /ads-dna <url>              → brand-profile.json                (save in phase folder)
2. /ads-audience <url>         → ADS-AUDIENCE.md                   (+ -Beginner.md if beginner)
3. /ads-competitor <url>       → ADS-COMPETITORS.md                (+ -Beginner.md if beginner)
4. /ads-plan <industry>        → ADS-PLAN-[industry].md            (+ -Beginner.md if beginner)
5. /ads-strategy <url>         → ADS-STRATEGY-[Company].md         (+ -Beginner.md if beginner)
```

### Between commands
Show a one-line progress indicator:
```
  Phase 1 — Intelligence & Strategy
    [✓] Brand DNA extracted
    [✓] 7 personas built
    [✓] Competitor intelligence complete (4 competitors)
    [✓] saas industry template loaded
    [⏳] Running /ads-strategy (5 parallel agents)...
```

### Non-critical failure handling
If any of steps 1-4 fails (network timeout, malformed response, etc.), **continue** with remaining commands and record in `warnings[]`. Only `/ads-strategy` failure is phase-critical — pause and ask the user for a retry or skip via **one** question.

### Checkpoint prompt
```
Phase 1 complete. Files generated in ADS-Blueprint/Phase-1-Intelligence/:
  • brand-profile.json
  • ADS-AUDIENCE.md                    (+ -Beginner if applicable)
  • ADS-COMPETITORS.md                 (+ -Beginner if applicable)
  • ADS-PLAN-saas.md                   (+ -Beginner if applicable)
  • ADS-STRATEGY-[Company].md          (+ -Beginner if applicable)

Ad Readiness Score: 84/100.

Ready to proceed to Phase 2 (Budget & Funnel)?
Options: proceed / review / regenerate / stop  (one word)
```

If the user picks `review`, ask a **follow-up** question ("Which file?") and show the content of the one they name.

If the user picks `regenerate`, ask a **follow-up** question ("Which command? dna / audience / competitor / plan / strategy") and re-run only that one.

---

## Phase 2 — Budget & Funnel

**Directory**: `ADS-Blueprint/Phase-2-Budget-Funnel/`

### Command sequence
```
mkdir -p ADS-Blueprint/Phase-2-Budget-Funnel
1. /ads-budget <monthly-amount>   → ADS-BUDGET.md      (+ -Beginner.md if beginner)
2. /ads-funnel <url>              → ADS-FUNNEL.md      (+ -Beginner.md if beginner)
3. /ads-math                      → ADS-MATH.md        (+ -Beginner.md if beginner)
                                     (break-even CPA, target CPA, ROAS floor)
```

### Decision gate (CRITICAL)

After `/ads-math` computes break-even CPA, compare to industry-average CPA from `references/benchmarks.md`:

| Condition | Action |
|---|---|
| Break-even CPA ≥ 1.2× industry-average | ✅ Healthy margin, proceed |
| Between 0.8× and 1.2× | ⚠️ Tight-margin warning, continue |
| < 0.8× industry-average | ⛔ **BLOCK** |

**Block message**:
```
⛔ Break-even analysis blocked this workflow.

  Your break-even CPA:        $[X]
  Industry-average CPA:       $[Y]   (source: references/benchmarks.md)
  Viability threshold (0.8×): $[Z]

Your margins don't leave room for profitable paid ads at typical industry CPA.
You need one of:
  1. Higher AOV or LTV (upsells, subscription, bundles)
  2. Better margins (cost reduction, premium tier)
  3. A niche with materially lower CPA (different angle)

Blueprint paused. Adjust unit economics, then re-run with
`/ads-blueprint --resume`.
```

### Checkpoint prompt
```
Phase 2 complete. Files in ADS-Blueprint/Phase-2-Budget-Funnel/:
  • ADS-BUDGET.md     (+ -Beginner.md if applicable)
  • ADS-FUNNEL.md     (+ -Beginner.md if applicable)
  • ADS-MATH.md       (+ -Beginner.md if applicable)

Key numbers:
  • Break-even CPA: $[X]
  • Target CPA:     $[Y]
  • ROAS floor:     [Z]×

Ready to proceed to Phase 3 (Creative Production)?
Options: proceed / review / adjust-budget / stop  (one word)
```

---

## Phase 3 — Creative Production

**Directory**: `ADS-Blueprint/Phase-3-Creative/`

### Conditional logic (decide which commands to run based on context)

| Command | Run when |
|---|---|
| `/ads-keywords <url>` | Google Search in platform mix |
| `/ads-hooks` | Always |
| `/ads-copy <platform>` | Once per active platform |
| `/ads-video <product>` | Always |
| `/ads-create` | Always (consolidation) |
| `/ads-generate` | Image provider configured OR `creative_production == "solo"` |
| `/ads-photoshoot` | Physical product OR `e-commerce` / `mobile-app` |
| `/ads-creative-brief <product>` | `creative_production` is `designer-team` or `external-agency` |

### Before running, show the plan (one message) and ask for confirmation (one question)
```
Phase 3 plan for your context (intermediate, Google+Meta, $5K/mo, SaaS):

  [✓] ads-keywords (Google Search included)
  [✓] ads-hooks (20 scroll-stoppers)
  [✓] ads-copy google
  [✓] ads-copy meta
  [✓] ads-video (15s / 30s / 60s)
  [✓] ads-create (master brief consolidation)
  [✓] ads-generate (AI images, ~10 variants per platform)
  [ ] ads-photoshoot — SKIPPED (SaaS, no physical product)
  [ ] ads-creative-brief — SKIPPED (solo production)

Proceed with this plan? (yes / customize / stop)
```

If `customize`, ask **one** question at a time to add/remove items.

### Special: if video or creative-brief need a product name
If `/ads-video` or `/ads-creative-brief` require a specific product name not captured in intake, ask **one** question:
```
Before I generate the video scripts, I need a specific name or tagline for
your product to feature in the scripts.

Example: "Tiimo — the visual planner for ADHD brains"

What should I use?
```
Wait for reply, then proceed.

### Progress indicator
```
  Phase 3 — Creative Production
    [✓] ads-keywords      — 147 keywords, 12 ad groups, 58 negatives
    [✓] ads-hooks         — 20 hooks across 5 psychological angles
    [✓] ads-copy google   — 18 RSA headlines, 12 PMax assets
    [✓] ads-copy meta     — 10 primary texts, 8 headlines, 6 descriptions
    [⏳] ads-video        — generating scripts...
```

### Non-critical failure handling
- `ads-generate` with no image provider: show config guide, skip with warning
- All other failures: warn and continue

### Checkpoint prompt
```
Phase 3 complete. Files in ADS-Blueprint/Phase-3-Creative/:
  • ADS-KEYWORDS.md
  • ADS-HOOKS.md
  • ADS-COPY-Google.md
  • ADS-COPY-Meta.md
  • ADS-VIDEO-SCRIPTS.md
  • campaign-brief.md
  • ad-assets/                 (if ads-generate ran)
  • *-Beginner.md variants     (if beginner mode)

Ready to proceed to Phase 4 (Landing & Test Prep)?
Options: proceed / review / regenerate-single-file / stop
```

---

## Phase 4 — Landing & Test Prep

**Directory**: `ADS-Blueprint/Phase-4-Landing-Test/`

### Command sequence
```
mkdir -p ADS-Blueprint/Phase-4-Landing-Test
1. /ads-landing <url>                      → ADS-LANDING.md          (+ -Beginner.md)
2. /ads-testing "[campaign-name]"          → ADS-TESTING-PLAN.md     (+ -Beginner.md)
3. /ads-test                               → statistical validation (annotated in ADS-TESTING-PLAN.md)
```

### Derive `campaign-name` automatically
Use the Company name from `brand-profile.json` + month/year. Example: `"TiimoApp-Launch-Apr2026"`.

### Warning gate (non-blocking)
After `/ads-landing`, if Health Score < 60, ask **one** question:
```
⚠️ Landing page health: 56/100.

Top 3 fixes identified:
  1. [fix 1]
  2. [fix 2]
  3. [fix 3]

Recommendation: pause, apply fixes, resume with `--resume`.
You can also proceed and fix the landing later (not recommended).

What do you want to do? (fix-first / proceed-anyway / stop)
```

### Checkpoint prompt
```
Phase 4 complete. Files in ADS-Blueprint/Phase-4-Landing-Test/:
  • ADS-LANDING.md         (+ -Beginner.md if applicable)
  • ADS-TESTING-PLAN.md    (+ -Beginner.md if applicable)

Landing Health Score: 78/100.

Ready to generate the final deliverables (PDF + HTML + checklist)?
Options: proceed / review / stop
```

---

## Phase 5 — Launch Checklist + Final Reports

**Directory**: root of `ADS-Blueprint/` (deliverables are cross-cutting)

### Step 5.1 — PDF report
```
Run: /ads-report-pdf
# Save to: ADS-Blueprint/ADS-STRATEGY-REPORT.pdf
```

### Step 5.2 — HTML report

Generate standalone interactive HTML at `ADS-Blueprint/ADS-BLUEPRINT-REPORT.html` from the template at `skills/ads-blueprint/assets/report-template.html`:

1. Read template (all CSS + JS inline)
2. Load `ADS-BLUEPRINT-STATE.json`
3. Load each phase's Markdown outputs
4. Token substitute (see table below)
5. Convert Markdown sections to HTML snippets
6. Write the final HTML file

#### HTML Template Variables

| Token | Source |
|---|---|
| `{{COMPANY_NAME}}` | `brand-profile.json > company.name` |
| `{{COMPANY_URL}}` | `intake.url` |
| `{{INDUSTRY}}` | `intake.industry` |
| `{{MONTHLY_BUDGET}}` | `intake.budget` (formatted with $ and commas) |
| `{{PRIMARY_GOAL}}` | `intake.goal` |
| `{{EXPERIENCE_LEVEL}}` | `intake.experience_level` (beginner / intermediate / expert) |
| `{{GENERATED_AT}}` | current ISO timestamp |
| `{{READINESS_SCORE}}` | `phase_0.score` |
| `{{READINESS_VERDICT}}` | `phase_0.verdict` |
| `{{STRATEGY_SCORE}}` | composite score from `/ads-strategy` |
| `{{BREAK_EVEN_CPA}}` | `phase_2.break_even_cpa` |
| `{{TARGET_CPA}}` | `phase_2.target_cpa` |
| `{{LANDING_SCORE}}` | `phase_4.landing_health_score` |
| `{{TOP_3_STRENGTHS}}` | HTML `<ol>` with 3 `<li>` |
| `{{TOP_3_GAPS}}` | HTML `<ol>` with 3 `<li>` |
| `{{PERSONAS_CARDS}}` | rendered persona card HTML (loop) |
| `{{PLATFORM_ALLOCATION}}` | platform allocation bars HTML |
| `{{FUNNEL_DIAGRAM}}` | TOFU/MOFU/BOFU/retargeting stages populated |
| `{{COMPETITOR_TABLE}}` | table HTML from ADS-COMPETITORS.md |
| `{{CREATIVE_SAMPLES}}` | grid of hook + copy + video samples |
| `{{TESTING_PLAN_TABLE}}` | table HTML from ADS-TESTING-PLAN.md |
| `{{LAUNCH_CHECKLIST}}` | checkbox list HTML (Pre-Launch / Launch Day / Week 1-2) |
| `{{ACTION_PLAN_90D}}` | 3-column month-by-month timeline |
| `{{OUTPUT_LANG}}` | `intake.language` |
| `{{EXPERIENCE_LEVEL}}` | `intake.experience_level` (beginner / intermediate / expert) |
| `{{BEGINNER_BANNER}}` | HTML banner — see rules below |

**Rules for `{{BEGINNER_BANNER}}`**:

- If `experience_level == "beginner"`, replace with:
  ```html
  <div style="margin-top:28px;padding:18px 22px;background:var(--primary-soft);border:1px solid rgba(110,68,255,0.35);border-radius:14px;font-size:14px;line-height:1.5;">
    📚 <strong>Beginner mode is on.</strong> Every technical file in your
    <code style="background:var(--surface-2);padding:2px 6px;border-radius:4px;">ADS-Blueprint/</code>
    folder also has a <code style="background:var(--surface-2);padding:2px 6px;border-radius:4px;">-Beginner.md</code>
    twin that explains the same content in plain language. Start there whenever
    something feels unclear.
  </div>
  ```
- If `experience_level == "intermediate"`, replace with:
  ```html
  <div style="margin-top:28px;padding:14px 22px;background:var(--accent-soft);border:1px solid rgba(0,224,184,0.3);border-radius:14px;font-size:13px;line-height:1.5;color:var(--text-muted);">
    📚 Each technical file ends with a "📚 In plain English" section — a quick
    plain-language refresher of the content above.
  </div>
  ```
- If `experience_level == "expert"`, replace with an empty string (no banner).

Fallback if a phase output is missing: render the corresponding section with a muted placeholder — "Phase not completed — run `/ads-blueprint --resume` to finish."

### Step 5.3 — Launch checklist

Write `ADS-Blueprint/ADS-LAUNCH-CHECKLIST.md`. Derive items dynamically based on platforms chosen in intake.

```markdown
# Launch Checklist — [Company]

## 🔧 Pre-Launch (before turning on any campaign)
- [ ] Verify pixel / Conversions API installed on site
- [ ] Verify Consent Mode V2 (if EU/EEA traffic)
- [ ] Upload audience lists (Customer Match / Matched Audiences)
- [ ] Configure UTM template per platform
- [ ] Set up conversion tracking events (enhanced conversions ideal)
- [ ] Turn auto-apply recommendations OFF
- [ ] Attach negative keyword lists (Google)
- [ ] Set Special Ad Categories (if applicable)
- [ ] Verify budget alerts and daily caps

## 🚀 Launch Day
- [ ] Launch order: Search → Retargeting → Prospecting
- [ ] Start each campaign at recommended daily budget (see ADS-BUDGET.md)
- [ ] Set bidding per ADS-STRATEGY.md (not platform defaults)
- [ ] Schedule a 48h check-in (verify delivery only, no edits)

## 📅 Week 1 (learning phase — DO NOT EDIT)
- [ ] Day 2: verify ads are serving and pixel fires are clean
- [ ] Day 4: sanity check for policy violations or disapprovals
- [ ] Day 7: `/ads-audit` quick-check (observe only)
- [ ] Do NOT change bids, budgets, or creative this week

## 📅 Week 2 (learning phase continues)
- [ ] Day 10: observe, do not edit
- [ ] Day 14: learning phase should be complete; `/ads-audit` first review

## 📅 Week 3+ (optimization loop starts)
- [ ] Apply 3× Kill Rule on CPA ≥ 3× target
- [ ] Apply 20% Scaling Rule on winners
- [ ] `/ads-creative-audit` weekly for fatigue detection
- [ ] `/ads-audit` every 2 weeks
- [ ] `/ads-competitor <url>` monthly
- [ ] `/ads-report-pdf` monthly for stakeholder reporting
```

**Beginner mode**: also write `ADS-LAUNCH-CHECKLIST-Beginner.md` with identical steps but each item followed by a "what this means" plain-language note.

### Final summary (terminal output)

```
═══════════════════════════════════════════════════════════════════════
  🎉 BLUEPRINT COMPLETE — [Company]
═══════════════════════════════════════════════════════════════════════

  Ad Readiness Score:    84/100 (Grade B)
  Break-even CPA:        $40
  Target CPA:            $20
  Landing Health:        78/100
  Experience mode:       [beginner / intermediate / expert]

  📂 All files saved to: ADS-Blueprint/

  Top-level deliverables:
    📄 ADS-STRATEGY-REPORT.pdf        ← client-ready
    🌐 ADS-BLUEPRINT-REPORT.html      ← open in any browser
    ✅ ADS-LAUNCH-CHECKLIST.md        ← pre/post-launch tasks

  Phase folders:
    Phase-0-Reality-Check/    — readiness snapshot
    Phase-1-Intelligence/     — DNA, audience, competitors, strategy
    Phase-2-Budget-Funnel/    — budget, funnel, break-even math
    Phase-3-Creative/         — keywords, hooks, copy, video, assets
    Phase-4-Landing-Test/     — landing audit, A/B testing plan

  Next steps:
    1. Review ADS-STRATEGY-REPORT.pdf with stakeholders
    2. Address ADS-LANDING.md recommendations before launch
    3. Complete Pre-Launch section of ADS-LAUNCH-CHECKLIST.md
    4. Launch per the 3 sacred rules (3× Kill · 20% Scaling · No edits in learning)

  Every 2 weeks post-launch, run:  /ads-audit

═══════════════════════════════════════════════════════════════════════
```

If `experience_level == "beginner"`, append:

```
  📚 Beginner mode is ON.
     For every technical file, you also have a -Beginner.md twin that
     explains the same content in plain language. Start there if anything
     feels unclear.
```

---

## Resume Behavior (`--resume` flag)

When invoked with `--resume`:
1. Read `ADS-Blueprint/ADS-BLUEPRINT-STATE.json`
2. If missing: "No saved blueprint here. Start fresh with `/ads-blueprint`."
3. Identify last completed phase
4. Print 3-line recap: "Resuming from Phase N. Context loaded. Ready? (one word: yes / no)"
5. Continue from next incomplete phase

---

## State File Format (`ADS-Blueprint/ADS-BLUEPRINT-STATE.json`)

```json
{
  "version": "1.0.03",
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
    "platforms_exclude": [],
    "language": "english",
    "urgency": "standard-2-weeks",
    "experience_level": "intermediate"
  },
  "phases": {
    "phase_0": {"completed": true, "score": 78, "verdict": "Almost Ready", "files": [...]},
    "phase_1": {"completed": true, "strategy_score": 84, "files": [...]},
    "phase_2": {"completed": true, "break_even_cpa": 40, "target_cpa": 20, "files": [...]},
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
- All user-facing questions and progress messages in the intake
- All checkpoint prompts
- The final summary
- All file contents (technical + beginner variants) in the target language
- HTML report labels (via `OUTPUT_LANG`)
- Section headers in `ADS-LAUNCH-CHECKLIST.md`

The beginner mode's plain-language requirement applies across all languages.

---

## Invocation examples

```shell
# Full interactive flow from scratch
/maxym-ai-ads:ads-blueprint

# Pre-fill URL
/maxym-ai-ads:ads-blueprint https://www.mysite.com

# Resume after interruption
/maxym-ai-ads:ads-blueprint --resume
```

---

## Hard Rules (non-negotiable)

1. **NEVER ask multiple questions in the same assistant message** — one question, wait for reply, then next
2. **NEVER skip the initial 11-question questionnaire** unless `--resume` is passed
3. **NEVER proceed past a critical decision gate** without explicit user confirmation
4. **ALWAYS persist state** to `ADS-Blueprint/ADS-BLUEPRINT-STATE.json` after each phase
5. **ALWAYS write outputs into the correct `Phase-N-Name/` subfolder**, never in CWD root
6. **ALWAYS generate all 3 final deliverables** (PDF + HTML + checklist) at end of Phase 5; warn and continue if any one fails
7. **NEVER run `/ads-generate` silently if no image provider is configured** — show setup, skip with warning
8. **RESPECT `intake.language`** for all text in subsequent phases
9. **RESPECT `intake.experience_level`**:
   - `beginner` → write a -Beginner.md twin for every output file
   - `intermediate` → append "📚 In plain English" section to every output file
   - `expert` → technical files only, no explainers
10. **OBEY the critical gates**: Phase 0 score <40 blocks, Phase 2 break-even <0.8× industry CPA blocks
11. **ALWAYS preview the full question list before Q1**, so the user can mentally prepare — but still ask questions one at a time
12. **ALWAYS echo back the parsed answer** briefly after each question, before moving to the next
