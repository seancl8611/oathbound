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
updated_utc: 2026-09-04T01:26:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 136
  feature_head: 6b8af83a7d314cfe9d701092c5a4e51e5edda29c
  merge_commit: 6ae1de7bbbc84dc21e9ac87e7893517e161077ee
  validation: 13/13 PR-triggered workflows green; exact EnemyLifetimeHardeningSmoke green; mergeable true before merge
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 6ae1de7bbbc84dc21e9ac87e7893517e161077ee
current_objective: >-
  Continue player-facing Yomori/Region 2 integration from the PR #136 enemy-lifetime-hardened main, then proceed directly to Kagutsuchi/Region 3 if Yomori holds.
  The September 3/4 Twin Maws playtest reached the real Area 2 boss and exposed a concrete death crash when Briarthorn died after Rootfang had already been freed.
  PR #136 fixes that exact stale-partner type boundary, generalizes stale reward-parent handling across shared enemies/minibosses/bosses, and adds shared physical body clearance without numerical combat tuning.
  Region 2 is still the active manual integration boundary until the repaired Twin Maws fight is replayed successfully.
next_action: >-
  Run updated main and use Playtest Lab Chambers to reach Area 2/Yomori Boss -> Twin Maws as directly as practical. Kill Rootfang first and Briarthorn second to reproduce the previously crashing order; if practical, also validate the reverse order.
  Confirm the fight completes with no `Invalid type in function '_is_alive'`, no previously-freed Object error, no stale reward-parent error, and no enemy body pinning/pass-through. Confirm boss defeat ownership, reward/gate progression, Techniques, Aspects, Prosthetics, blocking/parry, posture breaks, Deathblows, and procedural FX remain intact.
  Preserve CombatTelemetry and the Godot log. If Twin Maws completes cleanly, continue directly into Area 3/Kagutsuchi and Eclipse Shogun in the same integration pass; stop at the first genuine blocker.
current_batch:
  - PR #136 merged from exact feature head 6b8af83a7d314cfe9d701092c5a4e51e5edda29c at merge commit 6ae1de7bbbc84dc21e9ac87e7893517e161077ee.
  - PR #136 passed all 13 final PR-triggered workflows, including Godot 4.7.2 Project Check, Yomori Region Check, Cross-Region Enemy Contract Check, RunScene Runtime Lifetime Check, Slot Runtime Lifetime Check, Post-playtest Stability Check, Hushiro combat/boss regressions, region handoff, release shell, presentation, and Blood Cavern checks.
  - The exact Twin Maws crash was a typed stale-reference boundary: after Rootfang was freed, DuoBossManager retained its cached Object and later passed it through `_is_alive(who: Node)` while processing Briarthorn death. GDScript rejected the freed Object before the old validity guard could execute.
  - DuoBossManager twin and special-mode ownership caches now cross Variant-safe boundaries, validate `is_instance_valid()` before Node calls/signals, clear dead twin caches, and discard freed deferred special owners.
  - EnemyLifetimeHardeningSmoke reproduces the real acquisition order by caching Rootfang while it is valid, freeing it, then ending deferred special ownership and notifying Briarthorn death. The smoke also validates stale reward-owner replacement and shared body depenetration; it is now part of Post-playtest Stability CI.
  - Shared EnemyBase reward spawning now accepts stale cached ownership safely and resolves a live current Loot parent at use time. This generalizes the earlier Keeper/Eclipse Shogun stale reward-parent class instead of adding boss-specific wrappers.
  - Shared EnemyBase object/free helpers reject freed references safely, and `_do_after` now uses enemy-owned Timer lifetime rather than an orphanable SceneTreeTimer callback.
  - EnemyBodyClearanceRuntime is an autoload applying only to live CharacterBody2D enemies. It derives physical clearance from collision shapes, removes enemy velocity driving farther into the player, and performs bounded outward depenetration while skipping dead/deathblow-ready enemies.
  - Playtest telemetry sampled Rootfang/Briarthorn at roughly 12-15 px center distance during the reported fight, supporting a physical penetration fix; PR #136 does not change attack damage, range, timing, selection, economy, Aspect/Technique/Prosthetic/Relic architecture, or Heart behavior.
  - Unwired bespoke Rootfang/temporary-area callback guard experiments were removed before merge rather than shipping speculative code without runtime evidence.
  - CI proves the code regression and shared lifetime contracts, but does not replace the required manual Twin Maws combat replay.
recent_batches:
  - pr_136: fixed the exact Twin Maws freed-partner death crash; generalized enemy reward/object lifetime safety; added shared body-clearance runtime and exact regression smoke; 13/13 final workflows green.
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
  - PR #119 through #136 merged; never continue old feature branches.
  - Direct Playtest Lab Area 2/3 warps are intentionally exposed; killing Keeper is not required for targeted later-region testing.
  - PR #136 CI reproduces the exact freed Twin Maws partner sequence and passes it without the `_is_alive(Node)` type crash; manual combat replay remains required before calling Region 2 player-facing integration proven.
  - Shared reward parent resolution now covers stale cached Loot ownership for common EnemyBase/HumanoidEnemyBase death rewards, including the previously observed Keeper/Eclipse Shogun class.
  - Shared EnemyBodyClearanceRuntime applies across live CharacterBody2D enemies and only corrects physical penetration; numerical combat tuning remains unchanged.
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
