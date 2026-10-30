---
name: reel-build-review
description: Cost-saving workflow for education reels made in code (Remotion) - the main (Opus) session writes the script and an exact scene-by-scene storyboard, waits for the user's OK, delegates each scene to the cheaper `coder` subagent (Sonnet) in parallel, then reviews a few still frames per scene and loops on fixes before one full render. Use when the user runs /reel-build-review or asks to make a reel, short or explainer video with Opus planning and a cheaper model building.
argument-hint: <reel topic, or a script to animate>
---

# Script → Build → Review (reels)

Topic: **$ARGUMENTS**

You are the writer, director and reviewer. You do NOT write scene code yourself: the `coder` subagent (Sonnet) does. The point is to save cost and usage limits, so spend your tokens on the script, the storyboard and checking frames, not on reading or editing lots of files. If no topic or script was given, ask for one and stop.

## When NOT to use this

Work directly with the user instead when it's:
- a tiny tweak (one caption, one colour, one timing, a re-render),
- tuning by eye ("make this feel snappier", "nudge that 3 frames"): it needs fast back-and-forth, not a storyboard,
- a new visual style or kit being invented: design it first, then use this skill for reels in that style.

## House rules come first

Before writing anything, read the project's `CLAUDE.md` and the files it points to for reels (hook rules, engagement or pacing rules, naming, the reel-type skill such as `make-doodle-reel` or `make-motion-reel`, the voice and render workflow). **Where the project's rules and this skill differ, the project wins** (length, hook check, voice, music, naming, docs to update). This skill only decides who does what, and how exact the hand-off must be.

Read only what you need: the reel-type skill, the hook and engagement docs, the kit file's exports (Grep for `export`), and one recent reel of the same type as a model. Don't read whole old reels.

## Phase 1 — Script (you)

