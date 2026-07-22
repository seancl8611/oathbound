---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-21
---

# Current Design Questions

This file contains only unresolved decisions that materially affect the initial game scope, content volume, production planning, or narrative presentation.

Resolved questions should be removed after their authoritative files are updated. Exact values, attack timings, cooldowns, probabilities, frame counts, and other playtest-driven tuning remain in the owning gameplay or encounter file rather than becoming top-level scope questions.

## Current priority order

1. Run length and route structure
2. Launch build-content catalog
3. Persistent progression and trial scope
4. Narrative presentation scope
5. Postgame route and repeat-clear rewards

## 1. Run length and route structure

What target run duration and approximate room structure should define a successful full run through Hushiro, Yomori, and Kagutsuchi?

Decide:

- target duration for an ordinary successful run,
- approximate room-count range per area,
- expected number of route choices per area,
- whether both regional minibosses may appear in one run or occupy alternate routes,
- required versus optional room functions,
- and how much authored room variation is required for the initial release.

Already locked:

- the regional order is Hushiro, Yomori, then Kagutsuchi,
- route rewards are previewed where applicable,
- Areas 1 and 2 primarily build the run,
- Area 3 primarily refines or replaces the build,
- and Techniques are not awarded after every combat room.

**Why this matters:** This is the main remaining dependency for environment volume, room production, reward cadence, run pacing, and replayability scope.

## 2. Launch build-content catalog

What minimum launch catalog is required for Techniques, refinements, Prosthetic Techniques, Relics, and consumables?

Decide:

- total base Technique count and approximate distribution by category,
- which Techniques receive one refinement,
- number of temporary Prosthetic Techniques per tool,
- initial Relic count and rarity distribution,
- whether consumables are part of the initial release,
- and which entries require unique icons, bespoke VFX, new animation support, or only reusable presentation.

Already locked:

- four active Technique slots and one reserve,
- most Techniques are independently useful,
- a Technique may receive at most one slotless refinement,
- exact multi-Technique dependency chains are excluded,
- only the equipped prosthetic contributes Prosthetic Techniques to the reward pool,
- and the initial framework uses one run-scoped Relic slot.

**Why this matters:** Catalog size determines design workload, UI population, art quotation, VFX scope, reward variety, and balance-testing volume.

## 3. Persistent progression and trial scope

What is the minimum launch scope for the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- approximate number of permanent upgrade nodes or ranks per service,
- minimum Basic Combat Trial count,
- minimum trial count per Blood Aspect,
- number of Technique demonstrations and mastery trials,
- which Aspects, Techniques, prosthetics, or services are unlocked through trials,
- which rewards use Mist, Scrolls, or Boss Emblems,
- and which permanent upgrades require unique UI or presentation.

Already locked:

- permanent growth may improve options and reliability but cannot replace skilled combat,
- Aspect upgrades remain small, capped, and reliability-focused,
- trials cannot add new Aspect Tiers or permanently pre-equip run Techniques,
- the Forge owns permanent prosthetic development,
- and trial Techniques clear when the trial ends.

**Why this matters:** This defines hub content volume, persistent progression depth, onboarding, and the amount of replayable non-run content required at launch.

## 4. Narrative presentation scope

What minimum authored narrative presentation is required to communicate the locked story clearly?

Decide:

- the cause, location, and presentation of Akio's first death,
- how and when Akio's royal bloodline is confirmed,
- how Shogun dialogue progresses through dismissal, fascination, recruitment, and hatred,
- how the Shogun's reconstruction between successful clears is presented,
- how many clear-state NPC, codex, or Heart-chamber updates are required,
- whether the initial release uses voice acting,
- and which moments require cinematics rather than in-engine dialogue or environmental storytelling.

Already locked:

- Akio's lineage and first death awaken Returning Blood,
- the Shogun eventually recognizes him as a descendant of the escaped royal child,
- the first six successful clears destroy one Heart Binding each,
- the seventh successful story run continues from the Shogun into the Heart,
- and destroying the Heart ends Beast Blood and makes Akio mortal.

The Eclipse Shogun's high-level identity is also resolved: he is a regal, composed, disciplined false master whose controlled inhuman escalation preserves his intelligence and recognizable identity. His exact weapon, phase structure, attacks, transformation anatomy, and animation list remain later encounter-design work.

**Why this matters:** This determines writing volume, portraits, cinematics, voice requirements, repeated-clear variation, and endgame presentation scope.

## 5. Postgame route and repeat-clear rewards

How does a completed save access the optional Heart continuation, and what does repeating it provide?

Decide:

- whether postgame Heart access is selected at the Boat, enabled by a run modifier, or chosen after the Shogun,
- whether normal postgame runs may end after the Shogun by default,
- what repeat Shogun and Heart victories award,
- what records, mastery marks, cosmetics, or challenge results persist,
- and what UI clearly separates canonical story completion from repeat gameplay.

Already locked:

- the first Heart victory is the only canonical ending,
- repeat Heart victories do not advance or reverse the story,
- completed saves retain normal runs and optional Heart-route access,
- and additional difficulty modifiers or enemy variants are not required for the initial release.

**Why this matters:** The route-control decision affects the Boat, results flow, reward structure, save state, UI, and release-completion requirements.

## Deferred implementation and tuning

The following do not require resolution during the current full-game scoping pass:

- exact Twin Maws transition invulnerability, health, posture, and inherited-move timing,
- exact Blood Lotus cycle count, timers, HP chunks, reset behavior, and relocation rules,
- final boss and miniboss attacks, timings, and numerical tuning,
- Spirit costs, cooldowns, immunity tables, hitboxes, and status values,
- exact reward probabilities, prices, reroll costs, and anti-streak formulas,
- exact permanent-upgrade percentages,
- and final animation frame counts or VFX timing.

These values should be designed and tested when their systems or encounters enter implementation.