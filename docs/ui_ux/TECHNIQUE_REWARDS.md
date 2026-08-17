---
id: UI-TECHNIQUE-REWARDS
title: Technique Rewards and Build Management
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - techniques
  - reward-screen
  - combat-slots
  - replacement
  - refinement
  - supporting-techniques
  - offer-generation
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

A Technique reward may come from a combat room, Shop, Treasure, miniboss, regional boss, or another approved source. The source affects rarity / quality weighting but does not create a separate refinement-only, Legendary-only, or Supporting-only interface.

The prototype reward screen presents **3 Technique choices**. `TECHNIQUES.md` owns the generation rules, including direct/flex composition, rarity weighting, refinement/replacement/Cross-family/Legendary limits, and reroll behavior.

## Required persistent context

Every Technique reward screen must be able to show:

- active Blood Aspect and current Tier,
- the five core combat slots: Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow,
- owned Supporting Technique upgrades,
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

The five effect families do not need formal player-facing names. The current family mechanics are **Echo, Rupture, Seal, Rift, and Crimson Vulnerable / backstab / direct Health damage**; recognition should use symbol, color treatment, effect behavior, and VFX / audio language. Color cannot be the only identifier.

## Build-stage composition

The UI does not need to expose the generator's percentages, but the presented three-card screen must reflect the approved build-stage rules:

- with **3–5 direct slots empty**, at least 2 cards are Direct offers,
- with **1–2 direct slots empty**, at least 1 card is a Direct offer,
- with **0 direct slots empty**, all 3 cards may be flex offers.

Hushiro's fixed Chamber 1 Technique reward presents **3 Direct Techniques from different combat slots and different families** where the eligible pool allows it.

The player should not need to understand hidden generation math to understand why every displayed card is currently usable.

## Empty combat slot

When a card directly modifies an empty combat slot, confirmation fills that slot.

A slot may contain only one direct Technique. Choosing a Basic Attack Technique does not prevent later acquisition of Held Attack, Dash, Parry / Counter, Deathblow, or slotless Supporting Techniques.

## Filled combat slot

Ordinary offers do not stack a second direct Technique onto a filled slot.

A rare replacement offer may propose a new Technique for that same slot. Before confirmation, the interface must show:

- current Technique,
- proposed Technique,
- effect and rarity differences,
- a clear **current → replacement** comparison,
- and the fact that the current Technique will be lost.

Replacement requires explicit confirmation and is not a general free-respec system.

## Supporting Techniques

Supporting Techniques consume no combat slot.

The reward screen should show which owned family effect or interaction they deepen and why the choice is currently useful. Supporting Techniques are never displayed when the current build cannot use them.

## Cross-family Techniques

Cross-family cards must clearly identify the two existing family mechanics they connect. The interface should communicate the practical interaction rather than exposing the internal 1.5× Rare-pool selection weight.

A screen contains at most one Cross-family Technique under the prototype generator.

## Refinements

A slotted Technique may receive at most one refinement.

A refinement card must show:

- the specific owned Technique being improved,
- the current effect,
- the refined effect,
- and confirmation that no additional combat slot is consumed.

A refinement should read as a **small improvement to the same Technique**, not another Technique or a second major mechanic. A screen contains at most one refinement.

## Legendary / prerequisite presentation

Legendary Techniques remain prerequisite-gated capstones. When an eligible Legendary appears, the UI should present it as a rare high-impact opportunity without exposing the hidden source-specific appearance percentage.

The player should be able to understand why the card functions with the current build from its effect and prerequisite context. A screen contains at most one Legendary.

## Screen-quality safeguards

The presentation layer assumes the gameplay generator has already validated the screen. The UI should never receive or display:

- duplicate exact Techniques,
- an unusable Supporting Technique,
- more than one refinement,
- more than one replacement,
- more than one Cross-family Technique,
- more than one Legendary,
- or a replacement-only / optimization-only screen when a healthy immediately functional Technique option exists.

## Decline and rerolls

When the current reward source permits declining, the player may reject all Technique choices and take the displayed smaller fallback reward.

When rerolls are available:

- show the remaining count or cost,
- reroll all 3 unselected choices together,
- preserve the same reward source and its quality rules,
- preserve the same direct/flex composition rules,
- do not alter owned Techniques,
- do not guarantee an exact family or higher rarity,
- preserve the decline reward unless gameplay documentation changes it.

Where the eligible pool allows it, the immediately previous three cards should not simply repeat after a reroll.

## Rest-room and pause relationship

The retired reserve-slot model no longer supports routine Technique swapping at Rest rooms.

Rest and pause interfaces may provide build review, but filled combat slots are normally committed unless a valid replacement reward is being resolved.

## Presentation direction

Technique rewards should feel like temporary martial knowledge rather than modern collectible cards floating without context.

Use readable combat-slot identifiers and strong visual family recognition. Exact family colors, symbols, layout, and card art remain provisional even though the five family mechanics and three-choice reward structure are defined.

## Accessibility and clarity

- Rarity, combat slot, replacement state, refinement, and family identity cannot rely on color alone.
- Replacement and loss warnings require clear text, icon, and focus treatment.
- Long descriptions must remain localization-safe.
- The player must understand a Technique's practical immediate effect before confirming.
- The screen must distinguish direct combat-slot Techniques from slotless Supporting, Cross-family, Legendary, and refinement upgrades.