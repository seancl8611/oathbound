# OATHBOUND_AGENT_CONTROL_PLANE

<!-- OATHBOUND_AGENT_CONTROL_PLANE_V1 -->

This file is the single durable bootstrap + live handoff for AI-assisted Oathbound development. It is intentionally optimized for agent retrieval/recovery, not normal human repository reading. For assistant workflow/session recovery, this file overrides conflicting workflow guidance elsewhere in the repo. Gameplay/design authority still belongs to the approved owning design documents.

## SESSION_BOOTSTRAP

MANDATORY for every new chat/session before broad repo/PR/history inspection:

1. Fetch `AGENTS.md` from default branch `main`.
2. Parse `LIVE_STATE` below.
3. Fetch only the head of `active_branch`.
4. If branch HEAD == `covered_through_substantive_commit`: state is synchronized; continue from `next_action`.
5. If branch HEAD != `covered_through_substantive_commit`: assume prior session may have been interrupted. Inspect ONLY commits/files in `covered_through_substantive_commit..HEAD`, reconcile `LIVE_STATE`, checkpoint this file on `main`, then continue.
6. Read exact working-set files and only the authoritative design docs needed for the active task.
7. Never ask Sean to restate context that can be recovered by this protocol.

DO NOT use conversational memory as project state authority. Chat/project memory is a hint/cache only. Current GitHub state + this file win.

## LIVE_STATE

```yaml
state_schema: 1
state_updated_utc: 2026-08-28T02:13:00Z
control_ref: main
repo: seancl8611/oathbound
active_branch: agent/runtime-lifetime-reconciliation
active_pr: 119
covered_through_substantive_commit: 9a42a3ba8f4c57bf1fd5a74d4be4f3812c65ed97
known_good_checkpoint: a4b4313f2af66b47e0a541592683ac79df606c45

current_objective: >-
  Finish Blood Cavern fixed-trial-loadout persistence/lifetime isolation on PR #119,
  currently blocked only by the durable mutation smoke failure.
next_action: >-
  Download/read the small blood-cavern-runtime-logs artifact from failed run 33124240603,
  inspect blood-cavern-durable-mutation.log, identify the exact assertion/runtime error,
  then patch only the relevant Prosthetic/Relic durable-vs-temporary mutation boundary.

ci:
  commit: 9a42a3ba8f4c57bf1fd5a74d4be4f3812c65ed97
  workflows_total: 12
  passing: 11
  failing: 1
  failing_workflow: Blood Cavern Execution Trial Check
  failing_run_id: 33124240603
  failing_job_id: 98698390129
  failing_step: Verify durable trial mutation isolation
  artifact_id: 9667693788
  artifact_name: blood-cavern-runtime-logs
  target_log: blood-cavern-durable-mutation.log

working_set:
  - game/oathbound/Core/Trials/BloodCavernTrialLoadoutSandbox.gd
  - game/oathbound/Core/Progression/OathboundPersistentProstheticManager.gd
  - game/oathbound/autoload/ProstheticManager.gd
  - game/oathbound/Core/Release/OathboundSlotRelicRuntime.gd
  - game/oathbound/Core/Release/Validation/BloodCavernTrialDurableMutationSmoke.gd
  - game/oathbound/Core/Release/Validation/BloodCavernTrialLoadoutSandboxSmoke.gd
  - game/oathbound/Core/Release/Validation/BloodCavernTrialLoadoutLifecycleSmoke.gd
  - game/oathbound/Core/Release/Validation/BloodCavernExecutionTrialSmoke.gd
  - game/oathbound/World/OathboundBloodCavern.gd
  - game/oathbound/World/BloodCavern.gd
  - .github/workflows/blood-cavern-execution-trial-check.yml

confirmed_state:
  - Godot baseline is 4.7.2.
  - Technique collection is slotless/unlimited; never reintroduce Technique slots/caps.
  - Blood Cavern fixed trial sandbox supports temporary Aspect/Tier/Blood, unlimited Techniques, Prosthetic, Relic.
  - Permanent/direct progression writes must be blocked during active fixed-trial sandbox.
  - Trial-local/runtime Prosthetic selection/cooldown state must remain writable.
  - Restore exact temporary + durable state before legitimate first-clear reward processing.
  - Do not invent unresolved authored fixed-loadout IDs, final trial count, mastery currency, or reward sequencing.
  - Execution Trial completion requires real receive_deathblow; health-only defeat resets target.

current_hypothesis_unconfirmed:
  - Durable mutation guard may be too broad and may block sanctioned temporary/runtime mutation,
    or deferred campaign Forge sync may be escaping the suppression boundary.
  - Confirm from target log before editing.

do_not_reopen_without_evidence:
  - Technique slot/cap architecture.
  - Unrelated combat architecture while current failure is Blood Cavern persistence isolation.
  - Final authored Blood Cavern fixed loadout IDs/count/reward sequencing.

tooling_performance_context:
  pr_119_commits: 298
  pr_119_changed_files: 129
  pr_119_additions: 13229
  pr_119_deletions: 1368
  repo_size_kb_approx: 16730
  conclusion: >-
    Repo size is not the main bottleneck. Mega-PR/full-diff/full-log payloads are.
    Work in bounded exact-file/adjacent-commit mode. Once PR #119 is green/stable,
    finish it instead of continuing to grow it.
```

