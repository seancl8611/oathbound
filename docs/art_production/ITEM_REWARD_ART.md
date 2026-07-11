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

Pickup sprite and HUD icon must share the same core silhouette. Each currency needs a distinct palette and a small idle float, pulse, or slow spin. Pickup feedback includes a short number confirmation and restrained sound cue.

Corruption is not a physical pickup and should not be presented beside currency icons except where an interface explicitly shows its meter.

## Health, Spirit, and temporary capacity

Health and Spirit share a soft glowing-orb family so the player reads both as immediate resource drops:

- **Health:** warm muted red, paired to the HP bar.
- **Spirit:** warm amber with restrained ember flicker, paired to Spirit emblems.

Temporary maximum-Health and maximum-Spirit rewards must be more substantial than ordinary recovery pickups while remaining visibly related to their underlying resource.

Use a small shine and short absorb-into-Akio pickup effect. Color is important, but shape, placement, and HUD confirmation should also support accessibility.

## Route reward markers

Branching routes need preview symbols for primary reward categories:

- Technique,
- Gold,
- Mist,
- Scroll,
- Health,
- Spirit,
- temporary capacity,
- Shrine,
- rest,
- shop,
- treasure,
- miniboss,
- boss.

Markers should feel like ritual signs, hanging tags, lantern emblems, carved seals, or regionally integrated wayfinding rather than abstract neon game icons.

Each marker requires:

- a consistent core symbol,
- readable world-space and map/node treatment where applicable,
- regional material adaptation without changing the symbol,
- focused/selected/disabled treatment where needed,
- non-color differentiation.

## Technique presentation

Techniques appear as temporary blood-stabilized martial knowledge represented through ritual slips, inked action diagrams, seals, tokens, or offering objects rather than modern floating loot cards.

Shared Technique card template:

- icon,
- name,
- rarity or quality frame,
- category marker,
- concise description,
- combat-verb tags,
- Aspect affinity when relevant,
- prosthetic requirement when relevant,
- base/refined state,
- active/reserve relationship where relevant.

Icons use ink-line silhouettes of the action, trigger, target, or tool on aged paper and must remain readable at selection scale.

Required Technique UI art states include:

- offered,
- focused,
- selected,
- active,
- reserve/inactive,
- refined,
- unavailable or invalid,
- replacement preview,
- reserve overwrite warning,
- declined/fallback reward,
- reroll-ready when implemented.

Technique rarity, category, affinity, active/reserve state, and refinement cannot rely on palette alone.

## Refinement presentation

A refinement should look like a deeper or completed version of the same Technique rather than a separate unrelated card family.

Use restrained additions such as:

- a second ink pass,
- completed seal mark,
- stronger border knot,
- attached notation strip,
- subtle blood-lit channel,
- clear `Refined` label or icon.

The base Technique identity must remain visible.

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

Treasure, miniboss, and regional boss reward frames should use increasing presentation hierarchy while reusing the same card and icon language.

## Relic visual family

Relics use hand-inked icons on aged parchment cards. Forms draw from Order and island objects such as prayer beads, blood-marked amulets, bone tokens, lacquered seals, tattered banners, Shrine fragments, ritual cords, folded paper charms, and weathered artifacts.

Relics are visually separate from the four active Technique slots and use their own slot treatment.

Each Relic needs a silhouette that works at small icon scale and larger card scale. New Relics should fit the shared template without requiring a redesign of the full system.

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
- World pickups, route markers, and corresponding UI icons must remain visibly related.
- Area-specific objects inherit regional material language.
- Reusable Technique card, slot, reserve, refinement, comparison, and warning templates should be approved before producing a full catalog.
- Final unique Technique icons require a locked Technique catalog entry.
- All active, inactive, reserve, unopened, opened, broken, locked, warning, and rarity states require clear examples before final production approval.
