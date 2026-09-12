# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V5: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

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
- After every merged PR or other major durable milestone: update `AGENTS.md`, then continue if more evidence-backed work remains; a checkpoint is durable state, not a reason to stop.
- Minimize CI polling; inspect targeted failing/incomplete workflows rather than repeatedly reading everything.

## LIVE_STATE
```yaml
schema: 5
updated_utc: 2026-09-12T20:08:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 166
  feature_head: 8c812a73f399321d34bbab5fabf436e8fbc76d94
  merge_commit: d7ca53a11383ee3d9efdfd598b2ce38aeb9f95cb
  validation: 11/11 exact-head workflows green — Hushiro Combat Regression, Hushiro Combat Semantics, Godot 4.7.2 Project Check, Run Region Handoff, Hushiro Elite Boss Progression, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, Release Shell, Blood Cavern Execution Trial, and Region Transition Presentation.
active_branch: null
active_pr: null
covered_through_substantive_commit: d7ca53a11383ee3d9efdfd598b2ce38aeb9f95cb
known_good_checkpoint: d7ca53a11383ee3d9efdfd598b2ce38aeb9f95cb
current_objective: >-
  Area 1 / Hushiro now has the first approved player-paced hack-and-slash combat target on top of the complete standard-enemy Combat V2 migration. Ordinary enemies should be individually disposable while danger comes primarily from groups, overlapping intentions, composition, geometry, authored defense, hazards, and wave pressure. Preserve this merged target and cut a stable playtest snapshot before subjective pressure/population/numerical tuning.
next_action: >-
  Keep all older frozen playtest branches unchanged. Cut a new frozen playtest branch from the PR #166 merge checkpoint and exercise standard Hushiro rooms with emphasis on 3/4/5-hit common-enemy kills, Swordsman guard extending rather than stalling a kill, Warden as the durable exception, immediate wave chaining, varied arrivals, multi-enemy overlap, and directional basic-attack target handoff after a fodder target dies. Return the matching Godot `.log` and `combat_*.jsonl` before further subjective numerical/pressure tuning. Evidence-backed CI/validation cleanup may continue without waiting for the playtest.
current_batch:
  - PR #166 merged at d7ca53a11383ee3d9efdfd598b2ce38aeb9f95cb from exact feature head 8c812a73f399321d34bbab5fabf436e8fbc76d94; 11/11 exact-head workflows were green.
  - Base katana Health damage remains 9 -> 12 -> 21. The Area 1 pressure capability may continue once through Quick -> Cross -> Heavy -> Quick -> Cross -> Heavy for 84 total clean damage; the six-hit endpoint is not the normal durability target for standard enemies.
  - Area 1 Health targets are Hollow 40 (~3 clean hits), Hound 50 (~4), Archer 45 (~4), Swordsman 60 (5), Bilemass 60 (5), Warden 140 (~11 durable exception).
  - Swordsman guard remains enemy-authored and pressure-responsive. One meaningful guard can deny the otherwise lethal five-hit line, but the player may extend into hit six rather than being forced into a long duel.
  - Canonical Player ownership remains `res://Player/aspect_player.tscn` -> `res://Player/OathboundCombatPlayer.gd`. The six-hit pressure extension was folded into that canonical layer instead of replacing the Player root script.
  - `OathboundPlayerTargeting.gd` now sits between PlayerMotion and PlayerStability. Basic sword attacks use bounded directional soft targeting (short forward cone, player-aim override, death/invalid-target reacquisition); it is assistive steering, not lock-on, and does not own damage, hitboxes, timing, collision, or enemy pressure.
  - Immediate clear -> next-wave flow, the 120-second anti-stall escalation, and burst/staggered/sequence arrival scripts remain intact.
  - During PR #166 validation a stale Hollow HP assertion, stale Bilemass HP assertion, and a target-handoff test-geometry edge case were found and corrected. Do not restore the old 45-Hollow / 80-Bilemass assumptions.
