---
name: plan-build-review
description: Cost-saving workflow - the main (Opus) session plans the task, delegates all coding to the cheaper `coder` subagent (Sonnet), then reviews the result and loops on fixes. Use when the user runs /plan-build-review or asks to plan with Opus and code with a cheaper model to save cost or usage limits.
argument-hint: <task to build>
---

# Plan → Build → Review

Task: **$ARGUMENTS**

You are the planner and reviewer. You do NOT write the code yourself — the `coder` subagent (running on a cheaper model) does. The whole point is to save cost and usage limits, so keep your own work lean: spend your tokens on thinking and checking, not on reading or editing lots of files.

If no task was given, ask the user what to build and stop.

## Phase 1 — Plan (you)

1. Look at just enough of the codebase to plan well: the project layout, the files the task will touch, and how tests/builds run. Prefer Grep/Glob and partial reads over reading whole large files.
2. If the task has a real ambiguity only the user can settle, ask before planning. Otherwise use sensible defaults.
3. Write the plan to `.claude/pbr-plan.md` in the project. Break it into small, independent-as-possible steps. Each step must be concrete enough that a less capable model can do it without design decisions:
   - **Files:** exact paths to create/edit
   - **Change:** function/component names, signatures, data shapes, behaviour, edge cases
   - **Constraints:** what must not change; style or libraries to follow
   - **Verify:** the exact command to check it (test, build, lint, or a small script) and what "done" looks like
4. Show the user a short summary of the steps (not the whole file) and continue straight away unless they asked to approve plans first.

## Phase 2 — Build (coder subagent)

For each step, in order, call the Agent tool with `subagent_type: "coder"` and a short prompt:

> Implement step N of the plan in `.claude/pbr-plan.md` (project root: <path>). Only do step N. <any extra context the plan file doesn't already contain>

- Steps that touch different files and don't depend on each other may be sent in parallel (multiple Agent calls in one message). Steps that depend on each other go one at a time.
- Use the coder for all code edits. Only edit code yourself if a fix is a one-line change that would cost more to delegate than to do.
- For purely mechanical steps (renames, boilerplate, repetitive edits) you may pass `model: "haiku"` to the Agent call to save even more.

## Phase 3 — Review (you)

After the steps are done:

1. Review the change by its diff (`git diff`, or read only the changed regions if not a git repo) — not by re-reading whole files.
2. Run the project's tests/build/lint as named in the plan.
3. Check against the plan: correctness, edge cases, anything missed, anything changed that shouldn't have been, security issues.
4. If something is wrong, send a **specific** fix back to the coder: file, location, what's wrong, what it should be. Vague feedback ("fix the bugs") wastes rounds.
5. Repeat review → fix at most **3 rounds**. If it still isn't right after that, stop and tell the user what's left and why, rather than burning more usage.

## Finish

- Delete `.claude/pbr-plan.md` unless the user wants to keep it.
- Report to the user briefly: what was built, files changed, test/build result, and anything not done or not verified.
