# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V4: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

Single durable bootstrap + live handoff for AI-assisted Oathbound work. Repository state is authority; conversation/project memory is cache only.

## BOOT
1. Fresh session: fetch `main:AGENTS.md` first.
2. If `active_branch` is set, fetch only that HEAD.
3. If HEAD matches `covered_through_substantive_commit`, continue from `next_action`; otherwise inspect only the uncovered range/files and reconcile.
4. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

## AUTONOMOUS_PR_POLICY
- Routine PR merge approval is not required.
- Coherent + mergeable + required validation green => merge autonomously with exact verified head SHA.
- Diagnose failed CI/mergeability instead of asking.
- Multiple bounded PR cycles per response/session are allowed when they fit safely; they are not a quota.
- After every merge, branch subsequent work from updated `main`; never recreate a #119-style mega-PR.

## TURN_SURVIVAL_POLICY
- A turn is successful only if both repo state **and the user-visible handoff** survive. Durable GitHub state alone is not enough.
- Treat long connector/tool turns as finite. Do not keep extending work merely because another useful slice exists.
- After every merged PR or other major durable milestone: update `AGENTS.md` first, then send a concise progress update that explicitly states the safe checkpoint and next recoverable action before doing optional work.
- Normally complete at most **1 CI-heavy PR** or **2 light/bounded PRs** in one user turn. More is allowed only when prior cycles were cheap and there is ample execution headroom.
- Do not begin another implementation slice after a long CI/tool sequence. End at the safe checkpoint and give the user a final answer instead.
- Minimize CI polling. Prefer one targeted status read, then inspect only the failing/incomplete workflow. If repository settings support GitHub auto-merge, it may be armed after required validation is satisfied so the turn does not need a long polling loop.
- If a PR is still waiting on GitHub rather than on code work, checkpoint `active_pr`, exact head, current validation, and the next status/merge action in this file before any optional investigation.
- Late-turn commentary must report completed durable facts first (for example `SAFE CHECKPOINT: PR #123 merged at <sha>`), not only the activity currently being inspected. If the UI freezes on that message, Sean must still know what actually survived.
- Never spend the final portion of a long turn on broad read-only exploration. Preserve capacity for checkpointing and a final user-facing summary.

