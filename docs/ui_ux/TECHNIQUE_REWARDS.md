---
id: UI-TECHNIQUE-REWARDS
title: Technique Rewards and Build Management
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-12
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

All Technique rewards use one shared reward-screen system regardless of source.

A Technique reward may come from a combat room, shop, treasure, miniboss, regional boss, or another approved source. The source may later affect rarity or quality weighting, but it does not create a separate refinement-only, Legendary-only, or supporting-only interface.

## Required persistent context

Every Technique reward screen must be able to show:

- active Blood Aspect and current Tier,
- the five core combat slots: Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow,
- owned supporting Technique upgrades,
- current refinements,
- equipped Relic,
- rerolls remaining when available,
- decline / fallback reward when that source allows declining,
- controller and keyboard prompts.

## Technique card fields

Each card should communicate:

- icon,
- Technique name,
- rarity,
- affected combat slot when it directly modifies one,
- concise practical effect description,
- relevant prerequisite or existing-family interaction,
- refinement or replacement state when relevant.

The five effect families do not need formal player-facing names. The current family mechanics are Echo, Rupture, Seal, Rift, and Burst; recognition should later use symbol, color treatment, effect behavior, and VFX / audio language. Color cannot be the only identifier.

## Empty combat slot

When a card directly modifies an empty combat slot, confirmation fills that slot.

A slot may contain only one direct Technique. Choosing a Basic Attack Technique does not prevent later acquisition of Held Attack, Dash, Parry / Counter, Deathblow, or slotless supporting Techniques.

## Filled combat slot

Ordinary offers do not stack a second direct Technique onto a filled slot.

A rare replacement offer may propose a new Technique for that same slot. Before confirmation, the interface must show:

- current Technique,
- proposed Technique,
- effect and rarity differences,
- the fact that the current Technique will be lost.

Replacement requires explicit confirmation and is not a general free-respec system.

## Supporting Techniques

Supporting Techniques consume no combat slot.

The reward screen should show which owned family effect or interaction they deepen and why the choice is currently useful.

Supporting concepts remain deferred until the direct five-by-five Technique matrix is stable, but the interface must continue supporting them later.

## Refinements

A slotted Technique may receive at most one refinement.

A refinement card must show:

- the specific owned Technique being improved,
- the current effect,
- the refined effect,
- and confirmation that no additional combat slot is consumed.

A refinement should read as a **small improvement to the same Technique**, not another Technique or a second major mechanic.

## Legendary / prerequisite presentation

When a higher-rarity Technique uses prerequisites, eligibility and requirements must be understandable without exposing unnecessary hidden-generation math.

Exact Legendary eligibility remains deferred until the direct core roster is stable.

## Decline and rerolls

When the current reward source permits declining, the player may reject all Technique choices and take the displayed smaller fallback reward.

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

Technique rewards should feel like temporary martial knowledge rather than modern collectible cards floating without context.

Use readable combat-slot identifiers and strong visual family recognition. Exact family colors, symbols, layout, and card art remain provisional even though the five family mechanics are defined.

## Accessibility and clarity

- Rarity, combat slot, replacement state, refinement, and family identity cannot rely on color alone.
- Replacement and loss warnings require clear text, icon, and focus treatment.
- Long descriptions must remain localization-safe.
- The player must understand a Technique's practical immediate effect before confirming.
- The screen must distinguish direct combat-slot Techniques from slotless supporting upgrades.