## CHECKPOINT_PROTOCOL

`AGENTS.md` on `main` is the durable control plane even while implementation occurs on feature branches.

- `covered_through_substantive_commit` means: newest active-branch code/docs commit whose effects are represented in `LIVE_STATE`.
- It intentionally does NOT point at the commit that updates this control file; this avoids self-referential SHA problems.
- Live state updates are written to `main`, not to the active feature branch. This is an intentional meta-workflow exception so a fresh session always has one stable entry point.
- Feature branches should not modify `AGENTS.md` merely to update live state.
- After every substantive implementation commit/batch, update `LIVE_STATE` promptly before starting another large investigation.
- After CI, telemetry, or diagnosis materially changes `next_action`, checkpoint `LIVE_STATE` promptly.
- Before intentionally ending repo work, verify `LIVE_STATE` is current.
- If tool lifetime/budget appears at risk, checkpoint state BEFORE optional follow-up investigation.
- Keep `LIVE_STATE` compact and overwrite stale facts. Do not grow it into a historical narrative.

### Interrupted-session recovery

If `active_branch` HEAD is ahead of `covered_through_substantive_commit`:

1. Do NOT rescan the repo or full PR.
2. Compare/fetch only the uncovered commit range.
3. Read only changed files needed to understand those uncovered commits.
4. Reconcile the state block.
5. Update this file on `main`.
6. Resume from the recovered next action.

If the recorded active branch no longer exists or PR is merged/closed, use minimal PR/branch metadata to identify the successor and update state before broad work.

## WORKING_SET_PROTOCOL

Default development loop:

`main:AGENTS.md -> active branch HEAD -> exact affected files -> smallest diagnostic artifact -> patch -> coherent commit -> targeted CI -> main:AGENTS.md checkpoint`

Rules:

- Prefer exact-path `fetch_file` when a path is known.
- Prefer tiny branch-head metadata over full PR metadata.
- Prefer commit-specific workflow summaries, failed job steps, and small uploaded artifacts over full workflow/job logs.
- Prefer `covered_through_substantive_commit..HEAD` or adjacent/checkpoint compares over branch-vs-main mega compares.
- Search only when the owner/path is actually unknown. Narrow repository scope and terms.
- Do not fetch a full PR diff/patch, all changed-file patches, or hundreds of commits merely to orient a new session.
- Do not treat an empty search result as proof of absence.
- Broader audits are allowed only when the task itself requires repository-wide reconciliation; they are not a session-start ritual.
- For huge PRs, final review should still be bounded by authorities/risk areas and CI evidence; avoid repeatedly materializing the entire patch through the connector.

## DEVELOPMENT_STRATEGY

