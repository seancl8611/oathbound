---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-08-07
topics:
  - full-scope
  - asset-counts
  - areas
  - strand
  - techniques
  - the-heart
  - heart-bindings
  - campaign-clears
  - true-final-heart
  - postgame
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document defines Oathbound's current production-level shape. It does not lock exact balance values, route algorithms, frame data, final attack timings, or other implementation details that require prototyping and playtesting.

## Master scope

| Asset group | Planned count | Current boundary |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, introductory combat, three Aspect combat libraries |
| Blood Aspects | 3 | Wolf, Wraith, Ronin |
| Technique loadout | 4 active + 1 reserve | Launch catalog size remains open |
| Prosthetic tools | 8 | One equipped at a time |
| Run-scoped Relic capacity | 1 | Launch catalog remains open |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro rupture roster |
| Area 2 standard enemies | 4 | Yomori spirit/predator roster |
| Area 3 standard enemies | 5 | Kagutsuchi court roster |
| Miniboss encounters | 6 | Two designed encounters per area |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach and six player-destroyed Bindings |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart, Vessel of Continuance |
| Environment sets | 4 + Heart subset | Strand, Areas 1–3, Heart chamber states |
| Cross-area room functions | 6 | Combat, Shrine, rest, shop, treasure/miniboss, boss |
| Currency families | 4 | Mist, Scroll, Boss Emblem, Gold |
| Relic rarity tiers | 4 | Common, Uncommon, Rare, Legendary |

## Player and run build

Akio begins with a complete introductory katana kit. Core combat includes parry, player/enemy posture, stagger, deathblow, block, dash, and Prosthetic support.

After Returning Blood awakens, launch scope includes:

- one selected Blood Aspect as the immediate Tier 0 weapon foundation,
- three complete Aspect packages from Tier 0 through Tier IV,
- one physical katana expressed through Aspect-specific Blood forms,
- universal controls, locomotion, neutral dash, parry timing, enemy rules, and deathblow language,
- player-directed attacks without corrective tracking, homing, or post-input correction,
- optional fixed Aspect advancement through Shrine Resist/Embrace decisions,
- Blood as a run-only resource unavailable before Tier II,
- four active Technique slots and one reserve,
- one refinement maximum per Technique,
- one equipped Prosthetic,
- and one run-scoped Relic slot.

A fourth or fifth Aspect is outside current production scope.

## Locked Aspect scope

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **Tier 0** | Four-hit close pressure/pursuit kit | Two-hit extended reach/control kit | Three-hit heavy impact/stability kit |
| **Tier I** | Blood Tempo | Pale Barrage | Steadfast Reprisal |
| **Growth** | Feral Momentum | Spectral Edge | Maximum player-posture capacity |
| **Tier II** | Blood Hunt / Blood Fang | Wraith's Reach | Falling Mountain / Deep Rupture |
| **Tier III** | Fanged Guard | Spectral Passage | Unbroken Resolve / Measured Weight / Perfect Weight |
| **Tier IV** | Apex Mauling | Beyond the Veil | Shattering Wake |

Supporting growth is deliberately narrow:

- Wolf increasingly rewards later connected Basic positions.
- Wraith increasingly rewards eligible spectral-only contact with posture and guard pressure.
- Ronin gains modest maximum player-posture capacity at each Embrace; posture recovery speed and block efficiency do not scale.

The Blood Art distinction is fixed:

> **Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point.**

All three packages are ready for the final cross-roster paper-design comparison. Final animation counts, VFX counts, frame data, combat values, collision, and effect timing still require implementation briefs and playable validation.

## Optional investment outcomes

Launch balance must support:

- Tier 0-I with an excellent coherent Technique build,
- Tier II with a solid Technique build as a common hybrid,
- Tier III with fewer horizontal upgrades as deliberate Aspect specialization,
- occasional Tier IV high-roll runs.

Mandatory encounters must not assume a particular Tier or Blood Art.

## Run-duration target

A normal successful Binding run targets approximately **45–50 minutes** of active time.

