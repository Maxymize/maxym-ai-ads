#!/usr/bin/env bash
set -euo pipefail

# maxym-ai-ads installer (macOS / Linux)
# Wraps everything in main() to prevent partial execution on network failure

main() {
    SKILL_DIR="${HOME}/.claude/skills/ads"
    AGENT_DIR="${HOME}/.claude/agents"
    REPO_URL="${MAXYM_ADS_REPO_URL:-https://github.com/Maxymize/maxym-ai-ads}"

    echo "════════════════════════════════════════════════════════════"
    echo "   maxym-ai-ads — installer"
    echo "   Strategy · Creative · Multi-platform Audit · Reporting"
    echo "════════════════════════════════════════════════════════════"
    echo ""

    # Check prerequisites
    command -v git >/dev/null 2>&1 || { echo "✗ Git is required but not installed."; exit 1; }
    echo "✓ Git detected"

    # Create directories
    mkdir -p "${SKILL_DIR}/references"
    mkdir -p "${AGENT_DIR}"

    # Clone to temp directory
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "${TEMP_DIR}"' EXIT

    echo "↓ Downloading maxym-ai-ads..."
    git clone --depth 1 "${REPO_URL}" "${TEMP_DIR}/maxym-ai-ads" 2>/dev/null

    SRC="${TEMP_DIR}/maxym-ai-ads"

    # Copy every sub-skill under skills/ (including the 'ads' orchestrator)
    echo "→ Installing orchestrator + 29 sub-skills..."
    for skill_dir in "${SRC}/skills"/*/; do
        skill_name=$(basename "${skill_dir}")
        target="${HOME}/.claude/skills/${skill_name}"
        mkdir -p "${target}"
        cp "${skill_dir}SKILL.md" "${target}/SKILL.md"

        # Copy references/ (for the 'ads' orchestrator), assets/ (industry templates),
        # and research-sources/ if they exist.
        for sub in references assets research-sources; do
            if [ -d "${skill_dir}${sub}" ]; then
                mkdir -p "${target}/${sub}"
                cp "${skill_dir}${sub}/"*.md "${target}/${sub}/" 2>/dev/null || true
            fi
        done
    done

    # Copy agents
    echo "→ Installing 15 subagents (10 audit/creative + 5 strategy)..."
    cp "${SRC}/agents/"*.md "${AGENT_DIR}/" 2>/dev/null || true

    # Copy scripts
    SCRIPTS_DIR="${SKILL_DIR}/scripts"
    if [ -d "${SRC}/scripts" ]; then
        echo "→ Installing Python scripts..."
        mkdir -p "${SCRIPTS_DIR}"
        cp "${SRC}/scripts/"*.py "${SCRIPTS_DIR}/"
        cp "${SRC}/requirements.txt" "${SKILL_DIR}/requirements.txt"
    fi

    # Install Python dependencies
    echo ""
    echo "→ Installing Python dependencies..."
    if command -v pip3 >/dev/null 2>&1 || command -v pip >/dev/null 2>&1; then
        PIP_CMD="pip3"
        command -v pip3 >/dev/null 2>&1 || PIP_CMD="pip"
        ${PIP_CMD} install -q -r "${SKILL_DIR}/requirements.txt" 2>/dev/null \
            || { echo "  ⚠ Standard pip install failed, trying --break-system-packages..." >&2; \
                 ${PIP_CMD} install --break-system-packages -q -r "${SKILL_DIR}/requirements.txt" 2>/dev/null; } \
            && echo "  ✓ Python dependencies installed" \
            || echo "  ⚠ pip install failed. Run manually: pip3 install -r ${SKILL_DIR}/requirements.txt"
    else
        echo "  ⚠ pip not found. Install deps manually: pip3 install -r ${SKILL_DIR}/requirements.txt"
    fi

    # Optional: banana-claude for image generation
    echo ""
    if [ -d "${HOME}/.claude/skills/banana" ] || [ -f "${HOME}/.claude/skills/banana/SKILL.md" ]; then
        echo "  ✓ banana-claude detected (image generation ready)"
    else
        echo "  ℹ banana-claude not detected. Commands /ads generate and /ads photoshoot require it."
        echo "    See the README § Image Generation for provider setup options."
    fi

    echo ""
    echo "✓ maxym-ai-ads installed successfully!"
    echo ""
    echo "  Installed:"
    echo "    • 1 unified /ads orchestrator"
    echo "    • 29 sub-skills"
    echo "    • 15 subagents (6 audit + 4 creative-pipeline + 5 strategy)"
    echo "    • 25 reference files"
    echo "    • 11 industry strategy templates"
    echo ""
    echo "Usage:"
    echo "  1. Start Claude Code:  claude"
    echo "  2. Try:                /ads help"
    echo "                         /ads quick <url>"
    echo "                         /ads strategy <url>"
    echo "                         /ads audit"
    echo "                         /ads plan saas"
    echo ""
    echo "To uninstall: curl -fsSL ${REPO_URL}/raw/main/uninstall.sh | bash"
}

main "$@"
