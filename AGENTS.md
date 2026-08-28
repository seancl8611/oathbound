# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V2: machine-oriented bootstrap/state; GitHub is durable memory -->

Single durable bootstrap + live handoff for AI-assisted Oathbound work. Optimize for agent recovery/query efficiency, not human readability. For session/workflow recovery this file overrides conflicting meta-workflow guidance; owning approved design docs remain gameplay/content authority.

## BOOT
1. Fresh chat/session: fetch `main:AGENTS.md` first.
2. Parse `LIVE_STATE`; fetch only `active_branch` HEAD.
3. If HEAD == `covered_through_substantive_commit`, continue from `next_action`.
4. If different, assume interrupted work; inspect only `covered_through_substantive_commit..HEAD`, reconcile state, checkpoint this file, continue.
5. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

Repository state is authority. Conversation/project memory is cache only.

## LIVE_STATE
```yaml
schema: 2
updated_utc: 2026-08-28T03:17:00Z
repo: seancl8611/oathbound
control_ref: main

merged_cutoff:
  pr: 119
  feature_head: fcc6dda72efaf0cc51657ede4b9514d97332020c
  merge_commit: 959d2da7f05b9dd46b6947bc75497df1b67306fd
  validation: 12/12 workflows green at feature head

active_branch: agent/final-integration-readiness
active_pr: null
covered_through_substantive_commit: 959d2da7f05b9dd46b6947bc75497df1b67306fd
known_good_checkpoint: fcc6dda72efaf0cc51657ede4b9514d97332020c

current_objective: >-
  Prepare the merged build for the first long player-facing integration run without
  guessing balance or reopening implemented architecture. Execute a coherent final
  integration-readiness/release-QA slice, beginning with the approved final
  presentation-art/prototype replacement audit and current Heart-shell boundary.
next_action: >-
  Audit authoritative asset/release requirements against actual player-facing runtime
  references. Identify prototype/placeholder presentation still visible, stale superseded
  UI/art language, or release blockers resolvable from existing approved assets/authorities.
  Add bounded automated regression coverage where practical. Do not tune numerical
  balance/economy until playtest evidence exists.

working_set_seed:
  - docs/_meta/OPEN_QUESTIONS.md
  - docs/_meta/SOURCE_OF_TRUTH.md
  - docs/art_production/ASSET_INVENTORY.md
  - docs/overview/ENDGAME_POSTGAME_RELEASE.md
  - docs/external/RELEASE_ATTRIBUTION_AUDIT.md
  - player-facing scenes/scripts/assets discovered by bounded audit

confirmed:
  - PR #119 is merged; never continue agent/runtime-lifetime-reconciliation.
  - Godot baseline 4.7.2.
  - Techniques are slotless/unlimited; never reintroduce slots/caps.
  - Blood Cavern fixed-loadout persistence/MetaProgress isolation is green.
  - Real-player route currently ends at Heart shell; Heart combat is unauthored.
  - Contract-test Heart completion must never become normal player victory.
  - Final integration/playtest tuning is the active approved milestone.
  - Numerical balance/economy/difficulty tuning requires player-facing evidence.

avoid_without_evidence:
  - reopening implemented combat/Aspect/Technique/Prosthetic/Relic architecture
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - numerical balance/economy changes before long integration playtest

tooling:
  default: exact-file + adjacent-commit + targeted-CI/artifact
  avoid: mega-PR diffs, full logs, broad history reconstruction
```

## CHECKPOINT
- `covered_through_substantive_commit` = newest active-branch code/docs commit represented above; never the control-file commit itself.
- Keep this file on `main`; implementation stays on feature branches.
- After each substantive batch, checkpoint before another large investigation.
- After CI/telemetry/diagnosis changes `next_action`, checkpoint promptly.
- If tool lifetime risk rises, checkpoint before optional follow-up work.
- Before intentionally ending repo work, verify state is current.
- Overwrite stale facts; do not grow historical narrative here.
- Interrupted recovery = inspect only uncovered commit range/files, never whole repo/PR.

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> main:AGENTS.md`

Rules: exact-path reads when known; search only when path/owner unknown or task is inherently an audit; prefer commit workflow summaries/job steps/small artifacts over full logs; use adjacent/checkpoint compares; broad audits only when the task itself requires one; correctness > speed; dependency-sized batches; close green PRs at logical boundaries and never recreate a mega-PR.

## DESIGN_ACCESS
- unresolved question -> `docs/_meta/OPEN_QUESTIONS.md`
- authority owner -> `docs/_meta/SOURCE_OF_TRUTH.md`
- terminology ambiguity -> `docs/_meta/TERMINOLOGY.md`
- broad identity/scope -> owning overview docs
- narrow implementation -> exact owning docs only

## ENGINEERING_GUARDS
- Project `game/oathbound/`; Godot 4.7.2.
- Before manual Godot playtest, `godot-project-check.yml` must pass clean import + editor load/compile unless CI unavailable and explicitly stated.
- Validate live runtime ownership, not compilation alone; use markers/telemetry where needed.
- Combat changes need telemetry distinguishing block/parry/posture/deathblow behavior.
- GDScript `Cannot infer the type` is hard parser failure; explicitly type Variant/Dictionary.get/untyped-call/generic-index locals.
- Never synchronously mutate Area2D monitoring/collision registration during active contact/signal traversal; defer it.
- Freed-object/lambda ownership errors are runtime-lifetime defects.
- Trace actual creation/caller paths; maintain one canonical Player creation path.
- Canonical sword contacts use canonical AttackEvent fields; no second independent damage/posture pass.
- Posture-break/Deathblow-ready is shared state; child hurt reactions cannot overwrite it.
- Sustained block uses current defensive aim/facing.
- Parry/block/posture break/Deathblow stay shared across Wolf/Wraith/Ronin unless authority says otherwise.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing; repair stale UID references rather than deleting assets to silence warnings.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact branch/head, expected runtime marker where relevant, systems to exercise in one coherent run, and telemetry/log files to return. Prefer one larger integration pass over repeated micro-playtests.
