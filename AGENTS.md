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
- Normally complete at most 1 CI-heavy PR or 2 light/bounded PRs in one turn unless prior cycles were cheap and execution headroom is ample.
- Minimize CI polling; inspect targeted failing/incomplete workflows rather than repeatedly reading everything.

## LIVE_STATE
```yaml
schema: 4
updated_utc: 2026-09-09T23:36:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 143
  feature_head: c64e836530bd6a73214f817aacd483e468daa55c
  merge_commit: 506b4bef9e3d5a8b1da2063100c5fa4c9a8bbfe6
  validation: 10/10 PR-triggered workflows green on exact feature head, including Post-playtest Stability with the new AttackPresentationReadabilitySmoke, Yomori, Kagutsuchi, Cross-Region Enemy Contract, Region Transition Presentation, RunScene Runtime Lifetime, Hushiro Combat Semantics, Authored Presentation Content, Run Region Handoff, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 506b4bef9e3d5a8b1da2063100c5fa4c9a8bbfe6
current_objective: >-
  Player-facing validation of PR #143's September 9 telemetry-backed combat-readability repairs. PR #141's stationary-body authority is now manually confirmed: the latest replay no longer allowed Akio to drag enemies. PR #143 addresses the remaining observed defects without numerical tuning: the missing shared parry/attack cue implementation, Embered Pilgrim/Eclipse Shogun private CombatPhase not mirroring inherited attack-state fields, velocity-driven lunges/dashes skating around blocked player/enemy bodies, and Eclipse Shogun Timeless Zone's giant off-center CanvasLayer rectangle.
next_action: >-
  Run one targeted integration replay on updated main using Playtest Lab Recommended 5x Health + 5x Posture + Invulnerable. First exercise a normal Hushiro melee enemy and verify the shared attack cue contracts visually: warning cue is visible during WINDUP, gives a distinct bright ACTIVE/contact-ready pulse, and disappears in RECOVERY rather than lingering for an arbitrary total attack duration. Then fight Embered Pilgrim long enough to see ordinary combo lunges, overhead charge, and burning thrust; confirm attacks fully appear/resolve and blocked charges stop forward travel instead of sliding around Akio. In Twin Maws, deliberately put Akio or the other twin in Rootfang roll/lunge paths and, if available, Briarthorn empowered-lunge paths; blocked committed motion should stop rather than cross or skirt around bodies. In Eclipse Shogun, exercise Deathly Dash, Predator's Feint/pounce, ordinary combo lunges, Eclipse Measure, and Timeless Zone; blocked charges should stop cleanly while their attack/hit lifecycle completes, and Timeless Zone should render as a deliberate viewport-wide darkness effect with no giant offset grey rectangle following the camera/player. Preserve and return the Godot log plus CombatTelemetry JSONL. If an attack still appears not to fully spawn, capture which enemy/attack and use telemetry/state before changing timing or damage.
current_batch:
  - PR #143 merged from exact head c64e836530bd6a73214f817aacd483e468daa55c at merge commit 506b4bef9e3d5a8b1da2063100c5fa4c9a8bbfe6.
  - September 9 replay build 1451a0034e013351289e59fb82845ec9f4cecc31 produced no SCRIPT ERROR, engine ERROR, freed-object, lambda, deferred-call, CollisionObject, or physics-error recurrence. PR #141's anti-drag body-authority behavior was manually confirmed by the player.
  - The same telemetry still recorded real Embered Pilgrim/Eclipse Shogun contacts while inherited `telegraphing`, `swinging`, and `is_attacking` fields could remain false because those subclasses used private `_combat_phase` state. PR #143 mirrors WINDUP/ACTIVE/RECOVERY/NONE into the inherited fields for telemetry/readability consumers.
  - `res://Combat/parry_indicator.gd` was referenced by HumanoidEnemyBase and BeastEnemyBase but did not exist, so enemies used a static fallback diamond whose duration argument did not control real timing. PR #143 adds the shared phase-driven indicator: WINDUP contracts, ACTIVE pulses brightly, RECOVERY/NONE hides; legacy state fields and duration fallback remain compatible.
  - September 9 telemetry sampled Rootfang crossing Akio during 450 px/s roll passes and Eclipse Shogun repeatedly reaching roughly 500-550 px/s at body-contact distance. PR #143 makes committed high-speed attack motion use predictive `test_move()` and terminate forward travel when the next step is blocked rather than allowing `move_and_slide()` to convert the charge into a tangential skate around Akio, another enemy, or a wall.
  - Covered motion paths include Rootfang generic lunges and roll passes; Briarthorn empowered lunge; Embered Pilgrim generic combo lunges, overhead charge, and burning thrust; Eclipse Shogun generic melee lunges, Deathly Dash, Predator's Feint/pounce, and Eclipse Measure beast lunge.
  - Eclipse Shogun Timeless Zone previously created a viewport-sized ColorRect in a CanvasLayer at `-viewport_size * 0.5`, mixing world-center assumptions with screen coordinates. PR #143 anchors the darkness Control to the full viewport instead, removing the giant offset rectangle behavior.
  - AttackPresentationReadabilitySmoke is now part of Post-playtest Stability and validates the phase-driven cue contract, predictive blocked-lunge wiring across all four affected runtime authorities, and Timeless viewport overlay contract. The first two smoke-harness versions were replaced because their headless test approach hung; the final deterministic FileAccess source-contract smoke passes cleanly.
  - No damage, posture, attack-selection weights, cooldowns, authored recovery values, rewards/progression, Aspect/Technique/Prosthetic behavior, or Heart combat changed in PR #143.
