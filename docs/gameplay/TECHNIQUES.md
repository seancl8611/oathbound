---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-20
topics:
  - techniques
  - run-builds
  - action-techniques
  - supporting-techniques
  - cross-family-techniques
  - legendary-techniques
  - refinements
  - technique-families
  - rarity
  - eligibility
  - offer-generation
  - rarity-weighting
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
- **Action Techniques:** run-only modifications triggered by Basic Attack, Held Attack, Dash / Dash Attack, Parry / Counter, or Deathblow.
- **Supporting Techniques:** run-only upgrades that deepen a recurring family effect.
- **Cross-family Techniques:** hybrid upgrades that require established investment in two families.
- **Legendary Techniques:** rare run-shaping family capstones.
- **Refinements:** one small improvement to a specific parent Action Technique.
- **Prosthetic:** equipped tactical tool developed persistently through the Forge; Prosthetic Techniques are not part of the run Technique system.
- **Relic:** separate run-scoped passive rule.

# No Technique slots or inventory cap

Oathbound does **not** use Technique inventory slots and does **not** impose a global Technique inventory cap.

The five major combat actions are **trigger classifications**, not exclusive equipment slots:

1. **Basic Attack**
2. **Held Attack**
3. **Dash / Dash Attack**
4. **Parry / Counter**
5. **Deathblow**

Multiple owned Techniques may modify or respond to the same combat action when their individual effects permit it. Acquiring one Basic Attack Technique, for example, does not make other Basic Attack Techniques ineligible.

A specific Technique is normally acquired at most once per run. Refinements are tracked separately from their parent Techniques.

## Current roster size

The current working launch roster is complete at qualitative paper-design depth:

- **25 Action Techniques** — five per family across the five major combat-action triggers,
- **15 same-family Supporting Techniques**,
- **5 Cross-family Techniques**,
- **5 Legendary Techniques**,
- **10 refinements**, which are not counted as separate Techniques.

This produces **50 actual Techniques**, plus 10 refinements.

`TECHNIQUE_CATALOG.md` owns the individual entries, rarity assignments, and Technique-specific eligibility.

## Supporting Techniques

Supporting Techniques have no separate inventory cap.

They may deepen buildup, spread, payoff, duration, area, reliability, or another coherent family property. They should materially deepen the build rather than fill the pool with minor percentages.

A Supporting Technique may appear only when the player already owns a Technique that can actually interact with its effect. Reward generation must not offer dead support effects.

## Cross-family Techniques

Cross-family Techniques connect two already-functional family mechanics.

They:

- require existing investment in **both** listed families,
- may impose a more specific mechanic prerequisite when needed,
- never count as native family investment for Legendary eligibility,
- and must not be required for either family to function independently.

All five current Cross-family Techniques are Rare.

# Effect families

Families are internal build structures and do not require formal player-facing school names. Recognition should come from consistent symbols, color treatment, effect behavior, VFX, and audio. Color cannot be the only identifier.

The five approved family mechanics are:

- **Pale silver / twin slash — Echo:** delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest — Rupture:** buildup fills a visible enemy meter; completion triggers a major posture-impact proc and bounded nearby posture pressure.
- **Violet / binding knot — Seal:** discrete visible marks progressively restrict movement; three complete the pattern and briefly Bind the target without stunning it.
- **Ivory / blade circle — Rift:** one visible fracture automatically opens after a short fuse for direct Health damage and can be intensified before opening.
- **Crimson / split blood drop — Vulnerable / backstab / direct Health damage:** Vulnerable is a short status that substantially increases damage from genuine backstabs; other Crimson Techniques may instead provide standalone Health damage, AoE, or backstab payoff.

Families do not need identical buildup structures or power curves. Every Action Technique must remain worthwhile when it is the player's only pickup from that family.

# Rarity

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

Refinements do not receive Common / Uncommon / Rare / Legendary labels. Legendary generation uses a separate eligible-capstone check rather than the ordinary Common / Uncommon / Rare card roll.

# Eligibility and prerequisites

## Action Techniques

- An Action Technique has **no family prerequisite**.
- It is eligible whenever that exact Technique has not already been acquired this run.
- Other Techniques associated with the same combat action do not make it ineligible.
- Rarity does not prevent a Rare Action Technique from being the player's first Technique from that family.

