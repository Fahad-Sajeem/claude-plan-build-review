# plan-build-review

A Claude Code skill that cuts cost and usage limits by splitting work between models automatically:

| Phase  | Model                 | What it does                                                  |
|--------|-----------------------|---------------------------------------------------------------|
| Plan   | Opus (main session)   | Reads just enough code, writes small exact steps to a plan file |
| Build  | Sonnet (`coder` agent) | Implements each step; independent steps run in parallel       |
| Review | Opus (main session)   | Checks the diff, runs tests, sends specific fixes back (max 3 rounds) |

The model switch happens on its own: the `coder` subagent has `model: sonnet` in its frontmatter, so every coding step runs on Sonnet while planning and review stay on your main model. Simple mechanical steps can be sent to Haiku for even less.

## Install

Copies the skill and agent into your user `~/.claude` folder, so they work in every project (Claude Code terminal and the Code tab of the Claude desktop app).

**Windows (PowerShell):**

```powershell
./install.ps1
```

**macOS / Linux / Git Bash:**

```bash
./install.sh
```

Then start a **new** Claude Code session (agents are loaded when a session starts).

## Use

```
/plan-build-review add a dark mode toggle to the settings page
```

Add "show me the plan first" if you want to approve the plan before coding starts.

## When to use it

Good fit:
- Features with clear requirements
- Changes across many files where the design is obvious
- Repetitive or mechanical work (renames, boilerplate, conversions)
- Code-built media (Remotion, Manim, Blender scripts) once the storyboard is written

Skip it and ask directly for:
- One- or two-line fixes (the overhead costs more than it saves)
- Debugging an unknown cause
- Tricky logic: algorithms, concurrency, security, performance tuning
- Exploring code or deciding what to build
- Visual polish done by trial and error

## Files

```
agents/coder.md                       Sonnet implementation subagent
skills/plan-build-review/SKILL.md     The plan → build → review workflow
```

During a run the skill writes `.claude/pbr-plan.md` in your project and deletes it at the end.
