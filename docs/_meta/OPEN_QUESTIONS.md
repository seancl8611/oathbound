---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-26
---

# Current Design Questions

This file contains only unresolved decisions that materially affect initial-release scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

The following decisions are settled and should not be reopened as top-level questions:

- The launch Blood Aspect roster is **Wolf, Wraith, and Ronin**.
- Current launch identity space is complete: Wolf owns pressure and pursuit, Wraith owns reach and control, and Ronin owns impact and stability.
- Mobility, evasion, ranged utility, and broader crowd-control options remain shared-system, Technique, and prosthetic territory rather than requiring a fourth Aspect.
- A fourth or fifth Aspect is outside current launch scope and requires later playable evidence of a genuinely missing identity.
- Each Aspect is a complete Tier 0 katana weapon kit using the shared combat language.
- Aspect Tier progression is fixed rather than a branching upgrade-package choice.
- Every run begins at Tier 0. At a full Corruption threshold, the player chooses **Resist** or **Embrace**; Embrace advances the selected Aspect by one fixed Tier, up to Tier IV.
- Tier IV is the maximum. A full threshold at Tier IV uses **Stabilize** rather than creating Tier V.
- Blood is run-only, unavailable before Tier II, and resets after the run.
- Techniques remain universal temporary run rewards with four active slots, one reserve slot, and at most one refinement per Technique.

Authoritative references:

- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/CORRUPTION_AND_SHRINES.md`
- `gameplay/PROGRESSION.md`
- `gameplay/TECHNIQUES.md`
- `gameplay/WOLF_ASPECT.md`
- `gameplay/WRAITH_ASPECT.md`
- `gameplay/RONIN_ASPECT.md`

## Priority order

1. Fixed Blood Aspect Tier packages and Blood Arts
2. Launch run-build content catalog
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

## 1. Fixed Blood Aspect Tier packages and Blood Arts

Define the fixed Tier I-IV package for Wolf, Wraith, and Ronin within the approved Shrine structure.

Resolve:

- each Aspect's headline benefit at Tiers I, II, III, and IV,
- whether each Tier needs one minor supporting rule in addition to its headline benefit,
- one evolving drawback family per Aspect,
- the selected Aspect's Tier II Blood unlock and Blood Art package,
- Blood generation, capacity, activation, duration, retention, and anti-farming rules,
- how each package deepens the Tier 0 weapon kit without replacing Techniques,
- whether limited direct Aspect-, Tier-, or Blood-referencing Techniques ship,
- and the required HUD, input, animation, VFX, audio, Shrine, trial, and progression states.

Do not reopen whether advancement is linear or choice-based. The player choice is Resist versus Embrace; the Aspect's Tier path itself is fixed.

## 2. Launch run-build content catalog

Define the minimum complete and replayable launch catalog:

- approximate base Technique count and role distribution,
- universal action-tag coverage,
- affinity and offer-weighting rules,
- the number of Techniques that support one refinement,
- the allowed number of direct Aspect-, Tier-, or Blood-referencing entries,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and entries requiring unique icons, VFX, animation, or audio.

The coverage matrix belongs in `gameplay/TECHNIQUE_CATALOG.md`.

## 3. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern:

- permanent node, rank, or branch counts,
- basic-combat onboarding trials,
- Aspect teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- capped reliability upgrades,
- rewards and mastery marks,
- and required interface states.

The service ownership boundaries and persistent currencies are already approved.

## 4. Narrative delivery and authored-content package

Define the authored presentation required for launch:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression and reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

The story spine, Binding campaign, true-final Heart, ending consequences, and postgame continuity are already approved.

## 5. Postgame release package

Define:

- repeat access to the Heart route,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless explicitly promoted later.

## Deferred implementation and balance work

Keep the following in their owning gameplay, encounter, economy, UI, or production files rather than this tracker:

- exact frame data, hitboxes, cancel windows, tracking, damage, posture, stagger, and recovery values,
- exact neutral movement and dash values within the approved universal contract,
- exact Corruption gain, thresholds, Shrine frequency, and support values,
- exact Blood values after the Blood system direction is approved,
- Spirit costs and prosthetic cooldowns,
- immunity tables and status values,
- room counts, route topology, branch frequency, and miniboss placement,
- enemy and boss movesets,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- and final animation frames or VFX timing.
