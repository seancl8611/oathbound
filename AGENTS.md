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
updated_utc: 2026-09-03T15:32:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 131
  feature_head: c1c2116f9056a6bf3065c6fdc4da91bbc34f2716
  merge_commit: a169572df3ebf67e6e3862880e947aedf2f50a54
  validation: 7/7 PR-triggered workflows green; mergeable true
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: e71fbb362fd0d9e2a921fb8b7f009e76cb5b7123
current_objective: >-
  Continue player-facing integration evidence from the September 3 corrected-main playtest into Yomori/Region 2 and then Kagutsuchi/Region 3.
  Hushiro/Region 1 is now live-playtest proven through Keeper and the region handoff. Region 2 and Region 3 received the preemptive shared
  posture-contract audit in PR #130, but their full player-facing behavior still requires real evidence. Keep the temporary debug-only
  procedural FX active so Techniques, Aspects, Prosthetics, statuses, vulnerable/backstab state, and Deathblow opportunities can be compared
  against the underlying combat events while progressing through later regions.
next_action: >-
  Resume from the Area 2 handoff reached by the September 3 playtest and continue through Yomori/Region 2, including Twin Maws if reached.
  Player invulnerability may stay enabled for broad encounter coverage. Exercise Technique families, all available Aspect/Prosthetic effects,
  ordinary sword hits, parries, blocking, posture breaks, Deathblows, room clear/progression, and rewards. Watch specifically for either
  (a) an underlying effect firing with no readable procedural cue or (b) a cue appearing when the underlying effect did not occur. Preserve
  CombatTelemetry/logs and stop at the first genuine blocker. If Region 2 completes cleanly, continue into Kagutsuchi/Region 3 in the same
  integration pass rather than restarting Hushiro. Do not treat the temporary procedural FX as final authored art.
current_batch:
  - September 3 manual integration playtest ran exact main checkpoint e71fbb362fd0d9e2a921fb8b7f009e76cb5b7123 on Godot 4.7.2 with CombatTelemetry and PlaytestFx initialized.
  - The September 3 run cleared Hushiro/Region 1 through Keeper and reached run stage region_1_complete with boss defeat count 1 for Region 1, Keeper material 1, Mist 10, and the Keeper Fallen progression flag recorded.
  - The same run advanced into SceneRegistry area 2, instantiated combat content including TwinMawsChamber, and reached the next route choice [combat:gold, rest] before the captured evidence ended.
  - The retrieved September 3 runtime excerpt contains no concrete SCRIPT ERROR, assertion failure, or warning blocker. The JSONL event rows were not available in-session, so no unobserved combat-contract or procedural-FX mismatch is being inferred from the summary alone.
  - PR #131 merged from exact feature head c1c2116f9056a6bf3065c6fdc4da91bbc34f2716 at merge commit a169572df3ebf67e6e3862880e947aedf2f50a54.
  - PR #131 passed all 7 PR-triggered workflows, including Playtest Procedural FX Check, Godot 4.7.2 Project Check, Hushiro Combat Semantics, RunScene Runtime Lifetime, Run Region Handoff, Post-playtest Stability, and Authored Presentation Content.
  - Added a debug-only OathboundPlaytestFx runtime under the current TechniqueEffects autoload; release builds do not instantiate the temporary layer.
  - All temporary FX are generated entirely in Godot code with CanvasItem drawing primitives; no external textures, spritesheets, shaders, particles, or user-supplied visual assets are required.
  - Technique readability includes persistent and transient cues for Echo, Rupture, Seal/Bind, Rift, Vulnerable, Shock, Burn, Aspect slow, Deathblow readiness, Unseen, and Bloodletting while retaining terse TechniqueStatus text as a diagnostic fallback.
  - Added code-drawn activation silhouettes for all eight current Prosthetics: Beast Whistle, Thunder Rod, Smoke Gourd, Fang Harpoon, Mirror Umbrella, Flame Vent, Mist Raven, and Bloodletting Gourd.
  - Added temporary Aspect/Blood Art cues for Wolf, Wraith, and Ronin, including Blood Art readiness plus Blood Hunt, Wraith Reach corridor, and Falling Mountain silhouettes.
  - The FX layer is observational only and does not mutate damage, Posture, combat timing, status ownership, rewards, progression, or encounter behavior.
recent_batches:
  - sept_3_playtest: live main integration cleared Region 1/Keeper and crossed into Area 2; later-region validation is now the active evidence gap.
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
  - pr_129: repaired Collector/Keeper posture and Keeper Deathblow progression; gated inactive Area 2 duo manager startup.
  - pr_130: preemptively reconciled stale Region 2/3 hit/parry posture contracts through the shared canonical AttackEvent bridge.
  - pr_131: added temporary debug-only code-generated playtest FX for Techniques, Aspects, Prosthetics, statuses, and Deathblow readability.
confirmed:
  - PR #119 through #131 merged; never continue old feature branches.
  - September 3 live playtest proves current main can clear Hushiro/Region 1 through Keeper and enter Area 2 without the prior Region 1 progression blocker recurring.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix remain intact.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning remains evidence-driven rather than speculative.
  - Region 2/3 static audit and CI do not replace player-facing playtest validation; Region 2/3 are now the active integration evidence gap.
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
