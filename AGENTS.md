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
updated_utc: 2026-08-29T19:24:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 129
  feature_head: 848196dc1ea4515652fb5f513a55097c3cb187ab
  merge_commit: a98824b276e4044ae8ddc232e45d1e700ad4906a
  validation: 10/10 PR-triggered workflows green; mergeable true
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: a98824b276e4044ae8ddc232e45d1e700ad4906a
current_objective: >-
  Audit the authored Region 2 and Region 3 enemy roster against the corrected Hushiro combat contracts before the player
  reaches those regions. Look for the same classes of defects found during Region 1 playtesting: missing or duplicated authored
  posture, inconsistent parry/block reactions, Deathblow readiness/receive routing, HP-at-zero stalls, death/defeat signaling,
  boss phase transitions, manager/container lifecycle mistakes, and progression gates. Preserve intentional regional mechanics
  and difficulty; fix ownership/contract defects rather than speculative numerical balance.
next_action: >-
  Branch from current main and inspect the live Region 2/3 enemy scripts and scenes, prioritizing shared combat/death/posture APIs
  plus miniboss/boss progression. Add cross-region live Godot regression coverage for any concrete mismatches, then open and merge
  a bounded PR if validation is green. Do not claim Region 2/3 player-facing balance is proven until those regions are actually played.
current_batch:
  - PR #129 merged from exact feature head 848196dc1ea4515652fb5f513a55097c3cb187ab at merge commit a98824b276e4044ae8ddc232e45d1e700ad4906a.
  - PR #129 passed all 10 PR-triggered workflows, including Godot 4.7.2 Project Check, both Hushiro checks, the new Hushiro Elite Boss Progression Check, Yomori Region Check, region handoff, runtime lifetime, post-playtest stability, Blood Cavern execution, and authored presentation.
  - Collector parry posture now receives one authored posture award only when the imported reaction path failed to mutate posture; normal sword posture remains one-pass.
  - Keeper normal authored sword posture is no longer dropped, Keeper parries no longer double-award posture, and Keeper exposes canonical Deathblow readiness/receive routing so first execution transitions to Phase 2 and second execution can defeat the boss.
  - Area 2 DuoBossManager now stays inactive when its boss container is not the active regional boss, preventing its Keeper-room startup warning.
  - The new HushiroEliteBossProgressionSmoke instantiates live Player/Collector/Keeper/duo-manager paths and covers the repaired posture and boss progression semantics.
recent_batches:
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
  - pr_129: repaired Collector/Keeper posture and Keeper Deathblow progression; gated inactive Area 2 duo manager startup.
confirmed:
  - PR #119 through #129 merged; never continue old feature branches.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix remain intact.
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
  - save-slot lifecycle rewrites based only on duplicate startup reset logging when no duplicated live state is observed
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
