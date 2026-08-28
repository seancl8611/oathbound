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
updated_utc: 2026-08-28T03:38:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 119
  merge_commit: 959d2da7f05b9dd46b6947bc75497df1b67306fd
active_branch: agent/final-integration-readiness
active_pr: null
covered_through_substantive_commit: 3b24dbfa04b315273c5076e40af19dd09eba19e2
known_good_checkpoint: a86e3f5975b81d67320c9012b155e99951c8ce3d
current_objective: >-
  Prepare merged build for first long player-facing integration run without guessing
  balance/reopening architecture. Current slice: final integration-readiness/release-QA,
  presentation drift cleanup, and missing cross-system runtime regression boundaries.
next_action: >-
  Validate 3b24dbfa CI, especially Run Region Handoff Check and Godot 4.7.2 Project Check.
  If green, continue bounded readiness audit; if the slice is coherent/green, create a
  small PR rather than growing this branch. No numerical tuning before playtest evidence.
current_batches:
  - 0ea515dc: corrected stale Technique-slot art-production authorities; added Final Integration Readiness static CI; Heart test-only + attribution blocker guard.
  - a86e3f59: cleaned player-facing title/settings/credits engineering copy; readiness guard extended.
  - 3b24dbfa: added single release-GameFlow Region 1->2->3->Heart Approach smoke; verifies 33rd counted Shogun chamber exactly once, build continuity, safe Relic transitions, one Heart handoff, no Heart combat simulation.
ci_known:
  a86e3f59:
    workflows_total: 7
    failures: 0
    final_integration_readiness_check: success
    release_shell_check: success
    godot_4_7_2_project_check: success
    run_region_handoff_check: success
working_set:
  - game/oathbound/Core/Release/Validation/OathboundFullRunHandoffHarness.gd
  - game/oathbound/Core/Release/Validation/FullRunHeartHandoffSmoke.gd
  - game/oathbound/Core/Release/Validation/FullRunHeartHandoffSmoke.tscn
  - .github/workflows/run-region-handoff-check.yml
  - game/oathbound/TitleScreen/OathboundFrontEnd.gd
  - tools/release/check_final_integration_readiness.py
  - docs/art_production/ASSET_INVENTORY.md
  - docs/art_production/milestones/MILESTONE_04.md
confirmed:
  - PR #119 merged; never continue old branch.
  - Godot 4.7.2.
  - Techniques slotless/unlimited; five action labels are trigger classifications, never equipment slots.
  - Blood Cavern persistence/MetaProgress isolation green.
  - Real-player endpoint is Heart Approach/current unauthored Heart shell; do not simulate/invent Heart combat.
  - Endgame smoke protects contract-test Heart completion; Kagutsuchi smoke protects physical 11-chamber -> Heart seam.
  - New 3b24dbfa smoke closes missing single-release-GameFlow 1->2->3->Heart seam, pending CI.
  - Strand main background hub.png is a known attribution/provenance blocker; do not fabricate replacement/license evidence.
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
