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
updated_utc: 2026-08-29T06:08:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 126
  feature_head: 1d47c77a5651421f8d14fdb85cbeb2eb522f3c52
  merge_commit: 62bcf3dc5d7557ff0a2b86934f06b96444d97319
  validation: 5/5 final-head push workflows green; 11/11 PR-triggered workflows green; mergeable_state clean
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 62bcf3dc5d7557ff0a2b86934f06b96444d97319
current_objective: >-
  Gather the next player-facing integration evidence from main after the first long playtest stabilization batch.
  PR #126 fixed the failed-run crash, fresh-save/overwrite routing, Archer arrow block-vs-parry response, and duplicate
  Rest route ownership. Re-test those exact behaviors first, then continue the coherent Region 1 -> Region 2 ->
  Region 3 -> Heart Approach integration route if no real blocker stops the run.
next_action: >-
  Run `oathbound-playtest.cmd main` and wait for IMPORT PREFLIGHT PASSED. Verify a fresh New Game or overwritten slot
  opens The Strand, then launch the first expedition and confirm it enters the normal unscripted Hushiro route. In
  Archer encounters, ordinary block must absorb/despawn the arrow without reflection while a real parry must reflect.
  Use at least one Rest exit and watch for the retired duplicate make_choice warning. On player death, confirm run-result
  construction and return presentation complete without the prior Heart Binding API crash. If stable, continue through
  Region 1 -> Region 2 -> Region 3 -> Heart Approach or until another real failure. Preserve runtime log and CombatTelemetry.
current_batch:
  - PR #126 merged from exact feature head 1d47c77a5651421f8d14fdb85cbeb2eb522f3c52 at merge commit 62bcf3dc5d7557ff0a2b86934f06b96444d97319.
  - Failed-run result construction now uses MetaProgress.get_heart_bindings_remaining(); the stale nonexistent remaining_heart_bindings call is gone.
  - Fresh New Game and overwrite route to res://World/HubScene.tscn. FIRST_ATTEMPT authority now establishes The Strand before the first expedition while preserving the normal unscripted Hushiro first run.
  - Corrupted Archer projectile defense now treats canonical is_parrying/is_blocking state as authoritative. Normal block absorbs/despawns the arrow; only parry reflects it. Compatibility fallback uses BLOCKING=6 / PARRYING=7.
  - RestChamber no longer duplicates GameFlow route-gate ownership, retiring the observed make_choice-not-awaiting-choice warning path.
  - PostPlaytestStabilitySmoke covers failed-run result build, fresh-save Strand destination, and Rest single-owner routing.
  - HushiroProjectileDefenseSmoke reproduces the observed state=6/parry=false block and separately validates true parry reflection.
  - Exact feature head passed 5/5 triggered push workflows and PR #126 passed all 11 PR-triggered workflows, including Godot 4.7.2 Project Check, Release Shell, both Hushiro gates, Yomori/Kagutsuchi, lifetime, presentation, region handoff, and dedicated stability validation.
recent_batches:
  - pr_124: persisted/localized end-of-run performance summary from eight existing RunData counters.
  - pr_125: clean playtest import preflight + explicit Hushiro enemy guard cue + canonical guard transaction smoke.
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save Strand routing, Archer projectile defense, and Rest gate ownership.
confirmed:
  - PR #119 through #126 merged; never continue old feature branches.
  - Aug 29 player log had one SCRIPT ERROR at RecordsRuntime.on_run_finished from stale remaining_heart_bindings and one duplicate Rest make_choice warning; both exact paths are covered by PR #126 regressions.
  - Uploaded combat telemetry showed five Archer arrow block_success contacts with _parry_active=false, state=6, zero HP loss, and posture-only damage; projectile-local misclassification caused reflection.
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
