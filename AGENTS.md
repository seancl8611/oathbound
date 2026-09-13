# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V9: compact durable bootstrap/state + turn-survival protocol; GitHub is authority -->

Repository state is authority; conversation/project memory is cache only.

## BOOT
1. Fresh session: fetch `main:AGENTS.md` first.
2. If `active_branch` is set, fetch only that HEAD.
3. If HEAD matches `covered_through_substantive_commit`, continue `next_action`; otherwise inspect only the uncovered range/files.
4. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

## AUTONOMOUS_PR_POLICY
- Routine coherent PR merge approval is not required.
- Coherent + mergeable + required exact-head validation green => merge autonomously.
- Diagnose failed CI instead of asking.
- Branch subsequent work from updated `main`; never continue an old feature branch.

## TURN_SURVIVAL_POLICY
- After every merged PR or major durable milestone, update `AGENTS.md`, then continue if evidence-backed work remains.
- Minimize CI polling; inspect the targeted failed/incomplete workflow.

## LIVE_STATE
```yaml
schema: 9
updated_utc: 2026-09-13T20:15:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 179
  feature_head: 3d6c8e8329347c6d8133effa89a589b58c58b389
  merge_commit: 6c9c5b45372517e49166850050ad80dcc3fa69b8
  validation: >-
    Exact PR #179 head passed Hushiro Combat Contract Gate, Godot 4.7.2 Project Check,
    Hushiro Combat Semantics, Hushiro Combat Regression, Run Region Handoff,
    RunScene Runtime Lifetime, Post-playtest Stability, Authored Presentation Content,
    and Region Transition Presentation. The player-paced hard gate now protects both the
    PR #177 freed-soft-target lifetime regression and the telemetry-backed base-katana
    Health-before-fresh-Posture-break contract for every current Area 1 enemy baseline.
active_branch: null
active_pr: null
covered_through_substantive_commit: 6c9c5b45372517e49166850050ad80dcc3fa69b8
known_good_checkpoint: 6c9c5b45372517e49166850050ad80dcc3fa69b8
frozen_playtest:
  branch: playtest/area1-hack-and-slash-2026-09-12
  head: 824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a
  immutable: true
manual_playtest_2026_09_13:
  tested_main: 7b93ef1a113b5896f6426d6de039c7d6f9aa0acc
  godot_log: godot(20260913-194339).log
  telemetry: combat_1789328514.jsonl
  confirmed_crash: >-
    OathboundPlayerTargeting.gd passed a previously freed stored Node2D into typed
    `_v2_soft_target_viable`, causing repeated physics-frame SCRIPT ERRORs and severe
    debugger spam/lag before the run stopped.
  crash_fix: >-
    PR #177 keeps the stored soft-target reference as Variant until lifetime/type
    validation succeeds through `_v2_resolve_soft_target`; steering, acquisition,
    facing, telemetry, clearing, and public reads share that boundary. Target range,
    aim cone, scoring, attack timing, and movement semantics are unchanged.
  posture_evidence: >-
    Hollow max Posture=40. Telemetry recorded Cross Cut adding 16 Posture then Heavy
    Cleave reaching break while the Hollow still had 7 HP; another fresh Hollow took
    36/40 Posture from one Heavy while retaining 19 HP. Ordinary clean base-katana
    strikes were therefore opening Deathblow readiness before intended HP removal.
  posture_fix: >-
    PR #179 changes only no-Aspect Tier-0 ordinary basic unguarded Posture pressure:
    Quick/Cross/Heavy 10/16/36 -> 6/9/18. Health remains 9/12/21 and block-Posture
    remains 10/16/36. Held Thrust, dash, counter, Blood Aspects, enemy max Posture,
    Posture recovery/break rules, Deathblow mechanics, Poise, PressureDirector, and
    encounters remain unchanged.
current_objective: >-
  Retest the updated merged main after the September manual-playtest fixes. Confirm the
  soft-target lifetime crash/debugger spam is gone and ordinary base-katana attacks no
  longer make fresh standard enemies Deathblow-ready before their intended HP kill
  cadence, while parry/guard-driven Posture play remains useful.
next_action: >-
  Manual-test current merged main after this checkpoint merges and return the matching
  Godot `.log` plus `combat_*.jsonl`. Exercise multi-enemy basic strings and target
  handoff, especially killing a target mid-string, and watch whether the previous lag /
  freed-target SCRIPT ERROR returns. Also compare ordinary attack Posture/Deathblow
  pacing against the prior run. Do not make further numerical Posture, HP, Poise,
  PressureDirector, or encounter tuning without new playtest evidence.
```

