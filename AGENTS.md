# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V3: machine-oriented bootstrap/state; GitHub is durable memory -->

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
- Multiple bounded PR cycles per response/session are encouraged.
- After every merge, branch subsequent work from updated `main`; never recreate a #119-style mega-PR.

## LIVE_STATE
```yaml
schema: 3
updated_utc: 2026-08-28T04:20:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 122
  merge_commit: 389251b6fd20c88206f9b3506e1711501bb158da
active_branch: agent/long-run-integration-telemetry
active_pr: null
covered_through_substantive_commit: 3a5347d309c4ca7923f6eccde13f077211e87a44
known_good_checkpoint: 389251b6fd20c88206f9b3506e1711501bb158da
current_objective: >-
  Improve the upcoming long integration playtest's diagnostic value without changing gameplay.
  Current branch adds debug-only structured checkpoints at Region 1 complete, Region 2 complete,
  and Heart Approach using existing runtime state.
next_action: >-
  Validate head 3a5347d3 with commit-specific CI, especially Run Region Handoff Check and
  Godot 4.7.2 Project Check. Fix only evidenced parser/runtime defects. If green, open PR #123,
  verify PR-triggered checks/mergeability, merge autonomously, checkpoint main, then continue
  only if another bounded pre-playtest readiness slice is clearly supported.
current_batch:
  - new OathboundIntegrationTelemetry.gd debug-only observer
  - observer attached to canonical res://Utility/RunScene.tscn
  - once-only region_1_complete / region_2_complete / heart_approach events
  - structured elapsed/build/resources/combat/build/player snapshots into CombatTelemetry + console
  - deterministic smoke asserts stage timing/dedup and zero persistent-resource/Binding/Story writes
  - existing run-region-handoff workflow extended; no new broad workflow
confirmed:
  - PR #119 through #122 merged; never continue old branches.
  - Godot 4.7.2.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Achievement unlock presentation and canonical boss title cards are merged.
  - Numerical balance/economy/difficulty tuning waits for long player-facing evidence.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - numerical tuning before long playtest
  - waiting for routine PR merge approval
  - unrelated PR growth
```

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge -> updated main -> main:AGENTS.md`

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
