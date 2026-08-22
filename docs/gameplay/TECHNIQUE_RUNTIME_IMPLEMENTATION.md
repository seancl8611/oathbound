---
id: GAMEPLAY-TECHNIQUE-RUNTIME-IMPLEMENTATION
title: Technique Runtime Implementation
category: gameplay
status: implementation
last_reviewed: 2026-08-21
topics:
  - techniques
  - runtime
  - playtesting
  - implementation
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - META-OPEN-QUESTIONS
---

# Technique Runtime Implementation

This document records the current Godot implementation boundary for the approved Technique system. It does **not** replace `TECHNIQUES.md` or `TECHNIQUE_CATALOG.md` as design authority.

The design authorities intentionally leave exact damage, buildup, duration, radius, and timing values open for later tuning. Values in the runtime executor are therefore **first-playtest implementation baselines**, not locked design decisions.

# Current architecture

The active runtime is split into three responsibilities:

1. `Core/Techniques/TechniqueCatalog.gd` owns the canonical 50-Technique roster plus 10 refinements and their eligibility metadata.
2. `autoload/UpgradeService.gd` owns reward eligibility, source/region rarity weighting, acquisition, rerolls, family weighting, and run ownership.
3. `Core/Techniques/TechniqueEffectsRuntime.gd` and `TechniqueEffects.gd` execute current sword-triggered family mechanics in combat.

`Utility/hurt_box.gd` routes canonical Player sword contacts into `TechniqueEffects`. It no longer routes current sword contacts through the imported elemental `StanceEffects` executor.

`StanceEffects` remains autoloaded temporarily because unreconciled legacy callers still reference it. It is compatibility code, not authority for current Technique behavior.

# Implemented first-playtest family behavior

## Echo

Current runtime supports:

- Basic, Held, Dash Attack, Counter, and Deathblow Echo sources;
- delayed direct Health-damage Echoes;
- Passing Memory continuation after an Echo kill/posture break;
- Pale Wake limited behind-target continuation;
- Gathering Memory strengthening of overlapping pending Echoes;
- Unforgotten Steel one-generation secondary Echoes;
- Resonant Break reduced Rupture buildup;
- Fractured Memory existing-Rift intensification;
- the Lingering Cut and Final Memory refinements.

Exact Echo damage multipliers, delay, width, and search radii remain playtest tuning.

## Rupture

Current runtime supports:

- Basic, Dash Attack, Counter, and Deathblow buildup sources;
- Mountain Breaker direct posture pressure;
- a visible/debuggable buildup meter;
- Rupture completion with major primary posture pressure and bounded nearby posture pressure;
- Guardbreaker, Chain Break, Faultline, and Heavenbreaker;
- Resonant Break, Shattered Scar, and Exposed Break Cross-family interactions;
- both current Rupture refinements;
- Breaching Step's bounded secondary posture shockwave.

Exact buildup amounts, proc threshold pacing, posture values, and radii remain playtest tuning.

## Seal

Current runtime supports:

- Basic, Held, Dash Attack, Counter, and Deathblow Seal sources;
- progressive one-/two-Seal movement restriction;
- three-Seal Bind that anchors movement without replacing the enemy's combat state with a stun;
- Passing Script, Shared Restraint, Residual Knot, and Closed Circle;
- Bound Wound Vulnerable interaction;
- both current Seal refinements.

Exact mark duration, movement multipliers, Bind duration, and spread radius remain playtest tuning.

## Rift

Current runtime supports:

- Basic, Held, Dash Attack, Counter, and Deathblow Rift sources;
- one active evolving Rift per target;
- timed opening for direct Health damage;
- multiple intensity levels;
- faster Dash-created Rifts and Counter acceleration/forced opening;
- Lingering Scar, Overpressure, Fracture Spread, and Ivory Collapse;
- Fractured Memory and Shattered Scar Cross-family intensification;
- both current Rift refinements.

Exact fuse duration, intensity damage, spread limits, and collapse radius remain playtest tuning.

## Crimson

Current runtime supports:

- Basic and Counter Vulnerable application;
- genuine positional backstab detection rather than automatic repositioning;
- Vulnerable backstab Health-damage amplification;
- Held Deep Cut backstab payoff;
- Dash Blood Arc direct/AoE Health damage;
- Deathblow Predator's Wake;
- Fresh Wound, Blood Trail, and Severed Line;
- Bound Wound and Exposed Break Cross-family Vulnerable sources;
- Unseen Deathblow state with attack consumption and one pending backstab-payoff strike;
- both current Crimson refinements.

Exact backstab arc tolerance, Vulnerable duration, damage bonuses, and AoE size remain playtest tuning.

# Runtime readability

Until final Technique VFX assets exist, the implementation uses compact temporary combat labels for state validation:

- `R:n` — Rupture buildup,
- `S:n` — Seal count,
- `BIND` — active Bind,
- `F:n` — Rift intensity,
- `VULN` — Vulnerable.

Echo/Rupture/Rift/Bind resolutions also emit short temporary text pulses. These are debugging/readability scaffolds, not final UI/VFX authority.

# Telemetry

Technique events are recorded through `CombatTelemetry` with the `technique_` prefix. The runtime records, among other events:

- Echo scheduling/resolution damage,
- Rupture buildup and triggers,
- Seal application and Bind,
- Rift changes and openings,
- Vulnerable application,
- Technique Health/Posture damage,
- Unseen start/end/attack commitment,
- Deathblow Technique resolution.

This is intended to let a longer playtest surface multiple interacting defects in one capture.

# Playtest Lab

The Build tab now exposes direct Technique test kits:

- Echo,
- Rupture,
- Seal,
- Rift,
- Crimson,
- Cross-family Techniques,
- clear run Techniques/status state.

A family kit deliberately grants every native Technique and refinement in that family, bypassing ordinary reward prerequisites. This is debug-only behavior. Normal runs continue to use `UpgradeService` eligibility and reward generation.

# Current compatibility boundary

The following old systems are not yet fully removable:

- `UpgradeDb` remains available to unreconciled legacy callers;
- `StanceEffects` remains autoloaded for old non-current call paths;
- selected Player/enemy controllers still inherit imported implementations beneath current Oathbound rules layers.

No new current Technique behavior should be added to the old elemental Stance/UpgradeDb model.

# Validation target for this implementation batch

A useful validation run should be longer than a single Chamber 1 smoke test. It should exercise:

1. clean Godot 4.7.2 import/startup;
2. multiple Hushiro combat chambers and authored wave transitions;
3. ordinary Technique acquisition/reward screens and rerolls;
4. at least two different Technique families through normal rewards;
5. focused family kits through Playtest Lab when a mechanic needs direct stress testing;
6. Basic, Held, Dash Attack, Counter, and Deathblow Technique triggers;
7. multiple simultaneous statuses on mixed enemy groups;
8. miniboss and/or Keeper traversal when practical;
9. player death/return-to-Strand flow;
10. capture of all parser/runtime errors plus the resulting combat telemetry file.

Do not block this batch on final balance, final VFX, final numerical tuning, or every temporary compatibility dependency. Those remain separate follow-up work unless the playtest exposes a structural contradiction.