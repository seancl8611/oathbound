---
id: OVERVIEW-GAME
title: Oathbound Game Overview
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-14
topics:
  - project-identity
  - combat
  - returning-blood
  - techniques
  - blood-aspects
  - heart-bindings
related:
  - OVERVIEW-DESIGN-PILLARS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RUN-STRUCTURE
  - LORE-RETURNING-BLOOD
---

# Oathbound Game Overview

Oathbound is a high-angle 2D action roguelite built around disciplined katana combat, posture pressure, precise parries, stagger, deathblows, Hades-like room-and-boss flow, and run-based build progression.

The game should feel disciplined, dangerous, elegant, and cursed. Combat readability takes priority over spectacle.

## Premise

The player controls Akio, a warrior of the Order sent through a containment barrier onto a cursed Japanese-gothic island.

The island's kingdom once used Beast Blood from the Heart—an ancient living supernatural core—to survive a plague. Akio unknowingly descends from a royal child born during that era and escaped before containment.

Akio begins without active Blood powers. His first death inside the barrier during the Blood Moon awakens the dormant inherited condition and reconstructs him at the Strand as Returning Blood.

His lineage explains why the power can awaken; his discipline explains why he can control and evolve it without surrendering to the curse.

## Core player fantasy

Akio is a disciplined swordsman who learns to direct a supernatural curse through his existing martial skill.

The selected Blood Aspect determines how Akio fundamentally fights. Techniques are the main horizontal run-build layer and reshape his existing sword actions through recurring supernatural effects such as Echo, Rupture, Seal, Rift, and Crimson Vulnerable/backstab/direct Health damage.

## Approved gameplay snapshot

- Introductory attempt with a complete base katana kit and no active Blood powers.
- First death awakens Returning Blood and reconstructs Akio at the Strand.
- Shared combat: parry, player/enemy posture, stagger, deathblow, block, dash, universal backstab classification, and Prosthetic support.
- One selected Blood Aspect creates the immediate Tier 0 weapon identity.
- Launch roster: **Wolf, Wraith, Ronin**.
- Optional fixed Aspect progression from Tier 0 through Tier IV through Shrine Resist/Embrace decisions.
- Blood is run-only and unavailable before Tier II.
- Five core Technique slots tied to **Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow**.
- One direct Technique maximum per core combat slot; rare replacement offers may overwrite a filled slot.
- The current working Technique roster is **50 actual Techniques plus 10 refinements**.
- The 50 Techniques include 25 direct, 15 same-family Supporting, 5 Cross-family, and 5 Legendary Techniques.
- Technique rarity distribution is 10 Common, 18 Uncommon, 17 Rare, and 5 Legendary.
- At most one refinement per eligible slotted Technique.
- One equipped Prosthetic and one run-scoped Relic.
- Failed runs return Akio to the Strand through Returning Blood reconstruction.

## Launch Blood Aspect roster

| Aspect | Tier 0 identity | Inherent tradeoffs |
|---|---|---|
| **Wolf** | Four-hit fast close pressure and player-directed pursuit | Short reach, unsafe misses, dangerous overextension |
| **Wraith** | Two-hit extended spectral reach and frontal control | Fewer ordinary options, restrained movement, close/lateral pressure |
| **Ronin** | Three-hit slow heavy impact and strongest guard | Slow startup, severe recovery, minimal movement, slow posture recovery |

All three Aspect packages are locked at current qualitative paper-design depth. Exact combat values, timing, hitboxes, growth percentages, and final effects remain prototype and playtesting work.

## Run-build philosophy

- Base combat and player skill remain primary.
- The selected Aspect provides the strongest immediate weapon identity.
- Tier 0 is complete and viable.
- Aspect progression is optional vertical development.
- Techniques provide the main horizontal build development.
- The five Technique families are **Echo, Rupture, Seal, Rift, and Crimson Vulnerable/backstab/direct Health damage**.
- Technique families may use different buildup structures and early/late power curves rather than one standardized stacking model.
- Every direct Technique should remain useful even when it is the player's only pickup from that family.
- Supporting and Cross-family eligibility must avoid dead offers.
- Family Legendaries require meaningful prior family investment rather than appearing as isolated early pickups.
- Generic elemental schools are not the target.
- Focused and hybrid Technique builds should both be viable.
- Technique-heavy Tier 0-I, Tier II hybrid, Tier III Aspect-heavy, and occasional Tier IV high-roll runs should all be viable.
- Mandatory encounters do not assume a particular Tier, Blood Art, Technique family, or Legendary.

## Campaign structure

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding before the game, leaving six intact.

During each of the first six successful clears, Akio defeats the Eclipse Shogun, reaches the Heart chamber, uses Returning Blood with the Court's apparatus to break one remaining Binding, and reconstructs at the Strand with permanent progress intact.

After the sixth remaining Binding is destroyed, the next successful run becomes the seventh and final story run. It continues from the Shogun into the true-final Heart encounter.

Destroying the Heart ends the source of Beast Blood, stops the Shogun's reconstruction, ends the Blood Moon, weakens the barrier, and leaves Akio mortal in his current human body.

## World structure

- **The Strand:** persistent hub, preparation, progression, and return point.
- **Introductory attempt:** short unpowered entry ending in the Returning Blood awakening.
- **Area 1 — Hushiro Gate Village / Rupture**
- **Area 2 — Yomori Grove / Adaptation**
- **Area 3 — Kagutsuchi Court / False Ascendancy**
- **First six successful clears:** Eclipse Shogun followed by the Binding ritual.
- **Final story run:** Shogun followed by the two-form Heart.
- **Postgame:** repeatable normal runs and optional Heart-route access without changing the completed story.

A normal successful Binding run currently targets roughly 45-50 minutes. Exact room counts, route topology, encounter frequency, and authored layouts remain prototype work.

## Current unresolved scope

The remaining production-level questions are maintained in [Current Design Questions](../_meta/OPEN_QUESTIONS.md). The immediate Technique task is now **reward structure and roster validation**: reward frequency, offer-generation order, rarity probabilities/source weighting, rare replacement behavior, and the complete 50-Technique audit.

## Source links

- [Design pillars](DESIGN_PILLARS.md)
- [Full game scope](FULL_GAME_SCOPE.md)
- [Combat](../gameplay/COMBAT.md)
- [Blood Aspects](../gameplay/BLOOD_ASPECTS.md)
- [Progression](../gameplay/PROGRESSION.md)
- [Technique System](../gameplay/TECHNIQUES.md)
- [Run structure](../gameplay/RUN_STRUCTURE.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
