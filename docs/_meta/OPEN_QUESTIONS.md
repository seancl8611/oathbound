---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-23
---

# Current Design Questions

This file contains only unresolved decisions that materially change the initial release's content inventory, production workload, required interfaces, or authored presentation.

Questions are ordered by dependency. Resolve each only to the depth needed to establish scope and production consequences. Final entries, scripts, movesets, numerical tuning, and playtest values remain in their owning design work.

## Priority order

1. Blood Aspect Tier, Blood-generation, and Blood Art package
2. Launch run-build content catalog
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

## 1. Blood Aspect Tier, Blood-generation, and Blood Art package

How do the approved Blood Aspect framework and Tier II Blood Art system function for Wolf, Wraith, and Ronin?

### Approved framework

- Every Aspect has a persistent signature mechanic at Tier 0.
- Tier I strengthens, broadens, or stabilizes that signature mechanic.
- Tier II unlocks the run-only Blood resource and the Aspect's activatable Blood Art.
- Combat generates Blood after Tier II.
- Activating a Blood Art consumes the required Blood.
- Tier III and Tier IV deepen the established mechanic, Blood Art, or their interaction rather than continually adding unrelated abilities.
- Blood is not a currency, route reward, shop wallet, or persistent meta resource.
- Blood may be modified during a run by later Tiers, Techniques, refinements, Relics, or other approved run effects.
- Blood Arts should generally preserve sword execution and should not default to one large automatic attack.
- Blood Arts may use different forms; they are not all required to be temporary activatable buffs.
- The initial baseline uses one clear activation threshold. Partial activation is deferred until playable Arts and representative playtesting exist.
- Successful runs should commonly finish at Tier II or Tier III.
- Tier IV should be difficult, rewarding, occasional, and non-mandatory even for experienced players.
- Mid-Tier runs must remain complete, viable, and strategically interesting.

### Decide the shared Tier contract

- the exact baseline value and complexity allowed at Tier 0,
- what Tier I may add or improve,
- the guaranteed baseline supplied by the Tier II Blood Art unlock,
- whether Tier benefits accumulate, transform, or may do either under a consistent rule,
- whether drawbacks accumulate, transform, or use another clearly communicated structure,
- whether every Tier must add a benefit and drawback or may deepen an existing pair,
- how much complexity one Tier may add,
- what Shrine behavior remains available after Tier IV,
- and how Resist remains meaningful for players who deliberately remain at Tier II or III.

### Decide Blood generation and activation behavior

- which combat events generate Blood for each Aspect,
- whether all combat provides baseline Blood with Aspect-specific bonus sources or each Aspect uses distinct generation rules,
- how health damage, posture damage, parries, dodges, deathblows, elites, bosses, summons, hazards, and multi-target actions contribute,
- what anti-farming and multi-hit safeguards are required,
- Blood capacity and the activation amount,
- whether Blood carries unchanged between combat rooms,
- whether Blood decays, is retained, or is adjusted during transitions,
- what happens when Tier II is first acquired,
- what happens at boss entrances and phase changes,
- and whether any Blood remains after activation.

Exact numerical gain rates remain playtest values after the behavioral rules are approved.

### Decide each Blood Art's form and function

For Wolf, Wraith, and Ronin, establish:

- the exact Blood Art effect and tactical purpose,
- whether it is a temporary state, contextual action, defensive response, mobility or control tool, focused attack, or another bounded type,
- activation timing and interruption rules,
- whether it has a duration, immediate resolution, or mixed behavior,
- how it functions against standard enemies, groups, elites, and bosses,
- how Tier III and Tier IV deepen it,
- which Techniques or refinements may modify it,
- and what unique input, HUD, animation, VFX, and audio states it requires.

### Partial-activation boundary

Partial Blood Art activation is not part of the approved baseline. Reconsider it only after:

1. the three Blood Arts are playable,
2. the shared Blood and HUD framework is implemented,
3. representative standard, elite, miniboss, and boss testing exists,
4. and playtesting demonstrates that partial spending creates meaningful tactical choices without making readiness harder to read or full activation less satisfying.

This question materially affects combat mechanics, input mapping, HUD, Shrine presentation, tutorials, VFX, animation, audio, balancing, Technique design, and Milestone 4 production scope. It must be answered before individual Aspect tables or the Technique catalog are approved.

## 2. Launch run-build content catalog

What minimum catalog must exist at launch for a complete and replayable run-build system?

Decide:

- approximate base Technique count and broad combat-role distribution,
- how many Techniques support one refinement,
- how many Technique or refinement entries may modify Blood or Blood Arts,
- temporary Prosthetic Technique count per equipped tool,
- initial Relic count and approximate rarity distribution,
- whether consumables are included at launch,
- and which content groups use reusable presentation versus unique icons, VFX, or animation support.

This question establishes production counts and treatment tiers. It does not require final numerical tuning or every catalog entry to be implementation-complete.

Before approving those counts, complete the following design groundwork in the owning gameplay files:

1. shared Blood Aspect Tier contract,
2. shared Blood-generation and activation rules,
3. exact Tier 0–IV mechanical direction, signature mechanic, and Blood Art for Wolf, Wraith, and Ronin,
4. cross-Aspect distinction and overlap audit,
5. Technique category, combat-verb tag, affinity, and rarity model,
6. refinement design standard,
7. Aspect–Tier–Technique and Blood-interaction rules,
8. and the launch coverage matrix in `gameplay/TECHNIQUE_CATALOG.md`.

**Dependency:** the completed Blood Aspect package determines what mechanical territory Techniques should complement rather than duplicate.

**Affects:** run rewards, unlocks, trials, UI population, icon production, VFX planning, animation scope, and Milestone 4.

## 3. Persistent progression, onboarding, and trial package

What minimum persistent-progression and training package ships through the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- which services are fully available at launch,
- approximate permanent node, rank, or branch counts per service,
- required basic-combat and system-teaching trials,
- required Blood Aspect introduction and mastery trials,
- required Blood Art teaching and mastery states,
- whether Technique demonstrations or mastery trials are included,
- which approved catalog entries or systems unlock through each service,
- and the distinct interface and presentation states required for those flows.

Currency ownership is already resolved and is not part of this question. Blood is a run-only combat resource, not a persistent currency. Exact costs and upgrade percentages remain later balance work.

**Dependency:** the Blood Aspect package and launch catalog should be scoped first so unlock, tutorial, and trial ownership reference known systems and content.

**Affects:** Strand content volume, onboarding, persistent progression depth, UI workload, non-run replayability, and Milestone 3.

## 4. Narrative delivery and authored-content package

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

## 5. Postgame release package

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
- exact Corruption gains, Shrine frequency, and Tier thresholds,
- exact Blood gain values, capacity, activation amount, duration, retention, and anti-farming formulas,
- partial Blood Art activation before the required milestone and playtest evidence exists,
- Spirit costs, prosthetic cooldowns, hitboxes, immunity tables, and status values,
- reward probabilities, prices, reroll formulas, and anti-streak rules,
- exact permanent-upgrade percentages,
- final animation frame counts and VFX timing.

These should be decided through system design, encounter design, implementation, or playtesting when the relevant feature enters production.
