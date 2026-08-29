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
updated_utc: 2026-08-29T19:44:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 130
  feature_head: 6bcee893275cdcb97e883e90f054b99823cf18e5
  merge_commit: 114f306a70568cf764b71b572df512fcb68fd079
  validation: 10/10 PR-triggered workflows green; mergeable true
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 114f306a70568cf764b71b572df512fcb68fd079
current_objective: >-
  Resume player-facing integration evidence from the corrected main build. Region 1 has now driven two combat-contract repair passes;
  Region 2 and Region 3 received a preemptive code audit and shared posture-contract repair, but their player-facing difficulty,
  encounter behavior, boss phase presentation, and full progression still require actual playtest evidence before numerical tuning.
next_action: >-
  Run from current main through the remaining Hushiro path and Keeper, then continue into Yomori/Region 2 if progression succeeds.
  Player invulnerability may stay enabled for broad encounter coverage. Exercise standard enemies, Embered Pilgrim/Rotwood Host if
  encountered, Twin Maws, ordinary sword hits, parries, blocking, posture breaks, Deathblows, room clear/progression, and rewards.
  Preserve CombatTelemetry/logs and stop at the first genuine blocker. If Region 2 is healthy, continue the same evidence-driven
  process toward Kagutsuchi; do not claim Region 2/3 balance is proven from static audit/CI alone.
current_batch:
  - PR #130 merged from exact feature head 6bcee893275cdcb97e883e90f054b99823cf18e5 at merge commit 114f306a70568cf764b71b572df512fcb68fd079.
  - PR #130 passed all 10 PR-triggered workflows, including Godot 4.7.2 Project Check, Cross-Region Enemy Contract Check, Hushiro regression/semantics, region handoff, runtime lifetime, post-playtest stability, Blood Cavern execution, release shell, and authored presentation.
  - Cross-region audit covered Region 2 standards (Mist Shepherd, Lantern Wraith, Lingering Wraith, Stalker Hound), minibosses (Embered Pilgrim, Rotwood Host), Twin Maws (Briarthorn, Rootfang), and canonical Kagutsuchi standards/minibosses/boss/summon roster.
  - Concrete stale posture ownership was found in Embered Pilgrim, Rotwood Host, Briarthorn, Rootfang, Blood Lotus Heart core, Eclipse Shogun, and Court Sentinel parry handling.
  - CombatController now fills canonical hit/block Posture for legacy notify-only receivers only when no receiver already consumed the active AttackEvent; modern EnemyBase receivers remain exactly one pass.
  - Receiver-authored parry Posture is now idempotent with legacy notify_got_hit(parried=true), preventing the old explicit-plus-generic double spike while preserving notify-only legacy parry compatibility.
  - Blood Lotus Heart's exposed core can now receive canonical sword Posture through its existing notify-only path instead of potentially never filling its core Posture meter.
  - Audit found no equivalent structural repair needed for current Court Guard, Court Caster, Elite Defender, Eternal Swordsman wrapper, Mist Shepherd, Stalker Hound, or intentionally HP-only Hollow Vessel/Blood Lotus Stalk/Spillborn contracts.
  - Death/defeat routing inspected for Twin Maws and Eclipse Shogun remains connected to manager/defeated/enemy_died progression paths; no Keeper-style missing receive interface was found on the later miniboss/boss scripts inspected.
recent_batches:
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
  - pr_129: repaired Collector/Keeper posture and Keeper Deathblow progression; gated inactive Area 2 duo manager startup.
  - pr_130: preemptively reconciled stale Region 2/3 hit/parry posture contracts through the shared canonical AttackEvent bridge.
confirmed:
  - PR #119 through #130 merged; never continue old feature branches.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix remain intact.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning remains evidence-driven rather than speculative.
  - Region 2/3 static audit and CI do not replace player-facing playtest validation.
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
