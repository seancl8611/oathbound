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
updated_utc: 2026-08-29T18:12:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 128
  feature_head: 5b76be7f9724e334de80ec430baa1c6182333741
  merge_commit: 84469b1b584852176e7ad7654192fb2208eabaef
  validation: 7/7 final-head push workflows green; 9/9 PR-triggered workflows green; mergeable_state clean
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: 84469b1b584852176e7ad7654192fb2208eabaef
current_objective: >-
  Gather the next coherent player-facing integration evidence from main after the Aug 29 follow-up stabilization pass.
  The latest supplied log is materially clean: no SCRIPT ERROR/ERROR/WARNING signature, and the false +90 Spirit
  bootstrap popup is now fixed. Continue evidence-driven integration validation rather than speculative tuning.
next_action: >-
  On the next meaningful playtest, use `oathbound-playtest.cmd main` and wait for IMPORT PREFLIGHT PASSED. Confirm that
  entering The Strand and beginning a run no longer displays a false +90 Spirit popup, while real Spirit restoration
  can still produce legitimate gain feedback. Continue the broader run through normal combat, rewards, rooms, bosses,
  transitions, death/return, and toward Region 1 -> Region 2 -> Region 3 -> Heart Approach or until a genuine blocker.
  Preserve the Godot log, CombatTelemetry, IntegrationCheckpoint markers, and run-performance summary when available.
current_batch:
  - PR #128 merged from exact feature head 5b76be7f9724e334de80ec430baa1c6182333741 at merge commit 84469b1b584852176e7ad7654192fb2208eabaef.
  - Aug 29 follow-up Godot log from main 6e4caaca594220cdfd1b22c8265be0a6454271d8 contains no SCRIPT ERROR, ERROR, or WARNING entries; prior death crash and Rest ownership warning did not recur.
  - Combat telemetry contains no repeated Spirit award/mutation signal. The observed +90 popup was presentation-only bootstrap feedback, not an economy/resource award.
  - Root cause: player.tscn used the imported 10-Spirit compatibility baseline before current Oathbound rules promoted the Player to canonical 100 Spirit during _ready(), making bootstrap synchronization look like a +90 pickup.
  - OathboundPlayerStability now silently synchronizes the ProstheticExecutor child to CURRENT_MAX_SPIRIT before inherited HUD construction, covering both Strand player.tscn and run aspect_player.tscn inheritance paths.
  - RunHUDRewardSurfaceSmoke instantiates both live Player paths, requires bootstrap 100/100 with no popup, requires no popup on a decrease, and separately proves 90/100 -> 100/100 still shows a real +10 gain.
  - Exact feature head passed all 7 push-triggered workflows; PR #128 passed all 9 PR-triggered workflows, including Release Shell, both Hushiro gates, runtime lifetime, region handoff, post-playtest stability, Blood Cavern execution, authored presentation, and Godot 4.7.2 Project Check.
  - The same playtest log prints New run started three times during overwrite/startup. This was traced to pre-departure save-slot run-scope resets plus the real RunScene departure reset. No duplicated live run state or Spirit award was observed, so save-slot lifecycle ownership remains unchanged without stronger evidence.
recent_batches:
  - pr_126: first long-playtest stabilization for death/run-results, fresh-save routing, Archer projectile defense, and Rest gate ownership.
  - pr_127: restored approved direct first-attempt run start while preserving the other PR #126 stabilization fixes.
  - pr_128: suppressed false Spirit bootstrap feedback while preserving real Spirit gain presentation.
confirmed:
  - PR #119 through #128 merged; never continue old feature branches.
  - FIRST_ATTEMPT authority says first playable control begins directly in the normal Hushiro route at or immediately before Chamber 1; first death awakens Returning Blood and reconstructs at The Strand.
  - PR #126's failed-run Heart Binding API fix, Archer block-vs-parry projectile fix, and Rest duplicate gate-ownership fix remain intact.
  - Follow-up Aug 29 playtest showed no new runtime error/warning signature in the provided Godot log.
  - DamageNumberManager rejects zero/non-HP values; EnemyBase floating numbers use actual applied HP loss.
  - Techniques slotless/unlimited.
  - Heart combat unauthored; do not invent it.
  - Numerical balance/economy/difficulty tuning remains evidence-driven rather than speculative.
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
