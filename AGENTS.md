# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V8: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

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
schema: 8
updated_utc: 2026-09-13T05:40:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 173
  feature_head: 0ae6a8f5effb1ebb05006745985c7de196943ce0
  merge_commit: 2adfa0a8f4cf1c4d47ccc05c1120f76af28a1aa5
  validation: >-
    Exact PR #173 head finished green across Hushiro Combat Contract Gate, Godot 4.7.2 Project Check, Hushiro Combat Semantics, Hushiro Combat Regression, Run Region Handoff, RunScene Runtime Lifetime, Post-playtest Stability, Authored Presentation Content, and Region Transition Presentation. The dedicated Bilemass landing-readability hard gate passed after replacing sub-second wall-clock sleeps with deterministic elapsed-time stage/deadline boundary helpers used by the runtime itself.
active_branch: null
active_pr: null
covered_through_substantive_commit: 2adfa0a8f4cf1c4d47ccc05c1120f76af28a1aa5
known_good_checkpoint: 2adfa0a8f4cf1c4d47ccc05c1120f76af28a1aa5
frozen_playtest:
  branch: playtest/area1-hack-and-slash-2026-09-12
  head: 824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a
  baseline_main: 358eacb08dd4414296d7b40664d20213f3f062ed
  guide: docs/playtests/AREA1_HACK_AND_SLASH_PLAYTEST_2026-09-12.md
  immutable: true
current_objective: >-
  Preserve the merged Area 1 player-paced hack-and-slash target and evaluate it through the frozen manual playtest snapshot. Continue evidence-backed architecture, presentation, and validation cleanup without subjective population/durability/PressureDirector tuning. Direct contact, projectile, and hazard readability should each consume the timing authority appropriate to the threat rather than being forced through one universal prompt.
next_action: >-
  Keep every frozen playtest branch unchanged. Manual-test `playtest/area1-hack-and-slash-2026-09-12` at exact head `824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a` and return matching Godot `.log` + `combat_*.jsonl` before subjective tuning. Evidence-backed cleanup may continue from updated `main`: isolate the transient `HushiroDefenseContractSmoke` floating-damage-number count/value assertion from `DamageNumberManager` cooldown/lifetime timing without changing damage presentation or gameplay semantics. PR #171 failed that assertion once and passed unchanged on rerun; PR #173 also passed it unchanged.
current_batch:
  - PR #173 merged at `2adfa0a8f4cf1c4d47ccc05c1120f76af28a1aa5` from exact head `0ae6a8f5effb1ebb05006745985c7de196943ce0`.
  - Cellar Bilemass keeps canonical target selection, spit cadence, hazard launch, puddle construction, DoT, slow, lifetime, radius, caps, and PressureDirector admission unchanged.
  - `Core/Combat/BilemassLandingReadability.gd` observes the canonical committed `_pending_spit_indicator`, hides only its legacy visual, and mirrors the authored target with spatial ground-hazard presentation.
  - The warning now spans the full remaining authored launch timeline after the legacy marker appears: `spit_vomit_duration + spit_travel_time`, currently `0.45 + 3.0 = 3.45s`, instead of expiring roughly 0.45s before puddle arrival.
  - Existing light/medium/dark Bilemass indicator textures advance through deterministic thirds of that remaining timeline; the runtime exposes pure elapsed-time stage/deadline helpers so CI does not depend on sub-second runner sleeps.
  - The first armed process frame is guaranteed to remain LIGHT even under a long headless frame; later stage selection is computed from elapsed time, and presentation clears at the predicted landing deadline or pre-landing cancellation.
  - Bilemass warning metadata is explicitly `hazard_language=ground_landing` and `parry_prompt=false`; it is spatial hazard language, not direct-contact or projectile counter language.
  - Bilemass landing telemetry records arm timing, stage changes, deadline, target, and cleanup reason without spawning/cancelling the canonical hazard.
  - Exact PR #173 head passed all nine required workflows, including the fail-fast Bilemass landing-readability gate and unchanged Hushiro defense semantics.
  - The PR #171 one-off floating-damage-number failure remains validation-cleanup evidence only: the exact unchanged rerun passed, and PR #173 passed the same defense contract unchanged.
  - PR #169 remains the authority for direct close-frontline Hushiro counter cues: active PressureDirectorV2 `impact_at`, final 0.20 s warning, final 0.12 s inner mark, fixed scale, hide at predicted contact.
  - PR #171 remains the authority for post-launch Corrupted Archer defensive readability: projectile-local collision-course ETA, final 0.20 s warning, final 0.12 s perfect-parry beat, lateral-dodge suppression, and immediate clear after ownership changes.
  - PR #145 remains closed/superseded and must not be revived; its legacy timing adapter failed its own deterministic traversal before Combat V2 advanced.
  - Base katana Health damage remains 9 -> 12 -> 21; six clean hits total 84. Six-hit pressure is capability, not standard enemy durability.
  - Area 1 Health targets remain Hollow 40 (~3 clean hits), Hound 50 (~4), Archer 45 (~4), Swordsman 60 (5), Bilemass 60 (5), Warden 140 (~11 durable exception).
  - Immediate clear -> next wave, 120-second anti-stall escalation, burst/staggered/sequence arrivals, and directional basic-attack soft targeting remain intact.
