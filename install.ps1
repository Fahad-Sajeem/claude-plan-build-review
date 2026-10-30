# Installs the plan-build-review and reel-build-review skills and the coder agent into ~/.claude
$ErrorActionPreference = "Stop"
$dest = Join-Path $HOME ".claude"

foreach ($skill in "plan-build-review", "reel-build-review") {
    New-Item -ItemType Directory -Force (Join-Path $dest "skills\$skill") | Out-Null
    Copy-Item (Join-Path $PSScriptRoot "skills\$skill\SKILL.md") (Join-Path $dest "skills\$skill\SKILL.md") -Force
}
New-Item -ItemType Directory -Force (Join-Path $dest "agents") | Out-Null
Copy-Item (Join-Path $PSScriptRoot "agents\coder.md") (Join-Path $dest "agents\coder.md") -Force

Write-Host "Installed to $dest. Start a new Claude Code session, then run /plan-build-review <task> or /reel-build-review <topic>."
