---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-08-14
topics:
  - full-scope
  - techniques
  - relics
  - areas
  - strand
  - the-heart
  - postgame
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
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
| Direct Technique matrix | 25 approved Techniques | Five families × five direct combat slots |
| Same-family Supporting Techniques | 15 approved Techniques | Three per family |
| Cross-family Techniques | 5 approved Techniques | Rare hybrid-build effects |
| Legendary Techniques | 5 approved Techniques | One family capstone per family |
| Refinements | 10 approved concepts | Small parent-Technique upgrades; not separate Techniques |
| Working Technique roster | 50 actual Techniques | 10 Common / 18 Uncommon / 17 Rare / 5 Legendary |
| Prosthetic tools | 8 | One equipped at a time; permanent Forge progression |
| Relic slot | 1 | One equipped Relic at a time |
| Launch Relic roster | 10 approved Relics | Persistent collection, run-active benefit, no rarity tiers |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro rupture roster |
| Area 2 standard enemies | 4 | Yomori spirit/predator roster |
| Area 3 standard enemies | 5 | Kagutsuchi court roster |
| Miniboss encounters | 6 | Two designed encounters per area |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach and six player-destroyed Bindings |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart, Vessel of Continuance |
| Currency families | 4 | Mist, Scroll, Boss Emblem, Gold |

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
- 15 slotless same-family Supporting Techniques,
- 5 Rare Cross-family Techniques,
- 5 Legendary family capstones,
- 10 selective refinements with one refinement maximum per eligible parent Technique,
- rare same-slot replacement offers,
- four Technique rarity tiers: Common, Uncommon, Rare, Legendary,
- one equipped Prosthetic with permanent Forge progression,
- and one equipped Relic from the persistent 10-Relic collection.

Prosthetic Techniques are not part of the run-build system. Techniques do not add separate temporary upgrade layers to Prosthetics or Relics.

The current working Technique content roster is **50 actual Techniques plus 10 refinements**. The roster is complete for paper-design scope and should not be expanded without a concrete audit or prototype need.

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

Technique design uses five broad internal effect families. The families do not need formal player-facing names; recognition should rely on symbols, color treatment, effect behavior, VFX, and audio language.

All five family mechanics are approved:

- **Pale silver / twin slash — Echo:** delayed additional sword slashes created by qualifying actions.
- **Gold / cracked crest — Rupture:** buildup fills a visible enemy meter; completion triggers a large posture-impact proc and bounded nearby posture pressure.
- **Violet / binding knot — Seal:** discrete visible marks progressively restrict movement; three complete the pattern and briefly Bind the target without stunning it.
- **Ivory / blade circle — Rift:** one visible fracture mark automatically opens after a short fuse for direct Health damage; further qualifying applications intensify the same mark before it opens.
- **Crimson / split blood drop — Vulnerable / direct Health damage:** Vulnerable is a short enemy status that makes genuine backstabs deal substantially increased Health damage. Other Crimson Techniques may instead provide standalone direct Health damage, bounded AoE, or stronger backstab payoffs.

Backstabs remain universal positional hits based on actually reaching the enemy's rear. Crimson does not create fake rear-angle windows, force enemy facing, or rely on ordinary slow to manufacture backstabs.

`TECHNIQUE_CATALOG.md` owns the complete 50-Technique roster, rarity assignments, prerequisites, and refinements.

Remaining Technique reward-frequency, offer-generation, rarity/source weighting, replacement, compatibility, and readability work is still required, but it belongs to the later full-run integration/reward pass rather than interrupting the current system-design sequence.

## Relic scope boundary

Relics are a small supporting layer rather than another build family.

Launch scope uses:

- **one equipped Relic**,
- a persistent collection of **10 approved Relics**,
- simple run-wide benefits that remain broadly usable across Aspects,
- no Common / Rare / Legendary Relic tiers,
- dedicated Relic selection through a Strand Reliquary or equivalent physical interactible,
- and limited in-run replacement opportunities rather than free swapping in ordinary rooms.

The approved roster is Traveler's Coin, Merchant's Seal, Iron Prayer Bead, Spirit Tassel, Execution Bead, Wayfarer's Charm, Last Oath, Unbroken Cord, Scribe's Lens, and Blood Moon Shard.

