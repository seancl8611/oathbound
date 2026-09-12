# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V6: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

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
schema: 6
updated_utc: 2026-09-12T21:13:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 167
  feature_head: 11e9f3e344dc56edf5bf02ad40e0ee55afede024
  merge_commit: 358eacb08dd4414296d7b40664d20213f3f062ed
  validation: >-
    PR #167 exact head passed every triggered workflow, including the new fail-fast Hushiro Combat Contract Gate, Godot 4.7.2 Project Check, Hushiro Combat Semantics, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, and Region Transition Presentation.
active_branch: null
active_pr: null
covered_through_substantive_commit: 358eacb08dd4414296d7b40664d20213f3f062ed
known_good_checkpoint: 358eacb08dd4414296d7b40664d20213f3f062ed
frozen_playtest:
  branch: playtest/area1-hack-and-slash-2026-09-12
  head: 824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a
  baseline_main: 358eacb08dd4414296d7b40664d20213f3f062ed
  guide: docs/playtests/AREA1_HACK_AND_SLASH_PLAYTEST_2026-09-12.md
  immutable: true
current_objective: >-
  Preserve the first merged Area 1 player-paced hack-and-slash target and evaluate it as a stable manual playtest snapshot. Ordinary enemies should be individually disposable while danger comes primarily from groups, overlapping intentions, target priority, geometry, hazards, authored defense, and wave pressure. Continue evidence-backed architecture/validation cleanup, but do not perform subjective pressure/population/numerical tuning until manual evidence returns.
next_action: >-
  Keep every frozen playtest branch unchanged. Manual test `playtest/area1-hack-and-slash-2026-09-12` at exact head `824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a`, then return the matching Godot `.log` and `combat_*.jsonl`. Evaluate solo fodder weakness, 3/4/5-hit standard-enemy kill cadence, Swordsman guard as a short extension rather than a duel, Warden durability, immediate wave chaining, arrival variety, overlapping enemy pressure, and directional target handoff after a target dies. Evidence-backed cleanup may continue meanwhile. Stale pre-V2 PR #145 must not be merged directly; audit/retire it or reimplement any still-valid cue behavior as a fresh package against current `main`.
current_batch:
  - PR #167 merged at `358eacb08dd4414296d7b40664d20213f3f062ed` from exact head `11e9f3e344dc56edf5bf02ad40e0ee55afede024`.
  - PR #167 added `.github/workflows/hushiro-combat-contract-gate.yml` with `set -euo pipefail`, so missing PASS markers or failed Godot smokes cannot be hidden by a later shell command.
  - The hard gate covers current player-paced durability, six-hit pressure + target handoff, canonical Swordsman action/motor integration, and Hound/Hollow/Archer/Bilemass/Warden V2 migration smokes.
  - Frozen playtest branch `playtest/area1-hack-and-slash-2026-09-12` was cut from PR #167 main and then frozen at `824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a` after adding its playtest guide.
  - Older frozen branches remain immutable comparison artifacts and must not receive follow-on implementation.
  - PR #166 remains the substantive combat package: canonical six-hit base-katana pressure continuation, directional basic-attack soft targeting, and revised Area 1 durability.
  - Base katana Health damage remains 9 -> 12 -> 21; six clean hits total 84. The six-hit string is pressure capability, not normal standard-enemy durability.
  - Area 1 Health targets: Hollow 40 (~3 clean hits), Hound 50 (~4), Archer 45 (~4), Swordsman 60 (5), Bilemass 60 (5), Warden 140 (~11 durable exception).
  - One meaningful Swordsman guard can deny the clean five-hit kill, but the player may extend into hit six rather than enter a long duel.
  - Canonical Player ownership remains `res://Player/aspect_player.tscn` -> `res://Player/OathboundCombatPlayer.gd`.
  - `OathboundPlayerTargeting.gd` provides bounded directional soft targeting for ordinary basic sword flow only; it is assistive steering, not global lock-on, and does not own damage, hitboxes, AttackEvent delivery, action timing, collision, or enemy pressure.
  - Immediate clear -> next wave, 120-second anti-stall escalation, and burst/staggered/sequence arrivals remain intact.
