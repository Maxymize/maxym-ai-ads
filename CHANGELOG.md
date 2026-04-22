# Changelog

All notable changes to this project are documented here. The format is loosely based on [Keep a Changelog](https://keepachangelog.com/) and this project adheres to semantic versioning where practical.

## [1.0.04] — 2026-04-22

### Added
- **New guided skill `/ads blueprint-execution`** — the second half of the closed-loop workflow. Reads the existing `ADS-Blueprint/` folder produced by `/ads blueprint` and coaches the user through every remaining step: gate check (close residual P0/P1 blockers), pre-launch tracking setup (pixels, CAPI, GA4, LinkedIn Insight, UTM templates, Consent Mode V2), per-platform campaign build with click-by-click instructions drawn from the blueprint files, launch day activation sequence with 2h/24h/48h check-ins, learning-phase observation (weeks 1-2 "do nothing" rule), and the bi-weekly optimization cycle.
- **Live metric parsing** — accepts pasted text from ad platform dashboards, CSV exports (placed in `ADS-Blueprint/Execution/live-data/`), or screenshot text. Parses flexibly across Meta / Google / LinkedIn / TikTok / Microsoft column formats.
- **Mechanical rule application** — 3× Kill Rule, 20% Scaling Rule, Learning-Phase Protection, creative fatigue detection (frequency >3.0, CTR drop >30%) applied on the user's real data with ready-to-execute edit instructions.
- **Live HTML dashboard** (`ADS-Blueprint/Execution/live-dashboard.html`) — self-contained interactive page showing current stage, KPIs, open blockers, per-platform build status, latest audit decisions, recent session log, and the recommended next action. Regenerated automatically after every session.
- **Execution log** (`ADS-Blueprint/Execution/EXECUTION-LOG.md`) — dated diary of every action taken (resolved blockers, installed pixels, built campaigns, launched, scaled, killed, refreshed).
- **Per-platform setup guides** — `meta-setup-instructions.md`, `google-setup-instructions.md`, etc. written during the build stage, so the user can re-read without re-invoking the skill.
- **`EXECUTION-STATE.json`** — persistent state tracking 6 stages (gate_check → pretrack_setup → campaign_build → launch_day → learning_phase → optimization_cycle) and every decision.

### Changed
- Sub-skill count: 31 → 32 (added `ads-blueprint-execution`)
- Router (`skills/ads/SKILL.md`) — new "Guided Experience" entry for `blueprint-execution`; routing table updated; argument-hint extended
- README — new "Closed-loop workflow: plan → execute" section positioning the two guided skills as a unified story; new badge "🌟 guided: blueprint + execution"
- `docs/BLUEPRINT-ZERO-TO-SALES.md` — new "After the plan: execute it" section linking to the new skill; navigation links updated
- Installers (`install.sh`, `install.ps1`) — copy the new skill including its HTML dashboard template; updated usage hints
- Uninstallers — clean up `ads-blueprint-execution` on uninstall

### Hard rules (new, for the execution skill)
- NEVER fabricate metrics — if the user hasn't pasted real data, refuse to decide
- NEVER suggest editing during learning phase unless there's a true emergency
- NEVER recommend scaling beyond +20% per 3-5 days
- NEVER recommend killing with <$100 spend OR <50 clicks OR <7 days runtime
- ALWAYS read `ADS-BLUEPRINT-STATE.json` first to bootstrap context
- ALWAYS persist `EXECUTION-STATE.json` after every meaningful action
- ALWAYS regenerate `live-dashboard.html` at session start and after actions
- RESPECT `intake.experience_level` for output tone (beginner / intermediate / expert — same rule as blueprint skill)

## [1.0.03] — 2026-04-21

### Added
- **11th intake question: experience level** (beginner / intermediate / expert) added to `/ads blueprint`. The answer drives output formatting throughout every phase.
- **Beginner mode**: every technical file in every phase gets a parallel `-Beginner.md` twin — a standalone rewrite in plain language, with analogies, examples, glossary, and a "What to do next" section. Never a summary of the technical file, always a full companion document.
- **Intermediate mode**: every technical file appends a "📚 In plain English" section at the bottom (200–500 words, defines acronyms, lists key takeaways).
- **Expert mode**: technical files only, no explainers (fastest output, matches pre-v1.0.03 behavior for legacy users).
- **Beginner / Intermediate banner in the HTML report**: the hero section now shows the user's experience level and (only for beginner/intermediate) a contextual banner pointing to the plain-language companion content.

### Changed
- **Intake UX: one question at a time.** The skill now previews the full 11-question list upfront so the user can mentally prepare, then asks each question individually, waits for the answer, echoes it back, and moves to the next. This replaces the previous "dump-all-questions-at-once" pattern that forced users to copy-paste back and forth.
- **Clean output structure**: every phase writes into a dedicated subfolder `ADS-Blueprint/Phase-N-Name/`. Final deliverables (PDF, HTML, Launch Checklist, state file) live at the `ADS-Blueprint/` root. Replaces the flat-file-dump-in-CWD behavior.
- **Intake preview card** shows explicit count and "one at a time" promise.
- README and `docs/BLUEPRINT-ZERO-TO-SALES.md` prominently advertise the new adaptive-by-experience feature as a distinguishing selling point.
- New badge in README: "📚 adaptive: beginner | intermediate | expert".

### Hard rules (new)
- NEVER ask multiple questions in the same assistant message — one question, wait, echo, next.
- ALWAYS write outputs into `ADS-Blueprint/Phase-N-Name/`, never in CWD root.
- RESPECT `intake.experience_level`: beginner → write -Beginner.md twin; intermediate → append "📚 In plain English" section; expert → technical only.

## [1.0.02] — 2026-04-21

### Added
- **New guided skill `/ads blueprint`** — interactive end-to-end workflow that walks the user through all 5 phases of the Zero-to-Sales Blueprint. Asks a short questionnaire up front, runs every phase automatically, pauses at phase boundaries for confirmation, blocks only at critical decision gates (Phase 0 score <40, Phase 2 break-even CPA < 0.8× industry benchmark).
- **Interactive HTML report** — self-contained, zero-dependency, dark-themed HTML report template (`ADS-BLUEPRINT-REPORT.html`) with persistent checklist (localStorage), smooth scroll navigation, print-friendly CSS. Template lives at `skills/ads-blueprint/assets/report-template.html`.
- **Three final deliverables** produced at the end of the guided flow: `ADS-STRATEGY-REPORT.pdf` (client-ready), `ADS-BLUEPRINT-REPORT.html` (interactive), `ADS-LAUNCH-CHECKLIST.md` (week-by-week tasks).
- **State persistence** via `ADS-BLUEPRINT-STATE.json` — supports `/ads blueprint --resume` to continue after an interruption.
- **Dual-path documentation** in both README and `docs/BLUEPRINT-ZERO-TO-SALES.md`: prominent side-by-side presentation of Guided vs Manual mode so new users can choose.

### Changed
- Sub-skill count: 29 → 30 (added `ads-blueprint`)
- `install.sh` / `install.ps1` now also copy `.html` files from each skill's `assets/` directory (needed for the blueprint report template)
- Router (`skills/ads/SKILL.md`) updated with new "Guided Experience" section and `blueprint` entry in the routing table
- README: new "Two ways to run it" section, guided-workflow badge in header, `/ads blueprint` at the top of Quick Start

## [1.0.01] — 2026-04-21

### Changed
- Restructured to Claude Code plugin layout: `ads/` orchestrator moved to `skills/ads/` so it is discoverable by the plugin loader
- Added `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` — the project is now installable via `/plugin marketplace add Maxymize/maxym-ai-ads` + `/plugin install maxym-ai-ads@maxym-plugins`
- `install.sh` / `install.ps1` simplified: single loop copies every skill (orchestrator + 30 sub-skills) and their optional `references/`, `assets/`, `research-sources/` directories
- Removed redundant `skills/references/` mirror; references now live only under `skills/ads/references/`

## [1.0.00] — 2026-04-21

### Added
- Initial public release of **maxym-ai-ads**
- Unified `/ads` orchestrator with 30 sub-commands covering strategy, creative, audit, and reporting
- Full multi-platform audit across Google, Meta, YouTube, LinkedIn, TikTok, Microsoft, and Apple Ads — 250+ weighted checks
- 5-agent parallel strategy build (`/ads strategy <url>`) with Ad Readiness Score (0-100)
- 6-agent parallel audit (`/ads audit`) with Ads Health Score (0-100)
- Platform-specific ad copy generation for Google, Meta, LinkedIn, TikTok, YouTube, Pinterest
- 11 industry strategy templates: SaaS, e-commerce, local-service, B2B enterprise, info-products, mobile-app, real-estate, healthcare, finance, agency, generic
- Creative generation pipeline: brand DNA extraction → campaign brief → AI image generation → product photoshoot (5 styles)
- Audit-mode + Strategy-mode unified workflows for landing pages, budget, and competitor intelligence
- A/B testing plans, PPC math calculator, keyword research, hooks library, video scripts (15s/30s/60s)
- PDF report generation via ReportLab (`/ads report-pdf`)
- 25 RAG reference files: 2026-current benchmarks, bidding decision trees, platform specs, audit checklists, creative specs, compliance
- Quality gates: 3× Kill Rule, learning phase protection, Special Ad Categories enforcement, Andromeda creative diversity, Consent Mode V2 verification
- 15 subagents: 6 audit + 4 creative-pipeline + 5 strategy
- Cross-platform installers: `install.sh` + `install.ps1` with uninstall counterparts
- Python dependency manifest with security-conscious version pins
