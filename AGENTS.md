# OATHBOUND_AGENT_CONTROL_PLANE

<!-- V4: machine-oriented bootstrap/state + turn-survival protocol; GitHub is durable memory -->

Single durable bootstrap + live handoff for AI-assisted Oathbound work. Repository state is authority; conversation/project memory is cache only.

## BOOT
1. Fresh session: fetch `main:AGENTS.md` first.
2. If `active_branch` is set, fetch only that HEAD.
3. If HEAD matches `covered_through_substantive_commit`, continue from `next_action`; otherwise inspect only the uncovered range/files and reconcile.
4. Fetch exact working-set files + only needed authorities. Never ask Sean to restate recoverable repo context.

## AUTONOMOUS_PR_POLICY
- Routine coherent PR merge approval is not required.
- Coherent + mergeable + required validation green => merge autonomously with exact verified head SHA.
- Diagnose failed CI/mergeability instead of asking.
- Branch subsequent work from updated `main`; never continue old feature branches.

## TURN_SURVIVAL_POLICY
- A turn succeeds only if both repo state and the user-visible handoff survive.
- After every merged PR or other major durable milestone: update `AGENTS.md`, then report the safe checkpoint and next recoverable action.
- Normally complete at most 1 CI-heavy PR or 2 light/bounded PRs per turn unless prior cycles were cheap and execution headroom is ample.
- Minimize CI polling; inspect targeted failing/incomplete workflows rather than repeatedly reading everything.

