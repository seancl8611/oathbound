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
updated_utc: 2026-09-11T00:32:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 149
  feature_head: d4cb53168c4c2febe4e8ea3ebf595711b0388b2d
  merge_commit: c80aca2560ddb1f01a1fdc9e4eaefaf9b0c97cc4
  validation: 10/10 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Hushiro Combat Regression, Godot 4.7.2 Project Check, Release Shell, Blood Cavern Execution Trial, Run Region Handoff, Authored Presentation Content, Post-playtest Stability, RunScene Runtime Lifetime, and Region Transition Presentation
active_branch: null
active_pr: null
covered_through_substantive_commit: c80aca2560ddb1f01a1fdc9e4eaefaf9b0c97cc4
known_good_checkpoint: c80aca2560ddb1f01a1fdc9e4eaefaf9b0c97cc4
current_objective: >-
  Combat V2 Phase 1 reference-enemy response is now integrated for the Corrupted Swordsman. The game has a reusable `EnemyCombatResponseProfile` + `EnemyCombatResponseRuntime` boundary that keeps Health damage, Posture/Stagger pressure, guard conversion, and immediate Poise interruption separate while preserving the canonical AttackEvent/CombatController mutation path. Swordsman guard is now a finite authored window with cooldown and partial Health-through-guard; weak hits can damage a committed Swordsman without automatically cancelling the attack, while stronger Poise impacts can interrupt commitment or break guard. Current Player action/motion architecture, Swordsman attack execution/HFSM, and AttackDirector remain V1/legacy until later bounded migration packages.
next_action: >-
  Manually feel-test the merged Corrupted Swordsman V2 response slice on `main`: first one isolated Swordsman, then Swordsman + Hound and Swordsman + Archer. Confirm short/legible guard windows, visible Health progress through guard, light-hit neutral interruption, Health-without-cancel during committed attacks, stronger interruption/guard break, and intact parry/Posture/Deathblow behavior. Return CombatTelemetry/log evidence if anything feels wrong. If the response model feels coherent, the next CI-heavy implementation package is Phase 2: introduce the reusable `CombatActionRunner` + `EnemyMotor` around the Swordsman while initially preserving its current authored attacks. Do not jump directly to PressureDirectorV2, global encounter-count/Health retuning, Player rewrite, or broad enemy migration.
current_batch:
  - PR #149 merged at c80aca2560ddb1f01a1fdc9e4eaefaf9b0c97cc4 from exact head d4cb53168c4c2febe4e8ea3ebf595711b0388b2d; all 10 triggered workflows green.
  - Added `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md` as the concrete migration/component authority beneath `docs/overview/V2_COMBAT_DIRECTION.md`.
  - Added `Core/Combat/EnemyCombatResponseProfile.gd` and `EnemyCombatResponseRuntime.gd`; response policy/timing is now compositional and does not create a second Health/Posture mutation pass.
  - Corrupted Swordsman is the first V2 reference slice: guard duration 0.34s, guard cooldown 1.15s, guard-break cooldown 1.65s, guard range 95px, and 35% Health-through-guard are initial playtest values rather than global rules.
  - Canonical incoming `block_posture_damage` remains authoritative during guard; the response profile does not multiply that value in this first slice.
  - Poise migration currently reads explicit `poise_damage` when present and otherwise bridges canonical `stagger_level` to power (`level + 1`); neutral Swordsman requires power 1 to interrupt, committed offense/guard break require power 2.
  - Guarded Health feedback is clamped to actual HP removed, including overkill, and existing target+damage-type damage-number presentation cooldown remains unchanged.
  - Updated Hushiro defense/readability regression contracts and added `EnemyCombatResponseSmoke`; tests prove finite guard timing/cooldown, partial guarded Health, canonical single-pass Posture, neutral-vs-committed Poise behavior, guard break, and exact HP number semantics.
  - One CI failure during development was traced to the existing 0.1s DamageNumberManager target+type presentation cooldown between two independent test assertions; the test now spaces those assertions beyond the UI-only cooldown rather than altering gameplay.
  - No Player combo/action rewrite, EnemyMotor/EnemyBrain migration, PressureDirectorV2, global enemy-count/Health retune, stamina system, boss redesign, or Aspect capability removal was included.
recent_batches:
  - pr_149: implemented first Combat V2 reference-enemy response slice for Corrupted Swordsman; documented implementation blueprint; finite guard + partial Health + state Poise; 10/10 workflows green.
  - pr_148: refined V2 defense, guard, Health/posture, poise, break, and Deathblow direction; 6/6 workflows green; documentation/design only.
  - pr_147: recorded approved Combat V2 hunter direction; 6/6 triggered workflows green; documentation/design only.
  - pr_146: synchronized top-level implementation-status documentation; 6/6 triggered workflows green; no gameplay changes.
  - pr_143: added phase-driven shared enemy attack cue; synchronized Pilgrim/Shogun attack state; stopped blocked high-speed lunges from skating; fixed Timeless Zone viewport overlay; 10/10 workflows green; September 10 replay machine-validates runtime state/motion/lifetime behavior.
confirmed:
  - Combat V2 transition direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; concrete migration/component order is now in `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
  - PR #149 is the first explicit V2 gameplay migration package; current V1 gameplay authorities remain operative outside the bounded Corrupted Swordsman response seam.
  - Oathbound remains Japanese supernatural dark fantasy in current repository authority, with Akio framed more as an aggressive supernatural hunter than a formal duelist; broader theme changes discussed outside the repo require a dedicated authority update before implementation.
  - Standard V2 combat should create visible Health progress and faster ordinary-enemy kills while preserving posture/stagger, parry, and Deathblow as optional tactical layers.
  - Health, posture/stagger, and poise are not mirror resources: Health governs defeat, posture/stagger governs break/control opportunity, and poise governs immediate flinch/interruption behavior.
  - Guard does not require one universal HP/posture conversion. Enemy-specific defensive identity is an explicit V2 authoring principle.
  - A shield user's strong 0-HP block and a swordsman's partial-damage guard can both be valid if their frequency, duration, stagger pressure, and counterplay fit their roles.
  - Taking Health damage and being interrupted are not assumed to be the same event in V2; PR #149 now proves that distinction on committed Corrupted Swordsman offense.
  - Enemy posture/stagger recovery does not need one universal cadence; multi-target combat should not force Sekiro-style continuous pressure on every target.
  - Aspect-specific block/parry/defensive capability ownership remains undecided. No current Aspect loses a shared mechanic until a later explicit capability pass.
  - Substantive gameplay implementation is current through PR #149 merge c80aca2560ddb1f01a1fdc9e4eaefaf9b0c97cc4.
  - The broad Godot documentation-to-code delta audit is executed/closed. Do not make another broad audit a prerequisite for ordinary work.
  - Heart combat remains unauthored by design authority; the existing Heart shell/handoff and downstream Story Complete/postgame behavior are structural/contract-test surfaces, not permission to invent a real Heart kill path.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed; September 10 replay confirms prior lifetime/deferred/CollisionObject crash class remains clean and supports PR #143 state/motion repairs.
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
  - one universal enemy Health-through-guard percentage or posture/poise formula
  - removing or replacing block/parry on an Aspect before the dedicated V2 capability pass
  - globally increasing enemy counts or lowering Health/stagger values before the V2 response/pressure foundations exist
  - implementing PressureDirectorV2 before the reference response and Swordsman ActionRunner/EnemyMotor slices are coherent
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
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 high-level direction -> `docs/overview/V2_COMBAT_DIRECTION.md`; Combat V2 migration/components -> `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
