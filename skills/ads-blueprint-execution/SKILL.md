---
name: ads-blueprint-execution
description: "Guided end-to-end execution of the paid-ads Blueprint produced by /ads-blueprint. Reads the existing ADS-Blueprint/ folder, detects the current phase, and coaches the user through every remaining step: closing blocking gaps, pixel & tracking setup, campaign build in each ad platform, launch day sequencing, learning-phase observation, and the bi-weekly optimization cycle (3× Kill Rule, 20% Scaling Rule, creative fatigue detection). Accepts pasted screenshots / CSV exports for live metric analysis. Produces platform-specific setup guides, a session log, and an HTML live dashboard. Use when user says execute my blueprint, help me launch, run my campaigns, post-launch optimization, scale my ads, audit my running campaigns, kill or scale decision, what should I do now with my ads, continue the blueprint, or invokes /ads-blueprint-execution."
user-invokable: true
---

<!-- maxym-ai-ads | ads-blueprint-execution v1.0.04 -->

# Blueprint Execution — Guided Companion

While `/ads-blueprint` **produces the plan**, this skill **puts it into practice**. It reads the existing `ADS-Blueprint/` folder, detects where the user is in their ad journey (pre-launch / launching / learning / optimizing), and walks them step-by-step through every remaining action — closing blocking gaps, installing pixels, building campaigns in each ad platform, launching, observing learning-phase, and then running the bi-weekly optimization loop until the campaigns are profitable.

**Philosophy**: this skill is a **coach + instruction generator + analyst**, not an automation tool. Claude Code cannot click dashboard buttons for the user — but it can tell them *exactly* what to click, parse the metrics they paste back, and decide what to kill, scale, or refresh.

**Argument handling**:
- `/ads-blueprint-execution` → auto-detect phase from `EXECUTION-STATE.json` (or `ADS-BLUEPRINT-STATE.json` if first run), show the right menu
- `/ads-blueprint-execution --fresh` → force restart from Phase 0 (gate check), ignoring existing EXECUTION-STATE.json
- `/ads-blueprint-execution audit` → jump directly to a bi-weekly optimization audit (post-launch)

---

## Scope — What This Skill Does and Does NOT Do

**Does**:
- Reads `ADS-Blueprint/` structure (state + phase folders) to bootstrap context
- Verifies residual blocking gaps (Phase 0 score <60, landing <60, pixel missing, consent banner, etc.) and guides fixing
- Generates **step-by-step platform-specific setup guides** (Meta, Google, LinkedIn, TikTok, Microsoft) with copy-paste-ready values drawn from the blueprint files
- Accepts **pasted metrics / screenshot text / CSV files** for live campaign analysis
- Applies **3× Kill Rule, 20% Scaling Rule, Learning-Phase Protection** mechanically on the user's data
- Detects **creative fatigue** signals (frequency >3, CTR drop >30%)
- Writes an **execution log** in Markdown and a **live dashboard** in HTML
- Supports **beginner / intermediate / expert** output tone (adaptive)

**Does NOT**:
- Connect to Meta / Google / LinkedIn APIs directly (no MCP required in this skill)
- Click buttons or modify campaigns automatically
- Pull real-time metrics without the user pasting them in or providing a CSV

**Honest positioning** (communicate this at the start of the first session):
```
Heads up: I can't click buttons in Meta Ads Manager or Google Ads for you —
that's the one thing Claude Code can't do in a browser. What I CAN do:

  ✓ Tell you exactly what to click, in what order, with exact copy and budget values
  ✓ Read your blueprint files and pre-fill every number, copy variant, persona, keyword
  ✓ Analyze pasted metrics / CSV exports / screenshots to decide kill/scale/refresh
  ✓ Keep a log of every session so nothing gets lost

If you're OK with that setup, let's go.
```

---

## Bootstrap — Reading the Existing Blueprint

### Step 1 — Locate `ADS-Blueprint/`

Search strategy (first hit wins):
1. Current working directory: `./ADS-Blueprint/`
2. Parent directory: `../ADS-Blueprint/`
3. If neither, ask the user **one question**: "I couldn't find an ADS-Blueprint/ folder. Where is it? (paste the absolute path, or type `none` if the blueprint hasn't been run yet)"

If `none`: suggest running `/ads-blueprint` first. Do not proceed with execution.

### Step 2 — Read `ADS-BLUEPRINT-STATE.json`

Critical fields to extract:

| Field | Usage |
|---|---|
| `intake.url` | main URL to reference in setup guides |
| `intake.url_final_domain` (optional) | domain rename — alert the user if set |
| `intake.product_type` | determines platform recommendations |
| `intake.budget` | base for campaign budget calculations |
| `intake.goal` + `intake.goal_optimization_event` | conversion objective per platform |
| `intake.industry` | benchmarks reference |
| `intake.platforms_include` / `platforms_exclude` | which platforms to actually build |
| `intake.language` | all output language |
| `intake.experience_level` | confirm at start (see Adaptive below) |
| `phases.phase_0.score` | if <60, trigger gap-closure path |
| `phases.phase_0.gaps[]` | list of blocking issues to fix |
| `phases.phase_2.break_even_cpa` | target CPA math |
| `phases.phase_2.target_cpa` | per-platform target |
| `phases.phase_4.landing_health_score` | if <60, pause launch |

**Fallback**: if any field missing, infer from Markdown files with best-effort parsing. Log each inference in `EXECUTION-LOG.md`.

