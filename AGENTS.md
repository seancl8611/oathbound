# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V4: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

Single durable bootstrap + live handoff for AI-assisted Oathbound work. Repository state is authority; conversation/project memory is cache only.

## BOOT
1. Fresh session: fetch `main:AGENTS.md` first.
2. If `active_branch` is set, fetch only that HEAD.
3. If HEAD matches `covered_through_substantive_commit`, continue from `next_action`; otherwise inspect only the uncovered range/files and reconcile.
4. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

## AUTONOMOUS_PR_POLICY
- Routine coherent PR merge approval is not required.
- Coherent + mergeable + required validation green => merge autonomously with exact verified head SHA.
- Diagnose failed CI/mergeability instead of asking.
- Branch subsequent work from updated `main`; never continue old feature branches.

## TURN_SURVIVAL_POLICY
- A turn succeeds only if both repo state and the user-visible handoff survive.
- After every merged PR or other major durable milestone: update `AGENTS.md`, then report the safe checkpoint and next recoverable action.
- Normally complete at most 1 CI-heavy PR or 2 light/bounded PRs per turn unless prior cycles were cheap and execution headroom is ample.
- Minimize CI polling; inspect targeted failing/incomplete workflows rather than repeatedly reading everything.

## LIVE_STATE
```yaml
schema: 4
updated_utc: 2026-09-11T01:40:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 150
  feature_head: 51cd14c5000e71cc31f7399d8959142218c30bbb
  merge_commit: 7d26116cd3ccc34b8d5ff31227ac9e8d00db2327
  validation: 9/9 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Blood Cavern Execution Trial, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation
active_branch: null
active_pr: null
covered_through_substantive_commit: 7d26116cd3ccc34b8d5ff31227ac9e8d00db2327
known_good_checkpoint: 7d26116cd3ccc34b8d5ff31227ac9e8d00db2327
current_objective: >-
  Combat V2 Phase 1 reference-enemy response remains integrated for the Corrupted Swordsman, and PR #150 restores the explicit player-facing Posture readability contract exposed by the September 10 live playtest. Posture and Deathblow were never retired: CombatController Posture remains the mechanical authority and the existing enemy PostureBar remains the canonical player-facing buildup / Deathblow-approach signal until an explicit replacement is designed and approved. Hushiro now attaches `HushiroPostureReadabilityRuntime` after its post-spawn enemy contract so the existing bar is synchronized from the same authoritative posture values even if later runtime layering leaves presentation stale. Current Player action/motion architecture, Swordsman attack execution/HFSM, and AttackDirector remain V1/legacy until later bounded migration packages.
next_action: >-
  Continue with Combat V2 Phase 2 as the next CI-heavy implementation package: introduce the reusable `CombatActionRunner` + `EnemyMotor` around the Corrupted Swordsman while initially preserving its current authored attacks and all canonical Health/Posture/Deathblow interfaces. The September 10 playtest confirmed that Phase 1 response semantics alone are not expected to transform overall feel because `AttackDirector` still owns stable single-turn combat and Hushiro still limits active melee pressure. After Phase 2, migrate Swordsman tactical decisions into controlled-cadence `EnemyBrain`, then implement PressureDirectorV2. Do not suppress/remove PostureBar unless a later explicit readability replacement is approved and validated.
current_batch:
  - PR #150 merged at 7d26116cd3ccc34b8d5ff31227ac9e8d00db2327 from exact head 51cd14c5000e71cc31f7399d8959142218c30bbb; all 9 triggered workflows green.
  - September 10 playtest build `d0dac425128c0394f02954b7077988cde0e60a4f` showed the mechanical Posture/Deathblow path remained active while Sean could no longer see enemy Posture bars. Telemetry captured real Swordsman Posture growth through 25/35/51/87/90 plus posture-break and Deathblow-armed events, proving this was presentation/readability drift rather than mechanic retirement.
  - PR #149 did not delete or hide the shared EnemyBase PostureBar implementation; its code matched the pre-#149 baseline. The live-only seam was the later Hushiro post-spawn contract, which owns authoritative regional posture configuration after enemy `_ready()` has already constructed presentation.
  - Added `Utility/HushiroPostureReadabilityRuntime.gd`, a presentation-only bridge that reads canonical CombatController posture/max and refreshes the existing EnemyBase PostureBar every physics frame. It never mutates posture, break state, Health, or Deathblow eligibility.
  - `HushiroEnemyContract` now attaches the readability bridge beside the existing `HushiroPostureBreakRuntime`; telemetry records that ownership explicitly.
  - Strengthened `HushiroGuardReadabilitySmoke` to mirror live Hushiro spawn order, assert the regional readability runtime is attached, verify PostureBar exists, is visible in-tree, has non-zero fill after canonical Posture damage, and can recover from stale hidden presentation while the underlying posture remains non-zero.
  - The isolated pre-fix test proved EnemyBase still created/updated a visible bar; the strengthened live-order test now protects the post-spawn Hushiro runtime layering that the prior regression suite did not cover.
  - The same playtest also confirmed why Combat V2 felt only subtly different: Phase 1 changed response/guard/poise semantics but left the legacy single-turn AttackDirector, Swordsman HFSM/motion, and Hushiro one-melee-turn pressure policy intact.
recent_batches:
  - pr_150: restored/protected Hushiro PostureBar readability without changing posture/deathblow mechanics; added live-order regional synchronization runtime; 9/9 triggered workflows green.
  - pr_149: implemented first Combat V2 reference-enemy response slice for Corrupted Swordsman; documented implementation blueprint; finite guard + partial Health + state Poise; 10/10 workflows green.
  - pr_148: refined V2 defense, guard, Health/posture, poise, break, and Deathblow direction; 6/6 workflows green; documentation/design only.
  - pr_147: recorded approved Combat V2 hunter direction; 6/6 triggered workflows green; documentation/design only.
  - pr_146: synchronized top-level implementation-status documentation; 6/6 triggered workflows green; no gameplay changes.
confirmed:
  - Combat V2 transition direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; concrete migration/component order is now in `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
  - PR #149 is the first explicit V2 gameplay migration package; PR #150 repairs the player-facing Posture readability seam discovered immediately afterward.
  - Enemy PostureBar is still canonical player-facing feedback for Posture buildup and approaching Deathblow availability. It is not retired, optional, or implicitly replaceable by Combat V2 until a dedicated replacement is explicitly approved.
  - Posture/Deathblow mechanical state remained active in the September 10 live playtest even while the bar was missing; do not interpret missing UI as permission to change/remove the underlying system.
  - Oathbound remains Japanese supernatural dark fantasy in current repository authority, with Akio framed more as an aggressive supernatural hunter than a formal duelist; broader theme changes discussed outside the repo require a dedicated authority update before implementation.
  - Standard V2 combat should create visible Health progress and faster ordinary-enemy kills while preserving posture/stagger, parry, and Deathblow as optional tactical layers.
  - Health, posture/stagger, and poise are not mirror resources: Health governs defeat, posture/stagger governs break/control opportunity, and poise governs immediate flinch/interruption behavior.
  - Guard does not require one universal HP/posture conversion. Enemy-specific defensive identity is an explicit V2 authoring principle.
  - A shield user's strong 0-HP block and a swordsman's partial-damage guard can both be valid if their frequency, duration, stagger pressure, and counterplay fit their roles.
  - Taking Health damage and being interrupted are not assumed to be the same event in V2; PR #149 proves that distinction on committed Corrupted Swordsman offense.
  - Enemy posture/stagger recovery does not need one universal cadence; multi-target combat should not force Sekiro-style continuous pressure on every target.
  - Aspect-specific block/parry/defensive capability ownership remains undecided. No current Aspect loses a shared mechanic until a later explicit capability pass.
  - Substantive gameplay implementation is current through PR #150 merge 7d26116cd3ccc34b8d5ff31227ac9e8d00db2327.
  - The broad Godot documentation-to-code delta audit is executed/closed. Do not make another broad audit a prerequisite for ordinary work.
  - Heart combat remains unauthored by design authority; the existing Heart shell/handoff and downstream Story Complete/postgame behavior are structural/contract-test surfaces, not permission to invent a real Heart kill path.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed; September 10 replay confirms prior lifetime/deferred/CollisionObject crash class remains clean and supports PR #143 state/motion repairs.
  - Twin Maws and Eclipse Shogun produce attack/contact activity and can complete their encounters; do not treat either as generally inert.
  - Direct Playtest Lab Area 2/3 warps are intentional. Playtest Power defaults to 1x; Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - FIRST_ATTEMPT begins directly in the normal Hushiro route; first death awakens Returning Blood and reconstructs at The Strand.
  - Techniques are slotless/unlimited outside the five direct action slots as defined by current authorities.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
  - PR #131 procedural FX are temporary debug/playtest presentation, not final authored art.
  - Current approved Wraith V1 authority is the long-reach frontal posture/control Aspect; future V2 Aspect changes require an explicit capability/kit pass.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require captured state evidence before changing that system.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - unbounded whole-game combat rewrite instead of dependency-sized Combat V2 packages
  - rewriting the working player combo/action foundation before reference-enemy playtest evidence identifies a V2 blocker
  - suppressing/removing enemy PostureBar before an explicit replacement for Posture buildup / Deathblow-readiness feedback is approved
  - one universal enemy Health-through-guard percentage or posture/poise formula
  - removing or replacing block/parry on an Aspect before the dedicated V2 capability pass
  - globally increasing enemy counts or lowering Health/stagger values before the V2 response/pressure foundations exist
  - implementing PressureDirectorV2 before the reference response and Swordsman ActionRunner/EnemyMotor slices are coherent
  - invented Heart combat before dedicated encounter design
  - broad numerical tuning without integration evidence
  - unrelated PR growth
  - visibility/invisibility rewrites based only on perceived disappearance without captured state evidence
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
- Posture-break/Deathblow shared state; block uses current defensive aim while current V1 contracts remain operative.
- Enemy PostureBar remains canonical buildup/Deathblow-readiness feedback until an explicit replacement is approved; regional/runtime layers must keep it synchronized with authoritative CombatController posture.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
