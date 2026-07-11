---
id: UI-TECHNIQUE-REWARDS
title: Technique Rewards and Build Management
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - techniques
  - reward-screen
  - active-slots
  - reserve-slot
  - replacement
  - refinement
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-BLOOD-ASPECTS
  - UI-HUD
  - UI-PAUSE-OVERVIEW
  - ART-ITEM-REWARD-ART
---

# Technique Rewards and Build Management

This interface presents temporary Technique choices, refinements, replacements, reserve management, and decline rewards without turning the run into constant inventory maintenance.

## Required persistent context

Every Technique reward screen shows:

- active Blood Aspect and current Tier,
- four active Technique slots,
- one reserve slot,
- equipped prosthetic,
- rerolls remaining when the system is available,
- the predetermined decline/fallback reward,
- controller and keyboard prompts.

## Technique card fields

Each card includes:

- icon,
- Technique name,
- rarity or quality marker,
- category,
- concise effect description,
- combat-verb tags,
- Aspect affinity when relevant,
- prosthetic requirement when relevant,
- refinement state or prerequisite when relevant.

Affinity language communicates natural compatibility, not a hard requirement unless the card explicitly states one.

## Offer before all active slots are filled

The screen presents three Technique choices. Selecting one:

1. previews its effect,
2. fills an empty active slot,
3. confirms the updated build.

The player may choose the visual slot position for organization, but the four active slots have no category restrictions.

The first Technique choice should arrive early enough that run growth begins quickly, while Akio still starts the run with empty Technique slots.

## Offer after all active slots are filled

The offer should usually combine different decision types rather than present three interchangeable additions:

- a compatible new Technique,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

Selecting a refinement upgrades its active base Technique immediately and consumes no additional slot.

Selecting a new Technique opens the replacement and reserve state.

## Replacement and reserve state

The player may:

- replace any one active Technique,
- place the new Technique directly into reserve,
- cancel and return to the three-card offer.

When an active Technique is replaced:

- the selected new Technique becomes active,
- the displaced Technique moves to reserve,
- if reserve is occupied, the interface shows which dormant Technique will be lost.

Reserve overwrite requires an explicit confirmation. The confirmation shows:

- new active Technique,
- displaced Technique moving to reserve,
- reserve Technique being lost,
- retained refinement states.

The interface must never silently discard a Technique.

## Reserve swapping

At a Technique reward screen or rest room, the player may exchange the reserve Technique with any active Technique.

The interface must communicate that:

- reserve is inactive,
- only one Technique can be held there,
- refinements remain attached,
- reserve Techniques cannot receive new refinements while inactive,
- general swapping is unavailable from the ordinary pause screen.

## Decline and fallback

The player may reject all Technique choices and take the displayed smaller fallback reward.

The fallback is generated before the screen opens and is not a free menu of every reward category. Examples include:

- Gold,
- small Health and Spirit recovery,
- a small amount of Mist,
- a reroll resource when that system is approved.

The fallback must be visibly lower value than the Technique opportunity so players do not routinely convert Technique rooms into economy rooms.

## Rerolls

When rerolls are available:

- show the remaining count or cost,
- reroll all unselected Technique cards together,
- do not change already owned Techniques,
- do not guarantee an exact combination,
- preserve the decline reward unless gameplay documentation explicitly changes it.

## Rest-room build management

Rest rooms provide a compact build-management state containing:

- four active Techniques,
- one reserve Technique,
- current refinements,
- combat-verb tags,
- active Aspect and Tier,
- equipped prosthetic and Relic.

The player may only exchange active and reserve Techniques. Rest rooms do not create, recover, or freely browse lost Techniques.

## Pause-screen relationship

The ordinary pause/build overview is read-only for Technique loadout management. It shows active and reserve Techniques and their effects, but swapping remains restricted to Technique reward screens and rest rooms.

## Presentation direction

Technique rewards should feel like temporary blood-stabilized martial knowledge rather than modern collectible cards floating without context.

Use:

- aged paper or ritual-slip surfaces,
- ink-line action silhouettes,
- restrained Returning Blood seams or stamps,
- clear slot and reserve diagrams,
- stronger framing for rare options and refinements,
- explicit tags and comparisons before decorative lore text.

## Accessibility and clarity

- Rarity, category, active/reserve state, and refinement cannot rely on color alone.
- Replacement and loss warnings require clear text, icon, and focus treatment.
- Long descriptions must remain localization-safe.
- The player must understand a Technique's immediate effect before confirming.
- The screen should not imply exact-combination dependence or hidden prerequisites.
