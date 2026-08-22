# Decision Record — First-Attempt Base-Katana / Returning Blood Runtime Reconciliation

**Date:** 2026-08-22
**Status:** Resolved / runtime-integration gate passed
**Repository:** `seancl8611/oathbound`
**Pull request:** `#114`
**Validation branch:** `agent/first-attempt-runtime-reconciliation`
**Validated implementation head:** `81c651a5e1909225f9456b6e681ae090e2b187c8`

## Decision

The approved first-attempt combat-loadout boundary is now implemented as a real runtime state instead of being approximated by Wolf Tier 0.

Before Returning Blood awakens, Akio uses the base katana and universal combat/Technique trigger model while Blood Aspect selection, Tier progression, Blood generation, Blood Arts, Aspect HUD state, Corruption progression, and Relic loadout are unavailable. The first genuine death awakens Returning Blood but does not silently choose an Aspect. After awakening, The Well requires an explicit Wolf / Wraith / Ronin selection before a run and the chosen Aspect begins at Tier 0.

## Implemented Boundary

PR #114 adds:

- a campaign-aware `FirstAttemptAspectRuntime` layer around the already-validated Aspect runtime;
- explicit `NO_ASPECT` base-katana profiles for Quick Slash, Cross Cut, Heavy Cleave, Thrust, Dash Slash, and Counter Cut;
- preservation of the universal Basic / Held / Dash / Counter Technique trigger classes on the base katana;
- hard rejection of pre-awakening Aspect selection, Tier mutation, Blood mutation, and Blood Art activation;
- pre-awakening Aspect HUD suppression;
- preservation of the approved fresh first-attempt Beast-Bane Whistle loadout;
- explicit post-awakening Aspect selection at The Well rather than a silent Wolf default;
- focused `FirstAttemptRuntimeSmoke` coverage wired into the permanent Godot 4.7.2 project gate;
- stronger Corruption contract assertions around the first-death awakening handoff.

The canonical Player remains `res://Player/OathboundCombatPlayer.gd`; the package does not replace the validated post-awakening Wolf / Wraith / Ronin combat implementation.

## Direct Evidence

- Pull request: `#114` — `Reconcile first-attempt base katana and Returning Blood handoff`
- Exact tested implementation head: `81c651a5e1909225f9456b6e681ae090e2b187c8`
- Validation run: GitHub Actions run `32596967463` — `success`
- Workflow: `Godot 4.7.2 Project Check` in `.github/workflows/godot-project-check.yml`
- Job: `project-check` (`97089380702`)
- Godot 4.7.2 headless import and editor compile/load: passed.
- Current RunScene canonical-runtime ownership smoke: passed.
- Corruption state-machine contract: passed.
- First-attempt base-katana contract: passed, including pre-awakening exclusions, live Player base-profile resolution, first-death awakening, The Well selector construction/cancel, and explicit post-awakening Aspect activation.
- Hushiro seeded route contract: passed across the existing 256-seed validation set.
- Complete generated Hushiro traversal: passed through all 12 counted chambers and the Chamber 12 Keeper/boss endpoint.
- Shrine chamber smoke: passed.
- Merchant chamber smoke: passed.
- Forge Relic menu smoke: passed.

## Gate Result

The first-attempt base-katana / no-Aspect runtime boundary is no longer an open implementation gate. The current runtime now has automated evidence for both sides of the transition: the opening attempt remains genuinely pre-awakening, and Returning Blood hands control to explicit pre-run Aspect selection without changing the already-implemented post-awakening Aspect system.

This closes the current-runtime integration sequence for Hushiro. The next dependency-sized implementation package is Strand / permanent progression, using the approved progression authorities rather than reopening combat-system design.

## Final PR Validation

This record and the implementation-queue update are documentation follow-up changes on PR #114. PR #114 must also pass the full `Godot 4.7.2 Project Check` workflow on the final exact documentation head before it is marked ready for review.
