---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - open-questions
  - implementation-readiness
  - content-authoring
  - playtest-handoff
---

# Current Design Questions

This file is the implementation-facing design queue for Oathbound.

Oathbound's launch architecture is already scoped. From this point forward, an item belongs here only if answering it will materially reduce implementation ambiguity, prevent predictable rework, define authored launch content, or create a useful first-playtest baseline.

The goal is **not** to fully solve balance on paper. The goal is to make the documented game concrete enough that implementation becomes filling in known pieces, then let Godot playtesting drive revisions.

# Planning-to-implementation rule

Approved documents are the **current source of truth**, but they are not promises that every prototype value will survive playtesting unchanged.

Use three decision classes:

1. **Define before implementation** — content/state/rule decisions that code, data, UI, art, or authored encounters need in order to exist.
2. **Set a first-playtest baseline** — numerical values needed to make the game playable; choose a reasonable prototype instead of debating final balance indefinitely.
3. **Defer to playtesting** — final damage, timing, frequency, pacing, economy, and difficulty tuning that is better answered by the playable game.

A question should leave this file once it has enough of an answer to implement. It does not need to be mathematically final.

# Current implementation-readiness assessment

## Already sufficiently scoped at architecture level

Do **not** reopen these without a concrete playtest or implementation problem:

- three launch Blood Aspects,
- shared combat/action-slot model,
- 50 Techniques + 10 refinements,
- 8 Prosthetics / 19 permanent upgrades,
- 10 Relics / two mastery ranks each,
- Bloodwell / Forge / Blood Mirror progression architecture,
- currencies and boss-material model,
- 33-chamber three-region route,
- route branching / room / reward / Shop / survival prototypes,
- authored regional standard-encounter model,
- regional enemy rosters and enemy-lineage rule,
- six Binding clears + seventh story Heart route,
- silent-protagonist and narrative-delivery scope,
- Heart-suppression ending and canonical postgame,
- launch release / settings / accessibility / save / achievement scope.

## Still needs concrete implementation content

The largest remaining gaps are:

- first-playtest combat/system values,
- exact authored standard encounter pools,
- practical room-layout / arena inventories,
- codable miniboss/boss/Heart encounter packages,
- exact Bloodwell/Blood Mirror effects and first-playtest prices,
- exact trial roster and rewards,
- final Relic source assignments,
- exact narrative / codex / achievement content,
- implementation-vs-documentation delta once the Godot project is connected.

# Priority sequence

Work through these in order unless implementation exposes a stronger dependency.

## 1. Core combat implementation baseline

**Question:** What exact first-playtest data should the shared combat system use?

Define a coherent prototype table for the values needed by implementation, including:

- Akio base Health, posture, Spirit, movement, dash, block, parry, posture-break, deathblow, and recovery rules,
- baseline enemy Health/posture relationship and common response rules,
- backstab rear-angle / baseline treatment,
- perilous attack response contracts,
- shared status-duration / proc conventions where systems depend on them,
- any global damage/posture coefficient conventions used by Aspects, Techniques, enemies, or bosses.

**Exit condition:** the common combat layer can be implemented/tested without inventing missing rules in code.

**Do not require:** final frame-perfect tuning or final difficulty balance.

## 2. Player-build implementation sheets

**Question:** What first-playtest values and exact implementation behavior complete the already-approved player content?

Fill the remaining data fields for:

- Wolf, Wraith, and Ronin attacks/Tier mechanics,
- 50 Techniques + 10 refinements,
- 8 Prosthetics and 19 upgrade effects,
- 10 Relics and two mastery ranks each,
- Corruption / Shrine / Blood / Blood Art values where still qualitative.

Prefer reusable shared rules, coefficients, and data fields over one-off exceptions.

**Exit condition:** every launch player-build item has enough data to instantiate in Godot, even if values remain prototype tuning targets.

## 3. Hushiro implementation-ready content package

This is the first complete regional production target and should be finished before spending equal detail on every later region.

### 3A. Standard encounter pool

**Question:** What authored standard encounters ship in Hushiro?

Define:

- practical launch pool count,
- each encounter's tactical purpose,
- exact enemy composition,
- wave/spawn sequence if any,
- layout/space requirement,
- minimum-chamber restriction only where genuinely needed,
- anti-repeat/eligibility rule only if the route requires one.

### 3B. Room-layout inventory

**Question:** What reusable Hushiro gameplay spaces must actually exist?

Define the implementation-facing layout set for:

- standard Combat,
- Shrine,
- Rest,
- Shop,
- Treasure,
- miniboss spaces,
- Keeper arena,
- transition spaces.

