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
updated_utc: 2026-09-13T20:05:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 177
  feature_head: 402528764bda6458f81cec54003d410fd871d6bd
  merge_commit: 81a7db3b396d1530c92d159e0ffa47e0f1dee6ec
  validation: >-
    PR #177 exact head passed Hushiro Combat Contract Gate, Godot 4.7.2 Project Check,
    Hushiro Combat Semantics, Hushiro Combat Regression, Run Region Handoff,
    RunScene Runtime Lifetime, Post-playtest Stability, Authored Presentation Content,
    Region Transition Presentation, and Blood Cavern Execution Trial. The hard gate now
    reproduces the manual target-lifetime failure path: seed soft target -> free enemy ->
    run attack steering; no SCRIPT ERROR or stale typed bind is allowed.
active_branch: null
active_pr: null
covered_through_substantive_commit: 81a7db3b396d1530c92d159e0ffa47e0f1dee6ec
known_good_checkpoint: 81a7db3b396d1530c92d159e0ffa47e0f1dee6ec
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
    `_v2_soft_target_viable`, causing repeated physics-frame SCRIPT ERRORs at old line 52.
    The debugger accumulated hundreds of errors and the run became severely laggy.
  crash_fix: >-
    PR #177 keeps the stored soft-target reference as Variant until lifetime/type
    validation succeeds through `_v2_resolve_soft_target`; steering/acquisition/facing/
    telemetry/public reads all use that boundary. Target range, aim cone, scoring,
    attack timing, and movement semantics are unchanged.
  posture_evidence: >-
    Base no-Aspect Tier-0 ordinary hits are overfilling enemy Posture relative to the
    intended HP-removal cadence. Hollow max Posture=40. Telemetry recorded Cross Cut
    16 Posture followed by Heavy Cleave authored 36 (24 actual cap) entering break at
    40 while the Hollow still had 7 HP; another fresh Hollow took 36/40 Posture from
    one Heavy while retaining 19 HP. This supports reducing ordinary base-katana
    unguarded Posture pressure rather than raising enemy HP or changing Deathblow logic.
current_objective: >-
  Preserve player-paced Area 1 hack-and-slash Health durability while using the returned
  manual telemetry to correct ordinary base-katana Posture pacing. Health, Posture, and
  Poise remain separate. Parry/guard interaction should remain the tactical fast Posture
  route; normal clean katana hits should normally kill standard enemies through HP before
  independently forcing a fresh Posture break.
next_action: >-
  From updated main, make one evidence-backed Posture PR for pre-awakening/no-Aspect Tier-0
  basic katana only. Preserve Health 9/12/21 and existing block-posture values. Reduce
  unguarded `posture_damage`/`posture` for Quick/Cross/Heavy from 10/16/36 to 6/9/18 so
  the first clean phrase totals 33 Posture (< Hollow 40) while its 42 Health still kills
  Hollow on hit three. This also keeps clean HP removal ahead of self-generated Posture
  break for Hound/Archer/Swordsman/Bilemass/Warden baselines. Do not tune Aspects, held
  Thrust, enemy max Posture, Deathblow arming, HP, Poise, PressureDirector, or encounter
  population without further evidence. Add a deterministic contract protecting this
  Health-vs-Posture relationship and run exact-head CI.
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
- Base katana Health damage: Quick 9 -> Cross 12 -> Heavy 21; six-hit string = 84.
- Six-hit string is player capability, not standard enemy durability.
- Hollow 40 HP (~3 clean hits).
- Hound 50 HP (~4).
- Archer 45 HP (~4).
- Swordsman 60 HP (5; an authored guard may force six).
- Bilemass 60 HP (~5).
- Warden 140 HP (~11; deliberate durable/control exception).
- Difficulty should emerge primarily from compositions, overlapping intentions, movement,
  target priority, geometry, hazards, authored defense, and waves rather than HP sponges.
- Immediate clear -> next wave; varied burst/staggered/sequence arrivals; 120s anti-stall fallback.

## RECENT_MERGES
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
Request manual playtest only when a meaningful runtime gate is ready. Provide exact merged main/head,
coherent systems to exercise, and request the matching Godot `.log` plus `combat_*.jsonl`.