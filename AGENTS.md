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
updated_utc: 2026-09-11T02:58:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 153
  feature_head: c857b7fba585e4646ab4113f2ebaf25e87dc54ae
  merge_commit: 25df9fb2fc4bcecaad804dae3113c01bdd629f27
  validation: 10/10 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Release Shell, Blood Cavern Execution Trial, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation
active_branch: null
active_pr: null
covered_through_substantive_commit: 25df9fb2fc4bcecaad804dae3113c01bdd629f27
known_good_checkpoint: 25df9fb2fc4bcecaad804dae3113c01bdd629f27
current_objective: >-
  Combat V2 Phases 1-4 are integrated on the Corrupted Swordsman reference enemy. Phase 1 separated Health/Posture/guard/Poise response and preserved Posture/Deathblow. Phase 2 added CombatActionRunner + EnemyMotor and explicit commitment/action motion. Phase 3 moved tactical selection to controlled-cadence EnemyBrain. Phase 4 adds shared PressureDirectorV2 under the existing AttackDir autoload: migrated Swordsmen reserve predicted dangerous impact windows instead of owning whole melee turns, so multiple Swordsmen may approach/wind up concurrently when their impacts remain readable. Non-migrated enemies still use the legacy AttackDirector token API.
next_action: >-
  Continue Combat V2 without waiting for intermediate manual playtests. The next bounded package is Phase 5: audit and migrate only the Player movement/action ownership that blocks the approved free-flow hunter direction. Preserve existing Aspect combos, canonical AttackEvent, Health/Posture/Deathblow, Technique/Prosthetic hooks, and current inputs. Prefer locomotion/action-motion composition and phase-authored movement/steering over a broad Player rewrite. After that foundation is coherent, migrate Hound/Hollow/Archer/Bilemass/Warden to the shared response/action/motor/brain/pressure architecture before global encounter-count/Health tuning.
current_batch:
  - PR #153 merged at 25df9fb2fc4bcecaad804dae3113c01bdd629f27 from exact head c857b7fba585e4646ab4113f2ebaf25e87dc54ae; all 10 triggered workflows green.
  - Added `Core/Combat/PressureDirectorV2.gd`. It owns predicted dangerous impact reservations only; EnemyBrain still chooses attacks and existing attack coroutines still execute them.
  - The initial pressure policy uses separate normal/heavy/perilous spacing and a near-impact threat budget. Separated future impacts may coexist even when windups overlap; near-simultaneous impacts are delayed.
  - `Core/Prosthetics/OathboundAttackDirector.gd` now installs one shared PressureDirectorV2 and exposes a compatibility facade. Legacy role/token APIs remain unchanged for non-migrated enemies.
  - Smoke disruption applies to both legacy and V2 admission. During incremental migration, an active legacy melee holder blocks a new V2 pressure reservation; multiple migrated Swordsmen coordinate through pressure windows instead of the legacy one-turn token.
  - Added `Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Pressure.gd` and routed the canonical Swordsman through it. Normal attacks and guard counters no longer request the legacy melee token.
  - Active V2 reservations are surfaced as melee pressure for legacy crowd-spacing reads so a committed migrated attack cannot be shoved out of its admitted window.
  - Added telemetry for V2 threat requested/admitted/delayed/released and `PressureDirectorSmoke` coverage for overlapping windups, spaced impacts, perilous safety, legacy compatibility, and canonical Swordsman integration.
  - PR #152 immediately precedes this package: reusable controlled-cadence EnemyBrain on the Swordsman, 10/10 workflows green.
recent_batches:
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
  - Guard behavior is enemy-authored; no universal Health-through-guard ratio is required.
  - Corrupted Swordsman now owns EnemyCombatResponseRuntime + CombatActionRunner + EnemyMotor + EnemyBrain and uses PressureDirectorV2 for normal attack/counter admission.
  - PressureDirectorV2 schedules danger, not enemy intent: overlapping approach/windup is allowed when predicted impact windows remain fair.
  - Non-migrated enemies remain on legacy AttackDirector roles/tokens until individually migrated; do not globally raise the old melee token cap as a substitute for V2 pressure scheduling.
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
  - globally increasing enemy counts or reducing Health before shared enemy migrations and pressure foundations are coherent
  - rewriting working Player combo content instead of isolating locomotion/action-motion ownership
  - bypassing CombatActionRunner/EnemyMotor/EnemyBrain/PressureDirectorV2 with new parallel Swordsman-only state
  - globally raising `max_melee_attackers` as a shortcut around PressureDirectorV2
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
- Legacy AttackDirector remains the compatibility path for non-migrated enemies during phased conversion.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests. User has explicitly requested continued implementation without waiting for intermediate manual playtests during the current Combat V2 migration; use deterministic CI/telemetry gates between bounded packages.