- Experienced repeat clears may take roughly 35–42 minutes.
- Slower successful clears may approach 60 minutes.
- The seventh story run adds the two-form Heart encounter and may reach roughly 55–60 minutes.

Exact room counts, route topology, branch frequency, and miniboss frequency remain prototype decisions unless they create additional production scope.

## The Strand

Persistent NPCs:

- Keeper
- Peddler
- Smith
- Raven
- Undead Samurai
- Scribe

Primary services:

- Boat / run confirmation
- Forge Bench
- Merchant Stall
- Discovery Board
- Bloodwell
- Blood Cavern
- Blood Mirror

Service ownership is approved. Exact launch depth of permanent upgrades, onboarding, trials, unlocks, mastery content, and UI states remains open.

## Area 1 — Hushiro Gate Village / Rupture

Standard enemies:

- Corrupted Swordsman
- Corrupted Archer
- Blighted Hounds
- Hollow
- Cellar Bilemass
- Warden

Minibosses:

- Village Ogre
- The Collector

Boss:

- Keeper of the Gate

Hushiro represents recent corruption, bodily collapse, fragmented community, violence, and desperate faith.

## Area 2 — Yomori Grove / Adaptation

Standard enemies:

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound

Minibosses:

- Embered Pilgrim
- Rotwood Host

Boss:

- Twin Maws: Rootfang and Briarthorn

Both twins begin active. The first defeated transfers part of the shared bond to the survivor.

Yomori represents long-term predation, spirit persistence, and ecological damage caused by corrupted inhabitants and beasts. Beast Blood does not spread through soil, roots, water, prey, or vegetation.

## Area 3 — Kagutsuchi Court / False Ascendancy

Standard enemies:

- Court Guard
- Court Caster
- Elite Defender
- Hollow Vessel
- Court Sentinel

Minibosses:

- Blood Lotus
- Eternal Swordsman

Boss:

- Eclipse Shogun

Kagutsuchi is an immaculate royal court whose elites retain intelligence, hierarchy, and disciplined mutation while remaining unable to reject Beast Blood.

The Shogun's high-level identity is approved. Exact phase count, weapon, attacks, transformation anatomy, animation list, and VFX remain later encounter-design work.

## Heart Binding campaign

The Heart's prison originally contained seven ancient Bindings. The Court destroyed the outermost Binding during the plague, leaving six intact when Akio begins.

Each of the first six successful clears destroys one remaining Binding and permanently preserves that progress.

After the sixth remaining Binding is destroyed, the next successful run becomes the seventh and final story run and continues from the Eclipse Shogun into the Heart.

The true-final Heart has two conceptual forms:

1. **The Unbound Heart**
2. **The Vessel of Continuance**

Destroying the Heart ends Beast Blood, stops the Shogun's reconstruction, ends the Blood Moon, and leaves Akio mortal.

Postgame retains repeatable normal runs and optional Heart-route access without changing the completed ending.

## Run-build and persistence boundary

Temporary run state includes Aspect Tier, Corruption, Blood, Techniques/refinements, temporary Prosthetic specialization, run Relic, Gold, temporary capacities, and room progress.

Persistent state includes destroyed Bindings, story/codex progress, Aspect unlocks/mastery, permanent upgrades, and persistent currencies.

No duplicate Blood Art progression tree beneath each Aspect is included in launch scope.

## Current open production scope

1. Final cross-roster Aspect comparison.
2. Launch Technique/Prosthetic-Technique/Relic/consumable catalog.
3. Persistent progression, onboarding, and trial package.
4. Narrative delivery, voice, cinematic, portrait, and final-writing package.
5. Postgame reward and UI package.

## Deferred implementation work

Exact frame data, hitboxes, damage, posture, stagger, movement, recovery, Blood values, Tier-growth percentages, collision, pathing, room algorithms, route probabilities, reward probabilities, prices, animation frames, VFX density, audio timing, and final HUD layout remain implementation and playtesting work.

The removed Storm, Frost, Ember, Hex, and Shadow stance system is not part of the game.