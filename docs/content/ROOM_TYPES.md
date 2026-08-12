---
id: CONTENT-ROOM-TYPES
title: Cross-Area Room Types
category: content
status: approved
authority: primary
last_reviewed: 2026-08-12
topics:
  - rooms
  - combat-room
  - shrine-room
  - rest-room
  - shop-room
  - miniboss-room
  - boss-room
  - heart-binding-completion
  - reward-preview
related:
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-AREA2-OVERVIEW
  - CONTENT-AREA3-OVERVIEW
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-TECHNIQUES
---

# Cross-Area Room Types

Every common room type has a stable gameplay function and at-a-glance visual identity across all three areas. Regional skins change materials, architecture, and atmosphere without changing the functional read.

The Heart Binding completion space after the Shogun is a specialized endgame space rather than another common room family.

## Function and reward relationship

Room function and primary reward are related but separate.

- A combat room defines the encounter space.
- A reward marker previews the main payout for clearing it.
- Shrine, rest, shop, treasure, miniboss, and boss spaces retain their own stable service or encounter identity.

Where the route branches, the player should understand the upcoming room function and previewed primary reward before committing. Reward markers cannot rely on color alone.

The exact economy and reward-generation rules belong in [Items, Currencies, and Rewards](../gameplay/ITEMS_AND_REWARDS.md).

Exact room counts, route topology, branch frequency, miniboss frequency, and authored layout counts remain prototype and playtest decisions. The initial production boundary is the reusable room-family and modular regional-kit requirement defined below.

## Combat Room

**Function:** standard enemy encounter drawn from the current area's roster.

**Reward behavior:** one previewed primary reward after completion. Eligible categories include a Technique reward, Gold, Mist, Scrolls, recovery, temporary capacity, or another approved standard-combat payout.

**Shared read:** moderately sized open footprint, clear central sightlines, minimal combat clutter, and modular area-specific dressing around the perimeter. A route marker or entrance treatment communicates the primary payout without making the space look like a modern loot chamber.

**Area skins:**

- **Hushiro:** village lane, courtyard, gatehouse interior, or barricaded crossing.
- **Yomori:** forest clearing, widened hunting path, or shrine approach.
- **Kagutsuchi:** lacquered chamber, bridge expanse, or blossom courtyard.

**Production rules:** ambient fog, mist, fungal pulse, petals, water, or lantern motion cannot crowd the combat footprint. Build reusable templates with perimeter variants rather than unique room art for every encounter. Technique-marked combat rooms use the same environment kit as other combat rooms; their identity comes from route preview and reward presentation.

## Shrine Room

**Function:** in-run recovery and Corruption decision point.

**Reward behavior:** if Corruption is full, present Resist or Embrace. Otherwise grant approved Shrine support such as Health or Spirit recovery. Shrines do not normally offer Techniques.

**Shared read:** small quiet ritual room centered on an immediately visible Shrine object. Safe, but not conventionally holy. If Corruption is full, the Shrine visibly reacts and presents Resist or Embrace. Otherwise it still grants normal support so the room never feels dead.

**Area skins:**

- **Hushiro:** weather-worn village Shrine.
- **Yomori:** moss-eaten forest Shrine with roots and spirit light.
- **Kagutsuchi:** immaculate court Shrine with gilded trim and blossom offerings.

**Production rules:** the central object must be visible from the entrance. Use warm ritual light, restrained incense or mineral pulse, calmer audio, and no active threat language. The interface shows equipped Aspect, Tier, Corruption, and the approved Resist / next-Embrace information. Its visual language remains distinct from Technique rewards.

## Rest Room

**Function:** Health and Spirit recovery, read-only build review, and short narrative breathing room between pressure sequences.

**Reward behavior:** restore approved Health and Spirit values. Rest rooms do not generate new Techniques, recover discarded Techniques, or permit routine swapping between filled combat slots.

**Shared read:** enclosed or sheltered space with one bright inviting rest focal point and softer composition than neighboring combat spaces.

**Area skins:**

- **Hushiro:** boarded village room, sheltered guardhouse, or hearth interior.
- **Yomori:** root-sheltered hollow or Shrine-adjacent clearing.
- **Kagutsuchi:** quiet lacquered chamber with floor cushions and a small lantern.

**Production rules:** gentle warmth, low particulate motion, and no threat cues. Rest rooms should be recognizable immediately. Build review is compact and read-only rather than a Technique inventory or respec screen.

