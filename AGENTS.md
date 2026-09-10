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
updated_utc: 2026-09-10T22:10:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 148
  feature_head: 89c5bef1a63b2f05a11870d6872a33b94a100a9a
  merge_commit: 792a953c16d8adb703d677780255db0f15ef3c7e
  validation: 6/6 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Authored Presentation Content, Region Transition Presentation, Run Region Handoff, Post-playtest Stability, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: 792a953c16d8adb703d677780255db0f15ef3c7e
known_good_checkpoint: 792a953c16d8adb703d677780255db0f15ef3c7e
current_objective: >-
  Combat V2 direction is approved and now refined around an enemy-specific defense/response model. Health damage, posture/stagger pressure, flinch, interruption, knockback, guard conversion, and poise are independent authoring axes. Enemy guard behavior and guard damage conversion are not universal formulas: shield users, swordsmen, fodder, beasts, and elites may have materially different Health-through-guard, posture/stagger, poise, timing, and recovery behavior. Deathblows remain high-value break/finisher payoffs rather than mandatory ordinary-enemy endpoints. Existing V1 runtime remains operative until explicit V2 packages migrate these rules.
next_action: >-
  Continue V2 design from `docs/overview/V2_COMBAT_DIRECTION.md` as needed. If implementation is requested, first do a bounded player/action feel audit to preserve already-working combo/action mechanics, then prototype one reference enemy response package (prefer Corrupted Swordsman) with authored Health response, short intentional guard behavior, posture/stagger pressure, flinch/interrupt rules, poise, and recovery. Do not globally force one HP-through-block percentage, posture multiplier, poise threshold, or recovery rule. Use the reference enemy playtest to decide how much Player Motor V2 work is actually required before broad migration. Pressure Director V2 and encounter-count retuning follow only after the actor-response model feels coherent.
current_batch:
  - PR #148 merged at 792a953c16d8adb703d677780255db0f15ef3c7e from exact head 89c5bef1a63b2f05a11870d6872a33b94a100a9a; all 6 triggered workflows green.
  - PR #148 is documentation/design-only; no Godot runtime behavior, balance values, enemy stats, or Aspect capabilities changed.
  - `docs/overview/V2_COMBAT_DIRECTION.md` now explicitly separates Health damage, posture/stagger pressure, flinch/interruption, knockback, guard conversion, and poise instead of treating them as one universal exchange.
  - Poise/Armor is a V2 reaction/interrupt concept, not automatic Health mitigation: an enemy may take full Health damage while resisting flinch or action interruption.
  - Enemy guard is split into an authored guard profile (Health multiplier, posture/stagger multiplier, bypass/break rules, coverage, etc.) and authored guard behavior (frequency, duration, cooldown, tactical conditions, exit conditions).
  - A rare/brief block that negates 100% Health damage is explicitly valid when it does not stall the fight and still creates meaningful posture/stagger progress.
  - Conceptual examples are intentionally asymmetric: shield bearers may negate most/all frontal HP while guarding; swordsmen may leak some HP through shorter guard windows; beasts/fodder often do not block; elite martial enemies may have rare authored deflects.
  - Ordinary enemies should remain killable through Health damage without requiring posture break. Posture/stagger creates control and finisher opportunities; Deathblow is an optional/high-value payoff and can become more central for dedicated finisher builds.
  - Enemy posture/stagger recovery may vary by role rather than using one universal rule; exact numbers remain open.
  - V2 implementation order now prioritizes a player/action feel audit and reference enemy response package before rewriting working player combo systems or globally retuning encounter populations.
recent_batches:
  - pr_148: refined V2 defense, guard, Health/posture, poise, break, and Deathblow direction; 6/6 workflows green; documentation/design only.
  - pr_147: recorded approved Combat V2 hunter direction; 6/6 triggered workflows green; documentation/design only.
  - pr_146: synchronized top-level implementation-status documentation; 6/6 triggered workflows green; no gameplay changes.
  - pr_143: added phase-driven shared enemy attack cue; synchronized Pilgrim/Shogun attack state; stopped blocked high-speed lunges from skating; fixed Timeless Zone viewport overlay; 10/10 workflows green; September 10 replay machine-validates runtime state/motion/lifetime behavior.
  - pr_141: fixed player-vs-enemy physical authority so stationary enemies/bosses are not dragged by Akio; repaired Eternal Swordsman activation/engagement; manually confirmed anti-drag behavior.
confirmed:
  - Combat V2 transition direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; current V1 gameplay authorities/runtime remain operative until explicit package-by-package migration.
  - Oathbound remains Japanese supernatural dark fantasy, with Akio framed more as an aggressive supernatural hunter than a formal duelist.
  - Standard V2 combat should create visible Health progress and faster ordinary-enemy kills while preserving posture/stagger, parry, and Deathblow as optional tactical layers.
  - Health, posture/stagger, and poise are not mirror resources: Health governs defeat, posture/stagger governs break/control opportunity, and poise governs immediate flinch/interruption behavior.
  - Guard does not require one universal HP/posture conversion. Enemy-specific defensive identity is now an explicit V2 authoring principle.
  - A shield user's strong 0-HP block and a swordsman's partial-damage guard can both be valid if their frequency, duration, stagger pressure, and counterplay fit their roles.
  - Taking Health damage and being interrupted are not assumed to be the same event in V2.
  - Enemy posture/stagger recovery does not need one universal cadence; multi-target combat should not force Sekiro-style continuous pressure on every target.
  - Aspect-specific block/parry/defensive capability ownership remains undecided. No current Aspect loses a shared mechanic until a later explicit capability pass.
  - Substantive gameplay implementation remains current through PR #143; PR #148 is the latest substantive design-direction refinement.
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
  - rewriting the working player combo/action foundation before a player/action feel audit identifies a V2 blocker
  - one universal enemy Health-through-guard percentage or posture/poise formula
  - removing or replacing block/parry on an Aspect before the dedicated V2 capability pass
  - globally increasing enemy counts or lowering Health/stagger values before the V2 response/pressure foundations exist
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
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; Combat V2 transition -> `docs/overview/V2_COMBAT_DIRECTION.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
