---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-13
topics:
  - techniques
  - run-builds
  - combat-slots
  - supporting-techniques
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

Techniques are Oathbound's main horizontal run-build system. The selected Blood Aspect defines how Akio fundamentally fights; Techniques modify those sword actions and let the run develop into focused or hybrid builds.

## System ownership

- **Blood Aspect:** pre-run weapon foundation, Tier 0 moveset, fixed Tier I-IV progression, and Tier II Blood Art.
- **Slotted Techniques:** one run-only modification for each major combat action.
- **Supporting Techniques:** slotless run-only upgrades that deepen a recurring family effect or approved interaction.
- **Refinements:** one small improvement to a specific slotted Technique.
- **Prosthetic:** equipped tactical tool developed persistently through the Forge; Prosthetic Techniques are not part of the run Technique system.
- **Relic:** separate run-scoped passive rule.

## Five combat slots

Akio has five Technique-bearing combat slots:

1. **Basic Attack**
2. **Held Attack**
3. **Dash / Dash Attack**
4. **Parry / Counter**
5. **Deathblow**

All five begin empty each run.

A slotted Technique occupies exactly one combat slot. Ordinary direct Techniques cannot stack in the same slot. Once a slot is filled, ordinary offers do not add another direct Technique on top of it.

Filled slots normally remain committed for the run. Rare replacement offers may explicitly overwrite the current Technique in that same slot after confirmation.

## Supporting Techniques

Supporting Techniques consume no combat slot and have no separate global inventory cap.

They may:

- deepen a family's shared mechanic,
- improve buildup, spread, payoff, duration, area, reliability, or another coherent family property,
- connect two already-owned family effects,
- create cross-family interactions,
- or deepen another approved run pattern.

Their practical limit comes from reward opportunities, routing, prerequisites, rarity, and run length.

Supporting Techniques should not exist merely to fill the pool with minor percentages. They should materially deepen the build while leaving the five direct combat slots readable.

## Effect families

Families are internal build structures and do not require formal player-facing school names. Recognition should come from consistent symbols, color treatment, effect behavior, VFX, and audio. Color cannot be the only identifier.

The five approved family mechanics are:

- **Pale silver / twin slash — Echo:** delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest — Rupture:** buildup fills a visible enemy meter; completion triggers a major posture-impact proc and bounded nearby posture pressure.
- **Violet / binding knot — Seal:** discrete visible marks progressively restrict movement; three complete the pattern and briefly Bind the target without stunning it.
- **Ivory / blade circle — Rift:** one visible fracture automatically opens after a short fuse for direct Health damage and can be intensified before opening.
- **Crimson / split blood drop — Vulnerable / backstab / direct Health damage:** Vulnerable is a short status that substantially increases damage from genuine backstabs; other Crimson Techniques may instead provide standalone Health damage, AoE, or backstab payoff.

The full **25-Technique direct matrix is approved at qualitative paper-design depth**. `TECHNIQUE_CATALOG.md` owns the individual roster.

Families do not need identical buildup structures or power curves. Every direct Technique must remain worthwhile when it is the player's only pickup from that family.

## Rarity

Technique rarity remains:

- **Common**
- **Uncommon**
- **Rare**
- **Legendary**

Rarity represents unusualness, transformation, specialization, prerequisite depth, and reward restriction rather than only numerical strength.

Legendary Techniques should be very rare and run-shaping. They may eventually require prior family investment, but exact eligibility and prerequisites are part of the active later-catalog design pass.

## Refinements

A slotted Technique may receive at most one refinement.

A refinement:

- consumes no additional combat slot,
- improves only that specific Technique,
- is a small focused buff rather than another Technique,
- preserves the original behavior and reason for choosing the Technique,
- and must not introduce enough new mechanics to feel like a separate ability.

## Technique reward screens

A **Technique reward** always uses the same underlying reward screen and eligibility rules regardless of source.

A valid offer may include an appropriate combination of:

- a Technique for an empty combat slot,
- a Supporting Technique,
- a refinement,
- a rare same-slot replacement,
- a Cross-family Technique,
- or an eligible Legendary.

Combat rooms are the most common source, while shops, treasure, minibosses, regional bosses, or other approved sources may grant the same reward type. Source does not create a separate Technique system.

## Construction direction

Techniques should visibly alter or deepen Akio's sword combat rather than replace it with unrelated spell rotations.

Approved family language includes delayed Echo slashes, Rupture buildup and posture bursts, visible Seal patterns and Bind, Rift fractures that develop before opening, Vulnerable-based backstab payoff, direct Health-damage sword cleaves or AoE, and precise counter/deathblow interactions.

Avoid making the roster primarily generic fire, frost, lightning, poison, or autonomous magic.

## Compatibility guardrails

- Ordinary Techniques must remain usable across Wolf, Wraith, and Ronin unless explicitly approved otherwise.
- The underlying Aspect owns attack timing, reach, geometry, movement, damage profile, commitment, and failure state.
- Do not grant universal homing, corrective rotation, free commitment cancellation, or broad invulnerability.
- High-frequency and multi-hit interactions must be normalized so Wolf does not gain accidental proc dominance.
- Large single-action effects must be checked against Ronin, and reach/line effects against Wraith.
- Seal cannot invalidate protected boss movement or authored encounter mechanics.
- Rift remains one readable evolving target mark rather than an exposed stack counter.
- Backstab classification is universal combat behavior based on genuinely striking an enemy from behind. Crimson must not manufacture backstabs through forced facing, fake rear windows, or widened rear arcs.
- Vulnerable changes the payoff of genuine backstabs; it does not slow, stun, root, alter facing, suppress movement, or change awareness.
- Every Crimson direct Technique remains useful without another Crimson pickup.
- Mandatory encounters cannot assume a specific Technique family, Legendary, Aspect Tier, or Blood Art.

## Prosthetic boundary

Prosthetic Techniques are removed from the run-build system. Prosthetic progression is persistent and belongs to the Forge. Ordinary Techniques do not temporarily upgrade a particular Prosthetic.

## Reset rule

Slotted Techniques, Supporting Techniques, Cross-family Techniques, refinements, replacement state, and other temporary Technique progression reset when the run ends.

Permanent progression may unlock additional Techniques into future reward pools but does not pre-equip them.

## Current design package

The direct five-by-five matrix is complete at qualitative paper-design depth. The active Technique work is now:

1. design and approve the **Legendary Techniques** for the five families,
2. design the remaining same-family **Supporting Techniques**,
3. rebuild worthwhile **Cross-family Techniques** on top of the now-stable family rules,
4. design small **refinements** and identify any rare same-slot replacements,
5. assign rarity, prerequisites, eligibility, and reward-pool rules,
6. audit the complete catalog across Wolf, Wraith, Ronin, bosses, groups, trigger frequency, backstab access, mixed-family compatibility, AoE/control limits, and visual readability,
7. then lock final launch count and production requirements.

The approved direct matrix should not be reopened casually. Change a direct Technique only if prototyping or the later-catalog audit exposes a concrete overlap, balance, readability, compatibility, or implementation problem.

Exact numerical values, status durations, buildup rates, Rift timing, backstab multiplier, damage, posture values, rarity probabilities, offer weights, replacement frequency, and final UI identifiers remain later design and playtest work.
