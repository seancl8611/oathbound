# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V4: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

Single durable bootstrap + live handoff for AI-assisted Oathbound work. Repository state is authority; conversation/project memory is cache only.

## BOOT
1. Fresh session: fetch `main:AGENTS.md` first.
2. If `active_branch` is set, fetch only that HEAD.
3. If HEAD matches `covered_through_substantive_commit`, continue from `next_action`; otherwise inspect only the uncovered range/files and reconcile.
4. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

## AUTONOMOUS_PR_POLICY
- Routine PR merge approval is not required.
- Coherent + mergeable + required validation green => merge autonomously with exact verified head SHA.
- Diagnose failed CI/mergeability instead of asking.
- Multiple bounded PR cycles per response/session are allowed when they fit safely; they are not a quota.
- After every merge, branch subsequent work from updated `main`; never recreate a #119-style mega-PR.

## TURN_SURVIVAL_POLICY
- A turn is successful only if both repo state **and the user-visible handoff** survive. Durable GitHub state alone is not enough.
- Treat long connector/tool turns as finite. Do not keep extending work merely because another useful slice exists.
- After every merged PR or other major durable milestone: update `AGENTS.md` first, then send a concise progress update that explicitly states the safe checkpoint and next recoverable action before doing optional work.
- Normally complete at most **1 CI-heavy PR** or **2 light/bounded PRs** in one user turn. More is allowed only when prior cycles were cheap and there is ample execution headroom.
- Do not begin another implementation slice after a long CI/tool sequence. End at the safe checkpoint and give the user a final answer instead.
- Minimize CI polling. Prefer one targeted status read, then inspect only the failing/incomplete workflow. If repository settings support GitHub auto-merge, it may be armed after required validation is satisfied so the turn does not need a long polling loop.
- If a PR is still waiting on GitHub rather than on code work, checkpoint `active_pr`, exact head, current validation, and the next status/merge action in this file before any optional investigation.
- Late-turn commentary must report completed durable facts first (for example `SAFE CHECKPOINT: PR #123 merged at <sha>`), not only the activity currently being inspected. If the UI freezes on that message, Sean must still know what actually survived.
- Never spend the final portion of a long turn on broad read-only exploration. Preserve capacity for checkpointing and a final user-facing summary.

## LIVE_STATE
```yaml
schema: 4
updated_utc: 2026-08-29T14:29:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 126
  feature_head: 1d47c77a5651421f8d14fdb85cbeb2eb522f3c52
  merge_commit: 62bcf3dc5d7557ff0a2b86934f06b96444d97319
  validation: 5/5 final-head push workflows green; 11/11 PR-triggered workflows green; mergeable_state clean
active_branch: agent/restore-first-attempt-start
active_pr: 127
covered_through_substantive_commit: cf5322c0f1b2f07165a0147d45f8f9be3dd7621c
known_good_checkpoint: 62bcf3dc5d7557ff0a2b86934f06b96444d97319
current_objective: >-
  Restore the approved direct first-attempt start after Sean clarified that the fresh-save jump directly into Hushiro
  was intentional design, not a bug. Keep every other evidence-backed PR #126 stabilization fix intact.
next_action: >-
  PR #127 is open at exact feature head cf5322c0f1b2f07165a0147d45f8f9be3dd7621c after all 5 final-head push
  workflows passed. Check only PR-triggered workflow completion and mergeability. If all are green and
  mergeable_state is clean, merge autonomously with exact expected head SHA, checkpoint main, and hand main back
  for playtesting. Fresh New Game/overwrite must begin directly in the normal unscripted Hushiro first attempt.
current_batch:
  - Sean clarified the original First Attempt design was intentional: a fresh or overwritten save should begin directly in the normal Hushiro run, not The Strand.
  - PR #127 restores docs/gameplay/FIRST_ATTEMPT.md to the approved direct-Hushiro first-control authority.
  - TitleScreen keeps PR #126's get_new_game_destination_path() test seam but returns res://Utility/RunScene.tscn again; _start_new_game continues routing through that seam.
  - PostPlaytestStabilitySmoke now directly verifies the front-end seam resolves fresh New Game/overwrite to RunScene and still checks failed-run result construction plus Rest single-owner routing.
  - Post-playtest Stability Check marker now requires `fresh save -> first run`; its projectile block/parry regression remains unchanged.
  - Exact feature head cf5322c0f1b2f07165a0147d45f8f9be3dd7621c passed all 5 push-triggered workflows: Stability, Godot 4.7.2 Project, Hushiro Combat Semantics, Run Region Handoff, and Authored Presentation Content.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix are intentionally preserved.
recent_batches:
  - pr_125: clean playtest import preflight + explicit Hushiro enemy guard cue + canonical guard transaction smoke.
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127_open: bounded correction restoring the approved direct first-attempt run start while preserving the other PR #126 fixes.
confirmed:
  - PR #119 through #126 merged; never continue old feature branches.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - Aug 29 player log had one SCRIPT ERROR at RecordsRuntime.on_run_finished from stale remaining_heart_bindings and one duplicate Rest make_choice warning; both exact paths remain covered by PR #126 regressions.
  - Uploaded combat telemetry showed five Archer arrow block_success contacts with _parry_active=false, state=6, zero HP loss, and posture-only damage; projectile-local misclassification caused reflection and remains fixed.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning remains evidence-driven rather than speculative.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - broad numerical tuning without integration evidence
  - waiting for routine PR merge approval
  - unrelated PR growth
  - bulk scene UID rewriting while tracked assets exist and clean-import preflight remains the supported resolution
```

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge -> updated main -> main:AGENTS.md -> user-visible safe checkpoint/final`

## ENGINEERING_GUARDS
- Project `game/oathbound/`; Godot 4.7.2; clean import/editor compile before manual playtest.
- Validate live runtime ownership, not compile alone; combat changes require telemetry.
- Explicitly type Variant-derived GDScript locals.
- Defer physics registration mutation during active contact traversal.
- One canonical Player creation path; canonical AttackEvent only; no second damage/posture pass.
- Posture-break/Deathblow shared state; block uses current defensive aim.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact branch/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
