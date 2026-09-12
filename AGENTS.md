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
updated_utc: 2026-09-12T04:14:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 162
  feature_head: 806a2c6cf7caa990cf679b72322289fa25371ea2
  merge_commit: ba498ceca6cc48d60a48707a8d4d900c9c983af9
  validation: 9/9 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, Region Transition Presentation, and Blood Cavern Execution Trial.
active_branch: null
active_pr: null
covered_through_substantive_commit: ba498ceca6cc48d60a48707a8d4d900c9c983af9
known_good_checkpoint: ba498ceca6cc48d60a48707a8d4d900c9c983af9
current_objective: >-
  Combat V2 Phases 1-6 are integrated for Hushiro's canonical standard-enemy roster. Phase 7 has restored authored Hound packs, made mixed-role frontline occupancy role-aware, and removed proven V1 compatibility interference from fully migrated rooms: ranged/spatial actors no longer consume close-frontline crowd slots, migrated V2 actors are excluded from legacy stall-prevention nudges, and legacy/V2 damaging admission is symmetric. Continue retiring only residual compatibility gates that are demonstrably redundant with V2 movement/pressure ownership before changing encounter populations or numerical balance.
next_action: >-
  Continue Phase 7 by auditing residual `advance_move` ownership on migrated Corrupted Swordsman and Blighted Hound. Both currently use V2 EnemyBrain/EnemyMotor + PressureDirectorV2 but still call the inherited `_approach_gate_ok()` legacy movement-role path. Determine whether `advance_move` provides any safety not already owned by role-aware `max_frontline` crowd backoff, local `_backoff_until`, safe-spawn spacing, and PressureDirectorV2 impact admission. If it is redundant, retire `advance_move` only from migrated V2 movement while preserving crowd-backoff response and legacy role behavior for non-migrated actors. Reconcile `CombatChamber` advance-limit telemetry/validation if that limit becomes compatibility-only. Do not change encounter population, Health/damage, Posture, or PressureDirector spacing without new evidence.
current_batch:
  - PR #162 merged at ba498ceca6cc48d60a48707a8d4d900c9c983af9 from exact head 806a2c6cf7caa990cf679b72322289fa25371ea2; all 9 triggered workflows were green.
  - Found that PR #161's role-aware room `max_frontline` policy was not fully enforced by runtime crowd selection: inherited `_crowd_tick()` still counted every nearby enemy, so Archer/Bilemass could consume close-frontline occupancy or displace a true close-pressure body.
  - HushiroEnemyContract now applies generic pressure metadata to all six canonical standard families: `oathbound_v2_pressure_migrated`, `oathbound_frontline_pressure_body`, and `oathbound_pressure_role`. Swordsman/Hollow/Hound/Warden are close-pressure bodies; Archer is ranged; Bilemass is hazard; Warden retains control identity while counting as a close body.
  - OathboundAttackDirector now filters close-frontline crowd spacing by that metadata. Untagged actors retain legacy default behavior, preserving compatibility outside migrated Hushiro standard rooms.
  - Legacy single-turn stall prevention now skips migrated V2 actors and searches only for true legacy candidates. This prevents `_force_attack_soon` / backoff-clearing from fighting EnemyBrain + PressureDirectorV2 cadence while preserving the rescue path in mixed legacy/V2 scenes.
  - Closed an asymmetric compatibility race: existing legacy melee still blocks a new V2 reservation, and an active V2 reservation now blocks a different actor from acquiring legacy damaging roles (`melee_attack`, `ranged_attack`, `dog_lunge`, `hollow_lunge`). The reservation owner is exempt so inherited compatibility role calls inside its own already-admitted action cannot deadlock it.
  - Extended PressureDirectorSmoke to prove bidirectional admission safety, same-owner compatibility exemption, Swordsman vs Archer/Bilemass frontline classification, default legacy behavior, and legacy-only stall candidate selection.
  - No encounter count, Health, damage, Posture, room advance limit, legacy role cap, or PressureDirector spacing value changed.
