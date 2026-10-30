# Installs the plan-build-review skill and coder agent into ~/.claude
$ErrorActionPreference = "Stop"
$dest = Join-Path $HOME ".claude"

New-Item -ItemType Directory -Force (Join-Path $dest "skills\plan-build-review") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $dest "agents") | Out-Null
Copy-Item (Join-Path $PSScriptRoot "skills\plan-build-review\SKILL.md") (Join-Path $dest "skills\plan-build-review\SKILL.md") -Force
Copy-Item (Join-Path $PSScriptRoot "agents\coder.md") (Join-Path $dest "agents\coder.md") -Force

Write-Host "Installed to $dest. Start a new Claude Code session, then run /plan-build-review <task>."
