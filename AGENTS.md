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
updated_utc: 2026-09-04T16:50:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 139
  feature_head: 0ed5bd073ee7732fe57a5211f9b3adf6cee886cd
  merge_commit: d947dfc5634264a56d3b276dbe3fa28a20751286
  validation: 10/10 PR-triggered workflows green, including Post-playtest Stability, Yomori, Kagutsuchi, Cross-Region Enemy Contract, Region Transition Presentation, RunScene Lifetime, Hushiro Combat Semantics, Authored Presentation, Run Region Handoff, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: d947dfc5634264a56d3b276dbe3fa28a20751286
current_objective: >-
  Validate the PR #139 full-run combat-stability repairs player-facing on updated main. The September 4 full boss-room run already proved the major campaign path end-to-end: Keeper -> Yomori, Twin Maws -> Kagutsuchi, Eclipse Shogun defeat, Heart Approach, Heart Binding destruction, successful-run handoff, and return to The Strand. It also manually proves PR #138's previously blocked Region 1->2 and Region 2->3 transition presentation. PR #139 addresses the three concrete defects recovered from that run: physics-unsafe gate emission at the final successful-run handoff, solver-driven enemy/boss body sticking, and Lingering Wraith ordinary attack selection from charge-range distances.
next_action: >-
  Run updated main for one focused integration replay. Use Playtest Lab Recommended 5x + Invulnerable unless Fast Clear 10x is needed only to accelerate teardown. Specifically exercise Area 2 ordinary enemies/Lingering Wraith at medium and long range, sustained close-contact movement against bosses/enemies that previously stuck to Akio, and the final Heart Binding -> Strand gate. Confirm ordinary Wraith attacks no longer begin from charge-only distance, overlapping bosses release instead of being carried with the Player, and the successful-run return emits no CollisionObject-removal physics error. Preserve CombatTelemetry and the Godot log. Do not add a separate Area-2 visibility/disappearing fix unless a replay supplies concrete visibility/teleport state evidence.
current_batch:
  - PR #139 merged from exact head 0ed5bd073ee7732fe57a5211f9b3adf6cee886cd at merge commit d947dfc5634264a56d3b276dbe3fa28a20751286.
  - All 10 final PR-triggered workflows are green on the exact feature head, including the new FullRunCombatStabilitySmoke under Post-playtest Stability and the complete Godot 4.7.2 Project Check.
  - September 4 live full-run evidence on build cc5c1b34cfd35936d1e3efeaf88af750cbf4f415 cleared Area 1, Area 2, Area 3, Eclipse Shogun, Heart Approach, Heart Binding destruction, and the successful-run return path. Keeper->Yomori and Twin Maws->Kagutsuchi transition presentation both completed player-facing, closing the PR #138 manual evidence gap.
  - Final-run engine error root cause: RouteGate emitted gate_used synchronously from Area2D.body_entered; downstream successful-run scene replacement removed CollisionObjects while Godot was still flushing the physics callback. PR #139 consumes the gate immediately but defers the shared gate_used emission outside physics. The regression uses the real authored RouteGate overlap and deliberately frees a CharacterBody from the listener so CI reproduces the original engine ERROR if the callback becomes unsafe again.
  - Sticky-body evidence: Rotwood Host telemetry showed authored velocity at zero while its world position was carried with the moving Player for several seconds at roughly 23-26 px separation. PR #139 extends EnemyBodyClearanceRuntime to normalize enemy CharacterBody2D motion mode to FLOATING, remove inward authored velocity when present, and depenetrate existing overlap even when authored velocity is zero. The regression covers the stationary sticky-contact case without inventing enemy velocity.
  - Lingering Wraith evidence: ordinary windups were observed beginning around 160-178 px even though normal sword actions are authored around 48-62 px. The generic start gate had used the 180 px perilous-charge range for every attack. PR #139 splits range authority so ordinary attacks use normal start range, Running Swing uses only its legitimate gap-closing reach, and the intended perilous charge remains legal through 180 px when ready.
  - The reported Area 2 enemy disappearing behavior did not yield a separate concrete visibility/modulate/teleport defect in the supplied capture. Some perceived off-range/disappearing behavior is consistent with the confirmed Lingering Wraith range defect. Do not invent an unrelated visibility fix without new evidence.
  - No Health/damage/posture numbers, boss phases, Technique/Aspect/Prosthetic rules, rewards, route authority, or authored Heart combat changed in PR #139.
recent_batches:
  - pr_139: fixed physics-safe shared gate emission, stationary solver-driven enemy body sticking, and Lingering Wraith out-of-range ordinary attack selection; added exact regressions.
  - pr_138: fixed the shared Keeper/Twin-Maws region-transition choice deadlock and added real presentation regression coverage.
  - pr_137: made Playtest Lab viewport-safe/scrollable and added neutral-by-default 1x-10x sword/Blood-Aspect Health/Posture debug power presets.
  - pr_136: fixed the exact Twin Maws freed-partner death crash; generalized enemy reward/object lifetime safety; added shared body-clearance runtime and exact regression smoke.
  - pr_134: repaired Mist Shepherd targetability, Merchant room-entry auto-exit, and Lantern Wraith freed temporary callback captures.
  - pr_133: fixed Keeper stale reward-parent death crash and exposed direct Area 1/2/3 chamber warps.
  - pr_132: added live Area-2 Twin Maws initialization/ownership regression using the real authored chamber.
  - pr_131: added temporary debug-only procedural FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #139 merged; never continue old feature branches.
  - A live September 4 boss-room run now completes all three authored regions through Eclipse Shogun and the existing Heart Binding successful-run handoff back to The Strand.
  - PR #138's Region 1->2 and Region 2->3 transition presentation is now manually proven player-facing by that full run.
  - PR #139's three repairs are CI-proven on exact feature head 0ed5bd073ee7732fe57a5211f9b3adf6cee886cd but still need one player-facing replay to validate feel/behavior under the original scenarios.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require concrete visibility/teleport state before changing that system.
  - Direct Playtest Lab Area 2/3 warps are intentional; killing Keeper is not required for targeted later-region testing.
  - Playtest Lab tabs are scrollable and the shell is viewport-constrained.
  - Playtest Power defaults to 1x and is debug-session only. Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - PR #139 builds on PR #136 stale partner/special-owner boundaries, live reward-parent resolution, and EnemyBodyClearanceRuntime; do not regress those lifetime guarantees.
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
