---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-14
topics:
  - techniques
  - run-builds
  - combat-slots
  - supporting-techniques
  - cross-family-techniques
  - legendary-techniques
  - refinements
  - technique-families
  - rarity
  - eligibility
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
- **Supporting Techniques:** slotless run-only upgrades that deepen a recurring family effect.
- **Cross-family Techniques:** slotless hybrid upgrades that require established investment in two families.
- **Legendary Techniques:** rare run-shaping family capstones.
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

## Current roster size

The current working launch roster is complete at qualitative paper-design depth:

- **25 direct slotted Techniques**,
- **15 same-family Supporting Techniques**,
- **5 Cross-family Techniques**,
- **5 Legendary Techniques**,
- **10 refinements**, which are not counted as separate Techniques.

This produces **50 actual Techniques**, plus 10 refinements.

`TECHNIQUE_CATALOG.md` owns the individual entries, rarity assignments, and Technique-specific eligibility.

## Supporting Techniques

Supporting Techniques consume no combat slot and have no separate global inventory cap.

They may deepen buildup, spread, payoff, duration, area, reliability, or another coherent family property. They should materially deepen the build rather than fill the pool with minor percentages.

A Supporting Technique may appear only when the player already owns a Technique that can actually interact with its effect. Reward generation must not offer dead support effects.

## Cross-family Techniques

Cross-family Techniques connect two already-functional family mechanics.

They:

- consume no combat slot,
- require existing investment in **both** listed families,
- may impose a more specific mechanic prerequisite when needed,
- never count as native family investment for Legendary eligibility,
- and must not be required for either family to function independently.

All five current Cross-family Techniques are Rare.

## Effect families

Families are internal build structures and do not require formal player-facing school names. Recognition should come from consistent symbols, color treatment, effect behavior, VFX, and audio. Color cannot be the only identifier.

The five approved family mechanics are:

- **Pale silver / twin slash — Echo:** delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest — Rupture:** buildup fills a visible enemy meter; completion triggers a major posture-impact proc and bounded nearby posture pressure.
- **Violet / binding knot — Seal:** discrete visible marks progressively restrict movement; three complete the pattern and briefly Bind the target without stunning it.
- **Ivory / blade circle — Rift:** one visible fracture automatically opens after a short fuse for direct Health damage and can be intensified before opening.
- **Crimson / split blood drop — Vulnerable / backstab / direct Health damage:** Vulnerable is a short status that substantially increases damage from genuine backstabs; other Crimson Techniques may instead provide standalone Health damage, AoE, or backstab payoff.

Families do not need identical buildup structures or power curves. Every direct Technique must remain worthwhile when it is the player's only pickup from that family.

## Rarity

Technique rarity is:

- **Common**
- **Uncommon**
- **Rare**
- **Legendary**

The current 50-Technique roster is distributed as:

- **10 Common**
- **18 Uncommon**
- **17 Rare**
- **5 Legendary**

Rarity represents unusualness, transformation, specialization, prerequisite depth, and reward restriction rather than only numerical strength.

Refinements do not receive rarity labels.

Exact rarity **probabilities** and source weighting remain later reward-system tuning.

## Eligibility and prerequisites

### Direct Techniques

- A direct slotted Technique has **no family prerequisite**.
- It is eligible when its combat slot is empty.
- Rarity does not prevent a Rare direct Technique from being the player's first Technique from that family.
- If the slot is occupied, another direct Technique for that slot is normally ineligible except through a rare replacement offer.

### Supporting Techniques

- Require an already-owned Technique that can interact with the support effect.
- Technique-specific prerequisites are defined in `TECHNIQUE_CATALOG.md`.
- A support cannot appear solely because its family label matches if the player's current effects cannot use it.

### Cross-family Techniques

- Require existing investment in both named families.
- Any additional trigger requirement in the catalog must also be met.
- They reward a hybrid build rather than introducing a second family from nothing.

### Legendary Techniques

A Legendary requires **3 native Techniques from its family**, including at least **1 slotted Technique**.

For this requirement:

- slotted Techniques from that family count,
- same-family Supporting Techniques count,
- Cross-family Techniques do **not** count,
- refinements do **not** count.

Individual Legendaries may require an additional mechanic source, such as Rupture buildup or Rift intensification, when their effect would otherwise be unusable.

### Refinements

A refinement:

- consumes no additional combat slot,
- requires its exact parent slotted Technique,
- can appear only if that parent has not already been refined,
- improves only that specific Technique,
- is a small focused buff rather than another Technique,
- and preserves the original behavior and reason for choosing the Technique.

A slotted Technique may receive at most one refinement.

## Technique reward screens

A **Technique reward** always uses the same underlying reward screen and eligibility rules regardless of source.

A valid offer may include an appropriate combination of:

- a Technique for an empty combat slot,
- an eligible Supporting Technique,
- an eligible refinement,
- a rare same-slot replacement,
- an eligible Cross-family Technique,
- or an eligible Legendary.

Combat rooms are the most common source, while shops, treasure, minibosses, regional bosses, or other approved sources may grant the same reward type. Source does not create a separate Technique system.

The exact order of operations for rarity rolling versus eligible-pool construction, offer weights, reward frequency, and replacement frequency remains open.

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
- Mandatory encounters cannot assume a specific Technique family, Legendary, Aspect Tier, or Blood Art.
- Eligibility rules must prevent Technique rewards that cannot currently function.

## Prosthetic boundary

Prosthetic Techniques are removed from the run-build system. Prosthetic progression is persistent and belongs to the Forge. Ordinary Techniques do not temporarily upgrade a particular Prosthetic.

## Reset rule

Slotted Techniques, Supporting Techniques, Cross-family Techniques, Legendaries, refinements, replacement state, and other temporary Technique progression reset when the run ends.

Permanent progression may unlock Techniques into future reward pools but does not pre-equip them.

## Current design package

Technique **content creation, rarity assignment, and prerequisite design are complete for current paper-design scope**.

The next Technique-system work is:

1. define reward frequency and offer-generation logic, including when rarity is selected relative to eligibility,
2. define rare same-slot replacement frequency / presentation,
3. audit the 50-Technique roster across Wolf, Wraith, Ronin, bosses, groups, trigger frequency, mixed-family builds, AoE/control limits, backstab access, and visual readability,
4. tune exact values through prototyping,
5. change or add roster entries only if that audit exposes a concrete gap or problem.

Exact numerical values, status durations, buildup rates, Rift timing, backstab multiplier, damage, posture values, rarity probabilities, offer weights, replacement frequency, and final UI identifiers remain later design and playtest work.
