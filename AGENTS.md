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
updated_utc: 2026-09-04T03:00:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 138
  feature_head: 2b1e7c094fa47e6c6dc35913b29d1c3909b80e90
  merge_commit: 25c6752e69a1abccefa49943b1eab0a95685db75
  validation: 9/9 visible PR-triggered workflows green, including the new Region Transition Presentation Check and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 25c6752e69a1abccefa49943b1eab0a95685db75
current_objective: >-
  Continue player-facing cross-region integration on PR #138 main. The latest live Twin Maws replay on build 1b42e0de120fc40c7caa5292a7196ee455270b55 proved the PR #136 boss-lifetime repair: Twin Maws died cleanly, payout/reward ownership completed, region_2_complete was recorded, and no script error or warning occurred. The remaining blocker in that run was the shared region-transition presentation deadlock, now fixed by PR #138.
next_action: >-
  Run updated main. Prefer one integration pass that first proves Keeper -> Region 2 and Twin Maws -> Region 3 transitions visibly complete, then continue through Kagutsuchi/Region 3 to Eclipse Shogun if no blocker appears. Use Playtest Lab Recommended 5x + Invulnerable for combat-state integration and Fast Clear 10x + Invulnerable only for rapid teardown/reward/transition checks. Preserve CombatTelemetry and the Godot log; stop at the first genuine blocker.
current_batch:
  - PR #138 merged from exact head 2b1e7c094fa47e6c6dc35913b29d1c3909b80e90 at merge commit 25c6752e69a1abccefa49943b1eab0a95685db75.
  - Latest user log on build 1b42e0de120fc40c7caa5292a7196ee455270b55 shows Twin Maws payout +15 Mist/+1 material, Enhanced Spirit Capacity +25, region_2_complete, Area 3 SceneRegistry activation, and Kagutsuchi opening choice [rest, merchant], with zero SCRIPT ERROR, ERROR, or WARNING lines.
  - Root cause: imported GameFlow._show_area_transition() returned after a fixed 2.4-second timer while its visual tween lasted about 3.5 seconds. Region 2/3 routes begin on CHOICE_* slots; RunScene immediately pauses the SceneTree for that choice. The still-active layer-200 AreaTransition therefore froze above the layer-100 choice UI, making the game appear permanently stuck. This same lifecycle explains the earlier Keeper -> Region 2 hang.
  - Why CI missed it: RunRegionHandoffSmoke uses OathboundRunHandoffHarness, which intentionally stubs _show_area_transition() to one frame and stubs room loading. It proves route/build/state continuity but did not exercise real transition presentation + choice pause.
  - PR #138 moves current regional transition ownership into OathboundRegionGameFlow, makes the transition tween pause-safe, scene-scopes the overlay, removes stale exact-name overlays, and does not return until the tween finishes and the overlay is actually retired.
  - New RegionTransitionPresentationSmoke exercises both Region 1->2 and Region 2->3 and also starts one transition with the SceneTree already paused. The dedicated workflow passed.
  - Existing Run Region Handoff, Choice Resume State, Post-playtest Stability, Hushiro Combat Semantics, Authored Presentation, RunScene Runtime Lifetime, Release Shell, and Godot 4.7.2 Project checks also passed on PR #138.
  - No additional concrete blocker is supported by the supplied Twin Maws log/telemetry beyond the transition/choice deadlock. Do not invent unrelated fixes without evidence.
recent_batches:
  - pr_138: fixed the shared Keeper/Twin-Maws region-transition choice deadlock and added real presentation regression coverage.
  - pr_137: made Playtest Lab viewport-safe/scrollable and added neutral-by-default 1x-10x sword/Blood-Aspect Health/Posture debug power presets.
  - pr_136: fixed the exact Twin Maws freed-partner death crash; generalized enemy reward/object lifetime safety; added shared body-clearance runtime and exact regression smoke.
  - pr_134: repaired Mist Shepherd targetability, Merchant room-entry auto-exit, and Lantern Wraith freed temporary callback captures.
  - pr_133: fixed Keeper stale reward-parent death crash and exposed direct Area 1/2/3 chamber warps.
  - pr_132: added live Area-2 Twin Maws initialization/ownership regression using the real authored chamber.
  - pr_131: added temporary debug-only procedural FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #138 merged; never continue old feature branches.
  - Twin Maws live combat now completes without the previous freed-partner crash on the latest supplied replay; manual transition replay on PR #138 is still required to prove the presentation fix player-facing.
  - Direct Playtest Lab Area 2/3 warps are intentional; killing Keeper is not required for targeted later-region testing.
  - Playtest Lab tabs are scrollable and the shell is viewport-constrained.
  - Playtest Power defaults to 1x and is debug-session only. Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - PR #136 stale partner/special-owner boundaries, live reward-parent resolution, and EnemyBodyClearanceRuntime remain intact.
  - FIRST_ATTEMPT begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques are slotless/unlimited.
  - Heart combat remains unauthored; do not invent it.
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
