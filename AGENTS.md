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
updated_utc: 2026-09-12T02:55:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 159
  feature_head: 3ae3c640a370f2f5beebc9a0916f7a9340b7d669
  merge_commit: 0c99dd756cc30c9900779eaaeb48d69f996b762f
  validation: 8/8 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation.
active_branch: null
active_pr: null
covered_through_substantive_commit: 0c99dd756cc30c9900779eaaeb48d69f996b762f
known_good_checkpoint: 0c99dd756cc30c9900779eaaeb48d69f996b762f
current_objective: >-
  Combat V2 Phases 1-6 are integrated for Hushiro's canonical standard-enemy roster. Corrupted Swordsman is the full humanoid reference, Blighted Hound the predator reference, Hollow the low-Poise swarm/fodder reference, Corrupted Archer the ranged/spatial-pressure reference, Cellar Bilemass the delayed area-denial/hazard-pressure reference, and Warden the restraint/control-heavy reference. Begin Phase 7 encounter retuning from evidence in the current Hushiro room/spawn authoring rather than globally multiplying counts or flattening role identities.
next_action: >-
  Audit Hushiro encounter population and mixed-role authoring from the current canonical room/spawn pipeline. Identify which rooms currently instantiate the six migrated standard-enemy families, their counts/compositions, arena readability constraints, and any legacy AttackDirector assumptions that still serialize pressure. Then implement the smallest evidence-backed Phase 7 encounter-retuning package: improve mixed-role pressure and population only where spatial clarity supports it, preserve authored early/mid/late progression, and add deterministic room/composition/pressure validation. Do not globally lower Health/damage, raise max_melee_attackers, or apply the blueprint's illustrative 4-5 / 6-8 / 8-12 population examples as universal contracts.
current_batch:
  - PR #159 merged at 0c99dd756cc30c9900779eaaeb48d69f996b762f from exact head 3ae3c640a370f2f5beebc9a0916f7a9340b7d669; all 8 triggered workflows were green.
  - Added `EnemyCombatResponseProfile.warden_v2()` and routed canonical `Warden.tscn` through `WardenV2.gd` while preserving the existing WardenController/WardenRules attack hitboxes, chain restraint, timed pre-yank parry escape, failure Posture spike, rewards, animations, and death flow.
  - Warden now owns shared EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain seams and PressureDirectorV2 admission.
  - Warden tactical intent runs on controlled cadence. Its ready offense outranks guard; chain remains the dominant weighted attack, while thrust/cross/running attacks remain simpler secondary tools.
  - Replaced inherited proximity-permanent Humanoid guard behavior with a short tactical guard: 0.22s duration, 1.55s cooldown, full Health negation only during the rare active guard, and 1.25x Posture pressure through guard.
  - Warden Poise is stateful rather than hidden mitigation: neutral/early Warden remains light-hit interruptible, ordinary committed melee requires Poise power 2, and the identity-defining committed chain cast requires Poise power 3. Health/Posture damage still apply independently when the action survives.
  - Chain restraint requests perilous `control` pressure at 1.50 threat cost; its reservation models the cast impact and survives through the possible restraint window instead of behaving like a light melee token.
  - EnemyMotor composes Warden locomotion/action motion while preserving its slow approach/orbit identity and authored running lunge. CombatActionRunner freezes target tracking after commitment.
  - Canonical Hushiro authority remains 140 Health / 150 Posture at runtime. Warden restraint remains timed-parry escape, +25 Posture on failure, and 1.2s Warden stagger on successful escape.
  - Added `WardenV2MigrationSmoke`; Hushiro Combat Semantics validates runtime ownership, 140/150 Hushiro contract, restraint behavior, control-pressure request, commitment lock, short guard, and three-tier Poise behavior.
  - Phase 6 standard-enemy migration is now complete for the canonical Hushiro roster: Swordsman, Hound, Hollow, Archer, Bilemass, Warden.
