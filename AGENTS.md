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
updated_utc: 2026-08-29T06:06:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 125
  feature_head: 933e2eef3539cb9ed720772d8380c74ea6d15e18
  merge_commit: 630502879451b33d84273f85ffe95c12ee0be363
  validation: 8/8 PR-triggered workflows green; 8/8 push-triggered workflows green; mergeable_state clean
active_branch: agent/post-playtest-stability
active_pr: 126
covered_through_substantive_commit: 1d47c77a5651421f8d14fdb85cbeb2eb522f3c52
known_good_checkpoint: 630502879451b33d84273f85ffe95c12ee0be363
current_objective: >-
  Stabilize the first long player-facing integration evidence from main. The Aug 29 playtest exposed four bounded
  defects: failed-run result construction crashes on a stale MetaProgress Heart Binding API, fresh New Game/overwrite
  routes directly into RunScene instead of The Strand, ordinary blocked Archer arrows are locally misclassified and
  reflected, and Rest Chamber duplicates GameFlow route-gate ownership and emits a stale make_choice warning.
next_action: >-
  PR #126 is open at exact feature head 1d47c77a5651421f8d14fdb85cbeb2eb522f3c52 after all 5 final-head push
  workflows passed, including Post-playtest Stability Check, Godot 4.7.2 Project Check, and Hushiro Combat Semantics.
  Eleven PR-triggered workflows are running. Check only their completion/failures and PR mergeability. If all are green
  and mergeable_state is clean, merge autonomously with exact expected head SHA, checkpoint main, then return main for
  another integration playtest focused on death/run-results, fresh-save Strand routing, Rest exit, and arrow defense.
current_batch:
  - Failed-run crash root: OathboundRecordsRuntime called nonexistent MetaProgress.remaining_heart_bindings(); branch now uses canonical get_heart_bindings_remaining().
  - Fresh New Game and overwrite now create/select the slot then route to res://World/HubScene.tscn; FIRST_ATTEMPT authority now starts fresh saves in The Strand and begins the unscripted Hushiro first-attempt contract when the first expedition launches.
  - Uploaded combat telemetry recorded five Archer arrow block_success contacts with _parry_active=false, state=6, zero Health damage, and posture-only damage; no arrow parry_success events occurred.
  - CorruptedArcherProjectile now treats canonical defense methods as authoritative, preserves legitimate active/grace parries, and limits numeric fallback to BLOCKING=6 / PARRYING=7 compatibility states. Normal block absorbs/despawns; parry reflects.
  - RestChamber no longer connects its route gate through RoomBase; live GameFlow remains sole route-transition owner.
  - Added PostPlaytestStabilitySmoke for failed-run result construction, fresh-save Strand destination, and Rest single-owner gate state.
  - Added HushiroProjectileDefenseSmoke reproducing canonical block state 6 / parry false and separately proving real parry reflection.
  - Added dedicated Post-playtest Stability Check workflow with clean Godot 4.7.2 import/editor load and both new regressions.
  - Exact final branch head passed all 5 triggered push workflows; PR #126 now has 11 PR-triggered workflows queued/running.
recent_batches:
  - pr_123: debug-only Region 1/Region 2/Heart Approach structured integration checkpoints.
  - pr_124: persisted/localized end-of-run performance summary from eight existing RunData counters.
  - pr_125: clean playtest import preflight + explicit Hushiro enemy guard cue + canonical guard transaction smoke.
confirmed:
  - PR #119 through #125 merged; never continue old feature branches.
  - Aug 29 runtime log had one SCRIPT ERROR: stale remaining_heart_bindings call during RecordsRuntime.on_run_finished; it also had the duplicate Rest make_choice warning.
  - Shared player defense correctly classified the observed Archer contacts as block_success with zero HP loss; projectile-local response caused the false reflection.
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
