---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - currencies
  - pickups
  - boons
  - relics
  - breakables
  - rewards
related:
  - GAMEPLAY-PROGRESSION
  - ART-ITEM-REWARD-ART
  - UI-HUD
  - UI-HUB-INTERFACES
---

# Items, Currencies, and Rewards

This file owns the current functional categories for currencies, pickups, boons, relics, breakables, and reward containers. Exact drop rates, prices, rarity weights, and complete item lists remain balance content.

## Currency families

| Currency | Scope | Primary role |
|---|---|---|
| Mist | Persistent | Base meta-progression currency |
| Scroll | Persistent | Forge-focused upgrade currency |
| Boss Emblem | Persistent | Rare boss-derived progression currency |
| Gold | Run-scoped | Mid-run shop economy |

Corruption is not a currency or pickup. It is a run-only Blood Aspect pressure meter.

Earlier references to `Mist Shards` are treated as draft/deprecated wording unless a separate shard denomination is intentionally reintroduced later.

## Health and Spirit pickups

- **Health pickup:** restores HP.
- **Spirit pickup:** restores Spirit emblems used by prosthetic tools.
- Drops may come from enemies, breakables, or scripted rewards.
- Pickup confirmation should be fast and should not interrupt combat flow.

## Boons

Boons are run-scoped upgrades offered at Shrines, boss rewards, and other milestone moments. Selection must show:

- icon,
- name,
- rarity,
- concise effect description,
- source or category when relevant.

Boons disappear when the run ends unless a specific system explicitly converts or records them.

## Relics

Relics provide passive modifiers and use a shared card and icon language. The repository must distinguish run-scoped relics from any future persistent relic category in the item's data rather than relying only on presentation.

Current rarity tiers:

- Common
- Uncommon
- Rare
- Legendary

Rarity changes frame treatment and presentation hierarchy; it should not recolor the same icon into an unreadable palette swap.

## Breakable props

Breakables are area-appropriate destructible objects that may drop currency, Health, Spirit, consumables, or other small rewards.

Required gameplay states:

- intact,
- damaged where useful,
- broken/spent.

Breakables must be distinguishable from decorative props without appearing like modern glowing containers.

## Treasure and reward objects

Major reward containers appear after minibosses, in treasure rooms, and at scripted discoveries. They require unmistakable unopened and opened states. Contents may include currency, boons, relics, or consumables.

## Implementation boundaries

Still unresolved:

- final costs and drop tables,
- exact item and relic counts,
- whether any additional persistent currency families are needed,
- final rarity probabilities,
- full boon/relic effect catalog,
- persistent versus run-only relic ownership where not yet specified.

Do not invent numerical values in art or UI documents before these systems are designed and playtested.