## CURRENT AUTHORITIES
- Combat V2 direction: `docs/overview/V2_COMBAT_DIRECTION.md`.
- Combat V2 implementation: `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
- Project root: `game/oathbound/`; engine Godot 4.7.2.
- Canonical Player: `res://Player/aspect_player.tscn` -> `res://Player/OathboundCombatPlayer.gd`.
- Canonical AttackEvent only; no parallel Health/Posture damage pass.
- Player attack motion: CombatActionRunner + PlayerMotor via `OathboundPlayerMotion.gd`.
- Player basic soft targeting: `OathboundPlayerTargeting.gd`; explicit player redirection wins; no sticky lock-on.
- All six standard Hushiro families use shared V2 action/motor/brain/pressure seams while preserving species-specific contact authoring.
- PressureDirectorV2 schedules dangerous predicted impact timing, not all enemy intent.
- Direct close-frontline cue: PressureDirectorV2 `impact_at`, final 0.20s warning, final 0.12s parry beat.
- Archer final defense cue: projectile-local geometry/ETA after launch.
- Bilemass warning: spatial landing language through full remaining vomit+travel timeline; never parry language.
- Enemy PostureBar remains canonical player-facing Posture/Deathblow-readiness feedback.
- Health governs defeat; Posture/Stagger governs break/control opportunity; Poise governs immediate interruption.
- Taking Health damage does not inherently cancel committed actions; Poise owns interruption.
- Frozen playtest branches are immutable comparison artifacts.

## AREA_1_TARGETS
- Base katana Health: Quick 9 -> Cross 12 -> Heavy 21; six-hit string = 84.
- Base no-Aspect Tier-0 ordinary unguarded Posture: Quick 6 -> Cross 9 -> Heavy 18.
- Base no-Aspect Tier-0 basic block-Posture remains Quick 10 -> Cross 16 -> Heavy 36.
- Six-hit string is player capability, not standard enemy durability.
- Hollow: 40 HP / 40 Posture; clean Q+C+H = 42 HP and 33 Posture, so HP removal wins first.
- Hound: 50 HP / 45 Posture; clean 4-hit HP removal reaches 51 HP damage at 39 Posture.
- Archer: 45 HP / 65 Posture; clean 4-hit HP removal reaches 51 HP damage at 39 Posture.
- Swordsman: 60 HP / 90 Posture; clean 5-hit HP removal reaches 63 HP damage at 48 Posture; authored guard may force hit six.
- Bilemass: 60 HP / 70 Posture; clean 5-hit HP removal reaches 63 HP damage at 48 Posture.
- Warden: 140 HP / 150 Posture; clean 11-hit HP removal reaches 147 HP damage at 114 Posture; deliberate durable/control exception.
- The above Posture comparison assumes zero Posture recovery, so live recovery only increases the margin.
- Difficulty should emerge primarily from compositions, overlapping intentions, movement, target priority, geometry, hazards, authored defense, and waves rather than HP sponges.
- Immediate clear -> next wave; varied burst/staggered/sequence arrivals; 120s anti-stall fallback.

## RECENT_MERGES
- PR #179: telemetry-backed base-katana ordinary Posture 6/9/18; Health and block-Posture preserved; deterministic HP-before-fresh-Posture contract; 9 exact-head workflows green.
- PR #178: durable checkpoint of September 13 playtest crash/Posture evidence.
- PR #177: freed soft-target lifetime crash fix + exact regression; 10 exact-head workflows green.
- PR #176: checkpoint after deterministic defense validation.
- PR #175: deterministic Hushiro floating-damage-number smoke isolation; production manager unchanged.
- PR #173: Bilemass landing readability synchronized to actual landing timeline.
- PR #171: flight-local Corrupted Archer defensive readability.
- PR #169: direct V2 pre-contact cue authority.
- PR #166: player-paced durability, six-hit pressure continuation, directional target handoff.
- PR #165: player-paced Area 1 wave/pressure baseline.
- PR #159..154: standard-enemy V2 migrations + PlayerMotor/CombatActionRunner foundation.

## ENGINEERING_GUARDS
- Clean Godot import/editor compile before manual playtest; combat changes require telemetry-aware validation.
- Explicitly type Variant-derived locals only after validity/type checks when object lifetime can change.
- Defer physics registration mutations during active contact traversal.
- Preserve canonical Player/AttackEvent ownership.
- Do not suppress/remove PostureBar without approved replacement.
- Do not raise common Area 1 HP merely to make lone enemies threatening.
- Do not globally buff Player Health damage when enemy pressure/durability is the intended axis.
- Do not turn target handoff into sticky auto-lock or override explicit aim.
- Do not use one universal enemy guard/Poise formula.
- Do not remove block/parry from an Aspect before the dedicated capability pass.
- Do not globally multiply encounters or change PressureDirector spacing without evidence.
- Do not force projectile/hazard threats through the direct-melee cue contract.
- Do not invent Heart combat.
- Combat CI must fail hard on missing PASS markers or Godot runtime SCRIPT ERRORs.
- Prefer deterministic state/boundary assertions over sub-second sleeps when time itself is not the contract.

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge -> updated main -> AGENTS checkpoint -> continue while evidence-backed work remains`

## PLAYTEST_HANDOFF
Request manual playtest only when a meaningful runtime gate is ready. Test the current merged main unless an immutable comparison snapshot is specifically required. Provide the merged checkpoint SHA, coherent systems to exercise, and request the matching Godot `.log` plus `combat_*.jsonl`.