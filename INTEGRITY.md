# Integrity Report — v1.0.02 (2026-04-21)

Automated checks performed before release.

## Structure

- ✓ Plugin manifest at `.claude-plugin/plugin.json`
- ✓ Marketplace manifest at `.claude-plugin/marketplace.json`
- ✓ Orchestrator skill at `skills/ads/SKILL.md`
- ✓ 31 sub-skills at `skills/ads-*/SKILL.md` (incl. new `ads-blueprint`)
- ✓ 15 subagents at `agents/*.md`
- ✓ Blueprint HTML template at `skills/ads-blueprint/assets/report-template.html`

## Lint

- ✓ Every `SKILL.md` has valid YAML frontmatter with both `name:` and `description:` fields (32 files total: 1 orchestrator + 31 sub-skills)
- ✓ `plugin.json` and `marketplace.json` are valid JSON
- ✓ HTML template is standalone (no external CSS/JS dependencies, no CDN)

## Router Coverage

- ✓ All 31 sub-skills under `skills/ads-*/` referenced by `skills/ads/SKILL.md`
- ✓ New `blueprint` command entry present in both Quick Reference and routing table

## Agent Referencing

- ✓ All 15 subagents (`agents/*.md`) are referenced by at least one skill or the orchestrator

## File Counts

| Artifact | Count |
|---|---:|
| Skills under `skills/` (orchestrator + sub-skills) | 32 |
| Subagents (`agents/*.md`) | 15 |
| Industry strategy templates (`skills/ads-plan/assets/*.md`) | 12 |
| RAG reference files (`skills/ads/references/*.md`) | 25 |
| Research source files (`skills/ads/research-sources/*.md`) | 6 |
| Blueprint HTML template (`skills/ads-blueprint/assets/report-template.html`) | 1 |
| Python scripts (`scripts/*.py`) | 7 |

## Branding Sweep

- ✓ Zero third-party branding residues outside `NOTICES.md` and `LICENSE` (MIT-required attribution only)

## Install Script Paths

- ✓ `skills/ads/SKILL.md`, `skills/ads/references/`, `agents/`, `scripts/`, `requirements.txt` all present
- ✓ `install.sh` and `uninstall.sh` are executable (`chmod +x`)
- ✓ Installers copy both `*.md` and `*.html` files from each skill's `assets/` directory

## Plugin Installability

- ✓ Installable as a standalone skill bundle via `./install.sh`
- ✓ Installable as a Claude Code plugin via `/plugin marketplace add Maxymize/maxym-ai-ads` + `/plugin install maxym-ai-ads@maxym-plugins`

## New in v1.0.02

- ✓ `ads-blueprint` skill present with complete SKILL.md
- ✓ Interactive HTML report template present and self-contained
- ✓ README and BLUEPRINT doc prominently advertise dual-mode (guided vs manual)
- ✓ Installer + uninstaller updated to handle the new skill + HTML asset

## Commit Hygiene

- ✓ Atomic commits, one per build phase
- ✓ Every commit authored by Maximilian Giurastante `<info@maxymizebusiness.com>`
