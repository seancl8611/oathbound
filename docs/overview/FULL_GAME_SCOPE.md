---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-08-16
topics:
  - full-scope
  - techniques
  - relics
  - prosthetics
  - progression
  - areas
  - strand
  - the-heart
  - postgame
  - regional-routing
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-RUN-STRUCTURE
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document defines Oathbound's current production-level shape. It does not lock final balance values, final route algorithms, frame data, final attack timings, permanent-upgrade values, or other implementation details that require prototyping and playtesting.

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
| Launch Relic roster | 10 approved Relics | Persistent collection/mastery/progression; run-active benefit; no rarity tiers |
| Permanent upgrade stations | 3 | Bloodwell, Forge Bench, later-unlocked Blood Mirror |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro rupture roster |
| Area 2 standard enemies | 4 | Yomori spirit/predator roster |
| Area 3 standard enemies | 5 | Kagutsuchi court roster |
| Area 1 prototype chambers | 12 | Opening 1–3, main 4–8, pre-boss 9–11, Keeper at 12 |
| Area 2 prototype chambers | 10 | Opening 1–2, main 3–7, pre-boss 8–9, Twin Maws at 10 |
| Area 3 prototype chambers | 11 | Entrance 1–2, main 3–7, final Court 8–10, Eclipse Shogun at 11 |
| Total regional prototype chambers | 33 | 12 Hushiro + 10 Yomori + 11 Kagutsuchi |
| Miniboss encounters | 6 | Two designed encounters per area; each region offers one optional candidate per run |
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

There is **no global Technique inventory cap**. Direct combat actions remain limited by their five action-specific slots, while eligible Supporting, Cross-family, Legendary, and refinement growth is constrained by reward access, prerequisites, route choices, and run length.

Prosthetic Techniques are not part of the run-build system. Techniques do not add separate temporary upgrade layers to Prosthetics or Relics.

The current Technique content roster is **50 actual Techniques plus 10 refinements**. The roster is complete for paper-design scope and should not be expanded without a concrete audit or prototype need.

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

Remaining Technique reward-frequency, offer-generation, rarity/source weighting, replacement, compatibility, and readability work belongs to the later full-run integration/reward pass.

## Relic scope boundary

Relics are a small supporting layer rather than another build family.

Launch scope uses:

- **one equipped Relic**,
- a persistent collection of **10 approved Relics**,
- persistent kill-earned individual mastery,
- simple run-wide benefits that remain broadly usable across Aspects,
- no Common / Rare / Legendary Relic tiers,
- permanent Relic progression / Strand-side management at the **Forge Bench** alongside Prosthetics,
- and limited in-run replacement opportunities rather than free swapping in ordinary rooms.

The approved roster is Traveler's Coin, Merchant's Seal, Iron Prayer Bead, Spirit Tassel, Execution Bead, Wayfarer's Charm, Last Oath, Unbroken Cord, Scribe's Lens, and Blood Moon Shard.

No separate Relic Reliquary is required in current hub scope. Exact acquisition allocation, mastery ranks, Forge presentation, costs if any, swap timing, and numerical values remain later implementation/content work.

## Permanent progression scope

The launch hub uses three permanent upgrade stations:

### Bloodwell

Upgrades:

- **Akio**
- **Run Infrastructure**

Run Infrastructure is one umbrella covering approved permanent improvements to Rest support, Shrine support, reward possibilities, routing/run conditions, regional transitions, and related expedition support. It is not split into separate permanent upgrade trees for each room/reward subsystem.

The exact Bloodwell tree, Akio nodes, Run Infrastructure nodes, values, rank counts, and costs remain later detailed design.

### Forge Bench

Upgrades / manages:

- **Prosthetics**
- **Relics**

The eight Prosthetic paths are already locked as shallow and linear. Relics keep their own mastery/progression logic even though they share the Forge station.

The old generic weapon-development, weapon-socket, and alternate-weapon progression model is removed from current scope. Blood Aspects are Akio's run weapon identities.

### Blood Mirror

Upgrades:

- **Blood Aspects**

The Blood Mirror is physically inside the Blood Cavern, begins locked, and becomes available later through campaign/onboarding progression. The exact unlock point and permanent Aspect nodes remain later detailed design.

Permanent Aspect progression cannot bypass the Tier 0-IV Shrine path or unlock Blood before Tier II.

### Non-upgrade persistent systems

Technique pool unlocks, Blood Cavern trial completion, Discovery Board/codex progress, Merchant services, Boat confirmation, Heart Bindings, and story/postgame state may persist but are not separate permanent upgrade trees in current launch scope.

## Optional investment outcomes

Launch balance must support:

- Tier 0-I with a strong coherent Technique build,
- Tier II with a solid Technique build as a common hybrid,
- Tier III with less-developed horizontal upgrades as deliberate Aspect specialization,
- occasional Tier IV high-roll runs.

Mandatory encounters must not assume a particular Tier, Blood Art, Technique family, Legendary, Relic, or heavily developed permanent progression.

## Run-duration and route target

A normal successful Binding run targets approximately **45–50 minutes** of active time.

