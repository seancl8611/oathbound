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
updated_utc: 2026-09-13T22:08:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 187
  feature_head: ab4ff6d4bff847d9c83e98e8237bf6c7dddf393c
  merge_commit: 21d889977064aa9becd48762effd215fb5f2dc8e
  validation: >-
    Exact PR #187 head passed Hushiro Combat Contract Gate, Godot 4.7.2 Project Check,
    Hushiro Combat Semantics, Hushiro Combat Regression, Run Region Handoff,
    RunScene Runtime Lifetime, Post-playtest Stability, Authored Presentation Content,
    and Region Transition Presentation. The new CombatTelemetryDiagnostics smoke passed
    inside Post-playtest Stability and the project import/editor load remained clean.
active_branch: null
active_pr: null
covered_through_substantive_commit: 21d889977064aa9becd48762effd215fb5f2dc8e
known_good_checkpoint: 21d889977064aa9becd48762effd215fb5f2dc8e
frozen_playtest:
  branch: playtest/area1-hack-and-slash-2026-09-12
  head: 824ef7b099f7fbffb3be72d8169a94c8ffd1eb8a
  immutable: true
latest_manual_playtest:
  tested_main: 6c9c5b45372517e49166850050ad80dcc3fa69b8
  godot_log: godot(20260913-204954).log
  telemetry: combat_1789332106.jsonl
  runtime_result: >-
    No SCRIPT ERROR, ERROR, WARNING, or freed-soft-target recurrence. The PR #177
    target-lifetime fix held during the retest.
  posture_result: >-
    Only one Posture break occurred; the Swordsman was already at 6 HP and died through
    Health in the same contact sequence. PR #179's no-Aspect ordinary Posture 6/9/18
    therefore restored Health-first standard-enemy pacing in this run.
  poise_result: >-
    Hollow committed attacks were repeatedly cancelled by ordinary power-1 sword hits.
    PR #181 locks the first Area 1 role baseline: Hollow/Hound/Archer 1/1 neutral/
    committed; Swordsman/Bilemass 1/2; Warden 2/3. Warden guard-break remains 2.
  cleanup_result: >-
    The run exposed duplicate Hollow `hushiro_enemy_contract_applied` events and 304
    `enemy_v2_brain_intent_invalidated` events in ~38s, mostly repeated deaggro. PR #183
    makes Hushiro contract install idempotent per actor/type/revision; PR #185 makes an
    already-idle/no-schedule EnemyBrain invalidation a no-op. PR #187 adds a debug-only
    end-of-session diagnostic summary so the next JSONL directly reports contract repeat
    cardinality, invalidation reasons/per-enemy concentration, Poise absorption profiles,
    and capture duration without changing gameplay.
current_objective: >-
  Manual-retest current merged main as one coherent gate: role-based Poise, Health-first
  ordinary kills, soft-target handoff stability, idempotent Hushiro contract setup, and
  reduced no-op brain invalidation telemetry. The evidence path is now self-summarizing
  at `session_end`; do not add speculative combat tuning before that run.
next_action: >-
  Manual-test current merged main after this checkpoint merges. Exercise multi-enemy
  basic strings and target handoff; deliberately attack Hollow/Hound/Archer during
  commitments; compare Swordsman/Bilemass committed resistance; test Warden light vs
  Heavy interruption if encountered. Return matching Godot `.log` + `combat_*.jsonl`.
  In the JSONL `session_end.diagnostics`, expect Hushiro contract
  `repeat_application_events=0` and `max_applications_per_enemy=1` during an ordinary
  run; compare brain invalidation total/deaggro/max-per-enemy against the old 304-event
  churn; use Poise absorption profile counts as supporting evidence for protected
  commitments. Confirm no freed-target SCRIPT ERROR. Do not make further numerical
  Health/Posture/Poise/PressureDirector/encounter tuning without new playtest evidence.
