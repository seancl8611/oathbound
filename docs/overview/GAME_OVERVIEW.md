---
id: OVERVIEW-GAME
title: Oathbound Game Overview
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-07
topics:
  - project-identity
  - combat
  - returning-blood
  - inherited-beast-blood
  - blood-moon
  - techniques
  - three-areas
  - the-heart
  - heart-bindings
  - true-final-heart
  - postgame
related:
  - OVERVIEW-DESIGN-PILLARS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RUN-STRUCTURE
  - LORE-RETURNING-BLOOD
  - LORE-BARRIER-BLOOD-MOON
---

# Oathbound Game Overview

Oathbound is a high-angle 2D action roguelite built around disciplined katana combat, posture pressure, precise parries, stagger, deathblows, Hades-like room-and-boss flow, and run-based build progression.

The game should feel disciplined, dangerous, elegant, and cursed. Combat readability takes priority over spectacle.

## Premise

The player controls Akio, a warrior of the Order sent through a containment barrier onto a cursed Japanese-gothic island.

The island's kingdom once used Beast Blood from the Heart—an ancient living supernatural core—to survive a plague. The Heart was already imprisoned beneath the island by seven ancient Bindings. During the plague, the Court breached the outermost Binding and built an extraction apparatus against the exposed Heart.

The Blood Moon reflects a recurring active cycle within the Heart. During it, existing Beast Blood strengthens and the barrier comes under pressure. The Strand, its Keeper, and a sealed Boat provide Akio's controlled route into the island.

## Akio and Returning Blood

Akio unknowingly descends from a royal child born during the kingdom's early Beast Blood era and escaped before the barrier was completed.

Akio begins without active Blood powers. His first death inside the barrier during the Blood Moon awakens the dormant inherited condition and reconstructs him at the Strand as Returning Blood.

His lineage explains why the power can awaken; his discipline explains why he can control and evolve it without surrendering to the curse.

## Core player fantasy

The player enters with a complete sword foundation, awakens forbidden inherited power, chooses one Blood Aspect before each run, and decides how deeply to invest in that Aspect versus Techniques and other run rewards.

Victory comes from reading intent, controlling rhythm, pressuring posture, building a coherent run loadout, and judging commitment correctly.

## Approved gameplay snapshot

- Introductory attempt with a complete base katana kit and no active Blood powers.
- First death awakens Returning Blood and reconstructs Akio at the Strand.
- Shared combat: parry, player/enemy posture, stagger, deathblow, block, dash, and Prosthetic support.
- One selected Blood Aspect creates the immediate Tier 0 weapon identity.
- Launch roster: **Wolf, Wraith, Ronin**.
- Universal locomotion, neutral dash, parry timing, enemy rules, and deathblow language across Aspects.
- No corrective tracking, hidden homing, or post-input target correction.
- Optional fixed Aspect progression from Tier 0 through Tier IV through Shrine Resist/Embrace decisions.
- Blood is run-only and unavailable before Tier II.
- Four active temporary Techniques, one reserve, and at most one refinement per Technique.
- One equipped Prosthetic and one run-scoped Relic.
- Failed runs return Akio to the Strand through Returning Blood reconstruction.

## Launch Blood Aspect roster

| Aspect | Tier 0 identity | Inherent tradeoffs |
|---|---|---|
| **Wolf** | Four-hit fast close pressure and player-directed pursuit | Short reach, unsafe misses, dangerous overextension |
| **Wraith** | Two-hit extended spectral reach and frontal control | Fewer ordinary options, restrained movement, close/lateral pressure |
| **Ronin** | Three-hit slow heavy impact and strongest guard | Slow startup, severe recovery, minimal movement, slow posture recovery |

### Fixed Tier packages

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **I** | Blood Tempo | Pale Barrage | Steadfast Reprisal |
| **Growth** | Feral Momentum | Spectral Edge | Maximum player-posture capacity |
| **II** | Blood Hunt / Blood Fang | Wraith's Reach | Falling Mountain / Deep Rupture |
| **III** | Fanged Guard | Spectral Passage | Unbroken Resolve / Measured Weight / Perfect Weight |
| **IV** | Apex Mauling | Beyond the Veil | Shattering Wake |

