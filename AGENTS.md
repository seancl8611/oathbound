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
updated_utc: 2026-09-10T01:49:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 143
  feature_head: c64e836530bd6a73214f817aacd483e468daa55c
  merge_commit: 506b4bef9e3d5a8b1da2063100c5fa4c9a8bbfe6
  validation: 10/10 PR-triggered workflows green on exact feature head, including Post-playtest Stability with AttackPresentationReadabilitySmoke, Yomori, Kagutsuchi, Cross-Region Enemy Contract, Region Transition Presentation, RunScene Runtime Lifetime, Hushiro Combat Semantics, Authored Presentation Content, Run Region Handoff, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 59d649ae1113c7341a49218421a0cdbcafa155a3
current_objective: >-
  Close player-facing validation of PR #143's September 9 combat-readability repairs without reopening already-proven runtime paths. The September 10 targeted replay on exact build 59d649ae1113c7341a49218421a0cdbcafa155a3 machine-validates the crash/lifetime class, Pilgrim/Shogun inherited attack-state mirroring, and representative blocked committed-motion behavior across Pilgrim and Twin Maws. The only remaining contracts that the returned log/CombatTelemetry cannot prove are intrinsically visual: the shared Hushiro warning/ACTIVE/RECOVERY cue appearance and Eclipse Shogun Timeless Zone's viewport-wide darkness placement.
next_action: >-
  Do not request another broad repo scan or another full integration replay by default. If Sean already observed the Hushiro cue and Timeless Zone visually and reports them correct, mark PR #143 player-facing validation complete and move to the next design/gameplay objective. If either visual is still wrong, capture only that exact visual defect and inspect only its authority (`res://Combat/parry_indicator.gd` for the shared cue or `res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunRuntime.gd` for Timeless Zone) before patching. Reopen motion/state timing only if new telemetry contradicts the September 10 evidence.
current_batch:
  - PR #143 remains the latest substantive gameplay change: feature head c64e836530bd6a73214f817aacd483e468daa55c, merge commit 506b4bef9e3d5a8b1da2063100c5fa4c9a8bbfe6, 10/10 triggered workflows green.
  - September 10 targeted replay used exact build 59d649ae1113c7341a49218421a0cdbcafa155a3 with Playtest Lab Recommended 5x Health/Posture and Invulnerable. Returned artifacts are `godot(20260910-011635).log` and `combat_1789002883.jsonl`.
  - Godot log has no SCRIPT ERROR, engine ERROR, freed-object, lambda/deferred-call, CollisionObject, or physics-error recurrence. Preserve the PR #139/#140 lifetime hardening guarantees.
  - Embered Pilgrim telemetry now visibly mirrors authoritative attack phases into inherited fields: WINDUP samples show `telegraphing=true/swinging=false`, ACTIVE samples show `telegraphing=false/swinging=true`, and recovery samples clear both while the attack lifecycle remains active as appropriate. A sampled high-speed committed Pilgrim attack reached roughly 500 px/s then stopped after only a small additional step at body-contact clearance instead of skating through/around Akio.
  - Twin Maws telemetry supports the predictive motion-stop repair. Rootfang's approach terminates around body-contact clearance instead of continuing through Akio, and Briarthorn has representative 400 px/s committed movement samples that collapse to zero velocity at close contact instead of tangentially skating around the player.
  - Eclipse Shogun inherited attack-state mirroring is active in the replay: many direct ACTIVE samples report `is_attacking=true`, `swinging=true`, `telegraphing=false`. An earlier contact sampled with `swinging=false` is consistent with a lingering hazard/contact outside the boss's direct ACTIVE phase and is not evidence of failed mirroring.
  - PR #143's source authority still maps CombatPhase WINDUP/ACTIVE/RECOVERY/NONE into inherited telemetry/readability fields and uses predictive `test_move()` for committed Shogun movement. Deathly Dash, Predator's Feint/pounce, Eclipse Measure, and Timeless Zone were deliberately overridden without numerical tuning.
  - Runtime evidence does not justify another gameplay patch at this checkpoint. Hushiro cue rendering and Timeless Zone screen-space placement remain visual-only confirmation items because JSONL/log telemetry cannot establish what Sean actually saw on screen.
  - No damage, posture, attack-selection weights, cooldowns, authored recovery values, rewards/progression, Aspect/Technique/Prosthetic behavior, or Heart combat changed in PR #143.
recent_batches:
  - pr_143: added phase-driven shared enemy attack cue; synchronized Pilgrim/Shogun attack state; stopped blocked high-speed lunges from skating; fixed Timeless Zone viewport overlay; 10/10 workflows green; September 10 replay machine-validates runtime state/motion/lifetime behavior with only two visual-only checks remaining.
  - pr_141: fixed player-vs-enemy physical authority so stationary enemies/bosses are not dragged by Akio; repaired Eternal Swordsman post-placement activation/engagement; manually confirmed anti-drag behavior in September 9 replay.
  - pr_140: hardened remaining live enemy temporary-object lifetimes across Rootfang, Briarthorn, Rotwood Host, Embered Pilgrim, Stalker Hound, and Eclipse Shogun; preserved canonical Kagutsuchi boss scene ownership.
  - pr_139: fixed physics-safe shared gate emission, solver-driven enemy body sticking, and Lingering Wraith out-of-range ordinary attack selection.
  - pr_138: fixed shared Keeper/Twin-Maws region-transition choice deadlock and added presentation regression coverage.
  - pr_137: made Playtest Lab viewport-safe/scrollable and added neutral-by-default 1x-10x Health/Posture debug power presets.
  - pr_136: fixed Twin Maws freed-partner death crash; generalized enemy reward/object lifetime safety; added shared body-clearance runtime.
confirmed:
  - PR #119 through #143 merged; never continue old feature branches.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed by the September 9 replay; preserve this guarantee while refining attack motion.
  - September 10 build 59d649ae1113c7341a49218421a0cdbcafa155a3 confirms the prior lifetime/deferred/CollisionObject crash class remains clean and provides positive telemetry for PR #143's Pilgrim/Shogun shared attack-state mirroring plus representative blocked-motion stops.
  - Twin Maws and Eclipse Shogun continue to produce attack/contact activity and can complete their encounters; do not treat either as generally inert.
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