### Step 3 — Check / Initialize `EXECUTION-STATE.json`

Path: `ADS-Blueprint/EXECUTION-STATE.json`

**First run** (file doesn't exist): create it with empty phases and save immediately.

**Subsequent runs**: read the file, identify the current stage, show the correct menu (no questions asked).

Schema:

```json
{
  "version": "1.0.04",
  "started_at": "ISO timestamp",
  "last_updated": "ISO timestamp",
  "blueprint_state_path": "ADS-Blueprint/ADS-BLUEPRINT-STATE.json",
  "experience_level": "beginner|intermediate|expert",
  "stages": {
    "gate_check": {"completed": false, "blockers_remaining": [], "resolved": []},
    "pretrack_setup": {
      "completed": false,
      "pixels_installed": {"meta_pixel": false, "meta_capi": false, "google_gtag": false, "google_ga4": false, "linkedin_insight": false, "tiktok_pixel": false, "microsoft_uet": false},
      "consent_mode_v2": false,
      "utm_templates_ready": false,
      "audience_lists_uploaded": false,
      "budget_alerts_set": false
    },
    "campaign_build": {
      "platforms": {
        "meta": {"status": "not_started|in_progress|done", "campaigns": [], "started_at": null, "done_at": null},
        "google": {"status": "not_started", "campaigns": [], "started_at": null, "done_at": null},
        "linkedin": {"status": "not_started", "campaigns": [], "started_at": null, "done_at": null},
        "tiktok":   {"status": "not_started", "campaigns": [], "started_at": null, "done_at": null},
        "microsoft":{"status": "not_started", "campaigns": [], "started_at": null, "done_at": null}
      }
    },
    "launch_day": {"completed": false, "launched_at": null, "launch_order": []},
    "learning_phase": {"completed": false, "week_1_checkin": null, "week_2_checkin": null},
    "optimization_cycle": {
      "audits": [
        /* each entry: {
             "date": "ISO",
             "source": "paste|csv|screenshot",
             "platform": "meta|google|...",
             "metrics_summary": {...},
             "decisions": [{"ad_set": "...", "action": "kill|scale|refresh|hold", "reason": "..."}],
             "next_audit_scheduled": "ISO"
           } */
    ],
    "refreshes": [ /* creative refresh events */ ]
  },
  "warnings": [],
  "session_count": 0
}
```

Every time the skill runs:
- Increment `session_count`
- Update `last_updated`
- Append any actions to appropriate arrays
- Write the file after **every** meaningful action (not just at session end)

### Step 4 — Confirm experience level

Read `experience_level` from `ADS-BLUEPRINT-STATE.json`. Ask **one question** to re-confirm:

```
In your blueprint intake you selected **{X}** as your experience level.

Is that still right, or do you want to change?

  • Stay beginner       — I still want plain-language explanations everywhere
  • Stay intermediate   — keep the technical output + plain-language refreshers
  • Stay expert         — just the facts
  • Switch to beginner  — I need more hand-holding now that I'm executing
  • Switch to intermediate
  • Switch to expert    — I've got this, keep it tight

Reply with one line (e.g. "stay intermediate" or "switch to beginner").
```

Save the chosen level in `EXECUTION-STATE.json > experience_level`. Apply the same formatting rules as the blueprint skill:

- **Beginner**: every generated guide file gets a `-Beginner.md` twin (standalone plain-language rewrite)
- **Intermediate**: every generated guide file ends with a "📚 In plain English" section
- **Expert**: technical files only

### Step 5 — Show the auto-detected menu

Based on `EXECUTION-STATE.json` stages, determine the **current stage** (the first one where `completed == false`) and display the relevant menu for that stage. The sections below define each menu.

---

## Stage 1 — Gate Check

**Goal**: confirm no blocking issues remain from the blueprint.

### What to read from the blueprint

1. `phase_0.score`
2. `phase_0.gaps` (list of unresolved gaps)
3. `phase_2.break_even_cpa_viability` (if <0.8× industry → blocker)
4. `phase_4.landing_health_score` (if <60 → blocker)

### Compose the blocker list

Every gap above becomes an entry in `EXECUTION-STATE.json > stages.gate_check.blockers_remaining`. Priority ranking:

- **P0** (must fix before launch): pixel/tracking missing, consent banner blocking CTA, landing <40, Special Ad Categories not declared for regulated industries
- **P1** (should fix before launch): landing 40-59, trust signals absent, pricing hidden, form >7 fields
- **P2** (can defer to week 1 post-launch): minor copy improvements, benchmark misalignment

### Guidance pattern

For each P0/P1 blocker, show a card with:

1. **What's broken** (1 sentence)
2. **Why it matters** (impact on paid-ad performance — expected % CPA degradation or block reason)
3. **How to fix** (2-5 concrete actions, with code snippets / configuration values)
4. **Estimated time**
5. **Verification step** (how to confirm the fix worked)

Use **one question** at the end of each card:
```
Mark this blocker as resolved? (yes / later / help)
```

- `yes` → move to `gate_check.resolved[]`, show next blocker
- `later` → keep in `blockers_remaining`, show next
- `help` → provide deeper guidance on that specific blocker

### Examples of P0 blocker cards

**Example 1 — Missing pixel**:
```
🔴 P0 — Meta Pixel not detected on site

What's broken:
  Your site has no Meta Pixel loaded. Without it, Meta can't optimize for your
  conversion event, and you lose 30-50% delivery efficiency within 14 days.

Why it matters:
  Meta needs ~50 optimization events to exit the learning phase. Without pixel,
  those events don't land back to the algorithm → learning phase never exits
  → CPA stays stubbornly high.

How to fix:
  1. Go to Meta Events Manager → Data Sources → + Add → Web
  2. Copy the base pixel code (the <script> block starting with !function(f,b,e,v))
  3. Paste it in the <head> of every page of {{site_url}}
     (If using Next.js: add to app/layout.tsx head section)
  4. Add Conversions API server-side for EMQ ≥ 7
     (See: docs.developers.facebook.com/docs/marketing-api/conversions-api)
  5. Configure standard event: CompleteRegistration mapped to trial signup

Estimated time: 45-90 min for pixel only; 3-5 hours with CAPI server-side

Verification:
  • Meta Events Manager → Test Events → Load your site in a new tab
  • Trigger a test event (click the signup button)
  • Confirm event appears in Test Events with EMQ score

Mark this blocker as resolved? (yes / later / help)
```

**Example 2 — Landing health <60**:
```
🔴 P0 — Landing page health score: 54/100

What's broken:
  Your landing page (from Phase 4 audit) has these top issues:
  1. {{top_gap_1}}
  2. {{top_gap_2}}
  3. {{top_gap_3}}

Why it matters:
  Meta and Google both factor landing page quality into their delivery algorithm.
  A 54-score page typically sees 35-50% worse CPA than an 80+ page — regardless
  of ad quality. Launching now means paying for traffic your page wastes.

How to fix:
  Open ADS-Blueprint/Phase-4-Landing-Test/ADS-LANDING.md — the audit already
  has rewrite suggestions ready. Address the top 3 gaps listed above
  (estimated 3-6 hours of landing page work).

Estimated time: 3-6 hours

Verification:
  • Re-run /maxym-ai-ads:ads-landing {{site_url}} after changes
  • Confirm health score >70 before proceeding

Mark this blocker as resolved? (yes / later / help)
```

### After all blockers are resolved

Show summary:
```
✅ Gate check complete.

  Resolved:      {N} blockers
  Still open:    {M} blockers (deferred to post-launch)

  You're cleared to move to tracking setup. Ready?  (yes / review / stop)
```

Mark `stages.gate_check.completed = true` only if all P0 are resolved. Keep P1/P2 deferred in the state.

---

## Stage 2 — Pre-Launch Tracking Setup

**Goal**: every tracking pixel, audience list, UTM template, consent implementation is verified before ads run.

### The 8-item checklist

For each item, display a card with:
- Status (checked from `EXECUTION-STATE.json.stages.pretrack_setup`)
- What to do (platform-specific steps)
- Values to use (drawn from the blueprint: company name, primary conversion event, UTM conventions)
- Verification method

Items (only show the ones relevant to the user's active platforms):

1. **Meta Pixel + CAPI** (if Meta is active)
2. **Google GA4 + gtag** (always; GA4 is universal)
3. **LinkedIn Insight Tag** (if LinkedIn active)
4. **TikTok Pixel + Events API** (if TikTok active)
5. **Microsoft UET Tag** (if Microsoft active)
6. **Consent Mode V2** (if EU/EEA traffic — detect from `intake.language` or ask)
7. **UTM template per platform** (auto-generate from company name + platform)
8. **Audience lists upload** (Customer Match / Matched Audiences — if user has customer lists)
9. **Budget alerts + daily caps** (set 20% above planned daily)

### UTM template auto-generation

From `intake.url`, product name, and current campaign identifier:

```
utm_source={platform}&utm_medium=cpc&utm_campaign={CompanyName}-Launch-{YYYY-MM}&utm_content={ad_set_name}&utm_term={keyword_or_audience}

Example for Meta campaign launching May 2026:
  ?utm_source=meta&utm_medium=cpc&utm_campaign=LeavePilot-Launch-May2026&utm_content=prospecting-icp-hr&utm_term=lookalike-1pct
```

Save the template in `ADS-Blueprint/Execution/utm-templates.md`.

### Verification cascade

After all items are marked done, run a final check:

```
🧪 Pre-launch tracking verification

Before you launch, let's verify everything is firing correctly.

  1. Open your site in a browser with this query string appended:
     {{site_url}}?gtm_debug=true&fbclid=TEST&gclid=TEST

  2. Visit 3 key pages: homepage, signup, thank-you

  3. Open Meta Events Manager > Test Events → do you see events? (yes / no)
  4. Open Google Analytics > Realtime → do you see yourself? (yes / no)
  5. Open Google Tag Assistant → any red flags? (paste the report)

I'll wait for your answers one question at a time.
```

Ask each verification question individually.

### Output artifacts

After Stage 2 completion, write/update:

- `ADS-Blueprint/Execution/pretrack-verification-report.md` — results of all checks
- `ADS-Blueprint/Execution/utm-templates.md` — UTM template per platform

If beginner mode: add `-Beginner.md` twins.

Mark `stages.pretrack_setup.completed = true`.

---

## Stage 3 — Campaign Build (Per Platform)

**Goal**: guide the user to create every campaign in every active platform's dashboard, with exact values, copy, audiences, and bidding drawn from the blueprint files.

### Order of platforms (launch sequence)

From industry best practice (Reality Check + strategy):

1. **Google Search** (highest intent) — but ONLY if keywords file exists
2. **Meta** (retargeting first, then prospecting) — highest volume
3. **LinkedIn** (if B2B and budget ≥$1,000/mo)
4. **TikTok** (if creative assets support it)
5. **Microsoft** (if Google campaigns are live — for import)
6. **Apple Ads** (if mobile-app industry)

### Per-platform build flow

For each active platform, follow this pattern (one platform at a time, unless user requests parallel):

#### Step 3.1 — Show the build plan

Display what campaigns this platform should run, derived from `ADS-STRATEGY.md` and `ADS-BUDGET.md`:

```
Meta campaign build plan (derived from your blueprint):

  Campaigns to create:
    1. [BOFU] Meta — Prospecting — Advantage+ Shopping
       Budget: $15/day      Bidding: Lowest cost, CPA cap $35
       Audience: Advantage+ (broad), exclude existing customers
       Ads: 4 variants (see ADS-COPY-Meta.md)

    2. [MOFU] Meta — Retargeting — Last 30 days visitors
       Budget: $5/day       Bidding: Lowest cost
       Audience: Website visitors 30d, excl. signups
       Ads: 3 variants (value prop reminder)

  Total Meta budget: $20/day / $600/month (out of $1,500 total)

Files to have open while we work:
  • ADS-Blueprint/Phase-3-Creative/ADS-COPY-Meta.md
  • ADS-Blueprint/Phase-3-Creative/campaign-brief.md
  • ADS-Blueprint/Phase-3-Creative/ad-assets/ (your generated images)

Ready to build in Meta Ads Manager? (yes / skip-platform / stop)
```

#### Step 3.2 — Step-by-step walkthrough

For each campaign in the plan, produce a numbered set of instructions. Use the **hybrid tone** (rule 3 in the build spec):

- **Literal with menu paths** for critical operations (pixel selection, bid strategy, conversion event)
- **Generic** for everything else

Example for the Meta Prospecting campaign (literal critical steps highlighted with ▸):

```
Campaign 1 of 2 — Meta Prospecting

  1. Meta Ads Manager → click "+ Create"
  2. Campaign objective: ▸ Sales  (NOT Traffic, NOT Engagement)
  3. Campaign name (copy-paste): LeavePilot-Launch-May2026-Meta-Prospecting
  4. Advantage campaign budget ▸ ON, daily budget $15
  5. Campaign Budget Optimization: use the default

  → Ad Set level:
  6. Conversion location: Website
  7. Performance goal: ▸ Maximize conversions
  8. Conversion event: ▸ CompleteRegistration  (the pixel event you
     configured for trial signup)
  9. Cost per result goal: $35 (your target CPA from ADS-MATH.md)
 10. Audience: ▸ Advantage+ audience (let Meta do the targeting).
     Exclusions: upload your existing customer list as an exclusion.
 11. Placements: Advantage+ placements (default)
 12. Optimization & delivery: leave all defaults

  → Ad level:
 13. Ad name (copy-paste): Meta-Prospecting-Ad1-HookA
 14. Identity: select your Facebook Page + Instagram account
 15. Format: Single image
 16. Media: upload ad-assets/meta-prospecting-1.jpg
     (from Phase-3-Creative/ad-assets/)
 17. Primary text — paste exactly this from ADS-COPY-Meta.md:
     ──────────────────────────────────────────────
     [PASTE: Primary Text variant 1 from ADS-COPY-Meta.md]
     ──────────────────────────────────────────────
 18. Headline:
     [PASTE: Headline variant 1]
 19. Description:
     [PASTE: Description variant 1]
 20. Call to Action: ▸ Sign Up
 21. Website URL: https://leavepilot.netlify.app?utm_source=meta&utm_medium=cpc&utm_campaign=LeavePilot-Launch-May2026&utm_content=prospecting-icp-hr&utm_term=adv-plus
 22. Confirm: Publish (but do NOT turn it on yet — save as "Off")

  Repeat steps 13-22 for variants 2, 3, and 4 (same ad set, different creative).

  When you're done, tell me "meta prospecting built" and we'll move to retargeting.
```

**Key rule**: after each campaign, wait for confirmation before moving to the next. Update `stages.campaign_build.platforms.meta.campaigns[]` with each completed campaign.

#### Step 3.3 — Output: per-platform setup guide file

For each platform the user builds, write a dedicated Markdown file in `ADS-Blueprint/Execution/`:

- `meta-setup-instructions.md`
- `google-setup-instructions.md`
- `linkedin-setup-instructions.md`
- `tiktok-setup-instructions.md`
- `microsoft-setup-instructions.md`
- `apple-setup-instructions.md` (if active)

Each file contains the step-by-step instructions the user followed, with their actual values substituted in (not the placeholder `{{site_url}}` notation). This way the user can re-read the instructions later without re-invoking the skill.

If beginner mode: add `-Beginner.md` twins for each.

#### Step 3.4 — After all platforms done

Summary:
```
🚧 Campaign build complete.

  Platforms built: meta (2), google (3), linkedin (1)
  Total campaigns: 6
  Total daily budget: $47 / monthly $1,410 (out of $1,500 plan)

  All campaigns are in "Off" state — nothing is spending yet.

  Ready to move to launch day?  (yes / review / stop)
```

Mark `stages.campaign_build.platforms.<X>.status = "done"` and set `done_at` timestamp.

---

## Stage 4 — Launch Day

**Goal**: coordinate the exact sequence of turning campaigns on and the 48-hour observation window.

### The launch sequence

Show the user the launch order explicitly:

```
🚀 Launch Day — LeavePilot

Today is {{date}}.

Before we begin, a final pre-flight check:
  ✓ Pre-track verification completed {{date}}
  ✓ All 6 campaigns built and sitting in "Off" state
  ✓ Gate check: 0 P0 blockers remaining
  ✓ Your calendar: can you check in at hour 2, hour 24, and hour 48?
    (yes / no)
```

Wait for reply. If `no`: "Then let's delay launch by 24h — when can you check in?" and update launch date.

If `yes`:

```
Launch order (activate in this sequence, one per assistant message below):

  1. Google Search: Brand + Non-Brand high intent (first)
  2. Google Search: Non-Brand informational
  3. Meta Retargeting (low risk, audience already warm)
  4. Meta Prospecting (Advantage+)
  5. LinkedIn Sponsored Content (if active)

Why this order:
  Search captures existing demand — fastest conversions, lowest risk of budget
  burn. Retargeting runs on an already-warm audience. Prospecting is the biggest
  unknown, so we launch it when the funnel upstream is already flowing.

Reply "start" when you're in front of your ad platforms.
```

When user replies `start`:

```
Step 1/5 — Activate Google Search: Brand + Non-Brand high intent

  1. Google Ads → Campaigns → find campaign "LeavePilot-Launch-May2026-GSearch-HighIntent"
  2. Toggle: Paused → Enabled
  3. Verify delivery starts within 5-10 minutes (Impression counter moves)

Reply "done" when activated. I'll give you the next step.
```

Wait. After user replies `done`, move to step 2/5. Continue one step at a time.

### 48-hour observation window

After all campaigns are activated:

```
✅ All campaigns activated at {{timestamp}}.

For the next 48 hours, the rule is: DO NOT EDIT.

Schedule these three check-ins:

  🕒 Hour 2  → {{time + 2h}}:
       Verify ads are serving (check Impressions > 0 on each campaign)
       Check Meta Ads Manager > Delivery → any ads disapproved?
       Check Google Ads > Overview → any policy warnings?

  🕒 Hour 24 → {{date + 1d}}:
       First spend sanity check. Daily budget pacing 50%+ on track?
       First conversions coming in? (Don't panic if zero — normal)

  🕒 Hour 48 → {{date + 2d}}:
       Confirm pixel events landing correctly (Meta Events Manager Test Events)
       Any ad set in "Limited" delivery state? Common in learning phase — ignore.

I'll ping you back to record each check-in. When you've done the hour-2
check, paste your notes here and I'll log them.
```

Record each check-in in `EXECUTION-STATE.json > stages.learning_phase` and in `EXECUTION-LOG.md`.

### The "Do Nothing" rule

If the user wants to edit anything during hours 0-48, refuse and explain:

```
⛔ Do NOT edit campaigns in the first 48 hours.

  Why: Meta and Google need ~50 conversion events to exit learning phase.
  Every edit (budget change, bid change, creative pause, audience change)
  resets the learning phase to zero. You'll see worse CPA and delay the
  optimization signal by days.

  What feels wrong right now? I can help you understand if it's actually
  a problem or normal learning-phase turbulence.
```

Wait for user to describe. Respond with diagnostic help but maintain the no-edit rule unless there's a real emergency (Ads disapproved, pixel broken, accidental 10x budget increase).

Mark `stages.launch_day.completed = true` at end.

---

## Stage 5 — Learning Phase (Weeks 1-2)

**Goal**: observe without interfering. 2 check-ins per week.

### The 4 check-ins

Each check-in is a **single conversation** with the user that reads pasted metrics and gives an observation-only update — no actions.

**Day 4 check-in** (first week):
```
Week 1, Day 4 Check-In

Paste me these metrics from each active campaign:
  Campaign name | Impressions | Clicks | Spend | Conversions | CPA | CTR

(You can take a screenshot of the Ads Manager overview and paste the
text portion, or export CSV — either works.)
```

User pastes. Skill parses and responds:

```
Week 1, Day 4 — Observation Report

  Learning phase: 5/7 campaigns still in learning
  Conversion events: 12 across all campaigns (need ~50 to exit learning on Meta)
  Delivery: all campaigns serving, no disapprovals

  Signals I'm watching:
    • Meta Prospecting: CTR 1.2% (above 0.9% benchmark) — good early sign
    • Google Non-Brand informational: CPC $3.80 vs $2.50 target — watch
    • LinkedIn: zero conversions yet — normal, LinkedIn needs 10-14d

  Action this week: NONE. Let the algorithms learn.

  Next check-in: Day 7 (same format). I'll log this and be ready.
```

**Day 7**, **Day 10**, **Day 14** check-ins follow the same pattern.

Update `EXECUTION-STATE.json > stages.learning_phase > week_N_checkin` with each.

### Learning phase exit detection

If at Day 14 fewer than 50 conversions total across campaigns:

```
⚠️ Learning phase not yet exited.

  Total conversions after 14 days: {{N}} (need 50 for Meta's threshold)

  Options:
    1. Wait another 7 days and re-evaluate
    2. Consolidate ad sets (combine similar targeting to concentrate signal)
    3. Broaden audience on prospecting campaigns (drop narrow interests)
    4. Increase budget 20% on best performers

  What's your preference?  (1/2/3/4/ask)
```

Wait for reply and continue accordingly.

If 50+ conversions reached before Day 14: move to Stage 6 early.

Mark `stages.learning_phase.completed = true` when either condition met.

---

## Stage 6 — Optimization Cycle (bi-weekly, ongoing)

**Goal**: every 2 weeks the user runs a full audit with the skill's help. Apply the 3 sacred rules mechanically on the data they paste.

### Auto-detect this stage

If `EXECUTION-STATE.json > stages.optimization_cycle.audits[]` has entries, or if `stages.learning_phase.completed == true`, show this menu:

```
You're in the optimization cycle. What would you like to do?

  1. 🧪 Run a bi-weekly audit           (paste metrics or share a CSV)
  2. 🔄 Refresh creative                 (fatigue detected or scheduled)
  3. 🚀 Scale a winning campaign         (apply the 20% rule)
  4. ⛔ Kill a losing campaign           (apply 3× Kill Rule check)
  5. 📊 Update the live dashboard       (regenerate live-dashboard.html)
  6. 📝 View execution log              (see EXECUTION-LOG.md highlights)
  7. 🎯 Review the original plan        (open ADS-STRATEGY-REPORT.md summary)

Reply with the number or the action name.
```

### 1. Bi-weekly audit

```
Let's run your bi-weekly audit.

For the most accurate analysis, CSV export is best. Do you have one, or
would a paste be easier for you?

  paste    — you copy-paste metrics from Ads Manager (quick, approximate)
  csv      — you export CSV and put it in ADS-Blueprint/Execution/live-data/
             (accurate, preferred for decision-making)
  screenshot — you have a screenshot of the dashboard (I'll parse the visible text)

Reply with one word.
```

**If paste**: user pastes tabular text. Skill parses, normalizes columns, runs analysis.

**If csv**: user places file in `ADS-Blueprint/Execution/live-data/meta-audit-2026-05-20.csv` (or similar). Skill reads with structured parsing.

**If screenshot**: user pastes the text-content of the screenshot. Skill parses best-effort.

Then for each campaign/ad set in the data:

```
Applying the 3 sacred rules:

  📊 Meta-Launch-May2026-Prospecting-AdSet1
     Days running: 21 | Spend: $315 | Conversions: 8 | CPA: $39.38
     Target CPA: $35 | Ratio: 1.12×

     Verdict: ✅ ACCEPTABLE — CPA within tolerance (0.5× to 2× of target).
     Frequency: 1.8 (healthy, under 3.0 threshold).
     Action: NONE. Continue current budget.

  📊 Meta-Launch-May2026-Prospecting-AdSet2
     Days running: 21 | Spend: $310 | Conversions: 2 | CPA: $155.00
     Target CPA: $35 | Ratio: 4.43×

     Verdict: ⛔ KILL — triggers the 3× Kill Rule (CPA > 3× target).
     Data points: 21 days + 2 conversions (sufficient to decide).
     Action: pause this ad set. Reallocate budget to AdSet1 and the
     Retargeting ad set.

  📊 Meta-Launch-May2026-Retargeting-AdSet1
     Days running: 21 | Spend: $105 | Conversions: 7 | CPA: $15.00
     Target CPA: $35 | Ratio: 0.43×

     Verdict: 🚀 SCALE — strongly profitable. Apply 20% rule.
     Current daily budget: $5. New daily budget: $6 (+20%).
     Important: wait 3-5 days before next increase.
     Frequency: 2.4 (fine, under 3.0).

Summary:
  • KILL   : 1 ad set (save $5/day, reallocate)
  • SCALE  : 1 ad set (+$1/day)
  • HOLD   : 1 ad set (stable)

Shall I generate the step-by-step instructions to apply these changes
in Meta Ads Manager? (yes / edit / stop)
```

If `yes`: generate the click-by-click instructions (same format as Stage 3 build, but for edits).

Record the audit in `EXECUTION-STATE.json > stages.optimization_cycle.audits[]` and append to `EXECUTION-LOG.md`.

### 2. Creative fatigue refresh

Detect fatigue signals:
- Frequency > 3.0 on Meta
- CTR dropped >30% from 7-day peak
- CPA climbed >20% over 14 days with no other changes

If detected automatically during an audit, flag it. If user requests manually:

```
Creative refresh — let's assess your current ads.

Paste the Frequency and CTR columns for each active ad:
  Ad name | Frequency | CTR | CPA

(Meta only — Google Ads doesn't show Frequency.)
```

User pastes. Skill identifies fatigued ads and produces refresh recommendations:

```
Creative fatigue detected in 3 ads:

  Meta-Prospecting-Ad1-HookA
    Frequency: 3.4 | CTR now: 0.6% (was 1.4% at day 7) — -57% drop
    Verdict: REFRESH needed within this week.

  Meta-Prospecting-Ad3-HookC
    Frequency: 3.1 | CTR now: 0.8% — -43%
    Verdict: REFRESH needed within 2 weeks.

  Meta-Retargeting-Ad2
    Frequency: 4.2 | CTR: 1.1% (was 2.8%)
    Verdict: REFRESH URGENTLY.

Refresh playbook for each:

  Option A (minimum effort): swap the image, keep copy and headline.
           1-hour work, 2-3 day testing window.

  Option B (better): regenerate the creative concept. Open
           ADS-Blueprint/Phase-3-Creative/ADS-HOOKS.md and pick 2 hooks
           you haven't used yet. Regenerate images with /ads-generate
           feeding those hooks in.

  Option C (best): full new creative round from /ads-create +
           /ads-generate using fresh campaign-brief angles.
           Best for long-term avoidance of Andromeda creative clustering.

Which option would you prefer? (A / B / C)
```

### 3. Scale a winner

User identifies a winning campaign. Skill applies the **20% Scaling Rule** and checks pre-conditions:

```
Scale check for: {{campaign_name}}

Checking pre-conditions:
  ✓ Days running: 21 (need ≥14)
  ✓ CPA vs target: 0.43× (need ≤0.8×)
  ✓ Conversion volume: 7 last 14 days (need ≥5)
  ✓ CTR stability: no drop in last 7 days
  ✓ Frequency: 2.4 (need ≤3.0)

All green. Safe to scale.

Current daily budget: $5
New daily budget:     $6 (+20% = $1)
Next scale window:    earliest {{date + 4d}}

Instructions to apply:
  1. Meta Ads Manager → Campaigns → find {{campaign_name}}
  2. Edit → Daily budget: $5 → $6
  3. Save
  4. Do NOT touch anything else
  5. Do NOT scale again before {{date + 4d}}

Reply "scaled" when done. I'll log it and compute your next check-in date.
```

### 4. Kill a loser

User identifies a losing campaign. Skill verifies 3× Kill Rule conditions:

```
Kill check for: {{campaign_name}}

Checking 3× Kill Rule conditions:
  Days running: {{N}}
  Spend: ${{X}}
  Conversions: {{Y}}
  CPA: ${{Z}}   Target CPA: ${{T}}   Ratio: {{Z/T}}×

Decision tree:
  • If ratio > 3× AND (spend ≥ $100 OR clicks ≥ 50 OR days ≥ 7):
    → KILL (definitive)
  • If ratio > 3× AND spend < $100:
    → WAIT for more data (another 3-5 days)
  • If ratio 2-3×:
    → CUT BUDGET 50%, reassess in 7 days
  • If ratio < 2×:
    → HOLD, continue monitoring

Outcome: [kill / wait / cut_50 / hold]
Instructions:
  {{specific instructions for this decision}}

Reply "killed" (or "cut") when done.
```

### 5. Update the live dashboard

See the next section.

### Output artifacts per audit

After each audit, update:

- `ADS-Blueprint/Execution/EXECUTION-LOG.md` — append dated entry
- `ADS-Blueprint/Execution/live-dashboard.html` — regenerate with latest state
- `ADS-Blueprint/EXECUTION-STATE.json` — append to `audits[]`

If beginner mode: add/update `-Beginner` variants of the audit files.

---

## Output File Organization

All execution artifacts live in `ADS-Blueprint/Execution/`:

```
ADS-Blueprint/
├── ADS-BLUEPRINT-STATE.json          (from /ads-blueprint, don't touch)
├── Phase-0-Reality-Check/             (from /ads-blueprint, don't touch)
├── Phase-1-Intelligence/              (from /ads-blueprint, don't touch)
├── Phase-2-Budget-Funnel/             (from /ads-blueprint, don't touch)
├── Phase-3-Creative/                  (from /ads-blueprint, don't touch)
├── Phase-4-Landing-Test/              (from /ads-blueprint, don't touch)
├── EXECUTION-STATE.json               ← THIS SKILL owns this file
└── Execution/
    ├── EXECUTION-LOG.md               ← session-by-session diary
    ├── live-dashboard.html            ← interactive status page
    ├── pretrack-verification-report.md
    ├── utm-templates.md
    ├── meta-setup-instructions.md
    ├── google-setup-instructions.md
    ├── linkedin-setup-instructions.md       (if used)
    ├── tiktok-setup-instructions.md         (if used)
    ├── microsoft-setup-instructions.md      (if used)
    ├── apple-setup-instructions.md          (if used)
    ├── launch-day-sequence.md
    ├── live-data/
    │   ├── meta-audit-YYYY-MM-DD.csv
    │   ├── google-audit-YYYY-MM-DD.csv
    │   └── ...
    └── *-Beginner.md                   ← beginner twins (if beginner mode)
```

Always `mkdir -p ADS-Blueprint/Execution/live-data` before writing any file.

---

## EXECUTION-LOG.md format

Append-only diary. New entry per session.

```markdown
# Execution Log — {{Company}}

## Session 1 — 2026-05-01 14:30 UTC
**Stage**: gate_check
**Duration**: 22 min
**Experience mode**: intermediate

### Actions
- ✅ Resolved P0: Meta Pixel installed + Test Event passed
- ✅ Resolved P0: GA4 deployed + Enhanced Measurement on
- ⏸️ Deferred P1: Add 3 testimonials to homepage (scheduled 2026-05-05)
- ⏸️ Deferred P1: Replace "0+" placeholder metrics (scheduled 2026-05-05)

### Next session
Target: 2026-05-03 — complete pre-track setup (LinkedIn Insight, CAPI)

---

## Session 2 — 2026-05-03 10:15 UTC
**Stage**: pretrack_setup
**Duration**: 45 min
**Experience mode**: intermediate
...
```

---

## Live Dashboard HTML

`ADS-Blueprint/Execution/live-dashboard.html` is a standalone self-contained page (no external CDN) that shows the **current state** of execution:

- Current stage + % progress bar
- Blocker status (P0/P1/P2)
- Per-platform campaign build status
- Latest audit summary (from last entry in `audits[]`)
- Scaled + killed + refreshed campaigns counts
- Next scheduled action

The template is at `skills/ads-blueprint-execution/assets/live-dashboard-template.html`.

**Generation rules** (same token-substitution pattern as blueprint HTML):

| Token | Source |
|---|---|
| `{{COMPANY_NAME}}` | brand-profile.json > company.name |
| `{{CURRENT_STAGE}}` | derived from EXECUTION-STATE.json |
| `{{PROGRESS_PERCENT}}` | % of 6 stages completed |
| `{{LAST_UPDATED}}` | state.last_updated |
| `{{BLOCKERS_OPEN}}` | count of open blockers |
| `{{CAMPAIGNS_ACTIVE}}` | sum of active campaigns across platforms |
| `{{DAILY_SPEND}}` | sum of current daily budgets |
| `{{TOTAL_CONVERSIONS_30D}}` | from latest audit |
| `{{BLENDED_CPA}}` | computed from latest audit |
| `{{LAST_AUDIT_DATE}}` | most recent audit entry |
| `{{NEXT_AUDIT_DUE}}` | last audit + 14 days |
| `{{DECISIONS_THIS_MONTH}}` | kill + scale + refresh counts |
| `{{EXECUTION_LOG_RECENT}}` | last 5 log entries as HTML |
| `{{PLATFORM_STATUS_TABLE}}` | table of per-platform state |
| `{{AUDIT_DECISIONS_TABLE}}` | latest audit's kill/scale/hold decisions |
| `{{EXPERIENCE_LEVEL}}` | execution-state.experience_level |
| `{{BEGINNER_BANNER}}` | same rules as blueprint HTML |

Regenerate the HTML after every significant action (gate resolved, pre-track item checked, campaign built, launch, audit run, kill/scale applied). Never require the user to manually trigger the regeneration.

---

## Hard Rules (non-negotiable)

1. **NEVER fabricate metrics**. If the user hasn't pasted real data, don't invent numbers. Instead say: "I need you to paste or export this info before I can decide".
2. **NEVER suggest editing campaigns in learning phase (first 14 days)** unless there's a true emergency (ad disapproval, pixel broken, budget accident).
3. **NEVER recommend scaling beyond +20% per 3-5 days**. No matter how good performance looks.
4. **NEVER recommend killing a campaign with <$100 spend OR <50 clicks OR <7 days runtime**. Data too thin.
5. **ALWAYS read `ADS-Blueprint/ADS-BLUEPRINT-STATE.json` first** at session start, unless `--fresh` is passed.
6. **ALWAYS persist state** to `ADS-Blueprint/EXECUTION-STATE.json` after every meaningful action.
7. **ALWAYS ask ONE question at a time** — same rule as the blueprint skill.
8. **RESPECT experience_level** for output formatting (beginner / intermediate / expert).
9. **ALWAYS reference specific values from blueprint files** in setup instructions. Never use generic placeholders if a real value exists.
10. **AT START of every session**, regenerate `live-dashboard.html` before showing the main menu. Makes "refresh the dashboard" a no-op (already fresh).
11. **NEVER ask the user to run a `/ads-` command** mid-execution unless it's clearly the right tool (e.g. re-running `/ads-landing` after landing fixes). This skill is the coach; other skills are analysis tools.
12. **RESPECT `intake.language`** from the state file for all text output.

---

## Adaptive Output — Same 3 Modes as Blueprint

### Beginner
Every setup guide, log entry, and audit report gets a `-Beginner.md` twin rewriting the content in plain language with analogies, glossary, "what to do next".

### Intermediate
Every setup guide, log entry, and audit report ends with a "📚 In plain English" section (200-500 words, define terms, 3 key takeaways).

### Expert
Technical files only. Fastest output. No explainers.

The HTML dashboard shows a banner for beginner/intermediate, nothing for expert.

---

## Metric Parsing

Accept paste / CSV / screenshot-text in these typical formats:

### Meta Ads Manager paste
```
Campaign name	Delivery	Budget	Results	Cost per result	Reach	Impressions	Frequency	Link clicks	CTR	CPC	Amount spent
```

### Google Ads paste
```
Campaign	Status	Budget	Impr.	Clicks	CTR	Avg. CPC	Cost	Conversions	Cost / conv.	Conv. rate
```

### LinkedIn paste
```
Campaign Name	Status	Spend	Impressions	Clicks	CTR	Avg. CPC	Conversions	Cost per Conversion
```

Each platform has slightly different column order. Handle flexibly — detect headers, not positions.

### Screenshot text
Use best-effort OCR-like parsing of pasted text. If confidence is low, ask the user **one** clarifying question per unclear field.

### CSV
Read line by line. Detect common header variants (case-insensitive, whitespace-tolerant). Fallback: ask user to specify column mapping.

---

## Invocation examples

```shell
# Auto-detect phase and continue
/maxym-ai-ads:ads-blueprint-execution

# Force restart from gate check
/maxym-ai-ads:ads-blueprint-execution --fresh

# Jump to a bi-weekly audit (user already post-launch)
/maxym-ai-ads:ads-blueprint-execution audit
```

---

## Session flow summary

```
  ▶ Read ADS-BLUEPRINT-STATE.json (if --fresh not passed)
  ▶ Read EXECUTION-STATE.json (create if missing)
  ▶ Ask ONE question: confirm experience level
  ▶ Regenerate live-dashboard.html with current state
  ▶ Display the correct menu based on auto-detected stage
  ▶ Execute the user's choice step by step (one Q at a time)
  ▶ After EVERY action: persist state + regenerate dashboard + append to log
  ▶ At session end: print summary + "next recommended action" timeline
```