Exact acquisition allocation, shallow mastery/rank rules, swap timing, and numerical values remain later implementation/content work.

## Optional investment outcomes

Launch balance must support:

- Tier 0-I with a strong coherent Technique build,
- Tier II with a solid Technique build as a common hybrid,
- Tier III with less-developed horizontal upgrades as deliberate Aspect specialization,
- occasional Tier IV high-roll runs.

Mandatory encounters must not assume a particular Tier, Blood Art, Technique family, Legendary, or Relic.

## Run-duration target

A normal successful Binding run targets approximately **45-50 minutes** of active time.

The final number of Technique reward opportunities must be tuned against the 50-Technique roster and competition with Shrines, Relics, economy, and survival routes.

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
- dedicated preparation interactibles for Aspect, Prosthetic, and Relic selection

The Relic selection interactible is currently represented by a **Relic Reliquary** direction. The Boat remains focused on run-start confirmation rather than a combined loadout screen.

Exact launch depth of permanent upgrades, onboarding, trials, unlocks, mastery content, and final UI states remains open.

## Area roster

- **Area 1 — Hushiro Gate Village / Rupture:** 6 standard enemies, 2 minibosses, Keeper of the Gate.
- **Area 2 — Yomori Grove / Adaptation:** 4 standard enemies, 2 minibosses, Twin Maws.
- **Area 3 — Kagutsuchi Court / False Ascendancy:** 5 standard enemies, 2 minibosses, Eclipse Shogun.

Exact encounter pacing and authored room distribution remain prototype work.

## Heart Binding campaign

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding during the plague, leaving six intact when Akio begins.

Each of the first six successful clears destroys one remaining Binding and permanently preserves that progress.

After the sixth remaining Binding is destroyed, the next successful run becomes the seventh and final story run and continues from the Eclipse Shogun into the Heart.

The true-final Heart has two conceptual forms:

1. **The Unbound Heart**
2. **The Vessel of Continuance**

Destroying the Heart ends Beast Blood, stops the Shogun's reconstruction, ends the Blood Moon, and leaves Akio mortal.

Postgame retains repeatable normal runs and optional Heart-route access without changing the completed ending.

## Run-build and persistence boundary

Temporary run state includes Aspect Tier, Corruption, Blood, slotted Techniques, Supporting Techniques, Cross-family Techniques, Legendaries, refinements, the equipped Relic benefit, Gold, temporary capacities, and room progress.

Persistent state includes destroyed Bindings, story/codex progress, Aspect unlocks/mastery, the unlocked Relic collection, permanent upgrades including Prosthetic progression, and persistent currencies.

## Current open production scope

Top-level questions remain broad and follow the established design trajectory:

1. **Define permanent Prosthetic / Forge progression** — establish meaningful persistent development for all eight Prosthetics before exact costs and values.
2. **Complete the wider Strand, permanent-progression, onboarding, and trial package** — Bloodwell, mastery, trials, preparation interactibles, unlock flow, currencies, and service ownership.
3. **Review full-run integration, rewards, encounters, and pacing** — validate the complete three-region run, reward ecosystem, room purposes, transitions, system coexistence, Technique reward/audit details, Relic acquisition/swap details, and whether any major launch-flow component is missing.
4. **Narrative delivery and campaign presentation** — first-death delivery, repeated-run dialogue/content, Binding-state communication, codex/NPC ownership, voice/cinematic boundary, ending/credits, and writing scope.
5. **Endgame, postgame, and release scope** — repeat Heart access/rewards, completion/mastery goals, required postgame/front-end UI, and what remains launch versus post-launch.

Exact Technique probabilities, Relic ranks, Prosthetic node values, room counts, route probabilities, and similar subsystem details should remain nested until their owning major system or later integration pass requires them.

## Deferred implementation work

Exact frame data, hitboxes, damage, posture, Rupture buildup, Seal behavior, Rift fuse/intensity/damage, backstab rear-angle threshold, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc footprint, Predator's Wake radius, Legendary durations, Relic values/rank thresholds, stagger, movement, recovery, Blood values, Tier-growth percentages, collision, pathing, room algorithms, route probabilities, reward probabilities, prices, animation frames, VFX density, audio timing, and final HUD layout remain implementation and playtesting work.

The removed Storm, Frost, Ember, Hex, and Shadow stance system is not part of the game.