recent_batches:
  - pr_166: hack-and-slash durability + canonical six-hit pressure continuation + directional target handoff; 11/11 exact-head workflows green.
  - pr_165: player-paced Area 1 readiness target, pressure-responsive Swordsman guard, immediate wave chaining, varied wave arrivals, 120-second anti-stall.
  - pr_164: made `advance_move` explicitly compatibility-only; role-aware frontline and PressureDirector impact policy unchanged.
  - pr_163: retired sticky `advance_move` from migrated Swordsman/Hound and made crowd backoff authoritative for Swordsman/Hound/Hollow.
  - pr_162: removed legacy crowd/stall/admission interference from migrated Hushiro rooms; role metadata + bidirectional compatibility.
  - pr_161: role-aware mixed Hushiro frontline pressure; four+ true close-pressure bodies may occupy four frontline slots without raising attack caps.
  - pr_160: restored authored Hound packs and bounded pack/frontline pressure.
  - pr_159: canonical Warden V2 restraint/control migration.
  - pr_158: canonical Cellar Bilemass V2 delayed hazard-pressure migration.
  - pr_157: canonical Corrupted Archer V2 ranged/spatial-pressure migration.
  - pr_156: canonical Hollow V2 swarm/fodder migration.
  - pr_155: canonical Blighted Hound V2 predator migration.
  - pr_154: PlayerMotor + Player CombatActionRunner motion composition.
  - pr_153: PressureDirectorV2 impact-window scheduling + Swordsman migration.
  - pr_152: controlled-cadence EnemyBrain for canonical Swordsman.
  - pr_151: reusable CombatActionRunner + EnemyMotor for canonical Swordsman.
  - pr_150: restored/protected Hushiro PostureBar readability.
  - pr_149: first Combat V2 response/guard/Poise slice.
  - pr_148: refined V2 defense/Health/Posture/Poise/Deathblow direction.
  - pr_147: recorded approved Combat V2 hunter/hack-and-slash direction.
