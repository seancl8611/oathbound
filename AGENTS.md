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
updated_utc: 2026-09-11T02:47:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 152
  feature_head: d586e55e22d276de26524856366894d9d6e257fb
  merge_commit: 575fc52388a25fb4e6236a07dee8139c1e689ca5
  validation: 10/10 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Release Shell, Blood Cavern Execution Trial, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation
active_branch: null
active_pr: null
covered_through_substantive_commit: 575fc52388a25fb4e6236a07dee8139c1e689ca5
known_good_checkpoint: 575fc52388a25fb4e6236a07dee8139c1e689ca5
current_objective: >-
  Combat V2 Phases 1-3 are integrated on the Corrupted Swordsman reference enemy. Phase 1 separated Health/Posture/guard/Poise response and preserved Posture/Deathblow. Phase 2 added reusable CombatActionRunner + EnemyMotor, explicit commitment, startup tracking, authored action motion, and final motor composition. Phase 3 adds reusable EnemyBrain and routes the canonical Swordsman through `CorruptedSwordsmanV2Brain.gd`: attack/approach/strafe/guard/retreat are now scored at controlled decision boundaries instead of frame-by-frame ENGAGE/DEFEND random checks. Existing attack coroutines, canonical AttackEvent, PostureBar, parry, Deathblow, guard/poise response, ActionRunner, EnemyMotor, and current room AttackDirector remain operative.
next_action: >-
  Continue directly into Combat V2 Phase 4 without waiting for manual playtest: implement a bounded PressureDirectorV2 room-fairness layer that schedules overlapping threat/impact windows instead of whole melee turns, while preserving the existing AttackDirector API as a compatibility facade for non-migrated enemies. Migrate the Corrupted Swordsman first and add deterministic concurrency/fairness telemetry/tests. Do not globally retune enemy counts/Health or rewrite the Player until the pressure layer is coherent.
current_batch:
  - PR #152 merged at 575fc52388a25fb4e6236a07dee8139c1e689ca5 from exact head d586e55e22d276de26524856366894d9d6e257fb; all 10 triggered workflows green.
  - Added `Core/Combat/EnemyBrain.gd`, a reusable controlled-cadence intent selector. It owns selection cadence and intent persistence only; it does not move actors, execute attacks, mutate combat resources, or bypass room fairness.
  - Added `Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Brain.gd` and routed the canonical Swordsman scene through it on top of the existing response/action/motor layers.
  - Swordsman tactical intents are now attack, approach, strafe, guard, retreat/reposition. Scores use distance, attack readiness, player passivity/pressure urgency, posture ratio, other active threats, and guard cooldown.
  - Removed legacy per-physics-frame `randf() < attack_chance` tactical behavior from the migrated Swordsman path. Intent is held through a minimum interval and reconsidered on a controlled cadence.
  - Removed the Swordsman-specific mid-swing courtesy gate from `_can_attack_now`; current AttackDirector still owns actual attack admission, preventing duplicated serialization logic while preserving existing room safety until Phase 4.
  - Removed the legacy random post-attack DEFEND-vs-ENGAGE outcome on the migrated path; EnemyBrain makes the next decision instead.
  - Added `EnemyBrainSmoke` and wired it into Hushiro Combat Semantics CI. It proves cadence-held intent, post-cadence reconsideration, canonical Swordsman EnemyBrain ownership, and retention of Phase 2 ActionRunner/EnemyMotor components.
  - No PressureDirectorV2, Player rewrite, global enemy-count/Health retune, boss migration, stamina, or Aspect capability removal was included.
recent_batches:
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
  - Guard behavior is enemy-authored; no universal Health-through-guard ratio is required.
  - Corrupted Swordsman now owns EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain. Current room fairness is still legacy AttackDirector until Phase 4.
  - Taking Health damage does not inherently cancel a committed action; poise decides immediate interruption on migrated enemies.
  - Enemy posture recovery need not use one universal cadence; multi-target combat should not force Sekiro-style continuous pressure on every target.
  - Aspect-specific block/parry/defensive capability ownership remains undecided. No current Aspect loses a shared mechanic before the dedicated capability pass.
  - Heart combat remains intentionally unauthored; do not invent a kill path without dedicated encounter authority.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
avoid_without_evidence:
  - unbounded whole-game combat rewrite instead of dependency-sized V2 packages
  - suppressing/removing PostureBar before an approved replacement
  - one universal enemy Health-through-guard or Poise formula
  - removing block/parry from an Aspect before the dedicated capability pass
  - globally increasing enemy counts or reducing Health before response + pressure foundations exist
  - rewriting working Player combos before evidence identifies the specific movement/action blocker
  - bypassing CombatActionRunner/EnemyMotor/EnemyBrain with new Swordsman-only parallel state
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
- Corrupted Swordsman final motion is mediated by CombatActionRunner + EnemyMotor and tactical choice by EnemyBrain; future migration must preserve those seams.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. User has explicitly requested continued implementation without waiting for intermediate manual playtests during the current Combat V2 migration; use deterministic CI/telemetry gates between bounded packages.