## LIVE_STATE
```yaml
schema: 4
updated_utc: 2026-09-03T21:52:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 134
  feature_head: 6153221ac0f6f79ce287e1212e04db442866a70c
  merge_commit: 8bb3e417adf98599cc78b7e9bd2ca200437130cb
  validation: 9/9 PR-triggered workflows green; mergeable true
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 8bb3e417adf98599cc78b7e9bd2ca200437130cb
current_objective: >-
  Continue player-facing Yomori/Region 2 integration from the September 3 blocker-repair main, then proceed to Kagutsuchi/Region 3.
  The first direct-warp Yomori playtest on checkpoint a5cd8119e584b22ee1b1c5782a903ff39b0fc431 proved later-region entry works and exposed three concrete runtime blockers:
  Mist Shepherd could not receive player damage, Merchant could auto-exit during room load, and Lantern Wraith temporary attack timers emitted freed-lambda errors.
  PR #134 repairs all three without numerical tuning or combat-architecture changes. Keep the temporary debug-only procedural FX active while comparing visible cues against combat events.
next_action: >-
  Run updated main and use Playtest Lab Chambers -> Area 2 - Yomori -> Combat. Confirm the Mist Shepherd in Pale Procession can take Health damage and die,
  and confirm Lantern Wraith encounters no longer emit "Lambda capture at index 0 was freed". Also directly warp to Area 2 -> Merchant and confirm the Shop remains active long enough to inspect/interact with its three offers instead of auto-transitioning.
  Then continue through the Yomori route and the real Twin Maws fight, exercising Techniques, Aspects, Prosthetics, blocking/parry, posture breaks, Deathblows, rewards, gates, and procedural FX.
  Preserve CombatTelemetry and the Godot log and stop at the first genuine blocker. If Region 2 completes cleanly, continue directly into Area 3/Kagutsuchi and Eclipse Shogun in the same integration pass.
current_batch:
  - PR #134 merged from exact feature head 6153221ac0f6f79ce287e1212e04db442866a70c at merge commit 8bb3e417adf98599cc78b7e9bd2ca200437130cb.
  - PR #134 passed all 9 PR-triggered workflows: Yomori Region Check, Cross-Region Enemy Contract Check, Godot 4.7.2 Project Check, Hushiro Combat Semantics, RunScene Runtime Lifetime, Run Region Handoff, Kagutsuchi Region Check, Post-playtest Stability, and Authored Presentation Content.
  - The supplied September 3 Yomori playtest ran exact main checkpoint a5cd8119e584b22ee1b1c5782a903ff39b0fc431 and successfully used the new direct Area 2 combat warp with player invulnerability enabled.
  - Runtime evidence proved the reported Shop routing itself was correct: GameFlow resolved `merchant`, loaded MerchantChamber.tscn, and OathboundMerchant rolled current offers. Telemetry then showed the merchant room survive only about 31 ms before an unlocked exit fired and loaded combat, with no purchase interaction.
  - The merchant failure was a room-entry timing race: GameFlow temporarily re-parents the persistent Player at previous-room coordinates for a frame before moving it to PlayerSpawn; immediately unlocked Merchant exits could observe that stale overlap. RouteGate now supports an opt-in entry grace and both Merchant exits use 0.25 s, leaving other gate behavior unchanged.
  - The final captured Yomori encounter was Y05_pale_procession with Mist Shepherd plus two Lingering Wraiths. Telemetry showed the Wraiths take sword damage and die while Mist Shepherd remained at 20/20 Health with no resolved player contact.
  - Mist Shepherd's scene root lacked the authored `enemy` group when its child HurtBox ran `_ready()`. The generic HurtBox therefore fell back to default HurtBoxType=Player and rejected player-owned attacks as friendly fire. The scene now authors the root into `enemy` before ready and explicitly sets HurtBoxType=Enemy.
  - Repeated `Lambda capture at index 0 was freed. Passed null instead.` errors were traced to Lantern Wraith SceneTreeTimer lambdas retaining temporary wave/pulse Area2D captures after contact or room cleanup freed those objects.
  - The live lantern_wraith.tscn still resolves through the archer_v2.gd compatibility shim. PR #134 overrides only temporary wave/pulse lifetime wiring there, replacing Object-capturing SceneTreeTimer lambdas with child-owned Timers and integer instance handles.
  - YomoriPlaytestRegressionSmoke reproduces all three observed blockers: Mist Shepherd targetability, Merchant stale-position gate entry, and early-freed Lantern wave/pulse callback lifetimes. The focused Yomori CI passed the regression and rejects any `Lambda capture` output.
  - No combat numbers, economy prices, route weights, encounter composition, Aspect/Technique/Prosthetic/Relic architecture, or Heart behavior changed in PR #134.
  - PR #133 remains intact: Keeper stale reward-parent death crash is repaired and primary Playtest Lab Chambers exposes direct Area 1/2/3 warps.
  - PR #132 remains intact and proves the real authored Twin Maws chamber initializes under Area 2 with TwinMawsManager, Rootfang, Briarthorn, BossChamber defeat authority, and defeat-signal ownership intact.
recent_batches:
  - pr_134: repaired Mist Shepherd targetability, Merchant room-entry auto-exit, and Lantern Wraith freed temporary callback captures from the first direct-warp Yomori playtest; added exact CI regression coverage.
  - pr_133: fixed Keeper stale reward-parent death crash, added exact regression coverage, and exposed obvious direct Area 1/2/3 chamber warps.
  - pr_132: added live Area-2 Twin Maws initialization/ownership regression using the real authored chamber; no gameplay changes.
  - sept_3_yomori_playtest: direct Area 2 warp worked; reached deep Yomori route and exposed Mist Shepherd immunity, Merchant 31 ms auto-exit, and Lantern freed-lambda errors repaired by PR #134.
  - sept_3_playtest_latest: checkpoint 6c2931b5 reached Keeper payout then crashed in stale reward-parent handling; repaired by PR #133.
  - sept_3_playtest: earlier live main integration cleared Region 1/Keeper and crossed into Area 2.
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
  - pr_129: repaired Collector/Keeper posture and Keeper Deathblow progression; gated inactive Area 2 duo manager startup.
  - pr_130: preemptively reconciled stale Region 2/3 hit/parry posture contracts through the shared canonical AttackEvent bridge.
  - pr_131: added temporary debug-only code-generated playtest FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #134 merged; never continue old feature branches.
  - Direct Playtest Lab Area 2/3 warps are intentionally exposed; killing Keeper is not required for targeted later-region testing.
  - The reported Yomori Shop incident was not a merchant-to-combat routing alias: the real Merchant chamber loaded and rolled offers, then its open exit was consumed during the Player room-entry position race.
  - Mist Shepherd is the Area 2 support buffer/encounter-escalation caster represented by the live `spirit monk` node; its player-damage immunity was a HurtBox faction-initialization bug, not an intended targetability state.
  - PR #134 CI proves the repaired Mist Shepherd accepts a player-owned sword contact, Merchant ignores the initial stale-position gate contact, and early-freed Lantern temporary attacks produce no freed-lambda error in the regression.
  - PR #133 CI reproduces and passes the Keeper previously-freed loot-parent reward condition.
  - PR #132 CI proves the real Twin Maws authored chamber initializes correctly under Area 2 and the manager/twin/BossChamber defeat-ownership chain is intact; this does not replace manual Twin Maws combat validation.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix remain intact.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning remains evidence-driven rather than speculative.
  - Region 2/3 CI does not replace player-facing playtest validation; Region 2 remains the current manual integration boundary until Twin Maws is proven in combat.
  - PR #131 procedural FX are temporary debug/playtest presentation, not final authored art or visual authority.
  - Current approved Wraith authority is the long-reach frontal posture/control Aspect; do not silently replace it with older Crimson/backstab design notes without an explicit design reopen.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - broad numerical tuning without integration evidence
  - waiting for routine PR merge approval
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
When manual validation is genuinely needed, provide exact branch/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
