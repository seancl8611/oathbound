---
id: ART-ITEM-REWARD-ART
title: Item, Pickup, and Reward Art
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-13
topics:
  - currencies
  - pickups
  - techniques
  - relics
  - breakables
  - treasure
  - reward-markers
related:
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-TECHNIQUES
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - ART-MILESTONE-04
  - ART-MILESTONE-07
---

# Item, Pickup, and Reward Art

Item art must connect in-world pickups, route markers, HUD icons, Technique cards, Relic cards, and reward containers through one readable visual language. Silhouette and economic role take priority over decorative detail.

## Currency items

| Currency | World and icon language |
|---|---|
| Mist | Pale blue-white wisp or orb; base meta currency |
| Scroll | Rolled paper with red Order ribbon; Forge currency |
| Boss Emblem | Dark ornate metal token with Order sigil; rarest meta currency |
| Gold | Clear coin silhouette; run economy |

Pickup sprite and HUD icon must share the same core silhouette. Corruption is not a physical pickup.

## Health, Spirit, and temporary capacity

- **Health:** warm muted red, paired to the HP bar.
- **Spirit:** warm amber with restrained ember flicker, paired to Spirit emblems.

Temporary maximum-Health and maximum-Spirit rewards must be more substantial than ordinary recovery pickups while remaining visibly related to their underlying resource.

## Route reward markers

Branching routes need preview symbols for Technique, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, rest, shop, treasure, miniboss, and boss rewards.

Markers should feel like ritual signs, hanging tags, lantern emblems, carved seals, or regionally integrated wayfinding rather than abstract neon game icons. Color cannot be the only differentiator.

## Technique presentation

Techniques appear as temporary blood-stabilized martial knowledge represented through ritual slips, inked action diagrams, seals, tokens, or offering objects rather than modern floating loot cards.

A Technique card may need to communicate:

- icon,
- name,
- rarity,
- affected combat slot when direct,
- concise effect,
- prerequisite or supporting relationship when relevant,
- refinement or replacement state when relevant.

The five direct combat slots are Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow.

Supporting Techniques consume no combat slot and require a visually distinct relationship from direct slotted Techniques without becoming a completely separate visual product family.

The five approved family mechanics are **Echo, Rupture, Seal, Rift, and Crimson Vulnerable / backstab / direct Health damage**. The full 25-Technique direct matrix is approved at qualitative paper-design depth. Exact player-facing family names, symbols, colors, and final card treatment remain provisional; recognition may use symbols, color, seals, motion language, VFX motifs, or effect wording. Color alone is insufficient.

Required Technique UI art states currently include offered, focused, selected, slotted, supporting, refined, unavailable or invalid, replacement preview, declined/fallback reward, and reroll-ready when implemented.

The retired reserve/inactive Technique state and reserve-overwrite warning are no longer required.

## Refinement presentation

A refinement should look like a deeper or completed version of the same slotted Technique rather than a separate unrelated card family.

Possible treatment includes a second ink pass, completed seal mark, stronger border knot, attached notation strip, restrained Blood channel, or clear refinement icon.

## Breakable props

- **Area 1:** wood crates, barrels, ceramic jars, damaged village containers.
- **Area 2:** rotted stumps, cracked Shrine offerings, bone piles, root-bound containers.
- **Area 3:** ornamental urns, lacquered boxes, ceremonial jars.

Each breakable needs intact and broken states; a damaged middle state is optional where cost-effective.

## Treasure chests and reward objects

Major rewards are larger and more prominent than breakables:

- **Area 1:** bound wooden lockbox with iron banding.
- **Area 2:** root-grown offering bowl or Shrine container.
- **Area 3:** ornate lacquered chest with gold trim.

Required states are unopened and opened/spent. Treasure, miniboss, and regional boss reward frames should use increasing presentation hierarchy while reusing the same card and icon language.

## Relic visual family

Relics use hand-inked icons on aged parchment cards and remain visually separate from the Technique combat-slot system.

The current Relic rarity model is provisional. A working three-tier sketch is Common, Rare, and Legendary, but final labels and presentation should wait for the actual Relic roster.

Do not produce a fixed four-rarity Relic art set until that decision is locked.

## Delivery expectations

- Icons must work at HUD scale and card scale.
- World pickups, route markers, and corresponding UI icons must remain visibly related.
- Area-specific objects inherit regional material language.
- Reusable Technique card, combat-slot, supporting-upgrade, refinement, comparison, and warning templates should be approved before producing a full catalog.
- The approved 25 direct Techniques may receive individual icon planning now; final total Technique icon count still depends on later Legendary, Supporting, Cross-family, refinement, replacement, rarity, and eligibility decisions.