- Sean intentionally starts fresh ChatGPT chats/sessions frequently as chats become large/slow. Design all agent process around that fact.
- Optimize repository metadata/process for AI retrieval efficiency over conventional human readability.
- Prefer coherent dependency-sized implementation batches and longer telemetry-backed playtests over one-error-at-a-time trial-and-error PR churn.
- Correctness > speed, but do not require Sean to manually playtest every small change when CI/spec authority can validate it.
- Do not allow a coherent PR to become indefinitely large. Once a logical slice is green/stable, finish it and continue on a fresh branch/PR.
- When several playtest defects arrive together, inspect the complete supplied telemetry capture and group related fixes into a stabilization batch.

## DESIGN_AUTHORITY_ACCESS

Do not preload multiple meta docs every session. Read them only when needed:

- unresolved design question -> `docs/_meta/OPEN_QUESTIONS.md`
- need owning authority -> `docs/_meta/SOURCE_OF_TRUTH.md`
- ambiguous/deprecated terminology -> `docs/_meta/TERMINOLOGY.md`
- broad game-wide scope/identity change -> overview authority docs
- narrow implementation with known owning docs -> fetch those exact docs only

Approved gameplay docs are design authority. Imported/legacy code is compatibility plumbing only when a current Oathbound layer still depends on it.

## ENGINEERING_GUARDRAILS

### Project / validation

- Active Godot project: `game/oathbound/`.
- Pinned engine: Godot 4.7.2.
- Before asking Sean to pull/playtest Godot code, `.github/workflows/godot-project-check.yml` must pass clean import + editor load/compile unless CI is unavailable; if unavailable, state that explicitly.
- Validate runtime ownership, not compilation alone. Use runtime markers/telemetry where ownership matters.
- Combat changes require telemetry that distinguishes changed behavior (`block_success`, posture delta/break, Deathblow-ready entry, active Player script, etc.).
- GitHub mergeability alone is not playtest readiness.

### GDScript 4.7.2

- `Cannot infer the type of ...` is a hard parser error.
- Explicitly type locals fed by Variant, `Dictionary.get()`, untyped inherited calls/properties, conditional expressions, generic indexing, etc.
- Warning suppression must not hide parser/type failures.
- On inheritance failures, fix the first/root parent parser error before rewriting children.

### Physics/signal mutation

- Do not synchronously mutate `Area2D.monitoring`, `monitorable`, collision disabled state, or similar physics registration from active contact/signal traversal.
- Use deferred mutation/teardown (`set_deferred`, `call_deferred`, deferred `queue_free`).

### Runtime ownership

- Never assume an autoload/override owns runtime merely because it compiles; trace creation paths.
- Maintain one canonical Player creation path.
- Validate live caller/owner paths for Player, Technique, Aspect, Prosthetic, enemy, reward, and route authorities.

### Combat contract

- Canonical sword contacts use canonical `AttackEvent` fields; do not apply a second independent posture/damage scaling pass.
- Track authored posture, actual applied posture delta, and posture-break entry separately from between-hit recovery.
- Enemy posture break is shared real state and must expose Deathblow readiness for the approved duration.
- Child hurt/stagger reactions must not overwrite shared posture-break/Deathblow-ready state.
- Sustained block uses current defensive aim/facing, not stale movement facing.
- Parry/block/posture break/Deathblow execution stay shared across Wolf/Wraith/Ronin unless approved docs explicitly say otherwise.

### Resources/import

- `.godot/` and `.import/` stay untracked.
- Verify source assets exist in Git + clean CI import before declaring missing assets.
- Repair stale UID/resource references when practical; do not delete source textures merely to silence warnings.

## PLAYTEST_HANDOFF

When a playtest is genuinely needed, provide:

- exact branch;
- expected head SHA when useful;
- expected active runtime marker/script where relevant;
- meaningful systems to exercise in one longer run;
- telemetry/log files to return.

Do not fall back to tiny repeated manual playtests when a larger coherent validation pass is more efficient.
