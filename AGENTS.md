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
updated_utc: 2026-08-28T14:28:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 123
  feature_head: 3a5347d309c4ca7923f6eccde13f077211e87a44
  merge_commit: 97267db2c3daa77e35f11013f795e2a2bffecb83
  validation: 6/6 PR-triggered workflows green; mergeable_state clean
active_branch: agent/run-results-performance-summary
active_pr: null
covered_through_substantive_commit: e18dddd5b4414b53d6cf638604b219a67eeb7c52
known_good_checkpoint: 97267db2c3daa77e35f11013f795e2a2bffecb83
current_objective: >-
  Finish the bounded pre-playtest run-results performance summary without changing gameplay.
  RecordsRuntime now persists the existing run counters before teardown; the accessible results
  overlay renders a localized Run performance section; the existing release-shell smoke verifies
  the eight-key API shape and persisted player-visible values.
next_action: >-
  Validate feature head e18dddd5b4414b53d6cf638604b219a67eeb7c52 with commit-specific CI,
  prioritizing Release Shell Check and Godot 4.7.2 Project Check. Fix only evidenced parser/runtime
  defects. If green, open PR #124, verify PR-triggered validation and mergeability, merge autonomously,
  then checkpoint main and finalize this turn instead of starting another implementation slice.
current_batch:
  - RecordsRuntime.get_current_run_performance_snapshot reads eight existing RunData counters only.
  - End-of-run result payload persists that snapshot before run teardown.
  - Run-results overlay adds Enemies defeated, Parries, Perfect parries, Damage taken, Combat rooms cleared, Blessings received, Treasures opened, and Items purchased.
  - Accessible wrapper localizes the new section/labels through existing English-fallback localization.
  - Existing RunResultsOverlaySmoke now uses the accessible wrapper and verifies API keys plus persisted synthetic values.
  - Existing workflow PASS marker remains compatible; no new workflow added.
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
  - Cross-chat recovery worked for the interrupted PR #123 turn; the failure mode was missing user-visible completion, not lost repository work.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - numerical tuning before long playtest
  - waiting for routine PR merge approval
  - unrelated PR growth
  - indefinite same-turn PR/tool chaining after a safe checkpoint
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
