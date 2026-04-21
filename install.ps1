#Requires -Version 5.1
<#
.SYNOPSIS
    maxym-ai-ads installer for Windows
.DESCRIPTION
    Installs the maxym-ai-ads orchestrator, 29 sub-skills, 15 subagents,
    25 reference files, and 11 industry templates for Claude Code on Windows.
#>

$ErrorActionPreference = "Stop"

function Main {
    $SkillDir = Join-Path $env:USERPROFILE ".claude\skills\ads"
    $AgentDir = Join-Path $env:USERPROFILE ".claude\agents"
    $RepoUrl = if ($env:MAXYM_ADS_REPO_URL) { $env:MAXYM_ADS_REPO_URL } else { "https://github.com/MAXYMIZE-BUSINESS/maxym-ai-ads" }

    Write-Host "============================================================"
    Write-Host "   maxym-ai-ads - installer"
    Write-Host "   Strategy . Creative . Multi-platform Audit . Reporting"
    Write-Host "============================================================"
    Write-Host ""

    # Check prerequisites
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "X Git is required but not installed." -ForegroundColor Red
        exit 1
    }
    Write-Host "OK Git detected" -ForegroundColor Green

    # Create directories
    New-Item -ItemType Directory -Path (Join-Path $SkillDir "references") -Force | Out-Null
    New-Item -ItemType Directory -Path $AgentDir -Force | Out-Null

    # Clone to temp directory
    $TempDir = Join-Path $env:TEMP "maxym-ai-ads-install-$(Get-Random)"
    Write-Host "Downloading maxym-ai-ads..."

    try {
        $ErrorActionPreference = "Continue"
        git clone --depth 1 $RepoUrl "$TempDir\maxym-ai-ads" 2>&1 | Out-Null
        $ErrorActionPreference = "Stop"
        if ($LASTEXITCODE -ne 0) { throw "Git clone failed" }

        $Src = "$TempDir\maxym-ai-ads"

        # Copy main orchestrator + references
        Write-Host "Installing orchestrator..."
        Copy-Item "$Src\ads\SKILL.md" -Destination "$SkillDir\SKILL.md" -Force
        Copy-Item "$Src\ads\references\*.md" -Destination "$SkillDir\references\" -Force

        if (Test-Path "$Src\ads\research-sources") {
            $rsDir = Join-Path $SkillDir "research-sources"
            New-Item -ItemType Directory -Path $rsDir -Force | Out-Null
            Copy-Item "$Src\ads\research-sources\*.md" -Destination "$rsDir\" -Force
        }

        # Copy sub-skills
        Write-Host "Installing 29 sub-skills..."
        Get-ChildItem "$Src\skills" -Directory | Where-Object { $_.Name -ne "references" } | ForEach-Object {
            $TargetDir = Join-Path $env:USERPROFILE ".claude\skills\$($_.Name)"
            New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
            Copy-Item (Join-Path $_.FullName "SKILL.md") -Destination "$TargetDir\SKILL.md" -Force

            $AssetsDir = Join-Path $_.FullName "assets"
            if (Test-Path $AssetsDir) {
                $TargetAssets = Join-Path $TargetDir "assets"
                New-Item -ItemType Directory -Path $TargetAssets -Force | Out-Null
                Copy-Item "$AssetsDir\*.md" -Destination "$TargetAssets\" -Force
            }
        }

        # Copy agents
        Write-Host "Installing 15 subagents..."
        Copy-Item "$Src\agents\*.md" -Destination "$AgentDir\" -Force

        # Copy scripts
        if (Test-Path "$Src\scripts") {
            Write-Host "Installing Python scripts..."
            $ScriptsDir = Join-Path $SkillDir "scripts"
            New-Item -ItemType Directory -Path $ScriptsDir -Force | Out-Null
            Copy-Item "$Src\scripts\*.py" -Destination "$ScriptsDir\" -Force
            Copy-Item "$Src\requirements.txt" -Destination "$SkillDir\requirements.txt" -Force
        }

        # Install Python dependencies
        Write-Host ""
        Write-Host "Installing Python dependencies..."
        $ErrorActionPreference = "Continue"
        pip install -q -r "$SkillDir\requirements.txt" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  OK Python dependencies installed" -ForegroundColor Green
        } else {
            Write-Host "  Warning: pip install failed. Run manually: pip install -r $SkillDir\requirements.txt" -ForegroundColor Yellow
        }
        $ErrorActionPreference = "Stop"

        # Optional: banana-claude for image generation
        Write-Host ""
        $BananaPath = Join-Path $env:USERPROFILE ".claude\skills\banana\SKILL.md"
        if (Test-Path $BananaPath) {
            Write-Host "  OK banana-claude detected (image generation ready)" -ForegroundColor Green
        } else {
            Write-Host "  Note: banana-claude not detected. /ads generate and /ads photoshoot require it." -ForegroundColor Yellow
            Write-Host "    See the README (Image Generation section) for provider setup options."
        }

        Write-Host ""
        Write-Host "maxym-ai-ads installed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Installed:"
        Write-Host "    - 1 unified /ads orchestrator"
        Write-Host "    - 29 sub-skills"
        Write-Host "    - 15 subagents (6 audit + 4 creative pipeline + 5 strategy)"
        Write-Host "    - 25 reference files"
        Write-Host "    - 11 industry strategy templates"
        Write-Host ""
        Write-Host "Usage:"
        Write-Host "  1. Start Claude Code:  claude"
        Write-Host "  2. Try:                /ads help"
        Write-Host "                         /ads quick <url>"
        Write-Host "                         /ads strategy <url>"
        Write-Host "                         /ads audit"
        Write-Host "                         /ads plan saas"
    }
    finally {
        if (Test-Path $TempDir) {
            Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Main
