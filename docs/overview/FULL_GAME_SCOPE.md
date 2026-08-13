---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-08-13
topics:
  - full-scope
  - techniques
  - areas
  - strand
  - the-heart
  - postgame
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document defines Oathbound's current production-level shape. It does not lock exact balance values, route algorithms, frame data, final attack timings, or other implementation details that require prototyping and playtesting.

## Master scope

| Asset group | Planned count | Current boundary |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, introductory combat, three Aspect combat libraries |
| Blood Aspects | 3 | Wolf, Wraith, Ronin |
| Core Technique slots | 5 | Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow |
| Direct Technique matrix | 25 approved concepts | Five families × five direct combat slots |
| Supporting Technique capacity | No fixed inventory cap | Limited by Technique rewards, rarity, prerequisites, and run length |
| Prosthetic tools | 8 | One equipped at a time; permanent Forge progression |
| Run-scoped Relic capacity | 1 | Launch catalog remains open |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro rupture roster |
| Area 2 standard enemies | 4 | Yomori spirit/predator roster |
| Area 3 standard enemies | 5 | Kagutsuchi court roster |
| Miniboss encounters | 6 | Two designed encounters per area |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach and six player-destroyed Bindings |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart, Vessel of Continuance |
| Currency families | 4 | Mist, Scroll, Boss Emblem, Gold |
| Relic rarity tiers | Provisional 3 | Common, Rare, Legendary working sketch |

## Player and run build

Akio begins with a complete introductory katana kit. Core combat includes parry, player/enemy posture, stagger, deathblow, block, dash, universal rear-hit / backstab classification, and Prosthetic support.

After Returning Blood awakens, launch scope includes:

- one selected Blood Aspect as the immediate Tier 0 weapon foundation,
- three complete Aspect packages from Tier 0 through Tier IV,
- optional fixed Aspect advancement through Shrine Resist/Embrace decisions,
- Blood as a run-only resource unavailable before Tier II,
- five direct Technique slots tied to Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow,
- one direct Technique maximum per slot,
- the approved 25-Technique direct matrix across five families,
- rare same-slot replacement offers,
- slotless Supporting Technique upgrades with no fixed inventory cap,
- one small refinement maximum per eligible slotted Technique,
- four Technique rarity tiers: Common, Uncommon, Rare, Legendary,
- one equipped Prosthetic with permanent Forge progression,
- and one run-scoped Relic slot.

Prosthetic Techniques are not part of the run-build system. Techniques do not add separate temporary upgrade layers to Prosthetics or Relics.

The final total Technique roster size remains open because Supporting, Cross-family, Legendary, refinement, and replacement layers are still being designed. The retired rough ~30 count and Blade / Deflection / Execution / Movement / General quotas are no longer production requirements.

## Locked Aspect scope

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **Tier 0** | Four-hit close pressure/pursuit kit | Two-hit extended reach/control kit | Three-hit heavy impact/stability kit |
| **Tier I** | Blood Tempo | Pale Barrage | Steadfast Reprisal |
| **Growth** | Feral Momentum | Spectral Edge | Maximum player-posture capacity |
| **Tier II** | Blood Hunt / Blood Fang | Wraith's Reach | Falling Mountain / Deep Rupture |
| **Tier III** | Fanged Guard | Spectral Passage | Unbroken Resolve / Measured Weight / Perfect Weight |
| **Tier IV** | Apex Mauling | Beyond the Veil | Shattering Wake |

All three packages are locked at current qualitative paper-design depth. Final animation counts, VFX counts, frame data, combat values, collision, and effect timing still require playable validation.

## Technique scope boundary

Technique design uses five broad internal effect families that can meaningfully affect the five core combat slots. The families do not need formal player-facing names; recognition should rely on symbols, color treatment, effect behavior, VFX, and audio language.

All five family mechanics and all 25 direct slot Techniques are approved at qualitative core-rule depth:

- **Pale silver / twin slash — Echo:** delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest — Rupture:** buildup fills a visible enemy meter; completion triggers a large posture-impact proc and bounded nearby posture pressure.
- **Violet / binding knot — Seal:** discrete visible marks progressively restrict movement; three complete the pattern and briefly Bind the target without stunning it.
- **Ivory / blade circle — Rift:** one visible fracture mark automatically opens after a short fuse for direct Health damage; further qualifying applications intensify the same mark before it opens.
- **Crimson / split blood drop — Vulnerable / direct Health damage:** Vulnerable is a short enemy status that makes genuine backstabs deal substantially increased Health damage. Other Crimson Techniques may instead provide standalone direct Health damage, bounded AoE, or stronger backstab payoffs.

Backstabs remain universal positional hits based on actually reaching the enemy's rear. Crimson does not create fake rear-angle windows, force enemy facing, or rely on ordinary slow to manufacture backstabs.

The direct roster is owned by `TECHNIQUE_CATALOG.md` and should remain stable unless prototyping exposes a concrete issue.

The current Technique scope task is the later catalog layer: **Legendary Techniques, same-family Supporting Techniques, Cross-family Techniques, refinements, rare replacements, rarity assignments, prerequisites, and reward eligibility**. A brief Unseen / invisibility-style Crimson effect is reserved as a current Legendary candidate rather than an ordinary direct Technique.

## Optional investment outcomes

Launch balance must support:

- Tier 0-I with a strong coherent Technique build,
- Tier II with a solid Technique build as a common hybrid,
- Tier III with less-developed horizontal upgrades as deliberate Aspect specialization,
- occasional Tier IV high-roll runs.

Mandatory encounters must not assume a particular Tier, Blood Art, Technique family, or Legendary.

## Run-duration target

A normal successful Binding run targets approximately **45-50 minutes** of active time.

The final number of Technique reward opportunities must be tuned against the supporting-upgrade layer and competition with Shrines, Relics, economy, and survival routes.

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

## Area roster

- **Area 1 — Hushiro Gate Village / Rupture:** 6 standard enemies, 2 minibosses, Keeper of the Gate.
- **Area 2 — Yomori Grove / Adaptation:** 4 standard enemies, 2 minibosses, Twin Maws.
- **Area 3 — Kagutsuchi Court / False Ascendancy:** 5 standard enemies, 2 minibosses, Eclipse Shogun.

Exact encounter pacing and authored room distribution remain prototype work.

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

Temporary run state includes Aspect Tier, Corruption, Blood, slotted and Supporting Techniques, Cross-family Techniques, refinements, run Relic, Gold, temporary capacities, and room progress.

Persistent state includes destroyed Bindings, story/codex progress, Aspect unlocks/mastery, permanent upgrades including Prosthetic progression, and persistent currencies.

## Current open production scope

1. Complete the later Technique catalog layers and lock final Technique production count.
2. Finish Relic / consumable run-build scope.
3. Define permanent Prosthetic / Forge progression depth.
4. Persistent progression, onboarding, and trial package.
5. Narrative delivery, voice, cinematic, portrait, and final-writing package.
6. Postgame reward and UI package.

## Deferred implementation work

Exact frame data, hitboxes, damage, posture, Rupture buildup, Seal behavior, Rift fuse/intensity/damage, backstab rear-angle threshold, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc footprint, Predator's Wake radius, stagger, movement, recovery, Blood values, Tier-growth percentages, collision, pathing, room algorithms, route probabilities, reward probabilities, prices, animation frames, VFX density, audio timing, and final HUD layout remain implementation and playtesting work.

The removed Storm, Frost, Ember, Hex, and Shadow stance system is not part of the game.
