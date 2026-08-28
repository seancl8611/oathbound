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
updated_utc: 2026-08-28T04:26:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 123
  feature_head: 3a5347d309c4ca7923f6eccde13f077211e87a44
  merge_commit: 97267db2c3daa77e35f11013f795e2a2bffecb83
  validation: 6/6 PR-triggered workflows green; mergeable_state clean
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 97267db2c3daa77e35f11013f795e2a2bffecb83
current_objective: >-
  Continue pre-playtest release QA without tuning gameplay. Next bounded slice exposes already-
  tracked canonical run performance counters on the run-results overlay so the long integration
  test returns both structured checkpoint logs and an immediate human-readable summary.
next_action: >-
  Create agent/run-results-performance-summary from updated main. Extend RecordsRuntime run-result
  payload with existing RunData counters, render a localized/readable Run performance section,
  extend the existing run-results smoke/release-shell validation, then open and autonomously merge
  the PR when targeted and PR-triggered checks are green.
recent_batches:
  - pr_121: queued achievement-unlock presenter.
  - pr_122: canonical non-blocking regional boss title cards.
  - pr_123: debug-only Region 1/Region 2/Heart Approach structured integration checkpoints.
confirmed:
  - PR #119 through #123 merged; never continue old branches.
  - Godot 4.7.2.
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
