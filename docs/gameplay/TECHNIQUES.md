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

Techniques are Oathbound's main horizontal run-build system. The selected Blood Aspect defines how Akio fundamentally fights; Techniques modify those existing sword actions and let the run develop into a focused or hybrid build.

## System ownership

- **Blood Aspect:** pre-run weapon foundation, Tier 0 moveset, fixed Tier I-IV progression, and Tier II Blood Art.
- **Slotted Techniques:** one run-only modification for each major combat action.
- **Supporting Techniques:** slotless run-only upgrades that deepen a recurring family effect or create synergy.
- **Refinements:** one small improvement to a specific slotted Technique.
- **Prosthetic:** equipped tactical tool developed permanently through the Forge; Prosthetic Techniques are not part of the run Technique system.
- **Relic:** separate run-scoped passive rule.

Techniques do not stack additional Technique systems onto Prosthetics or Relics.

## Five combat slots

Akio has five Technique-bearing combat slots:

1. **Basic Attack**
2. **Held Attack**
3. **Dash / Dash Attack**
4. **Parry / Counter**
5. **Deathblow**

All five begin empty each run.

A slotted Technique occupies exactly one combat slot. Two direct Techniques cannot stack in the same slot. Once a slot is filled, ordinary offers do not add another direct Technique on top of it.

The five slots define the core build, while slotless supporting Techniques allow progression to continue after those decisions are made.

## Replacement

A filled combat slot normally remains committed for the run.

Rare replacement offers may allow the player to overwrite the Technique currently occupying that same slot. The old Technique is lost after explicit confirmation.

Replacement is an exceptional pivot, not a general inventory or free-respec system.

## Supporting Techniques

Supporting Techniques consume no combat slot and have no separate inventory cap.

They may:

- improve a family's shared scalable mechanic,
- improve buildup, spread, payoff, duration, or reliability,
- connect two already-owned family effects,
- create cross-family interactions,
- or deepen another coherent run pattern.

Their practical cap comes from Technique reward opportunities, routing, prerequisites, rarity, and run length.

Supporting Techniques should not exist merely to fill space with minor percentages. They are designed only after the core family mechanics are coherent.

## Effect families

Effect families are internal build structures, not necessarily player-facing named schools.

The player should primarily distinguish families through a consistent **symbol, color treatment, effect behavior, VFX, and audio language**. Exact UI treatment remains future design work, and color cannot be the only identifier.

A valid family must have one clear scalable gameplay identity that can meaningfully affect several of the five combat slots. The family should not merely be a collection of unrelated triggers such as "perfect timing" or "lose Health."

Current defined family mechanics include:

- **Pale silver / twin slash:** echoes are delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest:** Rupture buildup fills a visible enemy meter; a full meter triggers the Rupture posture-impact proc and resets.
- **Violet / binding knot:** discrete Seal stacks progressively restrict movement; three Seals complete the pattern and briefly Bind the enemy in place without stunning it.

The Ivory and Crimson scalable mechanics remain open. Supporting, cross-family, Legendary, and refinement content stays deferred until the core family mechanics and five-by-five direct matrix are stable.

## Rarity

Technique rarity remains:

- **Common**
- **Uncommon**
- **Rare**
- **Legendary**

Rarity represents unusualness, transformation, specialization, prerequisite depth, and reward restriction rather than only numerical strength.

Legendary Techniques should be very rare and run-shaping. Some may eventually require prior investment in the same effect family. Exact eligibility is deferred until the five core families and their direct Techniques are stable.

## Refinements

A slotted Technique may receive at most one refinement.

A refinement:

- consumes no additional combat slot,
- improves only that specific Technique,
- is a **small, focused buff** rather than another Technique,
- preserves the original behavior and reason for choosing the Technique,
- and must not introduce enough new mechanics to feel like a separate ability.

There is no target percentage of Techniques that must receive refinements. Refinement concepts are deferred until the current core slotted roster is stable.

## Technique reward screens

A **Technique reward** always uses the same underlying Technique reward screen and eligibility rules regardless of where it came from.

The most common source is a combat-room Technique reward, but the same Technique reward may also be offered through a shop, treasure, miniboss, regional boss, or another approved source.

The source does not inherently make the reward "a refinement reward" or "a supporting-Technique reward." An eligible screen may offer any appropriate combination of:

- a Technique for an empty combat slot,
- a supporting Technique,
- a refinement,
- a rare same-slot replacement,
- a cross-family Technique,
- or an eligible Legendary.

Source and encounter value may later influence rarity or quality weighting, but they do not create separate Technique reward systems.

## Construction direction

Techniques should visibly alter Akio's existing sword actions rather than add unrelated spell buttons.

Strong effects may include delayed slashes, repeated echoes, buildup meters, posture ruptures, visible seal stacks, movement binding, controlled AoE, altered attack geometry, precise counter payoffs, and other effects earned through sword actions.

Avoid making the roster primarily generic fire, frost, lightning, poison, or autonomous magic. Familiar gameplay functions are valid when expressed through Oathbound's combat language.

## Compatibility guardrails

- Ordinary Techniques must remain usable across Wolf, Wraith, and Ronin unless explicitly approved otherwise.
- The underlying Aspect still owns attack timing, reach, geometry, movement, damage profile, and failure state.
- Do not grant universal homing, corrective rotation, free commitment cancellation, or broad invulnerability.
- Do not make Wolf's pursuit, Wraith's reach/control, or Ronin's impact/stability universally available through ordinary Techniques.
- High-frequency triggers must be normalized so Wolf does not gain accidental proc dominance.
- Large single-action effects must be checked against Ronin, and reach/line effects against Wraith.
- Seal-based movement restriction must not invalidate protected boss movement or authored encounter mechanics.
- Mandatory encounters cannot assume a specific Technique family, Legendary, Aspect Tier, or Blood Art.

## Prosthetic boundary

Prosthetic Techniques are removed from the run-build system.

The equipped Prosthetic remains a separate tactical tool. Its progression is persistent and belongs to the Forge rather than Technique reward screens. Ordinary Techniques should not require or temporarily upgrade a particular Prosthetic.

## Reset rule

Slotted Techniques, supporting Techniques, refinements, replacement state, and other temporary Technique progression reset when the run ends.

Permanent progression may unlock additional Techniques into future reward pools but does not pre-equip them.

## Current design package

The active Technique task is now:

1. define the scalable Ivory mechanic,
2. define the scalable Crimson mechanic,
3. revisit weak core-slot concepts across the now-defined Echo, Rupture, and Seal families,
4. approve the five-by-five slotted Technique matrix,
5. only then rebuild supporting Techniques, cross-family Techniques, Legendaries, and refinements,
6. then determine launch count, rarity distribution, eligibility, reward frequency, and production requirements.

Exact numerical values, rarity probabilities, offer weights, replacement frequency, family weighting, and final UI identifiers remain later design and playtest work.
