#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "→ Uninstalling maxym-ai-ads..."

    # Remove main orchestrator (includes references, research-sources, scripts)
    rm -rf "${HOME}/.claude/skills/ads"

    # Remove sub-skills (31)
    for skill in \
        ads-blueprint ads-blueprint-execution \
        ads-strategy ads-quick ads-audience ads-plan ads-keywords ads-competitor \
        ads-copy ads-hooks ads-video ads-creative-brief ads-creative-audit \
        ads-funnel ads-budget ads-testing ads-landing \
        ads-audit ads-google ads-meta ads-youtube ads-linkedin ads-tiktok ads-microsoft ads-apple \
        ads-dna ads-create ads-generate ads-photoshoot \
        ads-math ads-test ads-report-pdf; do
        rm -rf "${HOME}/.claude/skills/${skill}"
    done

    # Remove subagents (15)
    for agent in \
        audit-google audit-meta audit-creative audit-tracking audit-budget audit-compliance \
        creative-strategist visual-designer copy-writer format-adapter \
        strategy-audience strategy-creative strategy-funnel strategy-competitive strategy-budget; do
        rm -f "${HOME}/.claude/agents/${agent}.md"
    done

    echo "✓ maxym-ai-ads uninstalled."
}

main "$@"