recent_batches:
  - pr_167: durable checkpoint + fail-fast Hushiro combat contract gate.
  - pr_166: hack-and-slash durability + canonical six-hit pressure continuation + directional target handoff; 11/11 exact-head workflows green.
  - pr_165: player-paced Area 1 readiness target, pressure-responsive Swordsman guard, immediate wave chaining, varied arrivals, 120-second anti-stall.
  - pr_164: `advance_move` made compatibility-only.
  - pr_163: sticky `advance_move` retired from migrated Swordsman/Hound; crowd backoff made authoritative for migrated close pressure.
  - pr_162: legacy crowd/stall/admission interference removed; legacy/V2 damaging admission made bidirectionally safe.
  - pr_161: role-aware mixed frontline occupancy.
  - pr_160: authored Hound packs restored.
  - pr_159..155: Warden/Bilemass/Archer/Hollow/Hound V2 migrations.
  - pr_154: PlayerMotor + Player CombatActionRunner motion composition.
  - pr_153..149: PressureDirectorV2, EnemyBrain, action/motor, PostureBar protection, and first V2 guard/Poise foundation.
confirmed:
  - Combat V2 direction authority: `docs/overview/V2_COMBAT_DIRECTION.md`; implementation authority: `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
  - Oathbound remains Japanese supernatural dark fantasy; Akio is an aggressive supernatural hunter rather than a formal duelist.
  - Weak standard enemies should not be major threats as lone targets. Area 1 danger should primarily emerge from enemy combinations, overlapping intentions, movement, target priority, geometry, hazards, authored defense, and wave pressure.
  - Health, Posture/Stagger, and Poise are separate axes: Health governs defeat; Posture/Stagger governs break/control opportunity; Poise governs immediate flinch/interruption.
  - Enemy PostureBar remains canonical player-facing Posture/Deathblow-readiness feedback until explicitly replaced.
  - Guard is enemy-authored; no universal Health-through-guard or Poise formula is required.
  - PressureDirectorV2 schedules dangerous impact timing, not enemy intent. Multiple enemies may approach/reposition/aim/wind up simultaneously if predicted impact timing remains fair.
  - All six canonical Hushiro standard-enemy families use the shared V2 response/action/motor/brain seams while preserving species-specific contact/action authoring.
  - Swordsman: EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain + PressureDirectorV2.
  - Hound: shared V2 seams with predator-specific movement/attacks and shared Hushiro Posture.
  - Hollow: simple low-Poise fodder; PressureDirectorV2 bite admission.
  - Archer: ranged/spatial pressure; reservation includes projectile travel; aim tracking ends at explicit commitment.
  - Bilemass: delayed ground-hazard pressure; future puddle arrival is the pressure event; committed pre-launch vomit has authored Poise.
  - Warden: durable restraint/control exception, not a permanent-block tank.
  - Canonical Player attack motion is mediated by CombatActionRunner + PlayerMotor through `OathboundPlayerMotion.gd`; target assistance is layered through `OathboundPlayerTargeting.gd`.
  - Basic-attack target assistance must respect explicit player redirection immediately and reacquire after invalid/dead targets without becoming sticky auto-lock.
  - Player dash remains current-authority exact. Defense mobility has not yet been redesigned; block/parry remain stationary by current scope.
  - Close-frontline occupancy is role-aware: Swordsman/Hollow/Hound/Warden are close-pressure bodies; Archer/Bilemass are ranged/spatial and do not consume extra close-frontline budget.
  - `max_frontline = 4` for four+ close-pressure bodies is an occupancy/movement rule, not permission for four simultaneous damaging attacks.
  - Migrated standard enemies do not consume `advance_move`; standard Hushiro `advance_move` is compatibility-only and fixed conservatively at 2 for remaining untagged/non-migrated actors.
  - Room crowd backoff owns excess close-pressure occupancy; PressureDirectorV2 owns damaging-impact timing.
  - Taking Health damage does not inherently cancel committed actions; Poise owns immediate interruption.
  - Aspect-specific block/parry capability ownership remains undecided. No Aspect loses shared defense before the dedicated capability pass.
  - Heart combat remains intentionally unauthored; do not invent a kill path without dedicated encounter authority.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
  - Frozen playtest branches are immutable comparison artifacts.
  - Stale PR #145 predates the current Combat V2 architecture and cannot be merged directly. Any retained counter-cue design must be re-audited against current action/pressure timing.
avoid_without_evidence:
  - unbounded whole-game combat rewrite instead of dependency-sized V2 packages
  - suppressing/removing PostureBar before an approved replacement
  - raising common Area 1 Health back toward long duel lengths merely to make single enemies threatening
  - globally buffing Player damage when enemy durability/encounter pressure is the intended tuning axis
  - turning directional target handoff into sticky auto-lock or letting it override explicit player aim
  - one universal enemy Health-through-guard or Poise formula
  - removing block/parry from an Aspect before the dedicated capability pass
  - globally multiplying encounter counts or changing PressureDirector spacing before playtest evidence
  - treating illustrative blueprint room sizes as universal authored targets
  - counting Archer/Bilemass as close-frontline pressure merely because total population is high
  - treating `advance_move` as active standard-V2 pressure
  - bypassing CombatActionRunner/PlayerMotor/EnemyMotor/EnemyBrain/PressureDirectorV2 with parallel actor-specific systems
  - globally raising legacy melee/ranged caps as a shortcut around PressureDirectorV2
  - treating Archer pressure as a melee token
  - treating Bilemass puddle pressure as an ordinary projectile hit
  - treating Warden as a permanent-block tank
  - merging stale pre-V2 counter-cue code without a fresh timing/ownership audit
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
- Hollow bite contact remains canonical in `Hollow.gd`/`HollowStability.gd` while `HollowV2.gd` mediates V2 behavior; preserve fodder identity and shared Hushiro Posture/Deathblow ownership.
- Corrupted Archer projectile/contact remains canonical in the current Archer projectile/controller stack while `CorruptedArcherV2.gd` mediates V2 behavior; preserve weak reactive guard, smoke behavior, and shared Posture/Deathblow ownership.
- Cellar Bilemass puddle construction/contact and skitter goal authoring remain canonical in `CellarBilemass.gd` while `CellarBilemassV2.gd` mediates V2 behavior; preserve the canonical `Combat` child and hazard caps/slow/lifetime.
- Warden restraint/contact/reward remains canonical in `WardenRules.gd`/`WardenController.gd` while `WardenV2.gd` mediates cadence/commitment/motion/Poise/short guard/control pressure; preserve timed-parry restraint escape and shared Posture/Deathblow ownership.
- Hushiro room-pressure tuning keeps legacy compatibility movement roles, role-aware close-frontline occupancy, and PressureDirectorV2 damaging-impact admission separate.
- OathboundAttackDirector crowd spacing counts only actors explicitly classified as close-frontline pressure when V2 metadata exists; ranged/hazard actors keep their own movement logic.
- Legacy single-turn stall prevention must not override EnemyBrain/PressureDirector cadence on migrated V2 actors.
- Legacy damaging roles and V2 reservations are mutually exclusive across different actors during incremental migration.
- Legacy AttackDirector remains compatibility infrastructure, not a substitute for PressureDirectorV2 in migrated combat.
- Combat CI must fail hard on a missing expected PASS marker or failed Godot smoke; do not trust a green wrapper if an inner assertion reports FAIL.
- `.godot/`/`.import/` are untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 implementation -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. Keep every explicitly frozen playtest branch immutable so its feel remains comparable even after `main` advances.