recent_batches:
  - pr_162: removed legacy crowd/stall/admission interference from migrated Hushiro rooms; role metadata + bidirectional compatibility; 9/9 triggered workflows green.
  - pr_161: role-aware mixed Hushiro frontline pressure; four+ true close-pressure bodies may occupy four frontline slots without raising mixed-room advance or attack caps; 8/8 triggered workflows green.
  - pr_160: first Phase 7 encounter retune; restored authored Hound packs, bounded pack movement/frontline pressure, deterministic composition/pressure validation; 8/8 triggered workflows green.
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
  - Phase 7 Hound-heavy standard waves may again contain up to four Hounds because actual damaging impact windows are PressureDirectorV2-scheduled. Movement/frontline participation may broaden without raising legacy attack-turn concurrency.
  - Phase 7 mixed-role frontline autoscaling is role-aware: Swordsman/Hollow/Hound/Warden are close-pressure bodies for crowd-spacing purposes; Archer/Bilemass are ranged/spatial pressure and do not consume extra close-frontline budget.
  - Four or more close-pressure bodies may use `max_frontline = 4`; this is an occupancy/movement rule, not permission for four simultaneous damaging attacks.
  - Non-Hound `advance_move` remains 2 for now. A four-body frontline does not imply three or four gated approachers, and attack-impact admission remains independent.
  - Hushiro standard enemies carry generic V2 pressure metadata from HushiroEnemyContract. OathboundAttackDirector uses it to keep close-frontline crowd spacing and legacy stall prevention aligned with migrated role ownership without hard-coding Hushiro scene names in the director.
  - Legacy/V2 attack compatibility is bidirectional: a legacy melee holder blocks new V2 pressure, while active V2 pressure blocks other actors from starting legacy damaging roles; the same reservation owner may still use inherited compatibility roles.
  - The current standard Hushiro encounter catalog remains bounded to 3-6 active enemies per wave; six active is a protected Phase 7 validation ceiling for now, not a statement that later evidence can never revise it.
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
  - restoring or changing every encounter simply because an older baseline differs; distinguish authored identity from proven compatibility workarounds before retuning
  - treating the blueprint's illustrative 4-5 / 6-8 / 8-12 room sizes as universal authored targets
  - counting Archer/Bilemass as close-frontline pressure merely because total wave population is high
  - raising mixed-room `advance_move`, legacy melee/ranged attack caps, or `max_melee_attackers` merely because `max_frontline` may now reach 4
  - rewriting working Player combo content instead of using the locomotion/action-motion seam
  - bypassing CombatActionRunner/PlayerMotor/EnemyMotor/EnemyBrain/PressureDirectorV2 with parallel actor-specific systems
  - globally raising `max_melee_attackers` or legacy melee/ranged role caps as a shortcut around PressureDirectorV2
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
- Hushiro Phase 7 room-pressure tuning keeps three layers separate: `advance_move` compatibility movement slots, `max_frontline` crowd-spacing occupancy, and PressureDirectorV2 damaging-impact admission. PR #161's role-aware frontline classification must not be treated as an attack-concurrency increase.
- OathboundAttackDirector crowd spacing counts only actors explicitly classified as close-frontline pressure when V2 metadata exists; ranged/hazard actors retain their own movement logic and do not consume close-frontline slots.
- Legacy single-turn stall prevention must not override EnemyBrain/PressureDirector cadence on migrated V2 actors. Mixed rooms may still use the inherited rescue mechanism for untagged legacy actors.
- Legacy damaging roles and V2 reservations are mutually exclusive across different actors during incremental migration; do not reopen the one-way admission race.
- Legacy AttackDirector remains a compatibility path, not a substitute for PressureDirectorV2 in migrated combat.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. User has explicitly requested continued implementation without waiting for intermediate manual playtests during the current Combat V2 migration; use deterministic CI/telemetry gates between bounded packages.