## Supporting Techniques

- Require an already-owned Technique that can interact with the support effect.
- Technique-specific prerequisites are defined in `TECHNIQUE_CATALOG.md`.
- A support cannot appear solely because its family label matches if the player's current effects cannot use it.

## Cross-family Techniques

- Require existing investment in both named families.
- Any additional trigger requirement in the catalog must also be met.
- They reward a hybrid build rather than introducing a second family from nothing.

## Legendary Techniques

A Legendary requires **3 native Techniques from its family**, including at least **1 Action Technique**.

For this requirement:

- same-family Action Techniques count,
- same-family Supporting Techniques count,
- Cross-family Techniques do **not** count,
- refinements do **not** count.

Individual Legendaries may require an additional mechanic source, such as Rupture buildup or Rift intensification, when their effect would otherwise be unusable.

## Refinements

A refinement:

- requires its exact parent Action Technique,
- can appear only if that parent has not already been refined,
- improves only that specific Technique,
- is a small focused buff rather than another Technique,
- and preserves the original behavior and reason for choosing the Technique.

A parent Action Technique may receive at most one refinement.

# Technique reward screens

A **Technique reward** always uses the same underlying three-choice reward screen and eligibility rules regardless of source.

A Technique reward may come from standard combat, a Shop purchase, Treasure, a miniboss, a regional boss, or another explicitly approved source. Reward source changes quality weighting; it does not create a separate Technique subtype or interface.

## Offer-generation order

The prototype generator resolves a Technique reward in this order:

1. **Build the valid eligible pool first.** Remove already-owned exact Techniques and Techniques whose mechanic prerequisites are not currently satisfied.
2. **Roll rarity / source quality** for the baseline cards.
3. **Select specific eligible Techniques**, applying family weighting and special rules for refinements, Cross-family Techniques, and Legendaries.
4. **Validate the final screen** against duplicate, functionality, family-diversity, and special-card limits before presentation.

If a rolled rarity has no valid candidate, that rarity's weight is redistributed across rarities with valid candidates. The generator does not reroll unusable cards indefinitely or display dead choices.

## Base screen composition

The standard reward screen presents **3 choices**.

Because there is no Technique slot system, screen composition does not depend on empty combat slots. When at least one unowned Action Technique remains eligible, a normal screen should contain **at least 1 Action Technique** so the reward does not collapse entirely into narrow optimization cards.

A normal screen may otherwise mix eligible Action, Supporting, Cross-family, refinement, and Legendary opportunities under the rules below.

## First Hushiro Technique reward

Hushiro Chamber 1 remains the fixed opening Technique reward. Its screen is deliberately stricter:

- **3 Action Techniques**,
- from **3 different combat-action triggers**,
- and from **3 different families**, where the eligible pool allows it.

The first reward is intended to present clearly different build directions rather than three near-identical openings.

# Prototype ordinary rarity weighting

For standard-combat Technique rewards, ordinary non-Legendary cards use:

| Region | Common | Uncommon | Rare |
|---|---:|---:|---:|
| **Hushiro** | 55% | 35% | 10% |
| **Yomori** | 35% | 45% | 20% |
| **Kagutsuchi** | 20% | 45% | 35% |

This progression lets Hushiro favor reliable Action starters while later regions increasingly surface specialized Rare build development.

## Prototype source-quality weighting

Shop Technique rewards shift **10 percentage points from Common into Rare** relative to the current region:

| Region | Shop Common | Shop Uncommon | Shop Rare |
|---|---:|---:|---:|
| Hushiro | 45% | 35% | 20% |
| Yomori | 25% | 45% | 30% |
| Kagutsuchi | 10% | 45% | 45% |

Other premium sources use:

| Source | Common | Uncommon | Rare |
|---|---:|---:|---:|
| **Treasure** | 10% | 40% | 50% |
| **Miniboss** | 0% | 35% | 65% |
| **Regional boss** | 0% | 25% | 75% |

Keeper and Twin Maws may grant current-run Technique rewards under this table. The Eclipse Shogun does not grant ordinary current-run power on the first six Binding clears because those runs end after the Binding ritual.

# Family weighting and diversity

After the player owns at least one Technique:

