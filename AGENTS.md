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
updated_utc: 2026-09-08T22:45:47Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 141
  feature_head: 02c6e2d411e28ddbd04d50e845a6838d1af50db2
  merge_commit: 5700cff639e4ae488747ebc20c0d124f6aa92f8d
  validation: 9/9 PR-triggered workflows green on exact feature head, including Post-playtest Stability, Kagutsuchi, Cross-Region Enemy Contract, Region Transition Presentation, RunScene Lifetime, Hushiro Combat Semantics, Authored Presentation, Run Region Handoff, and Godot 4.7.2 Project Check; the project check also covers Yomori seeded route/roster validation
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 5700cff639e4ae488747ebc20c0d124f6aa92f8d
current_objective: >-
  Player-facing integration validation of PR #141's two September 8 telemetry-backed combat repairs on updated main: stationary enemies/bosses must remain planted when Akio drives into them instead of being translated almost one-for-one by the shared body-clearance runtime, while enemy-authored inward movement must still depenetrate without recreating the earlier sticky/carry state; Eternal Swordsman must activate after chamber placement, re-baseline its inherited Court Guard home state, explicitly engage the solo duel, and proceed into normal attack-token/telegraph/swing behavior. Preserve all PR #139/#140 lifetime, gate, range, and temporary-object stability guarantees.
next_action: >-
  Run one fresh targeted integration replay on updated main. Use Playtest Lab Recommended 5x Health + 5x Posture + Invulnerable; use Fast Clear 10x only to accelerate teardown/transition coverage. First sustain movement directly into a stationary ordinary enemy, Eternal Swordsman, Twin Maws member, and Eclipse Shogun from multiple directions: Akio should stop/slide or be separated, the stationary enemy/boss should not be bulldozed or dragged, and bodies must still release cleanly when either side disengages. Fight Eternal Swordsman long enough to observe multiple normal telegraphs/attacks and confirm it is no longer inert. Then do quick Twin Maws and Eclipse Shogun sanity coverage, allowing representative temporary attacks to spawn/expire, and complete Heart Binding -> Strand if practical. Confirm no freed-lambda/deferred-call/CollisionObject errors. Preserve and return the Godot log plus CombatTelemetry JSONL. Do not reopen numerical balance or add an Area-2 visibility fix without new evidence.
current_batch:
  - PR #141 merged from exact head 02c6e2d411e28ddbd04d50e845a6838d1af50db2 at merge commit 5700cff639e4ae488747ebc20c0d124f6aa92f8d.
  - All 9 PR-triggered workflows are green on the exact PR #141 feature head. Post-playtest Stability passes the strengthened shared body-authority regression plus enemy temporary-lifetime and full-run stability smokes; Kagutsuchi passes the Eternal Swordsman miniboss contract and generated-route/progression checks; Godot 4.7.2 Project Check passes clean import/editor load, RunScene ownership, Hushiro/Yomori route coverage, chamber/menu smokes, and Strand progression.
  - EnemyBodyClearanceRuntime no longer translates a stationary enemy during ordinary player-authored/pre-existing overlap. It strips inward velocity from the driving body; enemy-authored inward drive can move the enemy out, while player-authored/tied/stationary overlap anchors the enemy and separates Akio. Enemy motion mode remains normalized to FLOATING and deathblow-ready/dead exclusions remain intact. No damage, posture, range, timing, or attack-selection values changed.
  - Eternal Swordsman activation is deferred until MinibossChamber placement is complete, then its inherited Court Guard home/patrol baseline is refreshed and the solo duel is explicitly engaged. This repairs the lifecycle/engagement path observed in two inert September 8 spawns without changing attack probabilities or aggression tuning.
  - The only follow-up CI failure was not gameplay: EnemyLifetimeHardeningSmoke renamed its PASS suffix from `shared body clearance` to `shared body authority` while the workflow still grepped the old marker. Commit 02c6e2d411e28ddbd04d50e845a6838d1af50db2 aligned the workflow marker; the actual strengthened body-authority assertions then passed.
  - September 8 playtest build e71ca9f460d04b215c48e600365c658d16a5b33e showed no recurrence of the freed-object/lambda/deferred/CollisionObject crash class. Its telemetry specifically showed zero-authored-velocity enemies moving with Akio during close overlap and two Eternal Swordsman spawns that never acquired attack-token/telegraph/swing state; Twin Maws and Eclipse Shogun otherwise attacked and completed normally.
recent_batches:
  - pr_141: fixed player-vs-enemy physical authority so stationary enemies/bosses are not dragged by Akio; repaired Eternal Swordsman post-placement activation/engagement; added exact regressions; 9/9 triggered workflows green.
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
  - PR #119 through #141 merged; never continue old feature branches.
  - A live September 4 boss-room run before PR #139/#140 completed all three authored regions through Eclipse Shogun and the existing Heart Binding successful-run handoff back to The Strand, providing the evidence that drove the stability repair sequence.
  - PR #138's Region 1->2 and Region 2->3 transition presentation is manually proven player-facing by that full run.
  - The September 8 replay manually confirmed PR #140's lifetime/deferred-crash class remained clean, but exposed the PR #139 body-clearance authority regression and an inert Eternal Swordsman; PR #141 repairs are CI-proven and still require one player-facing replay for feel/behavior validation.
  - Twin Maws and Eclipse Shogun produced normal attack/contact activity in the September 8 capture; do not treat either as generally inert. Lingering Wraith was not meaningfully exercised in that replay, so PR #139's range fix remains CI-proven rather than manually revalidated there.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require concrete visibility/teleport state before changing that system.
  - Direct Playtest Lab Area 2/3 warps are intentional; killing Keeper is not required for targeted later-region testing.
  - Playtest Lab tabs are scrollable and the shell is viewport-constrained.
  - Playtest Power defaults to 1x and is debug-session only. Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - PR #141 builds on PR #139/#140/#136 stale partner/special-owner, live reward-parent, gate-safety, body-clearance, attack-range, and temporary-lifetime guarantees; do not regress those lifetime or physics guarantees.
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
