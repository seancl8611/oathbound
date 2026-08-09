---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-09
topics:
  - techniques
  - run-builds
  - combat-slots
  - refinements
  - technique-families
  - rarity
  - prosthetic-techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUE-CATALOG
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-ITEMS-REWARDS
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - META-OPEN-QUESTIONS
---

# Technique System

Techniques are the main horizontal run-build system. The selected Blood Aspect defines how Akio fundamentally fights; Techniques determine how Returning Blood and disciplined swordcraft reshape that kit during the run.

Techniques should feel visibly transformative and worthy of a meaningful run choice. Small numerical improvements belong primarily in refinements, supporting upgrades, permanent progression, or tuning rather than occupying a major combat slot by themselves.

## System ownership

- **Blood Aspect:** pre-run weapon foundation, Tier 0 moveset, fixed Tier I-IV progression, and Tier II Blood Art.
- **Slotted Techniques:** one run-only modification for each major combat action family.
- **Supporting Techniques:** slotless run-only upgrades that deepen an existing effect family, create synergy, or improve broader Technique behavior.
- **Refinements:** one-step improvement to a specific slotted Technique.
- **Prosthetic:** equipped tactical tool with its own temporary specialization rules.
- **Relic:** separate run-scoped passive rule.

The Aspect remains the weapon identity underneath every Technique. A Technique may make an action supernatural, but it must not replace Wolf, Wraith, or Ronin with a different weapon class.

## Five combat slots

Akio has five Technique-bearing combat slots:

1. **Basic Attack slot** — modifies the selected Aspect's Basic Attack sequence or repeated primary sword action.
2. **Held Attack slot** — modifies the selected Aspect's committed Held Attack.
3. **Dash slot** — modifies neutral-dash follow-up, Dash Attack, or an approved dodge/re-entry interaction without rewriting the universal dash contract.
4. **Parry / Counter slot** — modifies successful parry payoff, Parry Counter, or an approved defense-to-offense interaction without changing the universal parry window.
5. **Deathblow slot** — modifies posture-break payoff, Deathblow, or the transition created by execution.

All five begin empty each run.

A slotted Technique occupies exactly one combat slot. Two slotted Techniques cannot stack in the same slot. Once a slot is filled, ordinary offers do not add another Technique on top of it.

This creates five clear run-defining decisions while allowing Technique progression to continue after the core kit is filled.

## Replacement

A filled combat slot normally remains committed for the run.

Rare or specially generated replacement offers may allow the player to replace the Technique currently occupying that same slot. The interface must clearly compare the current and proposed Technique before confirmation.

The replaced Technique is lost. The current design no longer uses a general inactive reserve inventory for slotted Techniques.

Replacement should be exceptional enough that early choices matter, but available often enough to let a rare high-value find create a meaningful pivot.

## Supporting Techniques

Supporting Techniques do not occupy the five combat slots and do not have a separate inventory cap.

They may:

- strengthen an effect family already present in the build,
- add a secondary rule to that family's effects,
- create synergy between two families or combat actions,
- improve status buildup, spread, duration, payoff, or reliability where appropriate,
- modify Health, Spirit, posture, or another approved resource interaction,
- or deepen a coherent run pattern without replacing one of Akio's core actions.

Their practical limit comes from reward opportunities, route choices, rarity, prerequisites, and run length rather than an arbitrary inventory maximum.

A supporting Technique must still be meaningful. The pool should not become cluttered with negligible percentage bonuses simply because supporting upgrades are slotless.

## Effect families

Techniques may belong to an internal effect family used for authoring, offer weighting, synergy, prerequisite logic, and presentation consistency.

These families are not required to appear to the player as named factions or schools. Player-facing recognition may later use color, symbols, VFX language, terminology inside effects, or another UI treatment.

A valid family must be broad enough to support comparable build depth across the major combat slots. Do not create one family that only owns healing while another owns repeated attacks, AoE, and multiple core-action modifications.

Each family should be capable of expressing its identity through several of the five combat slots plus supporting upgrades. Exact family names, visual identifiers, and launch family count remain catalog-design work.

## Family and slot independence

Combat slot and effect family answer different questions:

- **Combat slot:** which part of Akio's core kit is modified?
- **Effect family:** what supernatural or martial rule is being expressed?

A family may therefore have a Basic Attack Technique, Held Attack Technique, Dash Technique, Parry / Counter Technique, Deathblow Technique, and several supporting Techniques.

The player may mix families freely. Owning one family in the Basic Attack slot does not require choosing that family for Dash, Parry, or any other slot.

Soft offer weighting may make an existing family somewhat easier to deepen, but hybrid builds must remain normal and viable.

## Rarity

The current Technique rarity structure is:

- **Common**
- **Uncommon**
- **Rare**
- **Legendary**

