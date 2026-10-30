# plan-build-review

Claude Code skills that cut cost and usage limits by splitting work between models automatically:

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

## Reels: reel-build-review

The same split for education reels made in code (Remotion: vertical 1080x1920 Shorts/Reels):

| Phase | Model | What it does |
|---|---|---|
| Script + storyboard | Opus (main session) | Writes the script (hook, lock-in, body blocks with a rehook, closing, call to action) and an exact scene-by-scene storyboard in `.claude/reel-plan.md`: one shared style section, then per scene the words, on-screen text, positions, word-timed animations, file and 2–3 checkpoint frames. **Waits for your OK on the script.** |
| Voice + timing | Haiku (`coder`, `model: "haiku"`) | Runs the voice, sound and caption commands and writes the frame number of every checkpoint into the plan |
| Build | Sonnet (`coder` agents) | Shared pieces first (one coder), then one coder per scene in parallel; each renders only its own checkpoint stills |
| Review | Opus (main session) | Checks all checkpoints in one contact sheet against the storyboard (text, safe areas, timing, style), sends exact fixes (max 3 rounds), then renders the full reel once and checks length and caption sync |

```
/reel-build-review how a CPU cache works
```

The project's own rules (its `CLAUDE.md`, hook and pacing docs, reel-type skill) win wherever they differ from the skill. Skip it for tiny tweaks, re-renders, or timing you'd rather tune by eye: do those directly.

During a run it writes `.claude/reel-plan.md` and `out/check/` stills in your project and deletes them at the end.

## When to use plan-build-review

Good fit:
- Features with clear requirements
- Changes across many files where the design is obvious
- Repetitive or mechanical work (renames, boilerplate, conversions)
- Code-built media (Manim, Blender scripts) once the storyboard is written (Remotion reels: use reel-build-review)

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
skills/reel-build-review/SKILL.md     The script → build → review workflow for reels
```

During a run the skill writes `.claude/pbr-plan.md` in your project and deletes it at the end.

## License

[MIT](LICENSE)
