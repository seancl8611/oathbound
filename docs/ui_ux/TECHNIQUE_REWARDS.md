---
id: UI-TECHNIQUE-REWARDS
title: Technique Rewards and Build Management
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-09
topics:
  - techniques
  - reward-screen
  - combat-slots
  - replacement
  - refinement
  - supporting-techniques
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-BLOOD-ASPECTS
  - UI-HUD
  - UI-PAUSE-OVERVIEW
  - ART-ITEM-REWARD-ART
---

# Technique Rewards and Build Management

This interface presents slotted Techniques, slotless supporting upgrades, refinements, rare replacements, rarity, prerequisites, and decline rewards without turning the run into constant inventory maintenance.

## Required persistent context

Every Technique reward screen must be able to show:

- active Blood Aspect and current Tier,
- the five core combat slots: Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow,
- owned supporting Technique upgrades,
- current refinements,
- equipped Prosthetic,
- equipped Relic,
- rerolls remaining when available,
- decline / fallback reward,
- controller and keyboard prompts.

## Technique card fields

Each card should communicate:

- icon,
- Technique name,
- rarity,
- affected combat slot when it directly modifies one,
- concise effect description,
- relevant prerequisite or existing-family interaction,
- refinement or replacement state when relevant.

Exact player-facing family labels are intentionally not locked. Family recognition may later use symbols, color, VFX, effect wording, or another presentation system. Color cannot be the only identifier.

## Empty combat slot

When a card directly modifies an empty combat slot, confirmation fills that slot.

A slot may contain only one direct Technique. Choosing a Basic Attack Technique therefore does not prevent later acquisition of Held Attack, Dash, Parry / Counter, Deathblow, or slotless supporting Techniques.

## Filled combat slot

Ordinary offers do not stack a second direct Technique onto a filled slot.

A specially generated replacement offer may propose a new Technique for that same slot. Before confirmation, the interface must show:

- current Technique,
- proposed Technique,
- effect and rarity differences,
- the fact that the current Technique will be lost.

Replacement requires explicit confirmation and is not a general free-respec system.

## Supporting Techniques

Supporting Techniques consume no combat slot.

The reward screen should show which owned effect or family they deepen and why the choice is currently useful. They may remain valid after all five core slots are filled.

The interface should avoid presenting supporting upgrades that are functionally dead because their prerequisite effect is absent unless the card itself establishes standalone value.

## Refinements

A slotted Technique may receive at most one refinement.

A refinement card must show:

- the specific owned Technique being improved,
- the current effect,
- the refined effect,
- and confirmation that no additional combat slot is consumed.

## Legendary / prerequisite presentation

When a higher-rarity Technique uses prerequisites, eligibility and requirements must be understandable without exposing unnecessary hidden-generation math.

The exact prerequisite model is not yet locked. The interface must support a future family-capstone structure without assuming every Legendary uses prerequisites.

## Decline and rerolls

The player may reject all Technique choices and take the displayed smaller fallback reward.

When rerolls are available:

- show the remaining count or cost,
- reroll all unselected choices together,
- do not alter owned Techniques,
- do not guarantee an exact family or build,
- preserve the decline reward unless gameplay documentation changes it.

## Rest-room and pause relationship

The retired reserve-slot model no longer supports routine Technique swapping at rest rooms.

Rest and pause interfaces may provide build review, but filled combat slots are normally committed unless a valid replacement reward is being resolved.

## Presentation direction

Technique rewards should feel like temporary blood-stabilized martial knowledge rather than modern collectible cards floating without context.

Use aged paper or ritual-slip surfaces, ink-line action silhouettes, restrained Returning Blood seams or stamps, readable combat-slot identifiers, stronger framing for rare options, and clear comparisons before decorative lore text.

Final family color, symbol, terminology, and layout treatment remain future UI design.

## Accessibility and clarity

- Rarity, combat slot, replacement state, and refinement cannot rely on color alone.
- Replacement and loss warnings require clear text, icon, and focus treatment.
- Long descriptions must remain localization-safe.
- The player must understand a Technique's immediate effect before confirming.
- The screen must distinguish direct combat-slot Techniques from slotless supporting upgrades.