recent_batches:
  - pr_173: Bilemass ground warning synchronized to full vomit+travel landing timeline; staged spatial/non-parry readability + telemetry; deterministic boundary validation; 9/9 exact-head workflows green.
  - pr_172: durable control-plane checkpoint after Archer projectile readability.
  - pr_171: flight-local Corrupted Archer defensive readability + dynamic collision-course ETA telemetry; exact unchanged semantics rerun green after one transient damage-number UI assertion.
  - pr_170: durable record of direct V2 counter-cue authority and PR #145 supersession.
  - pr_169: direct Hushiro pre-contact cue timing from PressureDirectorV2 reservations; fixed 0.20 warning / 0.12 parry beat; spatial fallback; 9/9 exact-head workflows green.
  - pr_168: recorded immutable hack-and-slash playtest snapshot on the durable control plane.
  - pr_167: durable checkpoint + fail-fast Hushiro combat contract gate.
  - pr_166: hack-and-slash durability + canonical six-hit pressure continuation + directional target handoff; 11/11 exact-head workflows green.
  - pr_165: player-paced Area 1 readiness target, pressure-responsive Swordsman guard, immediate wave chaining, varied arrivals, 120-second anti-stall.
  - pr_164..160: compatibility cleanup, role-aware frontline occupancy, and authored Hound pack restoration.
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
  - PressureDirectorV2 `impact_at` is the preferred presentation timing seam for an admitted V2 threat when that predicted impact corresponds to the visualized contact.
  - Do not reverse-engineer current V2 impact timing from controller script names or locally inconsistent total-duration arguments when an explicit reservation exists.
  - Direct close-frontline Hushiro cues consume the actor's PressureDirectorV2 predicted impact. Projectile threats may require projectile-local relative-motion timing after launch; ground hazards require spatial landing readability. Do not force all three threat classes through one presentation contract.
  - All six canonical Hushiro standard-enemy families use shared V2 response/action/motor/brain seams while preserving species-specific contact/action authoring.
  - Swordsman: EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain + PressureDirectorV2.
  - Hound: shared V2 seams with predator-specific movement/attacks and shared Hushiro Posture.
  - Hollow: simple low-Poise fodder; PressureDirectorV2 bite admission.
  - Archer: ranged/spatial pressure; reservation includes aim + projectile travel; aim tracking ends at explicit commitment. After launch, the canonical projectile owns final defensive cue geometry through `ArcherProjectileCounterCue.gd`; collision/damage/deflect ownership remains in `CorruptedArcherProjectile.gd`.
  - Bilemass: delayed ground-hazard pressure; future puddle arrival is the pressure event; committed pre-launch vomit has authored Poise. `BilemassLandingReadability.gd` mirrors the canonical committed target through the full remaining vomit+travel timeline using staged spatial warning textures, never parry/counter language.
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
  - giant script-path timing adapters that infer V2 contact timing from legacy controller internals
  - forcing Archer projectile or Bilemass hazard pressure through the melee/direct-contact cue contract
  - leaving an Archer cue over the shooter after release when the actual arrow trajectory has diverged from the original scheduler estimate
  - treating Archer pressure as a melee token
  - treating Bilemass puddle pressure as an ordinary projectile hit or parryable warning
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
- Hollow bite contact remains canonical in `Hollow.gd`/`HollowStability.gd` while `HollowV2.gd` mediates V2 behavior; preserve fodder identity and shared Hushiro Posture/Deathblow ownership.
- Corrupted Archer projectile/contact remains canonical in `CorruptedArcherProjectile.gd`; `CorruptedArcherV2.gd` mediates V2 behavior and `ArcherProjectileCounterCue.gd` is presentation/telemetry only. Preserve weak reactive guard, smoke behavior, shared Posture/Deathblow ownership, projectile collision, block/parry, and reflection semantics.
- Cellar Bilemass puddle construction/contact and skitter goal authoring remain canonical in `CellarBilemass.gd` while `CellarBilemassV2.gd` mediates V2 behavior; preserve the canonical `Combat` child and hazard caps/slow/lifetime.
- Warden restraint/contact/reward remains canonical in `WardenRules.gd`/`WardenController.gd` while `WardenV2.gd` mediates cadence/commitment/motion/Poise/short guard/control pressure; preserve timed-parry restraint escape and shared Posture/Deathblow ownership.
- Hushiro room-pressure tuning keeps legacy compatibility movement roles, role-aware close-frontline occupancy, and PressureDirectorV2 damaging-impact admission separate.
- OathboundAttackDirector crowd spacing counts only actors explicitly classified as close-frontline pressure when V2 metadata exists; ranged/hazard actors keep their own movement logic.
- Legacy single-turn stall prevention must not override EnemyBrain/PressureDirector cadence on migrated V2 actors.
- Legacy damaging roles and V2 reservations are mutually exclusive across different actors during incremental migration.
- Legacy AttackDirector remains compatibility infrastructure, not a substitute for PressureDirectorV2 in migrated combat.
- Direct V2 close-frontline counter presentation consumes PressureDirectorV2 predicted `impact_at`; preserve the 0.20 warning / 0.12 perfect-parry-beat / hide-at-contact contract unless explicit evidence changes it.
- Archer final flight readability must remain projectile-local and geometry-aware; it is not authority for projectile mechanics.
- Bilemass ground-hazard readability must stay spatial and synchronized to actual puddle landing; it is not a parry/counter cue.
- Combat CI must fail hard on a missing expected PASS marker or failed Godot smoke; do not trust a green wrapper if an inner assertion reports FAIL. Diagnose isolated transient UI/timing assertions before modifying unrelated gameplay code.
- `.godot/`/`.import/` are untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 implementation -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. Keep every explicitly frozen playtest branch immutable so its feel remains comparable even after `main` advances.