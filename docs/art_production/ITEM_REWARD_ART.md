---
id: ART-ITEM-REWARD-ART
title: Item, Pickup, and Reward Art
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - currencies
  - boss-materials
  - pickups
  - techniques
  - relics
  - breakables
  - treasure
  - reward-markers
related:
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - UI-TECHNIQUE-REWARDS
  - UI-HUB-INTERFACES
  - ART-TECHNIQUE-VFX
  - ART-MILESTONE-04
  - ART-MILESTONE-07
---

# Item, Pickup, and Reward Art

Item art connects world pickups, route markers, HUD icons, Technique cards, Relic objects, boss rewards, and reward containers through one readable language. Silhouette and gameplay/economic role take priority over decoration.

# Currency items

| Currency | World and icon language |
|---|---|
| Mist | Pale blue-white wisp or orb; broad persistent meta currency |
| Scroll | Rolled paper with red Order ribbon; Forge-focused Prosthetic currency |
| Gold | Clear coin silhouette; run economy |

There is no generic Boss Emblem token/icon family.

# Regional boss materials

Keeper of the Gate, Twin Maws, and Eclipse Shogun each require **one distinct persistent boss-material representation**.

These are low-count physical remnants/trophies rather than another uniform currency-token family.

Production direction:

- each material should visibly belong to its source boss,
- the three materials should remain distinguishable at small UI scale,
- they may share a restrained `major permanent material` frame/icon treatment without sharing the same object silhouette,
- exact object concepts and player-facing item names remain deferred until the item naming/art brief pass,
- Rootfang and Briarthorn share one Twin Maws material family rather than creating two separate counters,
- minibosses do not require their own permanent material families.

The material should read as valuable and scarce without implying a crafting inventory full of dozens of monster parts.

# Health, Spirit, and temporary capacity

- **Health:** warm muted red, paired to the HP bar.
- **Spirit:** warm amber with restrained ember flicker, paired to Spirit presentation.

Temporary maximum-Health and maximum-Spirit rewards must be more substantial than ordinary recovery pickups while remaining visibly related to their underlying resource.

# Route reward markers

Branching routes need preview symbols for Technique, Relic, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, Rest, Shop, Treasure, Miniboss, and Boss where available.

Regional boss materials are fixed post-boss persistent rewards and do **not** need their own normal route-choice marker.

Markers should feel like ritual signs, hanging tags, lantern emblems, carved seals, or regionally integrated wayfinding rather than abstract neon game icons. Color cannot be the only differentiator.

# Technique presentation

Techniques appear as temporary blood-stabilized martial knowledge represented through ritual slips, inked action diagrams, seals, tokens, or offering objects rather than modern floating loot cards.

A Technique card may need to communicate:

- icon,
- name,
- rarity,
- affected direct combat slot,
- concise effect,
- prerequisite/supporting relationship,
- refinement/replacement state.

The five direct slots are Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow. Supporting / Cross-family / Legendary Techniques are slotless.

The current roster is **50 actual Techniques + 10 refinements**. Reusable card templates should be approved before unique icon production.

Required reusable states include offered, focused, selected, slotted, supporting, refined, unavailable/invalid, replacement preview, declined/fallback, and reroll-ready.

The retired reserve/inactive Technique state is not required.

# Breakables

- **Area 1:** wood crates, barrels, ceramic jars, damaged village containers.
- **Area 2:** rotted stumps, cracked Shrine offerings, bone piles, root-bound containers.
- **Area 3:** ornamental urns, lacquered boxes, ceremonial jars.

Each breakable needs intact and broken states; a middle damaged state is optional.

# Treasure and high-value reward objects

- **Area 1:** bound wooden lockbox with iron banding.
- **Area 2:** root-grown offering bowl or Shrine container.
- **Area 3:** ornate lacquered chest with gold trim.

Treasure, miniboss, and regional boss rewards should use increasing presentation hierarchy while reusing the same underlying reward-card/icon language where appropriate.

# Relics

The launch roster contains **10 Relics** with no rarity tiers:

- Traveler's Coin
- Merchant's Seal
- Iron Prayer Bead
- Spirit Tassel
- Execution Bead
- Wayfarer's Charm
- Last Oath
- Unbroken Cord
- Scribe's Lens
- Blood Moon Shard

Relics should read as collectible physical objects, not Technique cards or boss materials. Each needs a recognizable collection/equip icon and representation within the Forge Bench's Relic management/progression UI.

A separate Relic Reliquary environment/UI family is not required.

# Delivery expectations

- Icons must work at HUD/result/interface scale.
- World pickups and matching UI icons should share the same silhouette language.
- Persistent boss materials require three source-specific object/icon concepts, not a generic emblem recolor.
- Area-specific objects inherit regional material language.
- Markdown gameplay authorities determine resource ownership; art documents do not create currencies or reward mechanics.