1. **Pick the one idea.** One concept per reel. Extra examples or side stories become their own reels.
2. **Write the script** on this structure (from the Short-Form Storytelling guide), fitted to the project's length rule (default 30–60 s, about 2.5 words a second):

   | Part | Lines | Job |
   |---|---|---|
   | Hook | 1–2 | Said in the first 2 s. The four S's: **Subject** named in the first sentence, **Stakes** (why keep watching), **Simple** words, **Superclear** punchy sentence. |
   | Lock-in | 2–4 | Make them sure the rest is worth it: tease proof, a clear contrast with what people believe, a "magic box" (an unknown name for the thing they'll learn), an objection answered, or a double-down on the hook. |
   | Body block 1 | 3–5 | First step of the idea, with one non-obvious insight and the everyday thing that shows it. |
   | Rehook | 1 | One sentence that opens a new question around the middle ("That's clever, but the strange part is…"). Resets the viewer's ~20–25 s attention. Keep it clean, not corny. |
   | Body block 2 | 3–5 | Next step, second non-obvious insight. (Optional block 3 only if the one idea needs it.) |
   | Closing | 1–2 | The answer lands and closes the loop the hook opened: the last line answers the exact question of the first. |
   | CTA | 1 | The project's call to action (e.g. "Follow for more"). |

   Rules: no fluff, no throat-clearing, no greeting; each sentence follows from the one before; simple words whose meaning is obvious; every sentence must be **filmable** (if you can't picture it as 2–3 shots, rewrite it); one number beats an adjective; facts checked, no invented numbers.
3. **Rewrite pass** before showing it: read it at the speaking rate and cut to length (hedges first); swap every abstract noun for a physical thing; check the last line answers the first line's question; run the project's hook check (e.g. `docs/hooks.md`) and fix anything that fails.

## Phase 2 — Storyboard (you)

Write `.claude/reel-plan.md` in the project. It must be exact enough that Sonnet makes **no design decisions**: if a coder would have to choose a colour, size, position, timing or wording, the plan is not finished.

**1. Header:** slug (project naming rule), reel type and kit, composition id, 1080x1920 at 30 fps, target length, file layout, verify commands.

**2. Style (one shared section, every scene points here):**
- Palette as named constants or kit tokens (e.g. `T.ink`, `T.acc`, `LIME`), each with its job (accent = the one thing to look at).
- Fonts and sizes: heading, label, on-stage text, numbers, captions.
- Motion style: how things enter (draw in, wipe, pop), easing, how long an entrance takes, what's always moving, what's banned (e.g. line boil, whole-frame wobble).
- Safe areas for the Shorts/Reels UI: the stage box everything must stay inside, the caption band, the empty bottom band under it, side margins. Give pixel numbers.
- The project rules a coder must follow without reading the docs (e.g. no sound at a scene's start, no logos or real faces, claims carry a small source line).

**3. Shared pieces (built first, by one coder):** reusable objects drawn in several scenes (name, props, what they look like, where they're defined), style constants, the reel file that strings the scenes together, the thumbnail, registration in the reel index. List every export with its exact signature so scene coders can import it.

**4. Scenes:** one block per scene, in this shape:

```
### Scene 3: `cache` — 9.8–16.4 s (~6.6 s)
File: reel/src/motion/WebCaching/cache.tsx  (export `Cache: React.FC<C>`)
Voice: "Your phone keeps a copy close by, so the second time is instant."
On-screen text: heading "A COPY NEARBY" (kit heading, 2 lines max); stage label "SECOND VISIT" Mono 34 px, LIME, x 540 y 700, centred
Visuals (all positions in the 1080x1920 frame; times are spoken-word anchors):
- from 0.0: phone outline (shared `Phone`, x 300 y 1050, s 0.9) already drawn; server box right (x 820 y 900, 220x160) dim
- W("copy"): a page doodle copies out of the server and slides along a path to the phone (0.6 s, ease out); the phone's page glows T.acc
- W("second"): a stopwatch draws in above the phone (x 300 y 760, r 70)
- W("instant", -0.1): its needle snaps 0 → 0.1 s; counter "0.1 s" rolls up beside it (Mono 56 px); punch zoom 1.00 → 1.06 over 0.4 s on the stage
- always: dashed data line between server and phone flows (dash offset −2 px/frame)
Transition: hard cut (kit fades bodies); the phone stays at the same spot in scene 4
Sound cues: "ding" on "instant" (cues.json)
Checkpoints: cache:copy+0.4, cache:instant+0.3 — expect: page on its way to the phone; stopwatch showing 0.1 s, "0.1 s" readable, phone page glowing
```

Rules for scenes:
- Anchor timings to spoken words (`W("word", offset)`), since the voice decides the real seconds; give approximate seconds too.
- One idea on screen at a time; something changes every ~2–3 s; each scene reads with the sound off.
- Vary the framing between scenes (wide → close → detail) and use a small punch zoom on reveals, a short shake only on real impacts.
- Every scene lists 2–3 **checkpoints** (scene:word+offset) and what the frame must show at each. These are the only frames you will review.
- Mark which scenes are independent (different files, no shared object being invented in them).

**5. Mechanical steps (haiku):** voice/audio/captions commands, `cues.json` lines, asset copying and credits, index registration if trivial.

**Show the user the script and a short scene list** (one line per scene: time, what's on screen, which word triggers the change) plus the hook check, then **stop and wait for their OK**. The script is the part they most want to control; change it as often as they ask. Don't voice or build anything before the OK.

## Phase 3 — Voice and timing (haiku coder)

After the OK, the voice decides the real timings. Send one coder with `model: "haiku"`:

> Do the "Voice and timing" step of `.claude/reel-plan.md` (project root: <path>): write the script and cue files exactly as listed, run the voice, sound and caption commands in order, then append a "Timing" table to the plan: each scene's start/end frame and, for every checkpoint, its frame number (from the timeline file). Don't change any wording.

If the reel runs over the length rule, you cut words (the project's rules say how; never stretch it by eye), then re-run this step. Voice costs credits, so re-voice only changed lines if the project caches them.

## Phase 4 — Build (coder subagents)

1. **Shared pieces first.** One `coder` (Sonnet):
   > Implement the "Shared pieces" section of `.claude/reel-plan.md` (project root: <path>). Only that section. Verify with the typecheck command in the plan.
2. **Then one coder per scene**, in parallel for independent scenes (multiple Agent calls in one message; at most 3 at once, since each renders stills):
   > Implement scene N (`<id>`) of `.claude/reel-plan.md` (project root: <path>). Only that scene's file. Use the shared pieces and the Style section as written; make no design choices the plan doesn't state. Verify: typecheck, then render only your scene's checkpoint frames with `npx remotion still src/index.ts <comp> out/check/<id>-<frame>.png --frame=<frame> --scale=0.4` (frames from the plan's Timing table). Look at your own stills; fix anything that doesn't match the checkpoint. Never render the full reel.
3. Mechanical steps (registration, cues, asset wiring) may use `model: "haiku"`.
4. Don't edit scene code yourself unless a fix is one line and cheaper to do than to delegate.

## Phase 5 — Review (you)

1. Typecheck once.
2. Render **all checkpoints of all scenes into one contact sheet** (e.g. `python preview.py --ep <slug> --scale 0.4 <scene:word+off> ...`), so the review costs one image, not one per scene. Look at nothing else: no video, no extra frames unless a checkpoint is ambiguous.
3. Check every frame against its storyboard block:
   - text: exact wording, no typos, readable at phone size, not clipped or squashed;
   - inside the safe areas: nothing in the caption band or the bottom UI band, side margins kept;
   - timing: the change for that word has happened (or is mid-way, if the plan says so);
   - style: palette, fonts and line weights match the other scenes; one idea on screen;
   - the hook frame: frame 0 already shows the subject (heading or object), not a blank stage.
4. For each failure send a **specific** fix to the coder that built that scene: scene, checkpoint/timestamp, what's wrong, what it should be ("cache:instant+0.3 — the '0.1 s' counter overlaps the stopwatch; move it to x 420 y 760, left-anchored"). Batch fixes per scene; independent scenes' fixes go in parallel.
5. Re-render only the failed checkpoints. At most **3 fix rounds**; after that stop and tell the user exactly what's still wrong and why, rather than burning more usage.

## Phase 6 — Full render and final check (you)

1. When every checkpoint passes, render the full reel **once** with the project's render command (run it in the background if it's slow). Also the thumbnail, if the project makes one.
2. Check the length: the video's frame count or duration matches the timeline and the length rule.
3. Quick sync check: pick 2 spoken words (one early, one late), grab the frame at each word's time from the rendered video (`ffmpeg -ss <t> -i out/<slug>.mp4 -frames:v 1 out/check/sync-<n>.png`), and check the caption shows that word and the visual change for that word is there. Audio present, no silence at the start.

## Finish

- Delete `.claude/reel-plan.md` and `out/check/` unless the user wants to keep them.
- Do the project's after-render steps (e.g. update the episodes list); commit only if the user asks.
- Report briefly: output file path, length, thumbnail path, fix rounds used, and anything not done or not verified (frames you didn't check, sync checked on 2 words only, etc.).

## In the motion-animation repo (Nibbles Explains)

The project's own files say all of this in detail; this is the map for the plan:
- **Rules:** `CLAUDE.md`, `docs/hooks.md` (hook check, show it with the script), `docs/engagement.md` (one concept, 45–62 s, midpoint crash = the rehook, answer at the end, easter egg, "Follow for more"), `docs/naming.md`. Reel type and kit: the `make-doodle-reel` skill (default) or `make-motion-reel`.
- **Files:** episode data in `reel/src/episodes/<slug>/` (`script.json`, `cues.json`, `voice.json`, `timeline.json`, `captions.json`). For parallel coders, split the scenes into a folder: `reel/src/motion/<Name>/<sceneId>.tsx` (each exports one body `React.FC<C>` from `../kit`), shared objects in `reel/src/motion/<Name>/shared.tsx`, the reel and thumbnail in `reel/src/motion/<Name>.tsx` (`BODIES` map), registered in `reel/src/motion/index.tsx` (`MOTION_REELS`). Composition id = slug.
- **Voice and timing (run from `reel/`):** `python make-voice-elevenlabs.py --ep <slug>`, `python make-sounds-elevenlabs.py --ep <slug>`, `python build_audio.py --ep <slug>`, `python make_captions.py --ep <slug>`. Checkpoint frames come from `timeline.json` (scene `from` + word time × 30).
- **Coder verify:** `node node_modules/typescript/bin/tsc --noEmit -p .`, then `npx remotion still src/index.ts <slug> out/check/<id>-<frame>.png --frame=<f> --scale=0.4`. Coders must not use `preview.py`: it writes one shared `out/contact.png` that parallel coders would overwrite.
- **Review:** `python preview.py --ep <slug> --scale 0.4 0 <scene:word+off> ...` (one contact sheet, `out/contact.png`).
- **Render:** `python preview.py --ep <slug> --render` (checks every frame, then makes `out/<slug>.jpg`). If C: is full, set `TEMP`/`TMP` to the D: or E: temp folder the project names.
- **After render:** add the reel to `docs/episodes.md` in the same commit.