confirmed:
  - Combat V2 direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; migration/component authority is `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
  - Oathbound remains Japanese supernatural dark fantasy; Akio is an aggressive supernatural hunter rather than a formal duelist.
  - Weak standard enemies should not be major threats as lone targets. Area 1 danger should primarily emerge from enemy combinations, overlapping intentions, movement, target priority, geometry, hazards, authored defense, and wave pressure.
  - Standard V2 combat should create visible Health progress and fast ordinary-enemy kills while retaining Posture/Stagger, parry, and Deathblow as optional tactical layers.
  - Enemy PostureBar remains canonical player-facing Posture buildup / Deathblow-approach feedback until an explicit replacement is approved.
  - Health, Posture/Stagger, and Poise are separate: Health governs defeat, Posture/Stagger governs break/control opportunity, Poise governs immediate flinch/interruption.
  - Guard behavior is enemy-authored; no universal Health-through-guard or Poise formula is required.
  - PressureDirectorV2 schedules dangerous impact timing, not enemy intent. Multiple enemies may approach, reposition, aim, and wind up simultaneously when predicted impact windows remain fair.
  - All six canonical Hushiro standard-enemy families use the shared V2 response/action/motor/brain seams and preserve species-specific contact/action authoring.
  - Corrupted Swordsman uses EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain and PressureDirectorV2 normal attack/counter admission.
  - Blighted Hound uses those shared seams for predator pressure while retaining beast-specific attack/movement authoring and shared Hushiro Posture.
  - Hollow remains deliberately simple, low-Poise fodder. Its bite uses PressureDirectorV2 and ordinary hits may interrupt committed fodder pressure according to its authored response profile.
  - Corrupted Archer owns ranged/spatial pressure; reservation timing extends through projectile travel and aim tracking ends at explicit action commitment.
  - Cellar Bilemass owns delayed ground-hazard pressure; future puddle arrival is the pressure event, committed pre-launch vomit has authored Poise, and puddle caps/slow/lifetime remain canonical.
  - Warden remains the durable restraint/control standard-enemy exception, not a generic permanent-block tank.
  - Akio owns PlayerMotor + CombatActionRunner motion seams while preserving canonical action content, hitboxes, AttackEvent delivery, damage, and Aspect profile ownership.
  - Basic-attack soft targeting may steer toward a nearby enemy already inside player directional intent. It must immediately respect strong player redirection and must not become a sticky global lock-on system.
  - Player movement restriction is phase-authored for attacks rather than a universal ATTACKING hard stop. Heavy attacks may intentionally plant more strongly than fast attacks.
  - Player dash behavior remains current-authority exact. Defense mobility has not been redesigned; block/parry remain stationary by existing scope.
  - Phase 7 mixed-role frontline autoscaling is role-aware: Swordsman/Hollow/Hound/Warden are close-pressure bodies; Archer/Bilemass are ranged/spatial and do not consume extra close-frontline budget.
  - Four or more close-pressure bodies may use `max_frontline = 4`; this is occupancy/movement, not permission for four simultaneous damaging attacks.
  - Legacy/V2 attack compatibility is bidirectional. Migrated standard enemies do not consume `advance_move`; standard Hushiro `advance_move` is compatibility-only and conservatively fixed at 2 for remaining untagged/non-migrated actors.
  - Room crowd backoff is authoritative for excess close-pressure occupancy; PressureDirectorV2 remains authoritative for damaging impact timing.
  - The current standard Hushiro encounter catalog remains bounded to 3-6 active enemies per wave; six is a protected validation ceiling for now, not a universal future target.
  - Taking Health damage does not inherently cancel committed actions; Poise decides immediate interruption.
  - Aspect-specific block/parry capability ownership remains undecided. No Aspect loses shared defense before the dedicated capability pass.
  - Frozen playtest branches are comparison artifacts. Never push follow-on implementation onto them.
  - Heart combat remains intentionally unauthored; do not invent a kill path without dedicated encounter authority.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
avoid_without_evidence:
  - unbounded whole-game combat rewrite instead of dependency-sized V2 packages
  - suppressing/removing PostureBar before an approved replacement
  - raising common Area 1 Health back toward long duel lengths merely to make single enemies threatening
  - globally buffing Player damage when enemy durability/encounter pressure is the intended tuning axis
  - turning directional target handoff into sticky auto-lock or letting it override explicit player aim
  - one universal enemy Health-through-guard or Poise formula
  - removing block/parry from an Aspect before the dedicated capability pass
  - globally multiplying encounter counts or changing PressureDirector spacing before reading actual playtest evidence
  - treating blueprint illustrative room sizes as universal authored targets
  - counting Archer/Bilemass as close-frontline pressure merely because wave population is high
  - treating `advance_move` as active standard-V2 pressure
  - bypassing CombatActionRunner/PlayerMotor/EnemyMotor/EnemyBrain/PressureDirectorV2 with parallel actor-specific systems
  - globally raising legacy melee/ranged caps as a shortcut around PressureDirectorV2
  - treating Archer ranged/spatial pressure as a melee token
  - treating Bilemass puddle pressure as an ordinary projectile hit
  - treating Warden as a permanent-block tank
  - invented Heart combat
  - unrelated PR growth
```

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge -> updated main -> main:AGENTS.md -> continue while evidence-backed work remains -> user-visible handoff`

## ENGINEERING_GUARDS
- Project `game/oathbound/`; Godot 4.7.2; clean import/editor compile before manual playtest.
- Validate live runtime ownership, not compile alone; combat changes require telemetry.
- Explicitly type Variant-derived GDScript locals.
- Defer physics registration mutation during active contact traversal.
- One canonical Player creation path; root authority is `res://Player/aspect_player.tscn` using `res://Player/OathboundCombatPlayer.gd`.
- Canonical AttackEvent only; no second damage/Posture pass.
- Posture-break/Deathblow shared state; block uses current defensive aim while compatibility contracts remain operative.
- Enemy PostureBar remains canonical buildup/Deathblow-readiness feedback until explicit replacement approval.
- Canonical Player attack motion is mediated by CombatActionRunner + PlayerMotor through `OathboundPlayerMotion.gd`; target assistance is layered through `OathboundPlayerTargeting.gd`; future Player changes must preserve Aspect profile, hitbox, AttackEvent, and damage ownership unless explicitly replacing those responsibilities.
- Corrupted Swordsman final motion is mediated by CombatActionRunner + EnemyMotor, tactical choice by EnemyBrain, and attack admission by PressureDirectorV2.
- Blighted Hound bite/lunge contact remains canonical in the imported controller while `BlightedHoundV2.gd` mediates tactical choice/action commitment/motion/Poise/pressure.
- Hollow bite contact remains canonical in `Hollow.gd`/`HollowStability.gd` while `HollowV2.gd` mediates V2 behavior; preserve its fodder identity and shared Hushiro Posture/Deathblow ownership.
- Corrupted Archer projectile/contact remains canonical in the current Archer projectile/controller stack while `CorruptedArcherV2.gd` mediates V2 behavior; preserve weak reactive guard, smoke behavior, and shared Posture/Deathblow ownership.
- Cellar Bilemass puddle construction/contact and skitter goal authoring remain canonical in `CellarBilemass.gd` while `CellarBilemassV2.gd` mediates V2 behavior; preserve the canonical `Combat` child and hazard caps/slow/lifetime.
- Warden restraint/contact/reward remains canonical in `WardenRules.gd`/`WardenController.gd` while `WardenV2.gd` mediates cadence/commitment/motion/Poise/short guard/control pressure; preserve timed-parry restraint escape and shared Posture/Deathblow ownership.
- Hushiro room-pressure tuning keeps legacy compatibility movement roles, role-aware close-frontline occupancy, and PressureDirectorV2 damaging-impact admission separate.
- OathboundAttackDirector crowd spacing counts only actors explicitly classified as close-frontline pressure when V2 metadata exists; ranged/hazard actors keep their own movement logic.
- Legacy single-turn stall prevention must not override EnemyBrain/PressureDirector cadence on migrated V2 actors.
- Legacy damaging roles and V2 reservations are mutually exclusive across different actors during incremental migration.
- Legacy AttackDirector remains compatibility infrastructure, not a substitute for PressureDirectorV2 in migrated combat.
- `.godot/`/`.import/` are untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. Keep every explicitly frozen playtest branch immutable so its feel remains comparable even after `main` advances.
