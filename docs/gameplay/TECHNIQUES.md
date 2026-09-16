---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-09-16
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

Techniques are Oathbound's main horizontal run-build system. The selected Blood Aspect defines how Akio fundamentally fights; Techniques modify current combat actions and create focused or hybrid run builds.

## System ownership

- **Blood Aspect:** pre-run weapon foundation, Tier 0 moveset, fixed Tier I-IV progression, and Tier II Blood Art.
- **Action Techniques:** run-only modifications tied to approved shared combat actions such as Basic Attack, Held Attack, and Dash / Dash Attack.
- **Kit-specific Techniques/hooks:** may react to a mechanic owned by one Aspect, such as Ronin Reprisal, only when eligibility explicitly requires that kit.
- **Supporting Techniques:** run-only upgrades that deepen a recurring family effect.
- **Cross-family Techniques:** hybrid upgrades requiring established investment in two families.
- **Legendary Techniques:** rare run-shaping family capstones.
- **Refinements:** one small improvement to a specific parent Action Technique.
- **Prosthetic:** equipped tactical tool developed persistently through the Forge; Prosthetic upgrades are not part of the run Technique system.
- **Relic:** separate run-scoped passive rule.

## No Technique slots or inventory cap

Oathbound does **not** use Technique inventory slots and does **not** impose a global Technique inventory cap.

Action labels are trigger classifications, not equipment slots. Multiple owned Techniques may modify or respond to the same action when their effects permit it. Acquiring one Basic Attack Technique does not make another Basic Attack Technique ineligible.

A specific Technique is normally acquired at most once per run. Refinements are tracked separately from their parent Techniques.

## Current trigger model

The global Technique catalog may rely on combat events that exist across the supported runtime:

- **Basic Attack**
- **Held Attack**
- **Dash / Dash Attack**
- landed damage / kills where explicitly specified
- genuine backstab / positional events where explicitly specified
- Technique-family events such as Echo, Rupture, Seal, Rift, Vulnerable, and Bind

A global Technique must not assume that every Aspect owns the same defensive timing event. Aspect-specific events are valid only behind explicit compatibility/eligibility rules.

`TECHNIQUE_CATALOG.md` owns the active individual entries and current roster count.

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

## Effect families

Families are internal build structures and do not require formal player-facing school names. Recognition should come from consistent symbols, color treatment, effect behavior, VFX, and audio. Color cannot be the only identifier.

The five approved family mechanics are:

- **Pale silver / twin slash — Echo:** delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest — Rupture:** buildup culminates in a compact impact burst that deals direct Health damage and strong Poise/guard pressure, with bounded nearby impact.
- **Violet / binding knot — Seal:** visible marks progressively restrict movement; completing the pattern briefly Binds the target without redefining its Health resource.
- **Ivory / blade circle — Rift:** one visible fracture opens after a short fuse for direct Health damage and can be intensified before opening.
- **Crimson / split blood drop — Vulnerable / backstab / direct Health damage:** Vulnerable increases payoff from genuine backstabs; other Crimson Techniques may provide standalone Health damage, AoE, or positional payoff.

Families do not need identical buildup structures or power curves. Every Action Technique must remain worthwhile when it is the player's only pickup from that family.

## Rarity

Technique rarity is:

- **Common**
- **Uncommon**
- **Rare**
- **Legendary**

Rarity represents unusualness, transformation, specialization, prerequisite depth, and reward restriction rather than only numerical strength.

Refinements do not receive rarity labels. Legendary generation uses a separate eligible-capstone check rather than the ordinary Common / Uncommon / Rare card roll.

## Eligibility and prerequisites

### Action Techniques

- An Action Technique has no family prerequisite.
- It is eligible whenever that exact Technique has not already been acquired this run and the active combat kit supports its required trigger.
- Other Techniques associated with the same combat action do not make it ineligible.
- Rarity does not prevent a Rare Action Technique from being the player's first Technique from that family.

### Supporting Techniques

- The player must already own an effect that can interact with the support effect.
- A prerequisite must test actual mechanic compatibility rather than only family color/name.

### Cross-family Techniques

- Require existing investment in both listed families.
- May require a specific source mechanic when the hybrid effect would otherwise be dead.

### Legendary Techniques

- Require established native family investment, including at least one Action Technique.
- Cross-family Techniques and refinements do not count as native family investment.
- Exact thresholds are owned by the active catalog/runtime and should stay synchronized with reward generation.

### Refinements

- Require ownership of the exact parent Action Technique.
- A parent may receive at most one refinement unless the catalog explicitly changes that rule.

## Offer generation

Reward generation must:

1. filter out already-owned one-copy Techniques,
2. filter out unsupported kit-specific triggers,
3. filter out dead Supporting/Cross-family/Legendary choices whose prerequisites are not satisfied,
4. apply rarity/offer weighting,
5. avoid duplicate cards in the same offer,
6. preserve deterministic seeded behavior where the run system requires it.

## Presentation and readability

Technique cards and HUD feedback should communicate:

- what action or family event causes the effect,
- what the effect does,
- any compatibility requirement,
- and any prerequisite that materially affects whether the effect can occur.

Technique VFX must remain readable at the accepted high-angle camera and should not obscure enemy windups, hazards, target priority, or hit confirmation.

## Reconciliation rule

The active catalog and runtime must agree. When a shared combat mechanic is removed or becomes kit-specific, global Technique definitions that depended on the old assumption must be removed, rewritten, or explicitly restricted rather than left in the reward pool as dead content.