Rarity represents unusualness, transformation, specialization, prerequisite depth, reward restriction, and production complexity rather than only larger numbers.

Legendary Techniques should be very rare and capable of meaningfully changing a run. Some may function as family capstones that become eligible only after sufficient investment in that family. Exact prerequisite thresholds and which Legendaries require them remain catalog-design work.

A run should not require a Legendary to become viable.

## Refinements

A slotted Technique may receive at most one refinement.

A refinement:

- consumes no additional combat slot,
- deepens that specific Technique,
- preserves its original identity,
- may improve payoff, coverage, reliability, geometry, interaction, or risk,
- and does not become an unrelated second ability.

Refinements and supporting Techniques serve different purposes: a refinement improves one specific slotted Technique; a supporting Technique can improve a broader family or interaction.

The previous rough assumption that 60-70% of Techniques require refinements is no longer a quota. Refinement coverage should follow the actual roster.

## Construction direction

Techniques should preserve the samurai power fantasy established by Akio and Returning Blood.

Good Technique effects may include:

- delayed or repeated cuts,
- Blood-weapon extensions,
- compact cutting waves,
- marks and later detonation,
- binding or suppression,
- posture rupture and impact bursts,
- controlled AoE tied to a successful sword action,
- altered attack geometry,
- supernatural parry or Deathblow payoff,
- risk-and-recovery windows,
- and other effects that visibly grow out of swordsmanship, Order training, Returning Blood, seals, wounds, or controlled mutation.

Avoid making the roster primarily a collection of generic fire, frost, lightning, poison, or spell-casting effects. Familiar gameplay functions such as slow, area damage, extra reach, delayed damage, chaining, crowd control, and recovery are valid, but their presentation should fit Oathbound's world.

## Compatibility guardrails

- Ordinary Techniques must remain usable across Wolf, Wraith, and Ronin unless explicitly approved otherwise.
- The underlying Aspect determines the actual attack timing, reach, geometry, movement, damage profile, and failure state being modified.
- A Technique may reinforce, broaden, or partially compensate for an Aspect without erasing its firm tradeoff.
- Do not grant universal homing, corrective rotation, free commitment cancellation, or broad invulnerability.
- Do not make Wolf's pursuit, Wraith's reach/control, or Ronin's impact/stability universally available through ordinary Techniques.
- Frequent-trigger effects must be checked for accidental bias toward Wolf's higher hit frequency; large single-action effects must be checked for accidental bias toward Ronin; reach and line effects must be checked against Wraith.
- Mandatory encounters cannot assume ownership of a specific Technique family, Legendary, Aspect Tier, or Blood Art.

## Reward progression

Technique opportunities normally present three choices.

Early opportunities should favor filling empty combat slots with strong standalone choices while still allowing supporting upgrades when the player already has something worth deepening.

As the run develops, offers may include:

- a Technique for an empty combat slot,
- a supporting Technique for a family already represented,
- a refinement for an owned slotted Technique,
- a rare replacement for a filled slot,
- a cross-family synergy,
- an eligible higher-rarity or Legendary option,
- or an eligible Prosthetic-related upgrade.

Filling all five combat slots does not end Technique progression. Later Technique rooms should increasingly deepen, connect, refine, or selectively replace the existing build.

The number of Technique reward opportunities per run is a major balance lever and remains open until the roster and run pacing are reviewed together.

## Aspect relationship

The Wolf, Wraith, and Ronin Tier 0-IV packages are locked at current qualitative paper-design depth.

Technique design must work around those packages rather than reopen them. Strong Technique-focused runs at Tier 0-I, hybrid runs around Tier II, Aspect-heavy Tier III runs, and occasional Tier IV high-rolls should all remain viable.

## Prosthetic boundary

The Forge owns permanent Prosthetic development. Temporary run upgrades may deepen the equipped tool or create sword-and-tool synergy, but the current Prosthetic Technique structure should be rechecked against the new five-slot system before final catalog approval.

Do not consume one of the five core combat slots with a Prosthetic Technique unless a later design decision explicitly assigns it to one of those combat actions.

## Reset rule

All slotted Techniques, supporting Techniques, refinements, replacement state, and other temporary Technique progression reset when the run ends.

Permanent progression may unlock additional Techniques into future reward pools but does not pre-equip them.

## Current design package

The next catalog work is to:

1. define a small set of broad, equally expandable effect families using Oathbound-specific samurai / Returning Blood themes,
2. map candidate slotted Techniques across the five combat slots,
3. define enough supporting Techniques that focused and hybrid builds can deepen after slots fill,
4. identify refinements, rare replacements, and Legendary/capstone candidates,
5. then determine the actual launch Technique count, family representation, reward frequency, prerequisites, and production requirements.

Exact numerical values, rarity probabilities, offer weights, replacement frequency, family weighting, and final UI identifiers remain later design and playtest work.
