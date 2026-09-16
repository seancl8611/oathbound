# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V10: combat state + approved isometric-2D presentation pivot; GitHub is authority -->

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
- Branch subsequent work from updated `main`; never continue an old feature branch after merge.

## TURN_SURVIVAL_POLICY
- After every merged PR or major durable milestone, update `AGENTS.md`, then continue if evidence-backed work remains.
- Minimize CI polling; inspect the targeted failed/incomplete workflow.

## LIVE_STATE
```yaml
schema: 10
updated_utc: 2026-09-16T02:21:00Z
repo: seancl8611/oathbound
control_ref: agent/hades-combat-v3
merged_cutoff:
  pr: 187
  feature_head: ab4ff6d4bff847d9c83e98e8237bf6c7dddf393c
  merge_commit: 21d889977064aa9becd48762effd215fb5f2dc8e
  validation: >-
    PR #187 was the last recorded merged-main combat checkpoint. The active stacked draft
    PR #194 now contains later Combat V2 convergence plus the presentation work described below.
active_branch: agent/hades-combat-v3
active_pr: 194
covered_through_substantive_commit: eecde2fadcf5502757702af6b3a671723248fc4f
known_good_checkpoint: eecde2fadcf5502757702af6b3a671723248fc4f
active_validation: >-
  Exact pivot head eecde2fadcf5502757702af6b3a671723248fc4f passed all eight triggered workflows,
  including Hushiro Isometric 2D Presentation Check, Godot 4.7.2 Project Check,
  Post-playtest Stability, Authored Presentation Content, and the combat/runtime checks.
  The dedicated live RunScene gate requires the HushiroIsometric2D marker and fails if
  Planar3DPresentationBridge activates in the ordinary Hushiro chamber.
presentation_pivot:
  authority: docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md
  runtime: 2d
  camera: fixed high-angle Camera2D / three-quarter-isometric composition
  proving_zoom: 0.50
  proving_ground_compression: 0.72
  directional_actor_contract: 8-way
  live_3d_status: retired from ordinary Hushiro CombatChamber; retained as research/reference
  future_character_art: hand-drawn sprites OR offline 3D model/rig/animation rendered to 2D atlases
  environment_target: layered illustrated 2D with ground-anchor depth sorting
latest_manual_presentation_evidence:
  rejected_live_3d_head: 1b82f2dab66ad5e102f60c100837154cbde0a4a2
  result: >-
    Wider live-3D framing improved readability, but Akio/enemies still read too large and
    the user rejected the miniature real-time-3D character/environment look versus Hades/Hades II.
    This evidence caused the approved runtime pivot to isometric 2D rather than further
    live-3D camera/material iteration.
current_objective: >-
  Manually validate the new ugly-but-correct Hushiro isometric-2D slice before investing
  in better placeholder/final art: camera threat visibility, small actor screen footprint,
  eight-direction readability, feet/depth ordering, planar CombatFX alignment, exclusive
  body replacement, and stable death/despawn/room-transition lifetime behavior.
next_action: >-
  Build/playtest current agent/hades-combat-v3 at the latest checkpoint descended from
  eecde2fadcf5502757702af6b3a671723248fc4f. Confirm startup includes
  `[HushiroIsometric2D] revision=1 runtime=2d directional=8 zoom=0.50 compression=0.72 live_3d=false`
  and does NOT include live Planar3D activation. Exercise multi-enemy combat, ranged threats,
  deaths/despawns and at least one room transition. Return a screenshot plus matching Godot
  `.log` and `combat_*.jsonl`. Do not tune Combat V2 numerical balance from presentation-only
  feedback. If composition is accepted, next implementation work is layered Hushiro 2D
  environment staging and higher-quality directional placeholder atlases, not live-3D reactivation.
```

