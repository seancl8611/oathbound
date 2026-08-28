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
updated_utc: 2026-08-28T03:31:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 119
  feature_head: fcc6dda72efaf0cc51657ede4b9514d97332020c
  merge_commit: 959d2da7f05b9dd46b6947bc75497df1b67306fd
  validation: 12/12 workflows green at feature head
active_branch: agent/final-integration-readiness
active_pr: null
covered_through_substantive_commit: a86e3f5975b81d67320c9012b155e99951c8ce3d
known_good_checkpoint: 0ea515dc349f81a978ba0217289f7d01a82c5930
current_objective: >-
  Prepare merged build for first long player-facing integration run without guessing
  balance/reopening architecture. Current slice: final integration-readiness/release-QA,
  prototype/presentation drift cleanup, and automated regression boundaries.
next_action: >-
  Validate a86e3f59 CI, then continue bounded player-facing scene/asset audit. Fix only
  resolvable readiness defects using approved behavior/assets; record true external-art/
  provenance blockers rather than inventing replacements. No numerical tuning before playtest.
current_batches:
  - 0ea515dc: corrected stale Technique-slot art-production authorities; added Final Integration Readiness static CI; Heart test-only and attribution blocker guard.
  - a86e3f59: release wrapper replaces internal title/settings/credits engineering copy with intentional player-facing development copy; readiness guard extended.
ci_known:
  0ea515dc:
    final_integration_readiness_check: success
    godot_4_7_2_project_check: success
working_set:
  - docs/art_production/ASSET_INVENTORY.md
  - docs/art_production/milestones/MILESTONE_04.md
  - docs/art_production/milestones/MILESTONE_07.md
  - docs/external/RELEASE_ATTRIBUTION_AUDIT.md
  - game/oathbound/TitleScreen/OathboundFrontEnd.gd
  - game/oathbound/Core/Endgame/HeartEncounterShell.gd
  - game/oathbound/Core/Endgame/Validation/EndgameCampaignContractSmoke.gd
  - tools/release/check_final_integration_readiness.py
  - .github/workflows/final-integration-readiness-check.yml
confirmed:
  - PR #119 merged; never continue old branch.
  - Godot 4.7.2.
  - Techniques slotless/unlimited; five action labels are trigger classifications, never equipment slots.
  - Blood Cavern persistence/MetaProgress isolation green.
  - Real-player route ends at unauthored Heart shell; contract-test Heart completion cannot be normal gameplay.
  - Endgame smoke protects Heart completion boundary; Kagutsuchi smoke protects 11 chambers + non-counted Heart handoff + persistent build.
  - Attribution audit has unresolved font/music/audio/texture provenance blockers; never fabricate evidence.
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
- `covered_through_substantive_commit` = newest active-branch code/docs commit represented above; never control-file commit itself.
- Keep this file on `main`; implementation on feature branches.
- After each substantive batch/CI diagnosis, checkpoint promptly; if tool lifetime risk rises, checkpoint before optional work.
- Before intentionally ending repo work, verify state current. Overwrite stale facts; no historical narrative.
- Interrupted recovery: inspect only uncovered commit range/files, never whole repo/PR.

## WORK_LOOP
`main:AGENTS.md -> active HEAD -> exact authority/files -> smallest diagnostic -> coherent patch -> commit -> targeted CI -> main:AGENTS.md`
Rules: exact-path reads; search only when path unknown/task inherently audit; targeted CI/job steps/artifacts; adjacent compares; correctness > speed; dependency-sized batches; close green PRs at logical boundaries; never recreate mega-PR.

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
When manual validation is genuinely needed, provide exact branch/head, runtime marker where relevant, systems for one coherent run, telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
