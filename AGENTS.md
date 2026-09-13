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
updated_utc: 2026-09-13T21:35:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 181
  feature_head: b57067cea9daa43fe100e01b95d4fa417fa34828
  merge_commit: 3b65224a7ea61060de86fd8e64c448e7300178a8
  validation: >-
    Exact PR #181 head passed Hushiro Combat Contract Gate, Godot 4.7.2 Project Check,
    Hushiro Combat Semantics, Hushiro Combat Regression, Run Region Handoff,
    RunScene Runtime Lifetime, Post-playtest Stability, Authored Presentation Content,
    and Region Transition Presentation. The response smoke and Hound/Warden migration
    smokes now protect the role-based Area 1 Poise ladder without changing Health,
    Posture, guard-break thresholds, PressureDirector spacing, or encounter tuning.
active_branch: null
active_pr: null
covered_through_substantive_commit: 3b65224a7ea61060de86fd8e64c448e7300178a8
known_good_checkpoint: 3b65224a7ea61060de86fd8e64c448e7300178a8
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
manual_playtest_2026_09_13_posture_retest:
  tested_main: 6c9c5b45372517e49166850050ad80dcc3fa69b8
  godot_log: godot(20260913-204954).log
  telemetry: combat_1789332106.jsonl
  runtime_result: >-
    No SCRIPT ERROR, ERROR, WARNING, or freed-soft-target recurrence was present in the
    matching Godot log. The prior target-lifetime crash/debugger spam was not reproduced.
  posture_result: >-
    Only one enemy Posture break occurred in the run. It was a Swordsman already at
    6 HP, and the same contact sequence immediately removed its remaining Health. The
    PR #179 base-katana reduction therefore moved ordinary Posture back toward a
    secondary break/control route instead of a routine standard-enemy kill route.
  poise_evidence: >-
    Hollow committed attacks were repeatedly cancelled by ordinary power-1 sword
    contacts. This supports the intended light-enemy hunter flow where squishy bodies
    are frequently interruptible. PR #181 locks the first role ladder: Hollow/Hound/
    Archer 1/1 neutral/committed; Swordsman/Bilemass 1/2; Warden 2/3. Warden guard-break
    Poise remains separately authored at 2.
  cleanup_evidence: >-
    Telemetry also showed duplicate `hushiro_enemy_contract_applied` events for Hollow
    spawns and 304 `enemy_v2_brain_intent_invalidated` events in about 38 seconds,
    predominantly repeated `deaggro` invalidations. Treat these as runtime/telemetry
    cleanup issues, not balance evidence.
current_objective: >-
  Preserve the now-validated role-based Poise baseline while cleaning two concrete
  runtime/telemetry issues from the same playtest: duplicate Hushiro enemy-contract
  application and repeated no-op deaggro intent invalidation churn.
next_action: >-
  First make Hushiro enemy-contract application idempotent at the shared authority and
  add deterministic coverage proving a repeated apply does not duplicate attached
  runtimes or telemetry-side setup. Preserve final HP/Posture/pressure metadata. Then
  address repeated EnemyBrain deaggro invalidation so a no-op invalidation does not
  repeatedly churn state/telemetry while actual deaggro behavior remains unchanged.
  Do not make further numerical Health/Posture/Poise/PressureDirector/encounter tuning
  until another playtest supplies new evidence.
```

## CURRENT AUTHORITIES
- Combat V2 direction: `docs/overview/V2_COMBAT_DIRECTION.md`.
- Combat V2 implementation: `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
- Area 1 role-based Poise: `docs/overview/V2_POISE_ROLE_TIERS.md`.
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
- Guard-break resistance remains separately authored from flinch/interruption Poise.
- Frozen playtest branches are immutable comparison artifacts.

## AREA_1_TARGETS
- Base katana Health: Quick 9 -> Cross 12 -> Heavy 21; six-hit string = 84.
- Base no-Aspect Tier-0 ordinary unguarded Posture: Quick 6 -> Cross 9 -> Heavy 18.
- Base no-Aspect Tier-0 basic block-Posture remains Quick 10 -> Cross 16 -> Heavy 36.
- Current Poise power bridge: ordinary Quick/Cross power 1; base Heavy-class impact power 2; explicit `poise_damage=3+` is the stronger future Technique/Prosthetic seam.
- Area 1 neutral/committed Poise requirements: Hollow 1/1; Hound 1/1; Archer 1/1; Swordsman 1/2; Bilemass 1/2; Warden 2/3.
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
- PR #181: telemetry-backed Area 1 role Poise tiers; Hound committed 1, Warden neutral/committed 2/3; guard-break/Health/Posture preserved; 9 exact-head workflows green.
- PR #180: durable checkpoint after PR #179 September playtest fixes.
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
- Preserve the role-based Area 1 Poise baseline unless new playtest evidence justifies a numerical change.
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