---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-22
---

# Current Design Questions

This file contains only unresolved decisions that materially change the initial release's content inventory, production workload, required interfaces, or authored presentation.

Questions are ordered by dependency. Resolve each only to the depth needed to establish scope and production consequences. Final entries, scripts, movesets, numerical tuning, and playtest values remain in their owning design work.

## Priority order

1. Launch run-build content catalog
2. Persistent progression, onboarding, and trial package
3. Narrative delivery and authored-content package
4. Postgame release package

## 1. Launch run-build content catalog

What minimum catalog must exist at launch for a complete and replayable run-build system?

Decide:

- approximate base Technique count and broad combat-role distribution,
- how many Techniques support one refinement,
- temporary Prosthetic Technique count per equipped tool,
- initial Relic count and approximate rarity distribution,
- whether consumables are included at launch,
- and which content groups use reusable presentation versus unique icons, VFX, or animation support.

This question establishes production counts and treatment tiers. It does not require final Technique effects, exact balance values, or complete item-by-item design.

**Why first:** the catalog defines the content inventory used by run rewards, unlocks, trials, UI population, icon production, VFX planning, and Milestone 4.

## 2. Persistent progression, onboarding, and trial package

What minimum persistent-progression and training package ships through the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- which services are fully available at launch,
- approximate permanent node, rank, or branch counts per service,
- required basic-combat and system-teaching trials,
- required Blood Aspect introduction and mastery trials,
- whether Technique demonstrations or mastery trials are included,
- which approved catalog entries or systems unlock through each service,
- and the distinct interface and presentation states required for those flows.

Currency ownership is already resolved in the progression and reward authorities and is not part of this question. Exact costs and upgrade percentages remain later balance work.

**Dependency:** the launch catalog should be scoped first so unlock and trial ownership can reference a known amount of content.

**Affects:** Strand content volume, onboarding, persistent progression depth, UI workload, non-run replayability, and Milestone 3.

## 3. Narrative delivery and authored-content package

What minimum authored package is required to communicate the approved story clearly across the campaign?

The core campaign spine, world rules, character relationships, Heart Binding structure, ending, and major lore are approved. This question scopes delivery rather than reopening canon.

Decide:

- the required first-death and Returning Blood awakening presentation,
- the timing and evidence used to confirm Akio's bloodline,
- the minimum Shogun dialogue progression across successful clears,
- the minimum Shogun reconstruction presentation,
- required NPC, codex, results, and Heart-chamber updates across campaign states,
- ending and credits presentation requirements,
- voice-acting scope,
- and which moments require cinematics, portraits, in-engine dialogue, or environmental delivery.

This question should produce an authored-content inventory and presentation boundary. Exact final scripts can follow after that package is approved.

**Affects:** writing volume, dialogue and codex counts, portraits, cinematics, voice requirements, repeated-clear variation, and milestones 6 and 7.

## 4. Postgame release package

What minimum postgame package ships after the canonical Heart victory?

The completed save, repeatable normal runs, optional repeat Heart route, and non-canonical status of repeat victories are already approved.

Decide:

- how the player chooses or unlocks continuation from the Shogun to the Heart,
- what repeat Shogun and Heart clears award,
- whether launch includes mastery records, marks, cosmetics, or equivalent completion goals,
- and which Boat, results, save-state, and postgame UI states are required.

Additional difficulty settings, run modifiers, enemy variants, room variants, and challenge restrictions remain outside the initial release unless deliberately promoted later.

**Affects:** release-completion requirements, Boat flow, results, rewards, save state, and postgame UI.

## Deferred gameplay and implementation decisions

The following are intentionally not top-level scoping questions:

- exact room counts and room distribution,
- route topology and branch frequency,
- miniboss frequency or route placement,
- authored room-variant counts before environment prototyping,
- exact enemy and boss movesets,
- Shogun and Heart encounter details,
- Spirit costs, cooldowns, hitboxes, immunity tables, and status values,
- reward probabilities, prices, reroll formulas, and anti-streak rules,
- exact permanent-upgrade percentages,
- final animation frame counts and VFX timing.

These should be decided through system design, encounter design, implementation, or playtesting when the relevant feature enters production.