recent_batches:
  - pr_143: added phase-driven shared enemy attack cue; synchronized Pilgrim/Shogun attack state; stopped blocked high-speed lunges from skating; fixed Timeless Zone viewport overlay; 10/10 workflows green.
  - pr_141: fixed player-vs-enemy physical authority so stationary enemies/bosses are not dragged by Akio; repaired Eternal Swordsman post-placement activation/engagement; manually confirmed anti-drag behavior in September 9 replay.
  - pr_140: hardened remaining live enemy temporary-object lifetimes across Rootfang, Briarthorn, Rotwood Host, Embered Pilgrim, Stalker Hound, and Eclipse Shogun; preserved canonical Kagutsuchi boss scene ownership.
  - pr_139: fixed physics-safe shared gate emission, solver-driven enemy body sticking, and Lingering Wraith out-of-range ordinary attack selection.
  - pr_138: fixed shared Keeper/Twin-Maws region-transition choice deadlock and added presentation regression coverage.
  - pr_137: made Playtest Lab viewport-safe/scrollable and added neutral-by-default 1x-10x Health/Posture debug power presets.
  - pr_136: fixed Twin Maws freed-partner death crash; generalized enemy reward/object lifetime safety; added shared body-clearance runtime.
confirmed:
  - PR #119 through #143 merged; never continue old feature branches.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed by the September 9 replay; preserve this guarantee while refining attack motion.
  - September 9 replay also confirms the prior lifetime/deferred/CollisionObject crash class remains clean.
  - Twin Maws and Eclipse Shogun continue to produce attack/contact activity and can complete their encounters; current work is presentation/motion readability, not general boss activation.
  - Direct Playtest Lab Area 2/3 warps are intentional; targeted later-region testing does not require killing Keeper.
  - Playtest Power defaults to 1x and is debug-session only. Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - FIRST_ATTEMPT begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques are slotless/unlimited.
  - Heart combat remains unauthored; the existing Heart Binding successful-run handoff is progression/presentation, not permission to invent Heart combat.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
  - PR #131 procedural FX are temporary debug/playtest presentation, not final authored art.
  - Current approved Wraith authority is the long-reach frontal posture/control Aspect; do not silently replace it with older Crimson/backstab notes without an explicit design reopen.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require concrete state evidence before changing that system.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
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
- Posture-break/Deathblow shared state; block uses current defensive aim.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing.

## DESIGN_ACCESS
Unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; ownership -> `SOURCE_OF_TRUTH.md`; terms -> `TERMINOLOGY.md`; otherwise exact authority only.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
