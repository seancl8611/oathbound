---
id: ART-ITEM-REWARD-ART
title: Item, Pickup, and Reward Art
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - currencies
  - pickups
  - boons
  - relics
  - breakables
  - treasure
related:
  - GAMEPLAY-ITEMS-REWARDS
  - ART-MILESTONE-04
  - ART-MILESTONE-07
---

# Item, Pickup, and Reward Art

Item art must connect in-world pickups, HUD icons, cards, and reward containers through one readable visual language. Silhouette and economic role take priority over decorative detail.

## Currency items

| Currency | World and icon language |
|---|---|
| Mist | Pale blue-white wisp or orb; base meta currency |
| Scroll | Rolled paper with red Order ribbon; Forge currency |
| Boss Emblem | Dark ornate metal token with Order sigil; rarest meta currency |
| Gold | Clear coin silhouette; run economy |

Pickup sprite and HUD icon must share the same core silhouette. Each currency needs a distinct palette and a small idle float, pulse, or slow spin. Pickup feedback includes a short number confirmation and restrained sound cue.

Corruption is not a physical pickup and should not be presented beside currency icons except where an interface explicitly shows its meter.

## Health and Spirit pickups

Health and Spirit share a soft glowing-orb family so the player reads both as immediate resource drops:

- **Health:** warm muted red, paired to the HP bar.
- **Spirit:** warm amber with restrained ember flicker, paired to Spirit emblems.

Use a small shine and short absorb-into-Akio pickup effect. Color is important, but shape, placement, and HUD confirmation should also support accessibility.

## Boon presentation

Boons appear as ritual tokens, offering-bowl objects, or pinned paper slips rather than modern loot cards floating in space.

Shared boon card template:

- icon,
- name,
- rarity frame,
- concise description,
- source attribution where needed.

Icons use ink-line silhouettes on aged paper and must remain readable at selection scale.

## Breakable props

### Area 1

Wood crates, barrels, ceramic jars, and damaged village containers. Destruction uses wood splinters, ceramic pieces, and dust.

### Area 2

Rotted stumps, cracked Shrine offerings, bone piles, and root-bound containers. Destruction uses bark, root, bone, and fungal fragments.

### Area 3

Ornamental urns, lacquered boxes, and ceremonial jars. Destruction uses lacquer shards, ceramic pieces, and restrained blossom accents.

Each breakable needs intact and broken states; a damaged middle state is optional where cost-effective. Drop origin should remain consistent.

## Treasure chests and reward objects

Major rewards are larger and more prominent than breakables:

- **Area 1:** bound wooden lockbox with iron banding.
- **Area 2:** root-grown offering bowl or Shrine container.
- **Area 3:** ornate lacquered chest with gold trim.

Required states:

- unopened with warm restrained pulse,
- opened and visibly spent.

Opening may use a short camera focus or light beam, but the reward reveal cannot overpower boss-completion or deathblow presentation.

## Relic visual family

Relics use hand-inked icons on aged parchment cards. Forms draw from Order and island objects such as prayer beads, blood-marked amulets, bone tokens, lacquered seals, tattered banners, Shrine fragments, ritual cords, folded paper charms, and weathered artifacts.

Each relic needs a silhouette that works at small icon scale and larger card scale. New relics should fit the shared template without requiring a redesign of the full system.

## Relic rarity tiers

| Rarity | Frame and presentation |
|---|---|
| Common | Plain parchment, minimal border, simple ink silhouette, no aura |
| Uncommon | Subtle accent, basic border detail, faint card glow |
| Rare | Dual-tone inking, ornate border, visible restrained pulse |
| Legendary | Highest detail, gold or crimson accent, ritual-marked frame, subtle persistent card aura |

Rarity is communicated by frame treatment first and icon complexity second. Do not rely on recoloring the same icon.

## Delivery expectations

- Icons must work at HUD scale and card scale.
- World pickups and corresponding UI icons must remain visibly related.
- Area-specific objects inherit regional material language.
- All active, unopened, opened, broken, locked, and rarity states require clear examples before final production approval.
