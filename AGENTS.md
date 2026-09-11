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
updated_utc: 2026-09-11T02:31:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 151
  feature_head: d28a628b4edead16b3889e685d8052376e3880c5
  merge_commit: 2a83be47a12d3d2b0bb8efdcdfad0a75661f5bd2
  validation: 10/10 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Release Shell, Blood Cavern Execution Trial, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation
active_branch: null
active_pr: null
covered_through_substantive_commit: 2a83be47a12d3d2b0bb8efdcdfad0a75661f5bd2
known_good_checkpoint: 2a83be47a12d3d2b0bb8efdcdfad0a75661f5bd2
current_objective: >-
  Combat V2 Phase 2 is integrated for the Corrupted Swordsman reference enemy. The canonical Swordsman scene now routes through `CorruptedSwordsmanV2Motion.gd`, which attaches reusable `CombatActionRunner` and `EnemyMotor` components while preserving the existing authored attack coroutines, canonical AttackEvent/contact path, Health/Posture/parry/Deathblow behavior, finite V2 guard/poise response, and current AttackDirector ownership. Action execution now exposes STARTUP -> COMMITTED -> ACTIVE -> RECOVERY lifecycle state; early windup may retain locomotion and track Akio, late windup crosses an explicit commitment point and locks targeting, and authored attack displacement is composed through EnemyMotor instead of the legacy constant-speed lunge fields. The Swordsman's tactical HFSM/attack selection and room-level AttackDirector remain V1/legacy.
next_action: >-
  Manually feel-test the merged Phase 2 Swordsman on `main`: first one isolated Swordsman, then Swordsman + Hound and Swordsman + Archer. Confirm that approach/deceleration and attack entry feel less stop/start, early windup carries some motion and can still be interrupted, late windup visibly commits instead of homing, lateral movement can create fair whiffs after commitment, attack steps ease rather than burst at one constant speed, strong/weak poise distinctions still make sense, and the enemy PostureBar remains visible with normal Posture/Deathblow behavior. Return CombatTelemetry/log evidence from this larger integration pass. If Phase 2 feels coherent, the next CI-heavy package is Phase 3: migrate Swordsman tactical decisions to a controlled-cadence utility `EnemyBrain` while retaining the current ActionRunner/EnemyMotor and AttackDirector; do not jump directly to PressureDirectorV2 before that reference brain is coherent.
current_batch:
  - PR #151 merged at 2a83be47a12d3d2b0bb8efdcdfad0a75661f5bd2 from exact head d28a628b4edead16b3889e685d8052376e3880c5; all 10 triggered workflows green.
  - Added `Core/Combat/CombatActionDefinition.gd`, a data-only timing/motion-permission contract. It does not own hitboxes or damage and therefore does not create a second combat pipeline.
  - Added `Core/Combat/CombatActionRunner.gd` with explicit IDLE/STARTUP/COMMITTED/ACTIVE/RECOVERY phases, commitment/tracking queries, phase-specific locomotion weights, interruption/completion, and CombatTelemetry events.
  - Added `Core/Combat/EnemyMotor.gd`, which composes smoothed tactical locomotion + authored action motion + external impulse. The initial action-motion curve preserves approximately the authored legacy displacement while replacing constant-speed attack bursts with an eased step.
  - Added `Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Motion.gd` and routed the canonical Swordsman scene through it. The imported legacy HFSM remains the tactical-intent source for this phase, but its final pre-move virtual seam now lets EnemyMotor author the actual final velocity.
  - Early Swordsman startup keeps 66% locomotion and may refresh the player target snapshot; after each action's authored commitment fraction the snapshot locks, so late lateral movement can produce genuine whiffs instead of full homing. Committed and active phases sharply reduce free locomotion without forcing every windup frame to zero velocity.
  - Existing legacy lunge data is adapted into EnemyMotor action motion; `_lunge_dir/_lunge_speed/_lunge_until` are disabled on the migrated Swordsman so the old constant-speed lunge does not run in parallel.
  - Phase 2 now uses the ActionRunner's actual commitment phase for V2 poise interruption. Early startup is no longer automatically considered committed merely because `telegraphing` is true; late startup/active/recovery remain committed.
  - Added `Core/Combat/Validation/CombatActionMotorSmoke.gd` + scene and wired it into Hushiro Combat Semantics CI. It proves startup momentum, commitment target-lock semantics, authored action-motion composition, recovery locomotion policy, interruption cleanup, and real canonical Swordsman ActionRunner/EnemyMotor ownership.
  - Existing Hushiro defense, PostureBar readability, response semantics, combat lifecycle, project-wide integration, stability, and region handoff checks all remained green on the exact PR head.
  - No `EnemyBrain`, PressureDirectorV2, Player motor/action rewrite, global enemy-count/Health retune, stamina system, boss redesign, or Posture/Deathblow/UI removal was included.
