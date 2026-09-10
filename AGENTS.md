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
updated_utc: 2026-09-10T21:32:22Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 147
  feature_head: 59b587eb1b0b7868ab89ec62d6c291235896041b
  merge_commit: f542701660533afc55187cd517f86cccdd440308
  validation: 6/6 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Authored Presentation Content, Region Transition Presentation, Run Region Handoff, Post-playtest Stability, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: f542701660533afc55187cd517f86cccdd440308
known_good_checkpoint: f542701660533afc55187cd517f86cccdd440308
current_objective: >-
  Combat V2 direction is now approved and durable. PR #147 keeps Oathbound's Japanese supernatural setting while shifting the dominant combat fantasy from formal samurai dueling toward Akio as an aggressive supernatural hunter. The V2 target is free-flow player movement, more numerous but individually weaker/staggerable standard enemies, purposeful multi-enemy pressure, stronger attack interruption/stagger feedback, selective high-value parry/posture use, predator-like beast/spirit behavior, and action-roguelite boss phase design. Existing V1 gameplay authorities/runtime remain operative until each V2 package is explicitly migrated.
next_action: >-
  Continue V2 design/brainstorming from `docs/overview/V2_COMBAT_DIRECTION.md` as needed. When implementation is requested, do not begin with global enemy-count/Health/damage/parry tuning. Start with a bounded Player Motor V2 package: fetch the V2 direction plus exact current player/control authorities and runtime files, preserve public combat contracts, implement freer vector locomotion plus authored action-motion contribution/steering, instrument telemetry, validate in Playtest Lab, and only then proceed toward Combat Action/Intent, one reference enemy migration, Pressure Director V2, encounter retuning, boss V2, and the later Aspect capability pass. Do not remove block/parry from any Aspect before that dedicated capability decision.
current_batch:
  - PR #147 merged at f542701660533afc55187cd517f86cccdd440308 from exact head 59b587eb1b0b7868ab89ec62d6c291235896041b; all 6 triggered workflows green.
  - PR #147 is documentation/design-direction only; it changes no Godot runtime, balance values, current encounter counts, or current Aspect capabilities.
  - Added `docs/overview/V2_COMBAT_DIRECTION.md` as the approved authority for the Combat V2 transition direction and registered it in `docs/_meta/SOURCE_OF_TRUTH.md`.
  - Combat V2 keeps the Japanese setting, characters, architecture, weapons, folklore, Beast Blood, Blood Moon, samurai-derived visual language, and existing broader run/build/campaign systems while shifting normal combat toward a supernatural-hunter fantasy.
  - Locked V2 direction includes free-flow locomotion, authored movement/steering per action, clearer fodder/standard/elite/boss tiers, easier ordinary-enemy stagger/interrupt/kill, higher readable room pressure, deliberate AI decision cadence, threat/impact scheduling rather than single-attacker whole-turn ownership, predator-like beast/spirit behavior, and bosses whose phase transitions change the spatial/combat problem.
  - Parry remains a valuable aggressive defensive option, especially for posture/counters/elites/bosses, but should not be the default mandatory answer to every standard enemy. Sustained block is deemphasized as the preferred universal play pattern.
  - Aspect-dependent ownership of mechanics such as block, parry, defensive transitions, and stagger/poise behavior is explicitly OPEN for a later V2 capability pass. Current V1 universal block/parry contracts remain operative until that pass updates the owning authorities.
  - Added `docs/_meta/decisions/2026-09-10-combat-v2-hunter-direction.md` as durable decision history.
recent_batches:
  - pr_147: recorded approved Combat V2 hunter direction; 6/6 triggered workflows green; documentation/design only.
  - pr_146: synchronized top-level implementation-status documentation; 6/6 triggered workflows green; no gameplay changes.
  - pr_143: added phase-driven shared enemy attack cue; synchronized Pilgrim/Shogun attack state; stopped blocked high-speed lunges from skating; fixed Timeless Zone viewport overlay; 10/10 workflows green; September 10 replay machine-validates runtime state/motion/lifetime behavior.
  - pr_141: fixed player-vs-enemy physical authority so stationary enemies/bosses are not dragged by Akio; repaired Eternal Swordsman activation/engagement; manually confirmed anti-drag behavior.
  - pr_140: hardened live enemy temporary-object lifetimes and preserved Kagutsuchi boss scene ownership.
confirmed:
  - Combat V2 transition direction is approved in `docs/overview/V2_COMBAT_DIRECTION.md`; current V1 gameplay authorities/runtime remain operative until explicit package-by-package migration.
  - Oathbound remains Japanese supernatural dark fantasy. The redesign changes the dominant combat fantasy and pacing, not the setting into a different cultural/theme package.
  - The V2 player fantasy is Akio as an aggressive supernatural hunter who keeps momentum through readable groups of corrupted warriors, spirits, monsters, and beasts rather than treating standard rooms as serial formal duels.
  - Standard V2 encounter direction is more active enemies with lower individual durability/stagger resistance where readable; difficulty should come more from combinations, positioning, geometry, and overlapping intentions than from every normal enemy being a miniature posture duel.
  - V2 architecture should support per-action movement/steering, formal stagger/interrupt rules, deliberate enemy intent, and threat/impact scheduling before broad numerical encounter retuning.
  - Aspect-specific block/parry/defensive capability ownership is not decided. No current Aspect loses a shared mechanic until a later explicit design pass.
  - Substantive gameplay implementation remains current through PR #143; PR #147 is the latest substantive design-direction change.
  - The broad Godot documentation-to-code delta audit is executed/closed. Do not make another broad audit a prerequisite for ordinary work.
  - Heart combat remains unauthored by design authority; the existing Heart shell/handoff and downstream Story Complete/postgame behavior are structural/contract-test surfaces, not permission to invent a real Heart kill path.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed; September 10 replay confirms prior lifetime/deferred/CollisionObject crash class remains clean and supports PR #143 state/motion repairs.
  - Twin Maws and Eclipse Shogun produce attack/contact activity and can complete their encounters; do not treat either as generally inert.
  - Direct Playtest Lab Area 2/3 warps are intentional. Playtest Power defaults to 1x; Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - FIRST_ATTEMPT begins directly in the normal Hushiro route; first death awakens Returning Blood and reconstructs at The Strand.
  - Techniques are slotless/unlimited outside the five direct action slots as defined by current authorities.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
  - PR #131 procedural FX are temporary debug/playtest presentation, not final authored art.
  - Current approved Wraith V1 authority is the long-reach frontal posture/control Aspect; do not silently replace it with older Crimson/backstab notes. Future V2 Aspect changes require an explicit capability/kit pass.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require captured state evidence before changing that system.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - unbounded whole-game combat rewrite instead of dependency-sized Combat V2 packages
  - removing or replacing block/parry on an Aspect before the dedicated V2 capability pass
  - globally increasing enemy counts or lowering Health/stagger values before the V2 motor/action/pressure foundations exist
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
