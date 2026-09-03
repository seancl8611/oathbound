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
updated_utc: 2026-09-03T18:25:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 132
  feature_head: ae900eaf161dc02652efb698fcbe84b5587a375d
  merge_commit: 1cf77288a1025d254cab7853bf739ccef484e680
  validation: 7/7 PR-triggered workflows green; mergeable true
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 1cf77288a1025d254cab7853bf739ccef484e680
current_objective: >-
  Continue player-facing integration evidence from the September 3 corrected-main playtest into Yomori/Region 2 and then Kagutsuchi/Region 3.
  Hushiro/Region 1 is live-playtest proven through Keeper and the region handoff. PR #132 now also proves the real authored Twin Maws chamber
  initializes under Area 2 with TwinMawsManager, Rootfang, Briarthorn, BossChamber defeat authority, and defeat-signal ownership intact.
  Region 2 and Region 3 still require player-facing combat evidence. Keep the temporary debug-only procedural FX active so Techniques, Aspects,
  Prosthetics, statuses, vulnerable/backstab state, and Deathblow opportunities can be compared against the underlying combat events.
next_action: >-
  Resume from the Area 2 handoff reached by the September 3 playtest and continue through Yomori/Region 2, including Twin Maws.
  Player invulnerability may stay enabled for broad encounter coverage. Exercise the Area 2 ordinary roster, Technique families, all available
  Aspect/Prosthetic effects, ordinary sword hits, parries, blocking, posture breaks, Deathblows, room clear/progression, rewards, and the real
  Twin Maws fight. Watch specifically for either (a) an underlying effect firing with no readable procedural cue or (b) a cue appearing when
  the underlying effect did not occur. Preserve CombatTelemetry/logs and stop at the first genuine blocker. If Region 2 completes cleanly,
  continue into Kagutsuchi/Region 3 in the same integration pass rather than restarting Hushiro. Do not treat temporary procedural FX as final art.
current_batch:
  - PR #132 merged from exact feature head ae900eaf161dc02652efb698fcbe84b5587a375d at merge commit 1cf77288a1025d254cab7853bf739ccef484e680.
  - PR #132 passed all 7 PR-triggered workflows, including Yomori Region Check and Godot 4.7.2 Project Check.
  - TwinMawsContractSmoke now instantiates the real authored TwinMawsChamber while RunData.current_area_id=2 and waits through its actual runtime initialization.
  - The live regression proves TwinMawsManager becomes boss authority, binds Rootfang and Briarthorn bidirectionally, remains assigned to both real twins, is selected by BossChamber, and owns the chamber defeat signal.
  - PR #132 changes validation only: no gameplay behavior, combat values, encounter tuning, Aspect/Technique/Prosthetic architecture, or progression ownership changed.
  - September 3 manual integration playtest ran exact main checkpoint e71fbb362fd0d9e2a921fb8b7f009e76cb5b7123 on Godot 4.7.2 with CombatTelemetry and PlaytestFx initialized.
  - The September 3 run cleared Hushiro/Region 1 through Keeper, reached region_1_complete, advanced into SceneRegistry area 2, instantiated Area 2 content including TwinMawsChamber, and reached the next route choice [combat:gold, rest].
  - The retrieved September 3 runtime excerpt contains no concrete SCRIPT ERROR, assertion failure, or warning blocker. The JSONL event rows were not available in-session, so no unobserved combat-contract or procedural-FX mismatch is inferred from the summary alone.
  - PR #131's debug-only OathboundPlaytestFx runtime remains active in debug builds and observational only; release builds do not instantiate it.
recent_batches:
  - pr_132: added live Area-2 Twin Maws initialization/ownership regression using the real authored chamber; no gameplay changes.
  - sept_3_playtest: live main integration cleared Region 1/Keeper and crossed into Area 2; later-region validation is now the active evidence gap.
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
  - pr_129: repaired Collector/Keeper posture and Keeper Deathblow progression; gated inactive Area 2 duo manager startup.
  - pr_130: preemptively reconciled stale Region 2/3 hit/parry posture contracts through the shared canonical AttackEvent bridge.
  - pr_131: added temporary debug-only code-generated playtest FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #132 merged; never continue old feature branches.
  - September 3 live playtest proves current main can clear Hushiro/Region 1 through Keeper and enter Area 2 without the prior Region 1 progression blocker recurring.
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
