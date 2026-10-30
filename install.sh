#!/usr/bin/env sh
# Installs the plan-build-review skill and coder agent into ~/.claude
set -e
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.claude"

mkdir -p "$dest/skills/plan-build-review" "$dest/agents"
cp "$here/skills/plan-build-review/SKILL.md" "$dest/skills/plan-build-review/SKILL.md"
cp "$here/agents/coder.md" "$dest/agents/coder.md"

echo "Installed to $dest. Start a new Claude Code session, then run /plan-build-review <task>."