## Shop Room

**Function:** mid-run merchant offering limited run-scoped goods for Gold.

**Reward behavior:** stock may include healing, Spirit, temporary capacity, approved consumables, rerolls, **Technique rewards**, and occasional run-scoped Relics. Purchasing a Technique reward opens the same universal Technique reward screen used by other approved sources.

**Shared read:** compact safe space with merchant figure, merchandise spread, and lantern-warm purchase focal point. It inherits the Strand Merchant Stall's internal layout language in a smaller temporary form.

**Area skins:**

- **Hushiro:** salvage spread on a broken village floor.
- **Yomori:** traveling altar or moss-bed display.
- **Kagutsuchi:** refined courtier display table in a lacquered alcove.

**Production rules:** merchant and merchandise dominate the center. Enemies do not spawn here. It is a purchase-decision space, not an exploration room. Technique purchases use the normal reward-card language rather than a shop-specific refinement or Prosthetic-Technique interface.

## Treasure and Miniboss Rooms

**Function:** risk/reward spaces culminating in a clearly presented high-value payout.

**Treasure behavior:** may provide a Technique reward, Relic choice, large currency bundle, major temporary capacity increase, approved rare consumable, or another previewed high-value reward.

**Miniboss behavior:** victory guarantees meaningful build development such as a Technique reward, run-scoped Relic, special regional reward, or modest persistent currency in addition to the main payout. It should not award only ordinary Gold or healing. A miniboss Technique reward may later receive better rarity or quality weighting, but it still uses the universal Technique reward screen.

**Shared read:** larger and more dramatic than a standard combat room, with landmark framing, deliberate arena footprint, and an unmistakable reward object revealed before or after victory.

**Area skins:**

- **Hushiro:** ruined training yard, gate courtyard, or mortuary street.
- **Yomori:** root-choked arena, corrupted Shrine circle, or old hunting ground.
- **Kagutsuchi:** lacquered terrace, blossom courtyard, or ceremonial approach.

**Production rules:** signal increased importance immediately on entry. Reuse approved miniboss arena foundations where practical. Reward objects must not be mistaken for decoration or breakables. Miniboss reward presentation should read as more valuable than a standard combat reward without implying a separate Technique subtype interface.

## Boss Room

**Function:** the area's culminating boss encounter.

**Reward behavior:** regional bosses that lead into another area provide persistent progression, a major current-run reward, and approved transition recovery. Defeating the Eclipse Shogun opens temporary access to the Heart chamber and the successful-run Binding ritual or true-final continuation.

**Shared read:** largest and most thematically saturated authored space in the region, designed first around boss mechanics and only then dressed outward.

**Area skins:**

- **Hushiro:** old stone gate and threshold where the village ends.
- **Yomori:** root-tangled, spirit-saturated heart of the grove.
- **Kagutsuchi:** royal throne-space or ritual sanctum guarding the Heart route.

**Production rules:** perimeter art and ambient particles never compete with the boss silhouette or attack telegraphs. The arena may evolve during phase changes, but geometry, hazard boundaries, and safe space stay readable. Each boss room receives a dedicated environment brief.

## Heart Binding Completion Space

**Function:** specialized successful-run space reached after defeating the Eclipse Shogun.

**Current behavior:** Akio reaches the Heart chamber, uses the Shogun-built extraction apparatus to offer Returning Blood, breaks one ancient Heart Binding through the Heart's rejection response, is dissolved by the retaliation, and reconstructs at the Strand.

**Approved campaign states:** the Court historically destroyed the outermost of seven original Bindings. Six remain when Akio begins, producing six player-destroyed states followed by the fully exposed Heart and true-final encounter.

**Shared read:** unmistakably deeper and older than the Shogun's court. Ancient Binding architecture and the later Court-built extraction apparatus must read as distinct historical layers.

**Production rules:** reuse the same apparatus and core completion sequence across successful clears. Escalate through damaged or removed Binding states, greater Heart exposure, stronger chamber reactions, and limited visual variants rather than a new mechanism, puzzle, or environment for every completion. Final Heart anatomy and true-final arena details remain owned by the approved Heart concept and later encounter design.

## Identification standard

The player should identify the room's function and, when applicable, its previewed primary reward before or immediately upon entry through footprint, focal object, lighting hierarchy, iconography, and perimeter language. Color alone is not sufficient.