recent_batches:
  - pr_159: canonical Warden V2 restraint/control-heavy migration; 8/8 triggered workflows green.
  - pr_158: canonical Cellar Bilemass V2 delayed area-denial/hazard-pressure migration; 8/8 triggered workflows green after canonical CombatController scene wiring fix.
  - pr_157: canonical Corrupted Archer V2 ranged/spatial-pressure migration; 8/8 triggered workflows green.
  - pr_156: canonical Hollow V2 swarm/fodder migration; 8/8 triggered workflows green.
  - pr_155: canonical Blighted Hound V2 predator migration; 8/8 triggered workflows green.
  - pr_154: PlayerMotor + Player CombatActionRunner motion composition; 9/9 triggered workflows green.
  - pr_153: PressureDirectorV2 impact-window scheduling + Swordsman migration; 10/10 workflows green.
  - pr_152: controlled-cadence EnemyBrain for canonical Swordsman; removed frame-by-frame tactical RNG; 10/10 workflows green.
  - pr_151: reusable CombatActionRunner + EnemyMotor for canonical Swordsman; explicit commitment/motion; 10/10 workflows green.
  - pr_150: restored/protected Hushiro PostureBar readability; 9/9 workflows green.
  - pr_149: first Combat V2 response/guard/poise slice; 10/10 workflows green.
  - pr_148: refined V2 defense/guard/Health/Posture/Poise/Deathblow direction; documentation only.
  - pr_147: recorded approved Combat V2 hunter/hack-and-slash direction; documentation only.
