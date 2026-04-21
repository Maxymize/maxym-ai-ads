# Changelog

All notable changes to this project are documented here. The format is loosely based on [Keep a Changelog](https://keepachangelog.com/) and this project adheres to semantic versioning where practical.

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