recent_batches:
  - pr_151: integrated reusable CombatActionRunner + EnemyMotor for the canonical Corrupted Swordsman reference slice; preserved current attacks/combat pipeline; 10/10 triggered workflows green.
  - pr_150: restored/protected Hushiro PostureBar readability without changing posture/deathblow mechanics; added live-order regional synchronization runtime; 9/9 triggered workflows green.
  - pr_149: implemented first Combat V2 reference-enemy response slice for Corrupted Swordsman; documented implementation blueprint; finite guard + partial Health + state Poise; 10/10 workflows green.
  - pr_148: refined V2 defense, guard, Health/posture, poise, break, and Deathblow direction; 6/6 workflows green; documentation/design only.
  - pr_147: recorded approved Combat V2 hunter direction; 6/6 triggered workflows green; documentation/design only.
confirmed:
  - Combat V2 transition direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; concrete migration/component order is in `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
  - PR #149 established V2 response semantics, PR #150 repaired/protected Posture readability, and PR #151 establishes the first reusable action lifecycle and enemy-motion foundation on the Corrupted Swordsman.
  - The canonical Swordsman now owns `CombatActionRunner` + `EnemyMotor`; its attack selection/HFSM and room fairness still remain legacy until the dedicated EnemyBrain and PressureDirectorV2 phases.
  - Enemy PostureBar is still canonical player-facing feedback for Posture buildup and approaching Deathblow availability. It is not retired, optional, or implicitly replaceable by Combat V2 until a dedicated replacement is explicitly approved.
  - Posture/Deathblow mechanical state remained active in the September 10 live playtest even while the bar was missing; do not interpret missing UI as permission to change/remove the underlying system.
  - Oathbound remains Japanese supernatural dark fantasy in current repository authority, with Akio framed more as an aggressive supernatural hunter than a formal duelist; broader theme changes discussed outside the repo require a dedicated authority update before implementation.
  - Standard V2 combat should create visible Health progress and faster ordinary-enemy kills while preserving posture/stagger, parry, and Deathblow as optional tactical layers.
  - Health, posture/stagger, and poise are not mirror resources: Health governs defeat, posture/stagger governs break/control opportunity, and poise governs immediate flinch/interruption behavior.
  - Guard does not require one universal HP/posture conversion. Enemy-specific defensive identity is an explicit V2 authoring principle.
  - A shield user's strong 0-HP block and a swordsman's partial-damage guard can both be valid if their frequency, duration, stagger pressure, and counterplay fit their roles.
  - Taking Health damage and being interrupted are not assumed to be the same event in V2; PR #149 proves that distinction and PR #151 now evaluates Swordsman commitment from an explicit action phase.
  - Enemy posture/stagger recovery does not need one universal cadence; multi-target combat should not force Sekiro-style continuous pressure on every target.
  - Aspect-specific block/parry/defensive capability ownership remains undecided. No current Aspect loses a shared mechanic until a later explicit capability pass.
  - Substantive gameplay implementation is current through PR #151 merge 2a83be47a12d3d2b0bb8efdcdfad0a75661f5bd2.
  - The broad Godot documentation-to-code delta audit is executed/closed. Do not make another broad audit a prerequisite for ordinary work.
  - Heart combat remains unauthored by design authority; the existing Heart shell/handoff and downstream Story Complete/postgame behavior are structural/contract-test surfaces, not permission to invent a real Heart kill path.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed; September 10 replay confirms prior lifetime/deferred/CollisionObject crash class remains clean and supports later state/motion repairs.
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
  - implementing PressureDirectorV2 before the Swordsman ActionRunner/EnemyMotor and EnemyBrain reference slices are coherent
  - bypassing CombatActionRunner/EnemyMotor with new Swordsman-only motion state once the Phase 2 reference seam exists
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
- Corrupted Swordsman final motion is now mediated by CombatActionRunner + EnemyMotor; future Swordsman migration must preserve that seam rather than revive legacy constant-lunge ownership.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