This is a layout inventory, not a requirement for unique art per chamber.

### 3C. Miniboss and Keeper packages

**Question:** What exact state/move package makes Village Ogre, Collector, and Keeper codable?

The qualitative identities are already approved. Add only the implementation details still missing:

- complete move/state list,
- targeting/selection conditions,
- parryable / dodge-focused / perilous classifications,
- phase/escalation transitions,
- arena interactions,
- add/hazard rules where applicable,
- death/posture/deathblow behavior.

**Exit condition for Pass 3:** Hushiro can be built as a complete repeatable region and used as the first serious end-to-end balance environment.

## 4. Strand and permanent-progression implementation package

**Question:** What exact content must the between-run loop instantiate?

Define:

- exact individual effects for 10 Akio Bloodwell nodes,
- exact individual effects for 8 Run Infrastructure nodes,
- exact 9 Blood Mirror node effects,
- first-playtest Mist prices / boss-material requirements within the approved structure,
- Relic mastery thresholds,
- Prosthetic unlock/source sequencing where still unresolved,
- exact Relic-to-source assignment for the approved 4 / 2 / 4 acquisition split,
- exact Blood Cavern trial roster, unlock cadence, first-time rewards, and the two challenge Relic assignments,
- save/progression flags required by these states.

**Exit condition:** the Strand/meta loop can be implemented without placeholder progression content beyond numerical tuning.

## 5. Yomori implementation-ready content package

Repeat the Hushiro process for Yomori:

- authored standard encounter pool,
- reusable gameplay-space/layout inventory,
- Embered Pilgrim package,
- Rotwood Host package,
- Twin Maws package,
- any region-specific hazard rules required by those encounters.

Do not add new systems merely to differentiate Area 2; use the approved enemy/region identity.

## 6. Kagutsuchi + Shogun + Heart implementation-ready package

Define:

- Kagutsuchi authored standard encounter pool,
- reusable gameplay-space/layout inventory,
- Blood Lotus package,
- Eternal Swordsman package,
- Eclipse Shogun complete encounter package,
- Binding-space implementation states,
- Unbound Heart complete encounter package,
- Vessel of Continuance complete encounter package,
- canonical first-clear vs repeat Heart-suppression presentation/state differences.

This pass should make the full combat route content-complete on paper without requiring final balance.

## 7. Exact authored presentation/content lists

Finish content that is scoped by volume but not yet individually written/assigned:

- NPC and Shogun dialogue scripts,
- Discovery Board / Lore entries,
- approximately 30 achievement names/triggers,
- tutorial/help text,
- exact records labels,
- final Relic acquisition presentation,
- ending/postgame Keeper/Scribe lines,
- credits/legal text once contributors/dependencies are known.

This work should not block combat implementation unless a specific UI/data structure depends on it.

# Implementation restart gate

**Do not wait for every item in Passes 5–7 before returning to Godot.**

The documentation-first phase has done its job once:

- Pass 1 provides a usable common combat baseline,
- Pass 2 makes player-build content instantiable,
- Pass 3 makes Hushiro fully implementation-ready,
- and the current Godot project is audited against the repo.

At that point, implementation and documentation should proceed together. Build/playtest Hushiro and the run loop while later-region content packages are completed in dependency order.

When the game-code repository becomes available, the first implementation task is a **documentation-to-code delta audit**:

- what already exists and still matches,
- what exists but reflects superseded design,
- what is partially implemented,
- what is missing,
- what should be deleted rather than updated.

The Oathbound documentation remains the design authority during that audit.

# Playtest-only tuning backlog

These should **not** become planning blockers before a playable build exists:

- final damage/posture numbers,
- final attack/frame timings,
- final parry/dash windows,
- final enemy Health/damage,
- final encounter counts if variety testing indicates adjustment,
- final route/reward weights,
- final Technique rarity/source percentages,
- final Shop prices,
- final recovery/capacity percentages,
- final Mist/Scroll payouts and prices,
- final Relic mastery thresholds,
- final Bloodwell/Blood Mirror percentages,
- final Prosthetic costs/effect magnitudes,
- exact 45–50 / 55–60 minute pacing validation,
- VFX density, hitbox polish, camera timing, and animation timing.

Use first-playtest values, implement them, measure them, then update the owning authority when evidence supports a change.

# Question-quality filter

Before adding a new item here, ask:

1. Does implementation need this answer now?
2. Would leaving it undefined force a coder/content author to invent design?
3. Would answering it now prevent meaningful rework?
4. Can playtesting answer it more reliably than documentation?

If the answer to #4 is yes and the first three are no, **do not add it as an open design question**.
