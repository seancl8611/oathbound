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

Resolved questions are removed after their authoritative files are updated. Exact values and playtest tuning remain in the owning gameplay or encounter file.

## Priority order

1. Run length and route structure
2. Launch build-content catalog
3. Persistent progression and trial scope
4. Narrative presentation scope
5. Postgame route and repeat-clear rewards

## 1. Run length and route structure

What target run duration and approximate room structure should define a successful full run?

Decide:

- target successful-run duration,
- approximate room-count range per area,
- expected route choices per area,
- whether regional minibosses share a run or occupy alternate routes,
- required and optional room functions,
- amount of authored room variation required at launch.

**Affects:** environment volume, room production, reward cadence, run pacing, replayability, and milestones 2, 5, and 6.

## 2. Launch build-content catalog

What minimum launch catalog is required for Techniques, refinements, Prosthetic Techniques, Relics, and consumables?

Decide:

- total base Technique count and category distribution,
- refinement count,
- temporary Prosthetic Techniques per tool,
- initial Relic count and rarity distribution,
- whether consumables ship at launch,
- which entries require unique icons, bespoke VFX, new animation support, or reusable presentation.

**Affects:** system-design workload, UI population, art quotation, VFX scope, reward variety, and balance-testing volume.

## 3. Persistent progression and trial scope

What is the minimum launch scope for the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- approximate permanent upgrade nodes or ranks per service,
- Basic Combat Trial count,
- trial count per Blood Aspect,
- Technique demonstration and mastery-trial counts,
- which systems and catalog entries unlock through trials,
- currency ownership for major upgrades,
- unique UI and presentation requirements.

**Affects:** hub content volume, progression depth, onboarding, non-run replayability, and Milestone 3.

## 4. Narrative presentation scope

What minimum authored presentation is required to communicate the locked story clearly?

Decide:

- Akio's first-death scene,
- bloodline-confirmation timing and evidence,
- Shogun dialogue progression across successful clears,
- Shogun reconstruction presentation,
- clear-state NPC, codex, and Heart-chamber updates,
- voice-acting scope,
- cinematic versus in-engine presentation ownership.

Exact Shogun encounter phases, attacks, weapon, transformation anatomy, animations, and VFX are excluded from this question and remain later encounter-design work.

**Affects:** writing volume, portraits, cinematics, voice requirements, repeated-clear variation, and milestones 6 and 7.

## 5. Postgame route and repeat-clear rewards

How does a completed save access the optional Heart continuation, and what does repeating it provide?

Decide:

- where the Heart-route choice occurs,
- whether ordinary postgame runs may end after the Shogun,
- repeat Shogun and Heart rewards,
- persistent records, mastery marks, or cosmetics,
- UI that separates canonical completion from repeat gameplay.

**Affects:** Boat flow, results, rewards, save state, postgame UI, and release-completion requirements.

## Deferred implementation and tuning

The following do not require resolution during the current full-game scoping pass:

- Twin Maws transition values,
- Blood Lotus cycle values,
- final enemy and boss movesets,
- Spirit costs and cooldowns,
- immunity tables, hitboxes, and status values,
- exact reward rates, prices, reroll costs, and anti-streak formulas,
- exact permanent-upgrade percentages,
- final frame counts and VFX timing.

These values should be designed and tested when their systems or encounters enter implementation.