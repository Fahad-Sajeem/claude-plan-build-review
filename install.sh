#!/usr/bin/env sh
# Installs the plan-build-review and reel-build-review skills and the coder agent into ~/.claude
set -e
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.claude"

mkdir -p "$dest/agents"
for skill in plan-build-review reel-build-review; do
  mkdir -p "$dest/skills/$skill"
  cp "$here/skills/$skill/SKILL.md" "$dest/skills/$skill/SKILL.md"
done
cp "$here/agents/coder.md" "$dest/agents/coder.md"

echo "Installed to $dest. Start a new Claude Code session, then run /plan-build-review <task> or /reel-build-review <topic>."
