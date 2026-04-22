# Integrity Report — v1.0.03 (2026-04-21)

Automated checks performed before release.

## Structure

- ✓ Plugin manifest at `.claude-plugin/plugin.json` (version 1.0.03)
- ✓ Marketplace manifest at `.claude-plugin/marketplace.json` (version 1.0.03)
- ✓ Orchestrator skill at `skills/ads/SKILL.md`
- ✓ 31 sub-skills at `skills/ads-*/SKILL.md` (incl. `ads-blueprint` with one-question-at-a-time UX, phase folders, adaptive modes)
- ✓ 15 subagents at `agents/*.md`
- ✓ Blueprint HTML template at `skills/ads-blueprint/assets/report-template.html` (now supports `{{EXPERIENCE_LEVEL}}` and `{{BEGINNER_BANNER}}`)

## Lint

- ✓ Every `SKILL.md` has valid YAML frontmatter with `name:` and `description:` fields
- ✓ `plugin.json` and `marketplace.json` are valid JSON (version bumped to 1.0.03)
- ✓ HTML template is self-contained (no external CSS/JS dependencies, no CDN)

## Router Coverage

- ✓ All 31 sub-skills referenced by `skills/ads/SKILL.md`
- ✓ `blueprint` command entry present in Quick Reference and routing table

## Agent Referencing

- ✓ All 15 subagents referenced by at least one skill or the orchestrator

## File Counts

| Artifact | Count |
|---|---:|
| Skills under `skills/` (orchestrator + sub-skills) | 32 |
| Subagents (`agents/*.md`) | 15 |
| Industry strategy templates (`skills/ads-plan/assets/*.md`) | 12 |
| RAG reference files (`skills/ads/references/*.md`) | 25 |
| Research source files (`skills/ads/research-sources/*.md`) | 6 |
| Blueprint HTML template | 1 |
| Python scripts (`scripts/*.py`) | 7 |

## Branding Sweep

- ✓ Zero third-party branding residues outside `NOTICES.md` and `LICENSE`

## Install Script Paths

- ✓ Orchestrator + 30 sub-skills copied via single loop
- ✓ `.html` assets (blueprint report template) copied alongside `.md`
- ✓ `install.sh` and `uninstall.sh` are executable

## Plugin Installability

- ✓ `./install.sh`
- ✓ `/plugin marketplace add Maxymize/maxym-ai-ads` + `/plugin install maxym-ai-ads@maxym-plugins`

## New in v1.0.03

- ✓ 11th intake question: experience level (beginner / intermediate / expert)
- ✓ Adaptive output logic documented in SKILL.md:
  - beginner → separate `-Beginner.md` twin file per technical file
  - intermediate → "📚 In plain English" section appended to each technical file
  - expert → technical files only (no explainers)
- ✓ One-question-at-a-time intake pattern with preview + per-question suggestions + echo-back
- ✓ Phase-folder output structure: `ADS-Blueprint/Phase-N-Name/`
- ✓ Final deliverables (PDF + HTML + Checklist) at `ADS-Blueprint/` root
- ✓ HTML template supports `{{EXPERIENCE_LEVEL}}` meta-item and `{{BEGINNER_BANNER}}` contextual banner
- ✓ README badge "📚 adaptive: beginner | intermediate | expert"
- ✓ README + BLUEPRINT.md advertise adaptive-by-experience as a distinguishing feature

## Commit Hygiene

- ✓ Atomic commits, one per feature
- ✓ Every commit authored by Maximilian Giurastante `<info@maxymizebusiness.com>`
