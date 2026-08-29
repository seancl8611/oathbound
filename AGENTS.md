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
updated_utc: 2026-08-29T00:42:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 124
  feature_head: e18dddd5b4414b53d6cf638604b219a67eeb7c52
  merge_commit: 1921dcbd487922e31faf2f5ca7c3ee09ec941b4f
  validation: 7/7 PR-triggered workflows green; mergeable_state clean
active_branch: agent/preplaytest-import-guard-feedback
active_pr: null
covered_through_substantive_commit: 63584640a918012fc0e7d0df7be9d41af976fd94
known_good_checkpoint: 1921dcbd487922e31faf2f5ca7c3ee09ec941b4f
current_objective: >-
  Resolve player-observed pre-playtest cold-import noise and Hushiro enemy-guard readability before
  returning to the long integration run. Uploaded telemetry proved the captured guarded Wolf Fang Slash
  preserved HP while applying Posture; the defect is player-facing guard/readability plus a local clean-worktree
  launcher that opened the editor before building its import cache.
next_action: >-
  Validate branch head 63584640a918012fc0e7d0df7be9d41af976fd94. Prioritize Hushiro Combat Semantics
  and Godot 4.7.2 Project Check. The new guard smoke must prove the canonical HurtBox transaction produces
  0 HP, exactly 14 Posture, zero floating damage numbers, and a visible guard cue. If branch validation is green,
  open the next PR, verify PR-triggered checks/mergeability, merge autonomously, checkpoint main, then hand the
  updated main build back for the long playtest.
current_batch:
  - Added tracked root oathbound-playtest.cmd so clean worktrees run the same headless import and editor-load preflight as CI before launching Godot.
  - The launcher rejects unresolved SCRIPT ERROR / Failed loading resource / deferred-call errors after the import pass and preserves logs in C:\OathboundPlaytest.
  - Corrupted Swordsman active guard now has a procedural shield-outline cue because the imported foot-soldier sheet has no authored block animation.
  - Added HushiroGuardReadabilitySmoke through the real HurtBox canonical AttackEvent transaction.
  - Captured telemetry evidence: guarded wolf_fang_slash held enemy HP at 77 while Posture rose 37 -> 51; no HP+Posture leak was present in that observed block.
  - Uploaded import log listed many missing-resource messages on initial cold editor open, while affected PNG sources are tracked and the subsequent runtime successfully instantiated those enemies.
recent_batches:
  - pr_121: queued achievement-unlock presenter.
  - pr_122: canonical non-blocking regional boss title cards.
  - pr_123: debug-only Region 1/Region 2/Heart Approach structured integration checkpoints.
  - pr_124: persisted/localized end-of-run performance summary from eight existing RunData counters.
confirmed:
  - PR #119 through #124 merged; never continue old feature branches.
  - Godot 4.7.2 clean import/editor/runtime ownership validation passed on PR #124.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Existing HushiroDefenseContractSmoke already asserts enemy guard posture-only/no damage number; new smoke closes the gap at the live canonical HurtBox route and visual guard state.
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