```

## CURRENT AUTHORITIES
- Combat V2 direction: `docs/overview/V2_COMBAT_DIRECTION.md`.
- Combat V2 implementation: `docs/overview/V2_COMBAT_IMPLEMENTATION_BLUEPRINT.md`.
- Area 1 role-based Poise: `docs/overview/V2_POISE_ROLE_TIERS.md`.
- Project root: `game/oathbound/`; engine Godot 4.7.2.
- Canonical Player: `res://Player/aspect_player.tscn` -> `res://Player/OathboundCombatPlayer.gd`.
- Canonical AttackEvent only; no parallel Health/Posture damage pass.
- Health governs defeat; Posture/Stagger governs longer-horizon break/control; Poise governs immediate flinch/interruption.
- Taking Health damage does not inherently cancel committed actions.
- Guard-break resistance remains separately authored from flinch Poise.
- Player attack motion: CombatActionRunner + PlayerMotor via `OathboundPlayerMotion.gd`.
- Player basic soft targeting: `OathboundPlayerTargeting.gd`; explicit player redirection wins; no sticky lock-on.
- All six standard Hushiro families use shared V2 action/motor/brain/pressure seams while preserving species-specific contact authoring.
- HushiroEnemyContract install is idempotent per actor/type/revision; intentional re-normalization requires `force=true`.
- EnemyBrain invalidation is idempotent once already idle with no scheduled decision.
- CombatTelemetry session-end diagnostics summarize contract repeat cardinality, brain invalidation reasons/concentration, Poise-absorption profiles, and capture duration; they are reporting-only.
- PressureDirectorV2 schedules dangerous predicted impact timing, not all enemy intent.
- Direct close-frontline cue: PressureDirectorV2 `impact_at`, final 0.20s warning, final 0.12s parry beat.
- Archer final defense cue: projectile-local geometry/ETA after launch.
- Bilemass warning: spatial landing language through full remaining vomit+travel timeline; never parry language.
- Enemy PostureBar remains canonical player-facing Posture/Deathblow-readiness feedback.
- Frozen playtest branches are immutable comparison artifacts.

## AREA_1_TARGETS
- Base katana Health: Quick 9 -> Cross 12 -> Heavy 21; six-hit string = 84.
- Base no-Aspect Tier-0 ordinary unguarded Posture: Quick 6 -> Cross 9 -> Heavy 18.
- Base no-Aspect Tier-0 basic block-Posture: Quick 10 -> Cross 16 -> Heavy 36.
- Current Poise power bridge: ordinary Quick/Cross power 1; base Heavy-class impact power 2; explicit `poise_damage=3+` is the stronger future Technique/Prosthetic seam.
- Area 1 neutral/committed Poise requirements: Hollow 1/1; Hound 1/1; Archer 1/1; Swordsman 1/2; Bilemass 1/2; Warden 2/3.
- Hollow 40 HP / 40 Posture; Hound 50 / 45; Archer 45 / 65; Swordsman 60 / 90; Bilemass 60 / 70; Warden 140 / 150.
- Six-hit string is player capability, not standard enemy durability.
- Difficulty should emerge primarily from compositions, overlapping intentions, movement, target priority, geometry, hazards, authored defense, and waves rather than HP sponges.
- Immediate clear -> next wave; varied burst/staggered/sequence arrivals; 120s anti-stall fallback.

## RECENT_MERGES
- PR #187: debug-only combat telemetry session diagnostics + deterministic smoke; no gameplay tuning; 9 exact-head workflows green.
- PR #186: checkpoint after EnemyBrain invalidation cleanup.
- PR #185: idempotent EnemyBrain invalidation; repeated already-idle deaggro checks no longer churn timestamps/telemetry; 9 exact-head workflows green.
- PR #184: checkpoint after idempotent Hushiro contract.
- PR #183: idempotent Hushiro enemy-contract installation; repeated apply preserves live Posture and avoids duplicate install telemetry; 10 exact-head workflows green.
- PR #182: checkpoint after role-based Poise baseline.
- PR #181: telemetry-backed Area 1 role Poise tiers; Hound committed 1, Warden neutral/committed 2/3; guard-break/Health/Posture preserved; 9 exact-head workflows green.
- PR #180/#179: September playtest checkpoint + base-katana ordinary Posture 6/9/18 with Health/block-Posture preserved.
- PR #178/#177: manual-playtest crash checkpoint + freed soft-target lifetime fix.
- PR #175/#173/#171/#169: deterministic defense validation + Bilemass/Archer/direct-melee readability work.
- PR #166/#165: player-paced durability/six-hit string/target handoff + Area 1 wave/pressure baseline.
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
Request manual playtest only when a meaningful runtime gate is ready. Test current merged main unless an immutable comparison snapshot is specifically required. Provide the merged checkpoint SHA, coherent systems to exercise, and request matching Godot `.log` plus `combat_*.jsonl`.