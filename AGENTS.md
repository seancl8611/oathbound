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
updated_utc: 2026-08-29T01:07:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 125
  feature_head: 933e2eef3539cb9ed720772d8380c74ea6d15e18
  merge_commit: 630502879451b33d84273f85ffe95c12ee0be363
  validation: 8/8 PR-triggered workflows green; 8/8 push-triggered workflows green; mergeable_state clean
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 630502879451b33d84273f85ffe95c12ee0be363
current_objective: >-
  Gather the first long player-facing integration evidence from the current main build now that cold-worktree
  import bootstrap and Hushiro enemy-guard readability are fixed. Use the existing structured integration checkpoints
  and end-of-run performance summary to identify evidence-backed fixes/tuning; do not pre-tune numerical balance.
next_action: >-
  Run the tracked root `oathbound-playtest.cmd main`. Let its clean-worktree import/editor-load preflight finish and
  only continue if it reports IMPORT PREFLIGHT PASSED. Then play one coherent run through Region 1 -> Region 2 ->
  Region 3 -> Heart Approach, or until a real gameplay failure stops the run. Exercise ordinary combat, enemy guards,
  block/parry, room choices, rewards, Technique/build growth, boss transitions, and run-end/return presentation.
  Preserve CombatTelemetry/log output including IntegrationCheckpoint markers and the final Run performance summary.
  Stop at the current Heart shell because Heart combat is not authored. Use that evidence for the next bounded batch.
current_batch:
  - PR #125 merged: clean-worktree import bootstrap + enemy guard readability + canonical guard regression.
  - Added tracked root oathbound-playtest.cmd: recreate exact remote worktree, headless import, clean post-import editor-load gate, then launch Godot.
  - Cold import artifacts confirmed scary PNG load messages happen during initial scan before Godot completes a 340-step successful reimport; post-import clean load is authoritative.
  - Corrupted Swordsman active guard now has an explicit procedural shield-outline cue because the imported foot-soldier sheet has no authored block animation.
  - HushiroGuardReadabilitySmoke exercises the real HurtBox canonical AttackEvent transaction and proves guarded wolf_fang_slash produces 0 HP, exactly 14 Posture, zero floating HP damage numbers, and a guard cue that tracks active guard state.
  - Captured player telemetry evidence remains: guarded wolf_fang_slash held enemy HP at 77 while Posture rose 37 -> 51; no HP+Posture leak was present in that observed block.
  - Godot 4.7.2 parser regression discovered during branch validation was fixed by constructing PackedVector2Array guard points at runtime rather than in a const expression.
recent_batches:
  - pr_122: canonical non-blocking regional boss title cards.
  - pr_123: debug-only Region 1/Region 2/Heart Approach structured integration checkpoints.
  - pr_124: persisted/localized end-of-run performance summary from eight existing RunData counters.
  - pr_125: clean playtest import preflight + explicit Hushiro enemy guard cue + canonical guard transaction smoke.
confirmed:
  - PR #119 through #125 merged; never continue old feature branches.
  - PR #125 passed 8/8 push and 8/8 PR workflows; Godot 4.7.2 clean import/editor/runtime ownership validation is green.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Canonical guarded enemy sword contact is posture-only in the tested path and cannot create a floating HP number.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning waits for long player-facing evidence.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - numerical tuning before long playtest
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