## LIVE_STATE
```yaml
schema: 4
updated_utc: 2026-09-10T02:01:00Z
repo: seancl8611/oathbound
control_ref: main
merged_cutoff:
  pr: 146
  feature_head: bf4c30b663dbe3866e2c53acbdd5395d08e22f27
  merge_commit: 2441046c5803e7608e39993e89805c80bbfdf4f0
  validation: 6/6 PR-triggered workflows green on exact feature head — Hushiro Combat Semantics, Authored Presentation Content, Region Transition Presentation, Run Region Handoff, Post-playtest Stability, and Godot 4.7.2 Project Check
active_branch: null
active_pr: null
covered_through_substantive_commit: 2441046c5803e7608e39993e89805c80bbfdf4f0
known_good_checkpoint: 2441046c5803e7608e39993e89805c80bbfdf4f0
current_objective: >-
  Final integration / playtest tuning with documentation and implementation status synchronized. PR #146 reconciled GAME_OVERVIEW, FULL_GAME_SCOPE, PRODUCTION_ROADMAP, ENDGAME_POSTGAME_RELEASE, and the documentation changelog with the already-authoritative OPEN_QUESTIONS implementation boundary. The broad documentation-to-code audit is closed: there is no currently identified implementation-ready feature package missing from code. The major intentional gameplay-content gap is the true-final Heart encounter, whose authority deliberately does not yet define an implementation-ready moveset/arena/tuning package.
next_action: >-
  Do not reopen a broad repo/documentation audit. For PR #143, only revisit the shared Hushiro cue or Eclipse Shogun Timeless Zone if Sean reports a concrete visual defect; telemetry/runtime behavior is otherwise validated. The next evidence-backed production work is either (a) one long real-player integration pass from release front end through the current Heart shell boundary for persistence/pacing/readability/economy/feel, or (b) a dedicated design pass for the true-final Heart encounter before any Heart combat implementation. Do not invent Heart attacks in code before that design authority is expanded.
current_batch:
  - PR #146 merged at 2441046c5803e7608e39993e89805c80bbfdf4f0 from exact head bf4c30b663dbe3866e2c53acbdd5395d08e22f27; all 6 triggered workflows green.
  - PR #146 is documentation/status reconciliation only. It changes no gameplay mechanics, scope counts, balance values, or Heart encounter details.
  - Updated top-level status-bearing authorities now consistently say the current phase is final integration/playtest tuning/production polish rather than Godot reconciliation or implementation restart.
  - GAME_OVERVIEW now records authored regional encounter pools/runtime integration and identifies final integration plus Heart encounter design as current work.
  - FULL_GAME_SCOPE now records that player-build systems, all three regional routes, first-attempt/Strand/campaign flow, release shell, records/settings/accessibility surfaces, and Shogun-to-Heart shell are implemented at first-playtest/release-contract depth.
  - PRODUCTION_ROADMAP now marks Hushiro, Strand, player-build systems, Yomori, Kagutsuchi/Shogun, narrative/release shell, and structural 1->2->3 handoff as implemented/validated at first-playtest depth; remaining work is tuning/polish/Heart design/release QA.
  - ENDGAME_POSTGAME_RELEASE now reflects authored achievement contracts and implemented safe checkpoint/resume surfaces while preserving the contract-tested-only Heart victory/postgame boundary until real Heart combat exists.
  - TRUE_FINAL_HEART remains intentionally non-implementation-ready: it locks role, two-form identity, story/postgame consequence, and constraints, while exact attacks/combinations, movement, parryability, posture/stagger, phase transition, arena, Health/damage, animation, VFX/audio, and accessibility remain open for dedicated encounter design.
  - GitHub code search returned no usable indexed results during the documentation audit; the approved bounded direct-read fallback was used and recorded in PR #146.
  - PR #143 remains the latest substantive gameplay change. September 10 telemetry/log validation confirms lifetime/crash stability, Embered Pilgrim/Eclipse Shogun inherited attack-state mirroring, and representative blocked committed-motion stops. Only the Hushiro cue appearance and Timeless Zone placement remain inherently visual confirmation items.
recent_batches:
  - pr_146: synchronized top-level implementation-status documentation; 6/6 triggered workflows green; no gameplay changes.
  - pr_143: added phase-driven shared enemy attack cue; synchronized Pilgrim/Shogun attack state; stopped blocked high-speed lunges from skating; fixed Timeless Zone viewport overlay; 10/10 workflows green; September 10 replay machine-validates runtime state/motion/lifetime behavior.
  - pr_141: fixed player-vs-enemy physical authority so stationary enemies/bosses are not dragged by Akio; repaired Eternal Swordsman activation/engagement; manually confirmed anti-drag behavior.
  - pr_140: hardened live enemy temporary-object lifetimes and preserved Kagutsuchi boss scene ownership.
  - pr_139: fixed gate emission, solver-driven body sticking, and Lingering Wraith out-of-range attack selection.
confirmed:
  - Substantive gameplay implementation is current through PR #143; PR #146 is the latest merged documentation/status synchronization.
  - The broad Godot documentation-to-code delta audit is executed/closed. Do not make another broad audit a prerequisite for ordinary work.
  - No currently identified implementation-ready feature package is missing from code. Remaining launch work is integration validation, tuning, final presentation/art/VFX/audio/readability/accessibility polish, Heart encounter design+implementation, release QA, and legal/provenance completion.
  - Heart combat remains unauthored by design authority; the existing Heart shell/handoff and downstream Story Complete/postgame behavior are structural/contract-test surfaces, not permission to invent a real Heart kill path.
  - PR #141 stationary enemy/boss anti-drag behavior is manually confirmed; September 10 replay confirms prior lifetime/deferred/CollisionObject crash class remains clean and supports PR #143 state/motion repairs.
  - Twin Maws and Eclipse Shogun produce attack/contact activity and can complete their encounters; do not treat either as generally inert.
  - Direct Playtest Lab Area 2/3 warps are intentional. Playtest Power defaults to 1x; Recommended integration preset is 5x Health + 5x Posture + Invulnerable; Fast Clear is 10x + Invulnerable for teardown/reward/transition checks only.
  - FIRST_ATTEMPT begins directly in the normal Hushiro route; first death awakens Returning Blood and reconstructs at The Strand.
  - Techniques are slotless/unlimited outside the five direct action slots as defined by current authorities.
  - Numerical balance/economy/difficulty tuning remains evidence-driven.
  - PR #131 procedural FX are temporary debug/playtest presentation, not final authored art.
  - Current approved Wraith authority is the long-reach frontal posture/control Aspect; do not silently replace it with older Crimson/backstab notes without an explicit design reopen.
  - No independent Area 2 invisibility/disappearing defect is currently evidenced; require captured state evidence before changing that system.
  - Known provenance blockers remain explicit; never fabricate license evidence.
avoid_without_evidence:
  - combat/Aspect/Technique/Prosthetic/Relic architecture reopen
  - invented Heart combat before dedicated encounter design
  - broad numerical tuning without integration evidence
  - unrelated PR growth
  - visibility/invisibility rewrites based only on perceived disappearance without captured state evidence
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
When manual validation is genuinely needed, provide exact main/head, runtime marker, coherent systems to exercise, and telemetry/logs to return. Prefer one larger integration pass over micro-playtests.
