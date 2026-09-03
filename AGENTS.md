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
updated_utc: 2026-09-03T20:52:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 133
  feature_head: 864d539e062a1f8d8f0322ebd00c44b7252d723b
  merge_commit: e6f97d8c1c88d1d82da125ed951599e15de1a93c
  validation: 9/9 PR-triggered workflows green; mergeable true
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: e6f97d8c1c88d1d82da125ed951599e15de1a93c
current_objective: >-
  Continue player-facing integration evidence in Yomori/Region 2 and then Kagutsuchi/Region 3 from the repaired September 3 main.
  The later September 3 playtest on checkpoint 6c2931b5952e5a67e988cfe20ba3dd8c6af47437 reached Keeper's final persistent payout but then exposed
  a stale cached loot-parent crash in Keeper death rewards. PR #133 repairs that evidence-backed failure and makes direct Area 1/2/3 chamber warps
  obvious in the primary Playtest Lab Chambers tab, so later-region validation no longer depends on replaying or killing Keeper first. Keep the
  temporary debug-only procedural FX active while comparing visible cues against underlying combat events.
next_action: >-
  Run updated main and open the Playtest Lab with backtick. In Chambers, choose Target Region "Area 2 - Yomori" and Target Chamber "Combat",
  then use "Warp Directly to Selected Region / Chamber". Exercise the Area 2 ordinary roster, Techniques, Aspects, Prosthetics, sword hits,
  parries, blocking, posture breaks, Deathblows, room clear/progression, rewards, and procedural FX. Then directly warp to Area 2 Boss/Twin Maws
  and validate the real duo fight. Preserve CombatTelemetry and the Godot log and stop at the first genuine blocker. If Yomori is clean, directly
  continue to Area 3/Kagutsuchi combat and Eclipse Shogun. A separate Keeper boss retest is useful for end-to-end Hushiro progression confidence,
  but it is no longer a prerequisite for reaching Area 2 or 3 during integration testing.
current_batch:
  - PR #133 merged from exact feature head 864d539e062a1f8d8f0322ebd00c44b7252d723b at merge commit e6f97d8c1c88d1d82da125ed951599e15de1a93c.
  - PR #133 passed all 9 PR-triggered workflows: Godot 4.7.2 Project Check, Hushiro Combat Semantics, Hushiro Combat Regression, Hushiro Elite Boss Progression, Post-playtest Stability, Authored Presentation Content, Kagutsuchi Region Check, Run Region Handoff, and RunScene Runtime Lifetime.
  - The supplied later September 3 Godot 4.7.2 playtest ran exact checkpoint 6c2931b5952e5a67e988cfe20ba3dd8c6af47437 and reached Keeper's persistent payout (+10 Mist / +1 keeper material / keeper_fallen) before one concrete SCRIPT ERROR stopped the run.
  - The concrete failure was HumanoidEnemyBase._run_humanoid_death_rewards passing Keeper's cached loot_base as argument 2 to spawn_experience_gem after that Object had already been freed.
  - ExperienceGem itself belongs to the broad "loot" group also used by chamber Loot containers, so first-group-member caching is not a durable boss-lifetime ownership guarantee.
  - PR #133 makes canonical Keeper refresh its reward parent at death time, preferring the live chamber node named Loot and falling back to Keeper's live parent before delegating to the inherited reward implementation.
  - HushiroCombatSemanticsSmoke now deliberately assigns Keeper a loot parent, frees it, invokes the reward path, and proves the experience gem is recovered into the live chamber Loot container without a runtime error.
  - The supplied combat_1788467816.jsonl contained 363 valid JSON rows plus one truncated final row at the crash boundary; no separate explicit telemetry error/warning was present, so no additional combat bug is inferred from that truncation alone.
  - The primary Playtest Lab Chambers tab now exposes Target Region Area 1/Hushiro, Area 2/Yomori, or Area 3/Kagutsuchi plus a chamber selector and direct warp button. The existing dedicated Regions tab remains available.
  - Direct region warps continue to use the existing region-aware GameFlow.debug_warp authority: Area 2 uses YomoriRouteAuthority and Area 3 uses KagutsuchiRouteAuthority while resetting run-scoped state for the isolated test.
  - Duplicate "New run started" startup logging was observed but not changed because no duplicated live run state was demonstrated; retain the existing guardrail against lifecycle rewrites from logging alone.
  - PR #132 remains intact and proves the real authored Twin Maws chamber initializes under Area 2 with TwinMawsManager, Rootfang, Briarthorn, BossChamber defeat authority, and defeat-signal ownership intact.
  - PR #131's debug-only OathboundPlaytestFx runtime remains observational only and is not final authored art.
recent_batches:
  - pr_133: fixed Keeper stale reward-parent death crash, added exact regression coverage, and exposed obvious direct Area 1/2/3 chamber warps.
  - pr_132: added live Area-2 Twin Maws initialization/ownership regression using the real authored chamber; no gameplay changes.
  - sept_3_playtest_latest: checkpoint 6c2931b5 reached Keeper payout then crashed in stale reward-parent handling; this is the evidence repaired by PR #133.
  - sept_3_playtest: earlier live main integration cleared Region 1/Keeper and crossed into Area 2; later-region validation remains the active evidence gap.
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
  - pr_129: repaired Collector/Keeper posture and Keeper Deathblow progression; gated inactive Area 2 duo manager startup.
  - pr_130: preemptively reconciled stale Region 2/3 hit/parry posture contracts through the shared canonical AttackEvent bridge.
  - pr_131: added temporary debug-only code-generated playtest FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #133 merged; never continue old feature branches.
  - PR #133 CI reproduces and passes the Keeper previously-freed loot-parent reward condition that crashed the supplied checkpoint 6c2931b5 playtest.
  - Playtest Lab direct Area 2/3 warps are now intentionally exposed in the primary Chambers tab; killing Keeper is not required for targeted later-region testing.
  - PR #132 CI proves the real Twin Maws authored chamber initializes correctly under Area 2 and the manager/twin/BossChamber defeat-ownership chain is intact; this does not replace manual Twin Maws combat validation.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix remain intact.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning remains evidence-driven rather than speculative.
  - Region 2/3 static audit and CI do not replace player-facing playtest validation; Region 2/3 are the active integration evidence gap.
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