The current regional prototype budgets are:

- **Hushiro:** 12 counted chambers, approximately 14–16 active minutes.
- **Yomori:** 10 counted chambers, approximately 12–14 active minutes.
- **Kagutsuchi:** 11 counted chambers, approximately 15–17 active minutes.

The complete regional route therefore contains **33 counted chambers** before specialized Heart-route spaces. All three regions use fixed chamber-index bands, weighted eligible contents, hard minimum-opportunity safeguards, previewed route choices, optional miniboss routing, and fixed boss endpoints. Keeper and Twin Maws lead to separate non-counted regional transition spaces; the Shogun opens the specialized Heart route.

The final number of Technique reward opportunities must be tuned against the 50-Technique roster and competition with Shrines, Relics, economy, survival, and Aspect routes. Exact branch frequency and percentage weights are the next full-run integration layer.

## The Strand

Persistent NPCs:

- Keeper
- Peddler
- Smith
- Raven
- Undead Samurai
- Scribe

Primary services and landmarks:

- Boat / run confirmation
- Forge Bench — Prosthetics + Relics
- Merchant Stall
- Discovery Board
- Bloodwell — Akio + Run Infrastructure
- Blood Cavern
- later-unlocked Blood Mirror — Blood Aspects

The Boat remains focused on fast run-start confirmation rather than becoming a combined permanent-progression screen.

Exact onboarding timing, trial counts, permanent-upgrade node values, mastery thresholds, and final UI layouts remain detailed design rather than full-game scope blockers.

## Area roster and run role

- **Area 1 — Hushiro Gate Village / Rupture:** 6 standard enemies, 2 designed minibosses, Keeper of the Gate; 12 counted chambers; establishes the first direct-action Technique modifications and family/build direction.
- **Area 2 — Yomori Grove / Adaptation:** 4 standard enemies, 2 designed minibosses, Twin Maws; 10 counted chambers; expands direct-action coverage and deepens the build through later Technique eligibility and Aspect progression.
- **Area 3 — Kagutsuchi Court / False Ascendancy:** 5 standard enemies, 2 designed minibosses, Eclipse Shogun; 11 counted chambers; finalizes/refines the mature run build under the most layered normal encounter pressure.

Each region generates one optional miniboss opportunity from its two authored candidates. Exact encounter composition and route percentage weights remain prototype work.

## Heart Binding campaign

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding during the plague, leaving six intact when Akio begins.

Each of the first six successful clears destroys one remaining Binding and permanently preserves that progress.

After the sixth remaining Binding is destroyed, the next successful run becomes the seventh and final story run and continues from the Eclipse Shogun into the Heart.

Heart approach, Binding-completion spaces, and the true-final Heart are specialized endgame content beyond the 33 counted regional chambers rather than additional Kagutsuchi chambers.

The true-final Heart has two conceptual forms:

1. **The Unbound Heart**
2. **The Vessel of Continuance**

Destroying the Heart ends Beast Blood, stops the Shogun's reconstruction, ends the Blood Moon, and leaves Akio mortal.

Postgame retains repeatable normal runs and optional Heart-route access without changing the completed ending.

## Run-build and persistence boundary

Temporary run state includes Aspect Tier, Corruption, Blood, slotted Techniques, Supporting / Cross-family / Legendary Techniques, refinements, the equipped Relic benefit, Gold, temporary capacities, and room progress.

Persistent state includes destroyed Bindings, story/codex progress, Aspect unlocks and later Blood Mirror progression, the Relic collection/mastery/progression, permanent Akio and Run Infrastructure upgrades, permanent Prosthetic progression, and persistent currencies.

## Current open production scope

The major-system production-scope audit and all three regional prototype chamber structures are complete. No additional core gameplay system or regional route skeleton is currently required before moving deeper into the run-design pass.

Current broad sequence:

1. **Continue full-run integration, rewards, encounters, and pacing** by evaluating the complete 33-chamber route and defining provisional branching frequency, room/reward weighting, Technique cadence, Shrine/Shop/Rest frequency, encounter pacing, and related route-generation values.
2. **Define narrative delivery and campaign presentation.**
3. **Define endgame, postgame, and release scope.**

These next run values remain prototype targets subject to playable validation. Exact Relic ranks, Prosthetic node values, Bloodwell/Run Infrastructure nodes, Blood Mirror Aspect ranks, combat damage/stats, and similar subsystem values remain nested until their owning implementation/playtest pass requires them.

## Deferred implementation work

Exact frame data, hitboxes, damage, posture, Rupture buildup, Seal behavior, Rift fuse/intensity/damage, backstab rear-angle threshold, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc footprint, Predator's Wake radius, Legendary durations, Relic values/rank thresholds, stagger, movement, recovery, Blood values, Tier-growth percentages, collision, pathing, route-generation percentage weights, reward probabilities, prices, permanent-upgrade values, animation frames, VFX density, audio timing, and final HUD layout remain implementation and playtesting work.

The removed Storm, Frost, Ember, Hex, and Shadow stance system and the older alternate-weapon development model are not part of the game.