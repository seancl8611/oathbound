# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V3: machine-oriented bootstrap/state; GitHub is durable memory -->

Single durable bootstrap + live handoff for AI-assisted Oathbound work. Optimize for agent recovery/query efficiency, not human readability. For session/workflow recovery this file overrides conflicting meta-workflow guidance; owning approved design docs remain gameplay/content authority.

## BOOT
1. Fresh chat/session: fetch `main:AGENTS.md` first.
2. Parse `LIVE_STATE`; if `active_branch` is set, fetch only that branch HEAD.
3. If HEAD == `covered_through_substantive_commit`, continue from `next_action`.
4. If different, assume interrupted work; inspect only the uncovered commit range/files, reconcile state, checkpoint this file, continue.
5. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

Repository state is authority. Conversation/project memory is cache only.

## AUTONOMOUS_PR_POLICY
- Sean does **not** need to approve routine PR merges. Do not stop merely to ask whether a green PR may be merged.
- When a PR is coherent, mergeable, and its required/targeted validation is green, merge it autonomously using the exact verified head SHA.
- If CI fails, diagnose/fix it; if mergeability is uncertain, resolve it. Ask Sean only when a genuine design/product decision or external/manual evidence is required.
- Multiple PR cycles in one assistant response/session are encouraged when useful: `branch -> implement -> validate -> PR -> merge -> fresh main -> next branch`.
- Prefer substantial coherent slices, but keep PRs bounded. Never recreate a #119-style mega-PR merely to reduce PR count.
- After every autonomous merge, start subsequent implementation from the new `main`, not the merged feature branch.

## LIVE_STATE
```yaml
schema: 3
updated_utc: 2026-08-28T03:40:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 120
  feature_head: 3b24dbfa04b315273c5076e40af19dd09eba19e2
  merge_commit: a24fbed77b40c53b3b613451ba9481a0506491ab
  validation: 7/7 PR-triggered workflows green at feature head
active_branch: null
active_pr: null
covered_through_substantive_commit: null
known_good_checkpoint: a24fbed77b40c53b3b613451ba9481a0506491ab
current_objective: >-
  Continue progressing the implemented game toward the approved documentation and first
  long player-facing integration run. Work autonomously in bounded coherent PRs; merge
  green PRs without waiting for Sean. Do not guess unresolved design or numerical tuning.
next_action: >-
  Read only docs/_meta/OPEN_QUESTIONS.md plus the minimum owning authority needed to select
  the next implementation-ready slice. Create a fresh branch from current main, implement,
  validate, open/merge the PR autonomously, then continue to another coherent slice if useful.
confirmed:
  - PR #119 and PR #120 are merged; never continue either old feature branch.
  - Godot 4.7.2.
  - Techniques are slotless/unlimited; five action labels are trigger classifications, never equipment slots.
  - Blood Cavern persistence/MetaProgress isolation is green.
  - Real-player endpoint is Heart Approach/current unauthored Heart shell; do not invent Heart combat.
  - Single release-GameFlow Region 1->2->3->Heart Approach seam is covered and green.
  - Strand interaction prompts already adapt to active keyboard/controller binding.
  - Known font/music/audio/texture provenance blockers must remain explicit; never fabricate license evidence.
  - Numerical balance/economy/difficulty tuning requires player-facing evidence.
avoid_without_evidence:
  - reopening implemented combat/Aspect/Technique/Prosthetic/Relic architecture
  - authored Heart combat
  - final Blood Cavern trial count/loadouts/reward sequencing
  - numerical balance/economy changes before long integration playtest
  - waiting for Sean to approve routine PR merges
  - accumulating unrelated changes into a large PR
```

## CHECKPOINT
- `covered_through_substantive_commit` = newest active-branch code/docs commit represented above; never the control-file commit itself.
- Keep this file on `main`; implementation on feature branches.
- After each substantive batch/CI diagnosis/merge, checkpoint promptly; if tool lifetime risk rises, checkpoint before optional work.
- Before intentionally ending repo work, verify state current. Overwrite stale facts; no historical narrative.
- Interrupted recovery: inspect only uncovered commit range/files, never whole repo/PR.

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> PR -> autonomous merge -> updated main -> main:AGENTS.md`
Rules: exact-path reads; search only when path unknown/task inherently audit; targeted CI/job steps/artifacts; adjacent compares; correctness > speed; dependency-sized batches; close green PRs at logical boundaries; multiple PRs per response are allowed; never recreate mega-PR.

## DESIGN_ACCESS
- unresolved -> `docs/_meta/OPEN_QUESTIONS.md`; owner -> `docs/_meta/SOURCE_OF_TRUTH.md`; terms -> `docs/_meta/TERMINOLOGY.md`; narrow work -> exact authority only.

## ENGINEERING_GUARDS
- Project `game/oathbound/`; Godot 4.7.2. Before manual playtest, godot-project-check must pass clean import/editor compile unless unavailable and stated.
- Validate live runtime ownership, not compile alone; combat changes need telemetry for changed defense/posture/deathblow behavior.
- GDScript inference failures are hard parser failures; type Variant/Dictionary.get/untyped-call/generic-index locals.
- Defer physics registration mutation during active contact traversal. Treat freed-object/lambda errors as lifetime defects.
- Trace actual creation/caller paths; one canonical Player creation path.
- Canonical AttackEvent only; no second damage/posture pass. Posture-break/Deathblow shared state; block uses current defensive aim.
- `.godot/`/`.import/` untracked; verify source assets + clean import before declaring missing; repair stale UID refs instead of deleting assets.

## PLAYTEST_HANDOFF
When manual validation is genuinely needed, provide exact branch/head, runtime marker where relevant, systems for one coherent run, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