## CURRENT AUTHORITIES
- Isometric 2D runtime presentation: `docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md`.
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
- Enemy PostureBar remains canonical player-facing Posture/Deathblow-readiness feedback where that enemy contract still deliberately exposes Posture.
- Hushiro live presentation now uses `HushiroIsometric2DPresentation.gd` + `DirectionalActorPresentation.gd`.
- Directional production animation naming is `<state>_<direction>` across `e,se,s,sw,w,nw,n,ne`.
- Actor world position is the feet/contact anchor; visual scale/depth presentation may not redefine gameplay collision/range.
- Live Planar3D Hushiro presentation is retired from the ordinary CombatChamber and preserved only as research/reference unless explicitly re-approved.
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

## RECENT MILESTONES
- PR #194 (active draft): presentation pivot checkpoint `eecde2f` establishes isometric 2D live Hushiro runtime, eight-direction placeholder/atlas seam, wider Camera2D framing, and retires live Planar3D from ordinary Hushiro combat; all 8 exact-head workflows green before this AGENTS checkpoint.
- PR #194 historical research: Planar3D V1/V2/V3 proved presentation separation, GLB validation, external-animation contracts and live-3D feasibility but was manually rejected as the production visual target.
- PR #187: debug-only combat telemetry session diagnostics + deterministic smoke; no gameplay tuning; 9 exact-head workflows green.
- PR #185: idempotent EnemyBrain invalidation; repeated already-idle deaggro checks no longer churn timestamps/telemetry.
- PR #183: idempotent Hushiro enemy-contract installation; repeated apply preserves live Posture and avoids duplicate install telemetry.
- PR #181: telemetry-backed Area 1 role Poise tiers; Hound committed 1, Warden neutral/committed 2/3; guard-break/Health/Posture preserved.
- PR #180/#179: September playtest checkpoint + base-katana ordinary Posture 6/9/18 with Health/block-Posture preserved.
- PR #178/#177: manual-playtest crash checkpoint + freed soft-target lifetime fix.
- PR #175/#173/#171/#169: deterministic defense validation + Bilemass/Archer/direct-melee readability work.
- PR #166/#165: player-paced durability/six-hit string/target handoff + Area 1 wave/pressure baseline.
- PR #159..154: standard-enemy V2 migrations + PlayerMotor/CombatActionRunner foundation.

## ENGINEERING_GUARDS
- Clean Godot import/editor compile before manual playtest; combat changes require telemetry-aware validation.
- Explicitly validate Variant object lifetime before `is` type checks when references can be freed.
- Defer physics registration mutations during active contact traversal.
- Preserve canonical Player/AttackEvent ownership.
- Presentation code may not become movement, damage, invulnerability, range, AI, pressure, encounter or progression authority.
- Do not reintroduce live Planar3D into ordinary Hushiro combat without a separate explicit direction decision.
- Replacement actor visuals are exclusive, never additive; old body art must not remain visible beneath a directional replacement.
- Production sprite atlases must use stable feet/contact pivots and must not encode gameplay root motion.
- Keep body art separate from combat VFX/telegraphs where practical so either can be replaced independently.
- Do not suppress/remove player-facing combat feedback without an approved replacement.
- Do not raise common Area 1 HP merely to make lone enemies threatening.
- Do not globally buff Player Health damage when enemy pressure/durability is the intended axis.
- Do not turn target handoff into sticky auto-lock or override explicit aim.
- Do not use one universal enemy guard/Poise formula.
- Preserve the role-based Area 1 Poise baseline unless new playtest evidence justifies a numerical change.
- Do not remove block/parry from an Aspect before the dedicated capability pass.
- Do not globally multiply encounters or change PressureDirector spacing without evidence.
- Do not force projectile/hazard threats through the direct-melee cue contract.
- Do not invent Heart combat.
- Combat/presentation CI must fail hard on missing PASS markers or Godot runtime SCRIPT ERRORs.
- Prefer deterministic state/boundary assertions over sub-second sleeps when time itself is not the contract.

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge only when mergeable/appropriate -> updated main -> AGENTS checkpoint -> continue while evidence-backed work remains`

## PLAYTEST_HANDOFF
Request manual playtest only when a meaningful runtime gate is ready. For this active stacked draft, test the exact branch checkpoint explicitly rather than assuming merged main. Provide the exact SHA, systems to exercise, expected startup marker, and request matching screenshot + Godot `.log` + `combat_*.jsonl`.