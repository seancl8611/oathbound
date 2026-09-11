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
updated_utc: 2026-09-11T22:12:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 156
  feature_head: c244b9acf3b071b56cdd9910fdfefa5f247529c3
  merge_commit: 7cdae9c8109d49916006517dab7e110f43f06ef2
  validation: 8/8 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation.
active_branch: null
active_pr: null
covered_through_substantive_commit: 7cdae9c8109d49916006517dab7e110f43f06ef2
known_good_checkpoint: 7cdae9c8109d49916006517dab7e110f43f06ef2
current_objective: >-
  Combat V2 Phases 1-5 are integrated, and Phase 6 standard-enemy migration is underway. Corrupted Swordsman remains the full humanoid reference enemy. Akio owns PlayerMotor + CombatActionRunner motion seams. Blighted Hound is migrated as the beast/predator reference. Hollow is now the first true swarm/fodder migration: shared response/action/motor/brain/pressure ownership is live while its one-bite identity, canonical bite contact, shared Hushiro Posture/Deathblow contract, rewards, and 45 HP / 40 Posture baseline remain authoritative.
next_action: >-
  Continue Combat V2 without waiting for intermediate manual playtests. Migrate Corrupted Archer next as the ranged/spatial-pressure standard enemy. Preserve projectile/contact authority, current Posture/Deathblow contract, spacing identity, and smoke/prosthetic interactions while moving tactical cadence, action commitment/motion where applicable, Poise response, and room-pressure admission onto shared V2 seams. Keep Archer ranged pressure distinct from melee impact scheduling; do not force it into the Hollow/Hound melee template. After Archer, migrate Bilemass, then Warden in separate evidence-backed packages. Do not globally increase encounter counts or retune Health/damage until these shared standard-enemy migrations are coherent.
current_batch:
  - PR #156 merged at 7cdae9c8109d49916006517dab7e110f43f06ef2 from exact head c244b9acf3b071b56cdd9910fdfefa5f247529c3; all 8 workflows triggered for this change were green.
  - Added `Regions/Hushiro/Enemies/Standard/HollowV2.gd` and routed the canonical Hollow scene through it. `HollowStability.gd` remains authoritative for shared CombatController ticking, visible Posture buildup, parry Posture, stagger-first Deathblow readiness, and the existing death/reward path.
  - Hollow tactical choice now uses controlled-cadence EnemyBrain intents: bite, approach, orbit/reposition, and retreat. It intentionally retains one authored attack rather than gaining duel-style move complexity.
  - Hollows no longer require the legacy whole melee turn in production. Their bite reserves a low-cost normal PressureDirectorV2 impact window; multiple Hollows may approach simultaneously while damaging impacts remain scheduled for readability.
  - CombatActionRunner now gives the Hollow bite explicit startup/commitment/active/recovery phases. Early windup may track and creep slightly; EnemyMotor composes the active bite step and recovery movement rather than direct constant attack-state velocity.
  - Added `EnemyCombatResponseProfile.hollow_v2()`. Hollows have no guard and deliberately remain low-Poise fodder: ordinary canonical sword impact can interrupt even a committed bite. Their threat comes from room position and numbers, not armor-like commitment.
  - Hushiro baseline remains 45 Health / 40 Posture. PostureBar, HushiroPostureBreakRuntime, delayed Deathblow arm, bite hitbox metadata, block/parry interaction, and rewards remain intact.
  - Added `HollowV2MigrationSmoke`; Hushiro Combat Semantics validates canonical runtime ownership, simple fodder scoring, low-cost pressure request, explicit commitment, committed low-Poise interruption, and Posture/Deathblow preservation.
  - PR #155 immediately precedes this package: canonical Blighted Hound V2 predator migration, 8/8 triggered workflows green.
recent_batches:
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
  - Hollow now owns shared V2 response/action/motor/brain seams and uses PressureDirectorV2 for bite admission. It remains deliberately simpler and lower-Poise than Swordsman/Hound; multiple Hollows can approach simultaneously while impact scheduling governs fairness.
  - PressureDirectorV2 schedules danger, not enemy intent: overlapping approach/windup is allowed when predicted impact windows remain fair.
  - Akio owns PlayerMotor + CombatActionRunner motion seams while preserving the existing canonical action-content and damage pipeline.
  - Player movement restriction is phase-authored for attacks rather than a universal ATTACKING hard stop. Heavy attacks may still intentionally plant the Player more strongly than fast attacks.
  - Player dash behavior remains current-authority exact. Defense mobility has not yet been redesigned; block/parry remain stationary by explicit package scope.
  - Non-migrated enemies remain on legacy AttackDirector roles/tokens until individually migrated; do not globally raise the old melee token cap as a substitute for V2 pressure scheduling.
  - Taking Health damage does not inherently cancel a committed action; Poise decides immediate interruption on migrated enemies. Hollow is an intentional archetype exception where committed Poise remains low enough for ordinary hits to interrupt.
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
- Canonical Player attack motion is mediated by CombatActionRunner + PlayerMotor through `OathboundPlayerMotion.gd`; future Player changes must preserve Aspect profile and AttackEvent ownership unless explicitly replacing those responsibilities.
- Legacy AttackDirector remains the compatibility path for non-migrated enemies during phased conversion.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. User has explicitly requested continued implementation without waiting for intermediate manual playtests during the current Combat V2 migration; use deterministic CI/telemetry gates between bounded packages.