- when a valid candidate exists, **at least one card should advance a family the player already owns**,
- focused builds may receive multiple cards from the same family,
- but a normal three-choice screen should not contain **three cards from the same family** when another meaningful eligible family option exists,
- and no exact Technique may appear twice on one screen.

This biases toward build coherence without locking the player into the first family chosen.

## Cross-family weighting

All current Cross-family Techniques remain Rare and must pass their catalog prerequisites.

When eligible, a Cross-family Technique receives **1.5x selection weight within the Rare candidate pool**. A reward screen may contain **at most 1 Cross-family Technique**.

## Refinement appearance

A reward screen may contain **at most 1 refinement**.

When at least one refinement is eligible, the prototype screen-level opportunity chance is:

| Source | Refinement chance |
|---|---:|
| Standard combat | 25% |
| Shop | 25% |
| Treasure | 20% |
| Miniboss | 10% |
| Regional boss | 10% |

Premium sources intentionally favor complete Techniques over small refinements.

## Legendary appearance

Legendary Techniques are checked separately from ordinary rarity. A Legendary must first satisfy its normal family and mechanic prerequisites.

When at least one Legendary is eligible, each Technique reward screen has the following chance to replace one ordinary card with an eligible Legendary:

| Source | Legendary chance |
|---|---:|
| Standard combat | 5% |
| Shop | 7% |
| Treasure | 10% |
| Miniboss | 12% |
| Regional boss | 15% |

A screen may contain **at most 1 Legendary**. The first prototype uses **no Legendary pity system**; eligibility makes the capstone possible rather than guaranteed.

# Final screen-quality safeguards

Every Technique reward screen must satisfy:

- no duplicate exact Techniques,
- maximum 1 refinement,
- maximum 1 Cross-family Technique,
- maximum 1 Legendary,
- at least 1 Action Technique when an eligible unowned Action Technique remains,
- Supporting Techniques only when an owned effect can actually use them,
- Cross-family and Legendary prerequisites before card generation,
- at least one card advancing an already-owned family when a meaningful eligible candidate exists,
- and no three-card single-family screen when a meaningful eligible alternative exists.

# Decline and rerolls

The player may decline all Technique choices for a displayed lower-value fallback when that source explicitly allows a decline.

A Technique reroll regenerates the **entire three-card screen** while preserving:

- the same reward source,
- the same region/source rarity weighting,
- the same eligibility and special-card rules,
- and the same decline reward where applicable.

Where the eligible pool permits it, cards from the immediately previous screen are excluded from the reroll. Rerolling does not automatically improve rarity or quality. The prototype imposes no additional per-screen reroll cap beyond the player's available reroll resource.

# Construction direction

Techniques should visibly alter or deepen Akio's sword combat rather than replace it with unrelated spell rotations.

Approved family language includes delayed Echo slashes, Rupture buildup and posture bursts, visible Seal patterns and Bind, Rift fractures that develop before opening, Vulnerable-based backstab payoff, direct Health-damage sword cleaves or AoE, and precise counter/deathblow interactions.

Avoid making the roster primarily generic fire, frost, lightning, poison, or autonomous magic.

# Compatibility guardrails

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

# Prosthetic boundary

Prosthetic Techniques are removed from the run-build system. Prosthetic progression is persistent and belongs to the Forge. Ordinary Techniques do not temporarily upgrade a particular Prosthetic.

# Reset rule

Action Techniques, Supporting Techniques, Cross-family Techniques, Legendaries, refinements, and other temporary Technique progression reset when the run ends.

Permanent progression may unlock Techniques into future reward pools but does not pre-equip them.

# Current design package

Technique **content creation, rarity assignment, prerequisites, reward frequency, and first-pass offer generation / source weighting are complete at prototype paper-design depth**.

Remaining Technique-system work is:

1. implement and audit the 50-Technique combat effects across Wolf, Wraith, Ronin, bosses, groups, trigger frequency, mixed-family builds, AoE/control limits, backstab access, and visual readability,
2. validate the prototype offer percentages and refinement/Legendary frequency in playable runs,
3. tune exact combat values through prototyping,
4. change or add roster entries only if that audit exposes a concrete gap or problem.

The percentages in this file are prototype implementation targets, not immutable final balance law. Final rarity rates, offer weights, Legendary/refinement frequency, status durations, buildup rates, Rift timing, backstab multiplier, damage, posture values, and final UI identifiers remain subject to playtesting.