confirmed:
  - Combat V2 direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; migration/component authority is `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
  - Oathbound remains Japanese supernatural dark fantasy; Akio is increasingly framed as an aggressive supernatural hunter rather than a formal duelist.
  - Standard V2 combat should create visible Health progress and faster ordinary-enemy kills while retaining Posture/Stagger, parry, and Deathblow as optional tactical layers.
  - Enemy PostureBar remains canonical player-facing Posture buildup / Deathblow-approach feedback until an explicit replacement is approved.
  - Health, Posture/Stagger, and Poise are separate: Health governs defeat, Posture/Stagger governs break/control opportunity, Poise governs immediate flinch/interruption.
  - Guard behavior is enemy-authored; no universal Health-through-guard or Poise formula is required.
  - Corrupted Swordsman owns EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain and uses PressureDirectorV2 for normal attack/counter admission.
  - Blighted Hound owns the same shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for bite/lunge admission while retaining beast-specific movement/attack authoring and the shared Hushiro Posture bridge.
  - Hollow owns shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for bite admission. It remains deliberately simpler and lower-Poise than Swordsman/Hound; multiple Hollows can approach simultaneously while impact scheduling governs fairness.
  - Corrupted Archer owns shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for ranged/spatial pressure. Its pressure timing extends through projectile travel, and aim tracking ends at explicit CombatActionRunner commitment.
  - Cellar Bilemass owns shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for delayed ground-hazard pressure. Its reservation represents future puddle arrival, committed pre-launch vomit has authored Poise, and its canonical scene owns the CombatController required by the shared Hushiro Posture contract.
  - Warden owns shared V2 response/action/motor/brain seams and PressureDirectorV2 control pressure. It is a slow restraint/support priority target, not a generic shield tank; chain commitment/Poise and room-control pressure are its heavy identity.
  - PressureDirectorV2 schedules danger, not enemy intent: overlapping approach/windup is allowed when predicted impact windows remain fair.
  - Akio owns PlayerMotor + CombatActionRunner motion seams while preserving the existing canonical action-content and damage pipeline.
  - Player movement restriction is phase-authored for attacks rather than a universal ATTACKING hard stop. Heavy attacks may still intentionally plant the Player more strongly than fast attacks.
  - Player dash behavior remains current-authority exact. Defense mobility has not yet been redesigned; block/parry remain stationary by explicit package scope.
  - All six canonical Hushiro standard-enemy families have now been migrated to V2 shared seams; legacy AttackDirector remains compatibility infrastructure for non-migrated actors/encounters, not the desired Phase 7 pressure model.
  - Taking Health damage does not inherently cancel a committed action; Poise decides immediate interruption on migrated enemies.
  - Enemy posture recovery need not use one universal cadence; multi-target combat should not force Sekiro-style continuous pressure on every target.
  - Aspect-specific block/parry/defensive capability ownership remains undecided. No current Aspect loses a shared mechanic before the dedicated capability pass.
  - User explicitly requested continued Combat V2 implementation without waiting for intermediate manual playtests; deterministic CI/telemetry is the gate between bounded packages.
  - Heart combat remains intentionally unauthored; do not invent a kill path without dedicated encounter authority.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
avoid_without_evidence:
  - unbounded whole-game combat rewrite instead of dependency-sized V2 packages
  - suppressing/removing PostureBar before an approved replacement
  - one universal enemy Health-through-guard or Poise formula
  - removing block/parry from an Aspect before the dedicated capability pass
  - globally multiplying encounter counts or lowering Health/damage before reading actual Phase 7 room authoring
  - treating the blueprint's illustrative 4-5 / 6-8 / 8-12 room sizes as universal authored targets
  - rewriting working Player combo content instead of using the locomotion/action-motion seam
  - bypassing CombatActionRunner/PlayerMotor/EnemyMotor/EnemyBrain/PressureDirectorV2 with parallel actor-specific systems
  - globally raising `max_melee_attackers` as a shortcut around PressureDirectorV2
  - flattening enemy defensive identities into one HP-through-guard or Poise formula
  - treating Archer ranged/spatial pressure as a melee token
  - treating Bilemass puddle pressure as an ordinary projectile hit
  - treating Warden as a permanent-block tank instead of a restraint/control threat
  - invented Heart combat
  - unrelated PR growth
```

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge -> updated main -> main:AGENTS.md -> user-visible safe checkpoint/final`

## ENGINEERING_GUARDS
- Project `game/oathbound/`; Godot 4.7.2; clean import/editor compile before manual playtest.
- Validate live runtime ownership, not compile alone; combat changes require telemetry.
- Explicitly type Variant-derived GDScript locals.
- Defer physics registration mutation during active contact traversal.
- One canonical Player creation path; canonical AttackEvent only; no second damage/posture pass.
- Posture-break/Deathblow shared state; block uses current defensive aim while V1 compatibility contracts remain operative.
- Enemy PostureBar remains canonical buildup/Deathblow-readiness feedback until explicit replacement approval.
- Corrupted Swordsman final motion is mediated by CombatActionRunner + EnemyMotor, tactical choice by EnemyBrain, and attack admission by PressureDirectorV2; future migration must preserve those seams.
- Blighted Hound bite/lunge contact remains canonical in the imported controller, while V2 tactical choice/action commitment/motion/Poise/pressure are mediated by `BlightedHoundV2.gd`; preserve its Hushiro shared Posture bridge until that responsibility is explicitly consolidated.
- Hollow bite contact remains canonical in `Hollow.gd`/`HollowStability.gd`, while V2 tactical choice/action commitment/motion/Poise/pressure are mediated by `HollowV2.gd`; preserve its one-attack fodder identity and Hushiro shared Posture/Deathblow ownership.
- Corrupted Archer projectile/contact remains canonical in the current Archer projectile/controller stack, while V2 tactical choice/action commitment/motion/Poise/pressure are mediated by `CorruptedArcherV2.gd`; preserve weak reactive guard, smoke behavior, and Hushiro shared Posture/Deathblow ownership.
- Cellar Bilemass puddle construction/contact and skitter goal authoring remain canonical in `CellarBilemass.gd`, while V2 tactical choice/action commitment/motion/Poise/hazard pressure are mediated by `CellarBilemassV2.gd`; preserve the canonical `Combat` child, shared Hushiro Posture/Deathblow ownership, and existing hazard caps/slow/lifetime.
- Warden restraint/contact/reward behavior remains canonical in `WardenRules.gd`/`WardenController.gd`, while V2 tactical cadence/action commitment/motion/Poise/short guard/control pressure are mediated by `WardenV2.gd`; preserve the timed-parry restraint escape and shared Hushiro Posture/Deathblow ownership.
- Canonical Player attack motion is mediated by CombatActionRunner + PlayerMotor through `OathboundPlayerMotion.gd`; future Player changes must preserve Aspect profile and AttackEvent ownership unless explicitly replacing those responsibilities.
- Legacy AttackDirector remains a compatibility path, not a substitute for PressureDirectorV2 in migrated combat.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. User has explicitly requested continued implementation without waiting for intermediate manual playtests during the current Combat V2 migration; use deterministic CI/telemetry gates between bounded packages.
