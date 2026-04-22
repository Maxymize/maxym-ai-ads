#Requires -Version 5.1
<#
.SYNOPSIS
    maxym-ai-ads uninstaller for Windows
.DESCRIPTION
    Removes the maxym-ai-ads orchestrator, sub-skills, subagents, and reference files.
#>

$ErrorActionPreference = "Stop"

function Main {
    Write-Host "Uninstalling maxym-ai-ads..."

    $ClaudeDir = Join-Path $env:USERPROFILE ".claude"

    # Remove main orchestrator (includes references, research-sources, scripts)
    $MainSkill = Join-Path $ClaudeDir "skills\ads"
    if (Test-Path $MainSkill) {
        Remove-Item -Path $MainSkill -Recurse -Force
    }

    # Remove sub-skills (31)
    $SubSkills = @(
        "ads-blueprint","ads-blueprint-execution",
        "ads-strategy","ads-quick","ads-audience","ads-plan","ads-keywords","ads-competitor",
        "ads-copy","ads-hooks","ads-video","ads-creative-brief","ads-creative-audit",
        "ads-funnel","ads-budget","ads-testing","ads-landing",
        "ads-audit","ads-google","ads-meta","ads-youtube","ads-linkedin","ads-tiktok","ads-microsoft","ads-apple",
        "ads-dna","ads-create","ads-generate","ads-photoshoot",
        "ads-math","ads-test","ads-report-pdf"
    )
    foreach ($skill in $SubSkills) {
        $p = Join-Path $ClaudeDir "skills\$skill"
        if (Test-Path $p) { Remove-Item -Path $p -Recurse -Force }
    }

    # Remove subagents (15)
    $Agents = @(
        "audit-google","audit-meta","audit-creative","audit-tracking","audit-budget","audit-compliance",
        "creative-strategist","visual-designer","copy-writer","format-adapter",
        "strategy-audience","strategy-creative","strategy-funnel","strategy-competitive","strategy-budget"
    )
    foreach ($agent in $Agents) {
        $p = Join-Path $ClaudeDir "agents\$agent.md"
        if (Test-Path $p) { Remove-Item -Path $p -Force }
    }

    Write-Host "maxym-ai-ads uninstalled." -ForegroundColor Green
}

Main
