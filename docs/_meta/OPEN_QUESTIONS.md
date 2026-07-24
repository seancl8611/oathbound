---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-23
---

# Current Design Questions

This file contains unresolved decisions that materially change release scope, production workload, interfaces, or authored presentation. Exact numerical tuning remains in implementation and playtesting.

## Priority order

1. Blood Aspect system foundation, launch count, and identities
2. Shared Aspect structure and selected Aspect packages
3. Launch run-build content catalog
4. Persistent progression, onboarding, and trial package
5. Narrative delivery and authored-content package
6. Postgame release package

## 1. Blood Aspect system foundation, launch count, and identities

What should the Blood Aspect system contribute to a run, how many Aspects should launch, and what distinct identity should each selected Aspect own?

No launch count or final Aspect roster is approved.

Wolf, Wraith, and Ronin are working candidates only. They may be retained, revised, renamed, replaced, combined, or cut. Their current roles, fantasies, loops, visual directions, Tier ideas, and mechanical terms are draft material rather than commitments.

Decide:

- the system's purpose within the run build,
- whether one selected Aspect should remain the central run specialization,
- the minimum launch count needed for meaningful replayability,
- whether three is the correct count,
- the player fantasy and combat identity of each selected Aspect,
- the combat territory each identity owns and must leave available for Techniques, prosthetics, and base combat,
- the risk-and-reward character of each identity,
- the visual and thematic distinction between identities,
- and whether the proposed roster is achievable within production scope.

Approval should produce a short roster and identity table before any exact Tier, Blood-generation, Blood Art, or individual mechanic work is treated as final.

## 2. Shared Aspect structure and selected Aspect packages

Only after the system purpose, count, and identities are approved, decide the shared gameplay structure.

The current Tier 0-IV, Corruption, Embrace, Blood, Blood Art, drawback-family, and one-Aspect-per-run model is a working proposal. It may be preserved, revised, simplified, or replaced during this pass.

Decide:

- whether the Tier 0-IV structure remains appropriate,
- whether every selected Aspect uses the same Tier contract,
- whether Blood remains a Tier II run-only activation resource,
- whether every Aspect has one Blood Art,
- whether one evolving drawback family remains the correct risk model,
- how Resist, Embrace, and maximum-Tier Shrine behavior relate to the final system,
- Blood generation and activation behavior if Blood remains,
- the exact package for each approved Aspect,
- cross-Aspect distinction and overlap,
- and required input, HUD, animation, VFX, audio, trial, and progression states.

Exact gain rates, thresholds, durations, and balance values remain playtest work.

Partial Blood Art activation is not part of the current working baseline. Reconsider it only if Blood Arts remain in the approved system and playable testing demonstrates a need.

This package must be completed before individual Technique coverage and launch counts are approved.

## 3. Launch run-build content catalog

What minimum catalog must exist at launch for a complete and replayable run-build system?

Decide:

- approximate base Technique count and broad combat-role distribution,
- how many Techniques support one refinement,
- how many entries may interact with the approved Aspect system,
- temporary Prosthetic Technique count per equipped tool,
- initial Relic count and approximate rarity distribution,
- whether consumables are included at launch,
- and which entries require unique icons, VFX, animation, or audio.

Before approving counts, complete:

1. the approved Aspect system purpose, count, and identity roster,
2. the approved shared Aspect structure and individual packages,
3. a cross-system overlap audit,
4. Technique category, tag, affinity, and rarity rules,
5. the refinement standard,
6. Aspect-Technique interaction rules,
7. and the launch coverage matrix in `gameplay/TECHNIQUE_CATALOG.md`.

## 4. Persistent progression, onboarding, and trial package

What minimum persistent-progression and training package ships through the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- available launch services,
- approximate permanent node, rank, or branch counts,
- required basic-combat and system trials,
- approved Aspect-system teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- and required interface states.

Exact costs and percentages remain balance work. Any persistent Aspect content depends on the final approved Aspect system.

## 5. Narrative delivery and authored-content package

What minimum authored package communicates the approved story clearly?

Decide:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression,
- Shogun reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

## 6. Postgame release package

What minimum postgame package ships after the canonical Heart victory?

Decide:

- continuation from the Shogun to the Heart,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless promoted later.

## Deferred gameplay and implementation decisions

- exact room counts and route topology,
- miniboss placement,
- exact enemy and boss movesets,
- exact Corruption gain, Shrine frequency, and Tier thresholds,
- exact Blood gain, capacity, activation, duration, retention, and anti-farming values if Blood remains,
- partial activation before approved system direction and playtest evidence,
- Spirit costs and prosthetic cooldowns,
- hitboxes, immunity tables, and status values,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- final animation frames and VFX timing.
