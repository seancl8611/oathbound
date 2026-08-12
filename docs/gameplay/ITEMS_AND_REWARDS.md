---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-12
topics:
  - currencies
  - pickups
  - techniques
  - relics
  - blood-resource
  - room-rewards
  - reward-cadence
  - heart-binding-completion
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RUN-STRUCTURE
  - CONTENT-ROOM-TYPES
  - META-OPEN-QUESTIONS
---

# Items, Currencies, and Rewards

This file owns reward categories, currency ownership, room payouts, and the current reward-cadence framework. Exact rates, prices, route probabilities, room counts, and numerical values remain balance and implementation work unless explicitly approved elsewhere.

## Reward goals

The reward framework should:

- make route choices readable before commitment,
- build run power gradually,
- create meaningful competition between Aspect, Technique, survival, economy, and rare-reward routes,
- keep Technique rewards valuable after all five core combat slots are filled,
- support focused and hybrid Technique builds,
- allow occasional high-roll builds without making ideal builds routine,
- and avoid severe random failure or exact-combination dependence.

Major rewards support:

1. **Build growth** — Technique rewards, Relics, and optional Aspect Tier advancement through Shrine routes.
2. **Survival** — Health, Spirit, recovery, temporary capacity.
3. **Economy** — Gold, shops, rerolls.
4. **Persistent progress** — Mist, Scrolls, Boss Emblems, unlocks, discoveries, Heart Bindings.

## Currency families

| Currency | Persistence | Primary role |
|---|---|---|
| Mist | Persistent | Broad meta progression |
| Scroll | Persistent | Forge upgrades, including permanent Prosthetic development |
| Boss Emblem | Persistent | Rare major progression gates |
| Gold | Run-only | Shops and run economy |

Corruption, Blood, and destroyed Heart Bindings are not currencies.

- **Corruption** governs Shrine-ready Aspect progression.
- **Blood** is a Tier II-and-later run-only combat resource used to activate the selected Blood Art.
- **Destroyed Heart Bindings** are persistent campaign state.

Blood is not purchased, banked at the Strand, displayed as a route reward, or carried between runs. `Mist Shards` remains deprecated unless intentionally restored.

## Pickups and minor drops

- Health restores HP.
- Spirit restores the shared Prosthetic resource.
- Minor enemy and breakable drops may include small Gold, Health, Spirit, Mist, or Scroll value where approved.
- Blood is generated through the approved Blood Aspect combat rules rather than treated as an ordinary pickup.
- Minor drops support flow but do not replace the room's previewed primary reward.

## Route previews and opportunity cost

The primary reward category should be shown before route commitment through a consistent symbol or environmental marker.

Supported preview categories may include Technique, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, rest, shop, treasure, miniboss, and boss.

Choosing a Shrine can mean giving up a Technique, Relic, economy, or survival opportunity; choosing another route can delay Aspect advancement.

Exact route topology and reward distribution remain later run-design and playtest decisions.

## Standard combat rewards

A standard combat room awards one previewed primary reward after completion.

Eligible rewards include Gold, Mist, Scrolls, Health or Spirit recovery, temporary capacity, a Technique reward, and an approved reroll resource.

Combat rooms are the **primary source of Technique rewards**, but not the only source.

## Universal Technique reward

A Technique reward always opens the same underlying Technique reward screen and follows the same eligibility rules regardless of source.

A Technique reward may come from:

- a standard combat room,
- a shop purchase,
- treasure,
- a miniboss,
- a regional boss,
- or another explicitly approved source.

The source does not make the reward inherently a "refinement reward," "Legendary reward," or another separate Technique subtype.

Depending on the current build, an eligible Technique reward screen may offer:

- a Technique for an empty combat slot,
- a slotless supporting Technique,
- a refinement for an owned slotted Technique,
- a rare same-slot replacement,
- a cross-family Technique,
- or an eligible Legendary.

The reward source may later influence rarity or quality weighting, but all sources use the same Technique system rather than separate reward interfaces or subtype-specific reward pools.

There is no global Technique inventory cap. The main cap on Technique growth is how many Technique rewards the player chooses and receives during the run.

The player may decline all Technique choices for a displayed lower-value fallback when that source allows a decline.

Detailed slot, rarity, replacement, family, and refinement rules belong in `TECHNIQUES.md`.

## Shrine rooms

Shrines own Blood Aspect stabilization and optional escalation.

