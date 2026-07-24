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

1. Blood generation and individual Blood Art package
2. Launch run-build content catalog
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

## 1. Blood generation and individual Blood Art package

The shared Blood Aspect framework and Tier contract are approved:

- Tier 0 grants one signature mechanic with no meaningful drawback.
- Tier I improves it and introduces one Aspect-specific drawback family.
- Tier II unlocks Blood and a complete Blood Art.
- Tier III is a complete specialization endpoint.
- Tier IV is an optional capstone with the strongest version of the same drawback family.
- Benefits normally accumulate but may explicitly transform for clarity.
- Each Tier adds one headline improvement and at most one minor supporting rule.
- No new Aspect resource, input, or second Blood Art is added after Tier II.
- Drawbacks evolve rather than stacking as unrelated penalties.
- Resist remains a stabilization choice, not an alternate upgrade path.
- Tier IV Shrines use Stabilize rather than creating Tier V.

### Decide Blood generation and activation behavior

- which combat events generate Blood for each Aspect,
- whether all combat provides baseline Blood with Aspect-specific bonus sources or each Aspect uses distinct rules,
- how damage, posture, parries, dodges, deathblows, elites, bosses, summons, hazards, and multi-target actions contribute,
- anti-farming and multi-hit safeguards,
- Blood capacity and activation amount,
- room-transition, boss-entry, and boss-phase behavior,
- what happens when Tier II is first acquired,
- and whether Blood remains after activation.

Exact gain rates remain playtest values.

### Decide each Blood Art and Aspect package

For Wolf, Wraith, and Ronin, define:

- the Tier 0 signature mechanic,
- the exact Blood Art and tactical purpose,
- activation and interruption rules,
- standard, group, elite, and boss behavior,
- Tier I, III, and IV effects,
- the evolving drawback family,
- Blood-related Technique or refinement interactions,
- and required input, HUD, animation, VFX, and audio states.

### Partial-activation boundary

Partial Blood Art activation is not part of the baseline. Reconsider it only after all three Arts, the shared HUD framework, and representative encounter testing are playable and readable.

This package must be completed before individual Technique coverage and launch counts are approved.

## 2. Launch run-build content catalog

What minimum catalog must exist at launch for a complete and replayable run-build system?

Decide:

- approximate base Technique count and broad combat-role distribution,
- how many Techniques support one refinement,
- how many entries may modify Blood or Blood Arts,
- temporary Prosthetic Technique count per equipped tool,
- initial Relic count and approximate rarity distribution,
- whether consumables are included at launch,
- and which entries require unique icons, VFX, animation, or audio.

Before approving counts, complete:

1. Blood generation and activation rules,
2. exact Wolf, Wraith, and Ronin packages,
3. cross-Aspect overlap audit,
4. Technique category, tag, affinity, and rarity rules,
5. refinement standard,
6. Aspect–Tier–Technique and Blood interaction rules,
7. and the launch coverage matrix in `gameplay/TECHNIQUE_CATALOG.md`.

## 3. Persistent progression, onboarding, and trial package

What minimum persistent-progression and training package ships through the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- available launch services,
- approximate permanent node, rank, or branch counts,
- required basic-combat and system trials,
- Blood Aspect and Blood Art teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- and required interface states.

Blood is run-only and not a persistent currency. Exact costs and percentages remain balance work.

## 4. Narrative delivery and authored-content package

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

## 5. Postgame release package

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
- exact Blood gain, capacity, activation, duration, retention, and anti-farming values,
- partial activation before milestone and playtest evidence,
- Spirit costs and prosthetic cooldowns,
- hitboxes, immunity tables, and status values,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- final animation frames and VFX timing.