Repeated growth remains narrow and Aspect-specific:

- Wolf increasingly rewards later connected Basic positions.
- Wraith increasingly rewards eligible spectral-only contact with posture/guard pressure.
- Ronin gains modest maximum player-posture capacity at every Embrace while posture recovery and block efficiency remain unchanged.

The three Blood Arts are intentionally different:

> **Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point.**

All three Aspect packages are locked at current qualitative paper-design depth. They are not active design questions unless prototyping exposes a concrete problem. Exact combat values, timing, hitboxes, growth percentages, and final effects remain prototype and playtesting work.

## Run-build philosophy

- Base combat and player skill remain primary.
- The selected Aspect provides the strongest immediate weapon identity.
- Tier 0 is complete and viable.
- Aspect progression is optional vertical development rather than a branching tree.
- Shrine routing competes with Techniques, Relics, economy, survival, and other rewards.
- Tier 0-I Technique-focused builds, Tier II hybrids, and deeper Tier III-IV Aspect builds should all be viable.
- Mandatory encounters do not assume a particular Tier or Blood Art.
- Techniques provide temporary horizontal customization through shared combat verbs.
- Run power should deepen active combat rather than replace it with automatic damage.

No duplicate Aspect-specific Blood Art upgrade tree is approved.

## Campaign structure

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding before the game, leaving six intact.

During each of the first six successful clears, Akio defeats the Eclipse Shogun, reaches the Heart chamber, uses Returning Blood with the Court's apparatus to break one remaining Binding, and reconstructs at the Strand with permanent progress intact.

After the sixth remaining Binding is destroyed, the next successful run becomes the seventh and final story run. It continues from the Shogun into the true-final Heart encounter.

The Heart encounter has two conceptual forms:

1. **The Unbound Heart** — a mobile beastlike organ with malformed support limbs.
2. **The Vessel of Continuance** — an enormous nonhuman defensive body formed around the visibly central Heart.

Destroying the Heart ends the source of Beast Blood, stops the Shogun's reconstruction, ends the Blood Moon, weakens the barrier, and leaves Akio mortal in his current human body.

## World structure

- **The Strand:** persistent hub, preparation, progression, and return point.
- **Introductory attempt:** short unpowered entry ending in the Returning Blood awakening.
- **Area 1 — Hushiro Gate Village / Rupture:** recent corruption, violence, bodily collapse, fragmented community.
- **Area 2 — Yomori Grove / Adaptation:** long-term predation, incomplete spirit remnants, ecological devastation caused by corrupted inhabitants and beasts.
- **Area 3 — Kagutsuchi Court / False Ascendancy:** courtly beauty, hierarchy, elite mutation, and false mastery of Beast Blood.
- **First six successful clears:** Eclipse Shogun followed by the Binding ritual.
- **Final story run:** Shogun followed by the two-form Heart.
- **Postgame:** repeatable normal runs and optional Heart-route access without changing the completed story.

A normal successful Binding run currently targets roughly 45–50 minutes. Exact room counts, route topology, encounter frequency, and authored layouts remain prototype work.

## Current unresolved scope

The remaining production-level questions are maintained in [Current Design Questions](../_meta/OPEN_QUESTIONS.md):

1. launch run-build content catalog,
2. persistent progression, onboarding, and trial package,
3. narrative delivery and authored-content package,
4. postgame release package.

## Source links

- [Design pillars](DESIGN_PILLARS.md)
- [Full game scope](FULL_GAME_SCOPE.md)
- [Combat](../gameplay/COMBAT.md)
- [Blood Aspects](../gameplay/BLOOD_ASPECTS.md)
- [Progression](../gameplay/PROGRESSION.md)
- [Technique System](../gameplay/TECHNIQUES.md)
- [Run structure](../gameplay/RUN_STRUCTURE.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)