- At full Corruption: present Resist or Embrace.
- Embrace advances the fixed Aspect Tier.
- Resist keeps the Tier and provides approved stabilization support.
- Below full Corruption: provide approved support such as Health or Spirit recovery.
- Shrines do not normally present ordinary Technique rewards.
- Blood Art charge is separate from Corruption and does not pay for Embrace.

## Rest rooms

Rest rooms provide Health and Spirit recovery, read-only build review, and short narrative breathing room where appropriate.

The retired reserve-slot model no longer supports routine Technique swapping at rest rooms.

## Shops

Run shops use Gold and may offer recovery, temporary capacity, consumables if included, rerolls, **Technique rewards**, and occasional Relics.

When a shop sells a Technique reward, purchasing it opens the normal Technique reward screen rather than a separate refinement-only or supporting-only screen.

Technique purchases should be expensive enough that Gold routing is a meaningful strategy rather than an automatic purchase path.

Blood is not directly bought or sold.

## Treasure and miniboss rewards

Treasure rooms may provide a Technique reward, Relic choice, large currency bundle, major temporary capacity, or rare consumable if consumables ship.

A miniboss guarantees meaningful build development and should never award only ordinary Gold or healing. Possible rewards include:

- a Technique reward,
- a Relic,
- a special encounter reward,
- modest additional Mist or Scrolls.

A miniboss Technique reward may later receive better rarity weighting, but it still uses the universal Technique reward screen.

Miniboss frequency and route placement remain later gameplay decisions.

## Regional boss rewards

The Area 1 and Area 2 bosses provide both persistent and current-run value.

Persistent rewards may include Boss Emblems, Mist, Scrolls, unlocks, and narrative or codex progress.

Current-run rewards may include a Technique reward, Relic, or major temporary Health or Spirit improvement.

Regional transitions should restore enough Health or Spirit for the next area to begin from a viable state. Blood is not automatically refilled by the reward system.

## Eclipse Shogun and Heart Binding completion

The Eclipse Shogun does not grant additional current-run power during the first six successful clears because the run ends after the Binding ritual.

After defeating him, Akio enters the Heart chamber, offers Returning Blood through the extraction apparatus, breaks one remaining Heart Binding, is dissolved by the Heart, and reconstructs at the Strand.

Permanent completion rewards may include destroyed-Binding progress, Mist, Scrolls, Boss Emblems, unlocks, discoveries, codex progress, and results confirmation.

After all six Bindings are destroyed, the seventh successful story run continues from the Shogun into the Heart.

## Relics

Relics are rare run-scoped passive rules using a separate slot. The initial structure uses one equipped Relic.

The current provisional rarity sketch is Common, Rare, and Legendary. This is not locked.

Relics are separate from Techniques. Techniques do not need Relic-specific upgrade cards, and Relics do not occupy one of the five Technique combat slots.

## Pacing framework

Within the approved 45-50-minute successful-run target, Technique reward frequency must be tuned against both core-slot filling and later supporting upgrades.

The old assumption of only six to eight Technique decisions is no longer authoritative.

Regional direction remains:

- **Area 1:** establish early core Technique identity.
- **Area 2:** fill more core slots and begin family/build deepening.
- **Area 3:** refine, deepen, pursue rare replacements or Legendaries, and finalize the build.

Exact counts and probabilities remain open.

## Expected build outcomes

The reward structure should continue supporting Tier 0-I Technique-focused runs, Tier II hybrids, Tier III Aspect-heavy runs, and occasional Tier IV high-rolls.

A Technique-heavy route may accumulate more slotless upgrades than an Aspect-heavy route. That is intended opportunity cost rather than a global Technique-cap problem.

## Guardrails

- Do not require an exact Technique combination for a viable run.
- Do not generate three invalid choices.
- A direct Technique cannot stack with another direct Technique in the same combat slot.
- Supporting Techniques must be meaningful enough to justify a reward choice.
- Rare replacement offers must clearly show what current slotted Technique will be lost.
- Prosthetic upgrades do not belong in Technique reward screens.
- Blood is a combat resource, not a currency or route reward.
- Rare rewards must not invalidate sword combat or boss mechanics.
- Mandatory encounters must not assume a particular Aspect Tier, Blood Art, Technique family, or ideal build.

## Current production dependency

The five core family mechanics are defined. The active run-build task is to finish and approve the direct five-by-five Technique matrix, then rebuild supporting, cross-family, Legendary, refinement, rarity, and reward-frequency work from that stable roster.