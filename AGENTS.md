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
updated_utc: 2026-09-04T23:12:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 140
  feature_head: 69137f82b120540a61b443712dbffd520aa18905
  merge_commit: d62fd5bdbd7ba809a3c53ed1750a1ec3ab245556
  validation: 10/10 PR-triggered workflows green on exact feature head, including Post-playtest Stability, Yomori, Kagutsuchi, Cross-Region Enemy Contract, Region Transition Presentation, RunScene Lifetime, Hushiro Combat Semantics, Authored Presentation, Run Region Handoff, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: d62fd5bdbd7ba809a3c53ed1750a1ec3ab245556
current_objective: >-
  Player-facing integration validation of the combined PR #139 full-run combat-stability repairs and PR #140 enemy temporary-object lifetime hardening on updated main. PR #139 addresses the three concrete defects recovered from the September 4 full route: physics-unsafe final gate emission, solver-driven enemy/boss body sticking, and Lingering Wraith ordinary attacks beginning from charge-only range. PR #140 then removes the remaining orphanable delayed temporary-object callbacks from live Rootfang, Briarthorn, Rotwood Host, Embered Pilgrim, Stalker Hound, and Eclipse Shogun runtime paths without changing authored combat balance.
next_action: >-
  Run one fresh full-route integration replay on updated main. Use Playtest Lab Recommended 5x Health + 5x Posture + Invulnerable; use Fast Clear 10x only when needed to accelerate teardown/transition coverage. Exercise Area 2 ordinary enemies and Lingering Wraith at medium/long range; sustain close contact against enemies/bosses that previously stuck to Akio; deliberately allow Rootfang/Briarthorn/Rotwood Host/Embered Pilgrim/Stalker Hound temporary attacks to spawn and expire; complete Eclipse Shogun while allowing Blood Halo, Blade Dance, and Black Wing temporary hazards to execute; then complete Heart Binding -> Strand. Confirm no freed-lambda/deferred-call errors, no ordinary Wraith attacks from charge-only distance, overlapping bodies release instead of being carried with the Player, and the successful-run return emits no CollisionObject-removal physics error. Preserve CombatTelemetry and the Godot log. Do not add a separate Area-2 visibility/disappearing fix unless the replay supplies concrete visibility/teleport state evidence.
current_batch:
  - PR #140 merged from exact head 69137f82b120540a61b443712dbffd520aa18905 at merge commit d62fd5bdbd7ba809a3c53ed1750a1ec3ab245556.
  - All 10 final PR-triggered workflows are green on exact PR #140 feature head. Kagutsuchi specifically passes clean import/editor compile, canonical scene ownership, standard-enemy contracts, seeded route/roster, miniboss, full generated-route traversal, and Binding/seventh-run/postgame contract. Godot 4.7.2 Project Check passes RunScene ownership, Hushiro/Yomori route coverage, Shrine/Merchant/Forge smokes, and Strand permanent progression.
  - PR #140 hardens Rootfang empowered-beam overlap probe; Briarthorn AOE/beam overlap and cleanup timers; Rotwood Host spirit-trail fade/cleanup; Embered Pilgrim afterimages, ember patches, and homing-orb lifetimes; Stalker Hound mist-pounce delayed hitbox shutdown; and Eclipse Shogun Blood Halo, Blade Dance, and Black Wing temporary hazard cleanup. Temporary nodes own their timers/tweens or cross delayed boundaries via stable instance IDs instead of orphanable object-capturing lambdas.
  - During final CI repair, EclipseShogunRuntime.gd required explicit Godot 4.7 typing for end_pos, out_time, my_seq, dist, and travel_time. The fix is type-only and does not alter values or authored timing.
  - Kagutsuchi's boss chamber retains canonical scene authority through res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.tscn while overriding that canonical scene instance with EclipseShogunRuntime.gd for hardened live behavior. This satisfies the existing canonical-ownership contract instead of weakening validation.
  - PR #139 remains the preceding live-stability layer: deferred shared RouteGate emission outside physics callbacks, solver-safe enemy body depenetration/FLOATING motion mode, and Lingering Wraith attack-specific range authority.
  - No Health/damage/posture numbers, boss phases, attack-selection probabilities, rewards, route rules, Technique/Aspect/Prosthetic behavior, or authored Heart combat changed in PR #140.
recent_batches:
  - pr_140: hardened remaining live enemy temporary-object lifetimes across Rootfang, Briarthorn, Rotwood Host, Embered Pilgrim, Stalker Hound, and Eclipse Shogun; preserved canonical Kagutsuchi boss scene ownership; 10/10 workflows green.
  - pr_139: fixed physics-safe shared gate emission, stationary solver-driven enemy body sticking, and Lingering Wraith out-of-range ordinary attack selection; added exact regressions.
  - pr_138: fixed the shared Keeper/Twin-Maws region-transition choice deadlock and added real presentation regression coverage.
  - pr_137: made Playtest Lab viewport-safe/scrollable and added neutral-by-default 1x-10x sword/Blood-Aspect Health/Posture debug power presets.
  - pr_136: fixed the exact Twin Maws freed-partner death crash; generalized enemy reward/object lifetime safety; added shared body-clearance runtime and exact regression smoke.
  - pr_134: repaired Mist Shepherd targetability, Merchant room-entry auto-exit, and Lantern Wraith freed temporary callback captures.
  - pr_133: fixed Keeper stale reward-parent death crash and exposed direct Area 1/2/3 chamber warps.
  - pr_132: added live Area-2 Twin Maws initialization/ownership regression using the real authored chamber.
  - pr_131: added temporary debug-only procedural FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #140 merged; never continue old feature branches.
  - A live September 4 boss-room run before PR #139/#140 completed all three authored regions through Eclipse Shogun and the existing Heart Binding successful-run handoff back to The Strand, providing the evidence that drove the current stability repairs.
  - PR #138's Region 1->2 and Region 2->3 transition presentation is manually proven player-facing by that full run.
  - PR #139's three repairs and PR #140's remaining temporary-lifetime hardening are CI-proven but still need one combined player-facing replay on updated main to validate feel and the original live failure boundaries.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require concrete visibility/teleport state before changing that system.
  - Direct Playtest Lab Area 2/3 warps are intentional; killing Keeper is not required for targeted later-region testing.
  - Playtest Lab tabs are scrollable and the shell is viewport-constrained.
  - Playtest Power defaults to 1x and is debug-session only. Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - PR #140 builds on PR #139/#136 stale partner/special-owner, live reward-parent, gate-safety, body-clearance, and attack-range guarantees; do not regress those lifetime or physics guarantees.
  - FIRST_ATTEMPT begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques are slotless/unlimited.
  - Heart combat remains unauthored; the existing Heart Binding successful-run handoff is progression/presentation, not permission to invent Heart combat.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
  - PR #131 procedural FX are temporary debug/playtest presentation, not final authored art.
  - Current approved Wraith authority is the long-reach frontal posture/control Aspect; do not silently replace it with older Crimson/backstab notes without an explicit design reopen.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - broad numerical tuning without integration evidence
  - unrelated PR growth
  - visibility/invisibility rewrites based only on perceived Area 2 disappearance without captured state evidence
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
