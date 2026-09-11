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
updated_utc: 2026-09-11T22:27:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 157
  feature_head: 6d4aad7248e3268645867867927a3267114bb1d7
  merge_commit: d8043550cda2e9fa29cd806a719a1ca8a6a42ede
  validation: 8/8 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation.
active_branch: null
active_pr: null
covered_through_substantive_commit: d8043550cda2e9fa29cd806a719a1ca8a6a42ede
known_good_checkpoint: d8043550cda2e9fa29cd806a719a1ca8a6a42ede
current_objective: >-
  Combat V2 Phases 1-5 are integrated and Phase 6 standard-enemy migration is underway. Corrupted Swordsman is the full humanoid reference, Blighted Hound the predator reference, Hollow the low-Poise swarm/fodder reference, and Corrupted Archer is now the ranged/spatial-pressure reference. Archer owns shared response/action/motor/brain/pressure seams while its projectile construction, predictive aim, wall avoidance, weak reactive guard, smoke/prosthetic behavior, Hushiro Posture/Deathblow contract, and 75 HP / 65 Posture baseline remain authoritative.
next_action: >-
  Continue Combat V2 without waiting for intermediate manual playtests. Migrate Cellar Bilemass next as the area-denial standard enemy. Preserve its delayed landing indicator, puddle DoT/slow, per-enemy and room hazard caps, skitter identity, current Posture/Deathblow contract, and rewards while moving tactical cadence, spit commitment, movement composition, Poise response, and room-pressure admission onto shared V2 seams. Its reservation should represent future ground-hazard arrival/coverage rather than a melee turn or ordinary projectile hit. After Bilemass, migrate Warden in a separate evidence-backed package. Do not globally increase encounter counts or retune Health/damage until the standard-enemy migrations are coherent.
current_batch:
  - PR #157 merged at d8043550cda2e9fa29cd806a719a1ca8a6a42ede from exact head 6d4aad7248e3268645867867927a3267114bb1d7; all 8 workflows triggered for this change were green.
  - Added `Regions/Hushiro/Enemies/Standard/CorruptedArcherV2.gd` and routed the canonical Archer scene through it. `CorruptedArcherRules.gd` remains authoritative for the 75 Health / 65 Posture Hushiro contract and Deathblow execution.
  - Archer tactical selection now uses controlled-cadence EnemyBrain intents: shoot, retreat, approach, reposition, hold. Existing wall avoidance and kite-shot movement identity remain available.
  - Archer normal shots no longer depend on the legacy `ranged_attack` role in production. Each shot requests a low-cost PressureDirectorV2 spatial reservation whose predicted impact includes both bow aim duration and arrow travel time.
  - Ranged reservation intentionally survives the shoot animation while the projectile is travelling; already-launched arrows remain spatial pressure even if the Archer is staggered afterward.
  - CombatActionRunner gives bow shots explicit startup/commitment/active/recovery. Early aim updates the predicted target; after commitment the target freezes, allowing late lateral movement to produce a real miss instead of last-frame homing.
  - EnemyMotor mediates Archer target locomotion through action-phase weights without replacing the existing wall-avoidance/kiting authoring.
  - Added `EnemyCombatResponseProfile.corrupted_archer_v2()`. Archer remains low-Poise even while committed to bow preparation: a normal canonical sword hit interrupts the shooter once Akio successfully closes distance.
  - Existing projectile construction/contact, parry indicator, smoke cancellation, weak reactive guard, PostureBar, HushiroPostureBreakRuntime, delayed Deathblow arm, and rewards remain intact.
  - Added `ArcherV2MigrationSmoke`; Hushiro Combat Semantics validates ranged intent, arrival-time pressure request, explicit aim commitment/target-lock, committed low-Poise interruption, PressureDirectorV2 reachability, and Posture/Deathblow preservation.
  - PR #156 immediately precedes this package: canonical Hollow V2 swarm/fodder migration, 8/8 triggered workflows green.
recent_batches:
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
  - Blighted Hound owns the same shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for bite/lunge admission, while retaining beast-specific movement/attack authoring and the shared Hushiro Posture bridge.
  - Hollow owns shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for bite admission. It remains deliberately simpler and lower-Poise than Swordsman/Hound; multiple Hollows can approach simultaneously while impact scheduling governs fairness.
  - Corrupted Archer owns shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for ranged/spatial pressure. Its pressure timing extends through projectile travel, and aim tracking ends at explicit CombatActionRunner commitment.
  - PressureDirectorV2 schedules danger, not enemy intent: overlapping approach/windup is allowed when predicted impact windows remain fair.
  - Akio owns PlayerMotor + CombatActionRunner motion seams while preserving the existing canonical action-content and damage pipeline.
  - Player movement restriction is phase-authored for attacks rather than a universal ATTACKING hard stop. Heavy attacks may still intentionally plant the Player more strongly than fast attacks.
  - Player dash behavior remains current-authority exact. Defense mobility has not yet been redesigned; block/parry remain stationary by explicit package scope.
  - Non-migrated enemies remain on legacy AttackDirector roles/tokens until individually migrated; do not globally raise the old melee token cap as a substitute for V2 pressure scheduling.
  - Taking Health damage does not inherently cancel a committed action; Poise decides immediate interruption on migrated enemies. Hollow and Archer are intentional low-Poise archetypes where committed actions can still be interrupted by ordinary clean sword impact.
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
  - globally increasing enemy counts or reducing Health before shared enemy migrations and pressure foundations are coherent
  - rewriting working Player combo content instead of using the new locomotion/action-motion seam
  - broad Player intent-buffer/defense rewrite in the enemy-migration package
  - bypassing CombatActionRunner/PlayerMotor/EnemyMotor/EnemyBrain/PressureDirectorV2 with parallel actor-specific systems
  - globally raising `max_melee_attackers` as a shortcut around PressureDirectorV2
  - turning Hollow/Hound fodder migrations into humanoid-duel complexity
  - treating Archer ranged/spatial pressure as if it were just another melee token
  - treating Bilemass puddle pressure as an ordinary projectile hit instead of future area denial
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
- Canonical Player attack motion is mediated by CombatActionRunner + PlayerMotor through `OathboundPlayerMotion.gd`; future Player changes must preserve Aspect profile and AttackEvent ownership unless explicitly replacing those responsibilities.
- Legacy AttackDirector remains the compatibility path for non-migrated enemies during phased conversion.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. User has explicitly requested continued implementation without waiting for intermediate manual playtests during the current Combat V2 migration; use deterministic CI/telemetry gates between bounded packages.
