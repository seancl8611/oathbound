---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - currencies
  - pickups
  - techniques
  - relics
  - blood-resource
  - room-rewards
  - reward-cadence
  - reward-weighting
  - run-infrastructure
  - heart-binding-completion
  - regional-routing
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-RUN-STRUCTURE
  - CONTENT-ROOM-TYPES
  - META-OPEN-QUESTIONS
---

# Items, Currencies, and Rewards

This file owns reward categories, currency ownership, room payouts, and the current reward-cadence framework. `RUN_STRUCTURE.md` owns regional chamber counts, branching-frequency targets, and route-network safeguards. The percentages below are approved **prototype generation values** intended for implementation and playtesting; final balance values remain tunable.

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

1. **Build growth** — Technique rewards, Relic opportunities, and optional Aspect Tier advancement through Shrine routes.
2. **Survival** — Health, Spirit, recovery, temporary capacity.
3. **Economy** — Gold, shops, rerolls.
4. **Persistent progress** — Mist, Scrolls, Boss Emblems, unlocks, discoveries, Heart Bindings, and approved permanent progression.

## Currency families

| Currency | Persistence | Primary role |
|---|---|---|
| Mist | Persistent | Broad meta progression, especially Bloodwell-owned progression |
| Scroll | Persistent | Forge-focused Prosthetic development |
| Boss Emblem | Persistent | Rare major progression gates where explicitly assigned |
| Gold | Run-only | Shops and run economy |

Corruption, Blood, Relic mastery, and destroyed Heart Bindings are not currencies.

- **Corruption** governs Shrine-ready Aspect progression.
- **Blood** is a Tier II-and-later run-only combat resource used to activate the selected Blood Art.
- **Relic mastery** is persistent progression earned through eligible kills while a Relic is equipped.
- **Destroyed Heart Bindings** are persistent campaign state.

Blood is not purchased, banked at the Strand, displayed as a route reward, or carried between runs. `Mist Shards` remains deprecated unless intentionally restored.

Sharing the Forge between Prosthetics and Relics does not automatically make Scrolls a Relic currency. Exact Relic upgrade costs, if any, remain later design.

## Pickups and minor drops

- Health restores HP.
- Spirit restores the shared Prosthetic resource.
- Minor enemy and breakable drops may include small Gold, Health, Spirit, Mist, or Scroll value where approved.
- Blood is generated through the approved Blood Aspect combat rules rather than treated as an ordinary pickup.
- Minor drops support flow but do not replace the room's previewed primary reward.

## Route previews and opportunity cost

The primary reward category should be shown before route commitment through a consistent symbol or environmental marker.

Supported preview categories may include Technique, Relic, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, Rest, Shop, Treasure, Miniboss, and Boss.

Choosing a Shrine can mean giving up a Technique, Relic, economy, or survival opportunity; choosing another route can delay Aspect advancement.

The approved prototype route model uses fixed chamber-index bands, weighted eligible contents, and hard safeguards rather than pure unbounded randomness. All three regional chamber counts, miniboss windows, minimum opportunity safeguards, and branch-count percentages are owned by `RUN_STRUCTURE.md`.

A guaranteed route-network opportunity is not a mandatory room. The player may still choose a competing exit and forgo it.

## Prototype room-type weighting

When an ordinary eligible route node is generated, the current chamber band uses these base room-type weights before safeguards and fixed miniboss/boss injections:

| Room type | Opening | Main stretch | Pre-boss / final stretch |
|---|---:|---:|---:|
| Standard Combat | 82% | 70% | 58% |
| Shrine | 6% | 8% | 5% |
| Rest | 4% | 7% | 13% |
| Shop | 2% | 7% | 13% |
| Treasure | 6% | 8% | 11% |

Rules:

- miniboss opportunities are not rolled from this table; one optional miniboss opportunity is deliberately injected into each region's approved miniboss window,
- regional bosses are fixed endpoints and are not rolled,
- Hushiro's earliest chambers may suppress Rest and Shop when they would have little practical value,
- safe service-room adjacency is prevented by the route safeguards in `RUN_STRUCTURE.md`,
- and pre-boss preparation safeguards may override these weights when required.

Across a normal completed 33-chamber regional route, the working target is roughly **20–22 standard combat chambers**, with the remaining non-boss chambers occupied by Shrines, Rests, Shops, Treasure, and optional minibosses according to routing choices and safeguards. This is an expected range rather than a fixed composition.

## Approved regional opportunity safeguards

### Hushiro

Before Keeper, the generated route network contains at least:

- 1 Shrine opportunity,
- 1 Shop opportunity,
- 1 Rest opportunity,
- 1 optional miniboss opportunity,
- 3 Technique-reward opportunities total, including the fixed Chamber 1 Technique reward.

The Hushiro miniboss opportunity appears within Chambers 5–8 and selects either Village Ogre or The Collector for that run.

### Yomori

Before Twin Maws, the generated route network contains at least:

- 1 Shrine opportunity,
- 1 Shop opportunity,
- 1 Rest opportunity,
- 1 optional miniboss opportunity,
- 2 Technique-reward opportunities.

The Yomori miniboss opportunity appears within Chambers 4–7 and selects either The Embered Pilgrim or Rotwood Host for that run.

### Kagutsuchi

Before the Eclipse Shogun, the generated route network contains at least:

- 1 Shrine opportunity,
- 1 Shop opportunity,
- 1 Rest opportunity,
- 1 optional miniboss opportunity,
- 2 Technique-reward opportunities,
- 1 meaningful final-preparation opportunity across Chambers 9–10.

The Kagutsuchi miniboss opportunity appears within Chambers 4–7 and selects either Blood Lotus or Eternal Swordsman for that run.

These safeguards define availability across the route network, not guaranteed player pickups.

## Standard combat rewards

A standard combat room awards one previewed primary reward after completion.

Eligible rewards include Gold, Mist, Scrolls, Health or Spirit recovery, temporary capacity, a Technique reward, and an approved reroll resource.

Combat rooms are the **primary source of Technique rewards**, but not the only source.

### Prototype standard-combat reward weights

| Reward | Hushiro | Yomori | Kagutsuchi |
|---|---:|---:|---:|
| Technique | 36% | 32% | 28% |
| Gold | 20% | 20% | 18% |
| Mist | 11% | 10% | 9% |
| Scrolls | 7% | 8% | 8% |
| Health / Spirit recovery | 12% | 12% | 16% |
| Temporary capacity | 7% | 10% | 11% |
| Reroll resource | 7% | 8% | 10% |

These weights intentionally shift over the run:

- Hushiro emphasizes Techniques so the run gains an identity quickly,
- Yomori is the balanced build-deepening region,
- Kagutsuchi slightly reduces raw Technique frequency while increasing survival, capacity, and reroll value for mature-build optimization.

Gold reward weight should fall sharply when no realistic Shop opportunity remains ahead. The generator should not offer late Gold as a dead primary reward immediately before the Shogun.

Relics are **not** part of the ordinary standard-combat reward table. They remain a rarer supporting layer associated with approved Treasure, miniboss, Shop, boss, discovery, or other special sources.

Consumables have **0% primary room-reward weight** in the first route-generation prototype. If consumables remain in launch scope, they should initially enter through Shops, Treasure, or another contained source rather than becoming another ordinary primary reward category.

## Universal Technique reward

A Technique reward always opens the same underlying Technique reward screen and follows the same eligibility rules regardless of source.

A Technique reward may come from:

- a standard combat room,
- a shop purchase,
- treasure,
- a miniboss,
- a regional boss,
- or another explicitly approved source.

The source does not make the reward inherently a `refinement reward`, `Legendary reward`, or another separate Technique subtype.

Depending on the current build, an eligible Technique reward screen may offer:

- a Technique for an empty combat slot,
- a slotless Supporting Technique,
- a refinement for an owned slotted Technique,
- a rare same-slot replacement,
- a Cross-family Technique,
- or an eligible Legendary.

The reward source may influence rarity or quality weighting, but all sources use the same Technique system rather than separate reward interfaces or subtype-specific reward pools.

There is no global Technique inventory cap. The main cap on Technique growth is how many Technique rewards the player chooses and receives during the run.

The player may decline all Technique choices for a displayed lower-value fallback when that source allows a decline.

Detailed slot, rarity, replacement, family, and refinement rules belong in `TECHNIQUES.md`.

## Prototype Technique cadence

The current successful-run target is:

- **Hushiro:** approximately 3 Technique pickups for a player meaningfully investing in Techniques, including the fixed Chamber 1 reward,
- **Yomori:** approximately 2–3 additional Technique pickups,
- **Kagutsuchi:** approximately 2–3 additional Technique pickups.

Typical outcomes:

- a normal Technique-invested successful run ends around **7–9 Technique pickups**,
- a strongly Technique-focused route may reach roughly **10–12+**,
- a player prioritizing Shrines, survival, economy, or persistent resources may finish with roughly **4–6**.

These are expected pickup ranges, not inventory caps or guaranteed counts. The player should see more Technique opportunities than they actually take because Technique routes compete with Shrine, survival, economy, and other rewards.

## Shrine rooms

Shrines own Blood Aspect stabilization and optional escalation.

- At full Corruption: present Resist or Embrace.
- Embrace advances the fixed Aspect Tier.
- Resist keeps the Tier and provides approved stabilization support.
- Below full Corruption: provide approved support such as Health or Spirit recovery.
- Shrines do not normally present ordinary Technique rewards.
- Blood Art charge is separate from Corruption and does not pay for Embrace.

Permanent **Run Infrastructure** upgrades may later improve approved Shrine support, but they cannot reduce or bypass the fixed Tier path, grant permanent Tier progress, or unlock Blood early.

### Prototype Shrine cadence

The full route should expose roughly **4–5 Shrine opportunities** during a typical run, while a normal player may actually choose approximately **2–3**. An Aspect-focused player may deliberately take four or more when routing and Corruption timing support it.

This cadence should make Tier II a common hybrid outcome, Tier III a deliberate Aspect-heavy investment, and Tier IV possible without becoming automatic. Mandatory encounters continue to support lower-Tier Technique-focused outcomes.

## Rest rooms

Rest rooms provide Health and Spirit recovery, read-only build review, and short narrative breathing room where appropriate.

The retired reserve-slot model does not support routine Technique swapping at rest rooms.

Permanent **Run Infrastructure** upgrades may later improve Rest support or introduce approved additional recovery opportunities. Exact upgrades remain later detailed design.

### Prototype Rest cadence

The route should expose roughly **3–4 Rest opportunities** across a typical successful run, with approximately **1–2 normally visited**. Increased pre-boss weighting makes recovery more available when it matters without making a free heal automatic.

## Shops

Run shops use Gold and may offer recovery, temporary capacity, consumables if included, rerolls, **Technique rewards**, and occasional Relic opportunities.

When a shop sells a Technique reward, purchasing it opens the normal Technique reward screen rather than a separate refinement-only or supporting-only screen.

Technique purchases should be expensive enough that Gold routing is a meaningful strategy rather than an automatic purchase path.

Blood is not directly bought or sold.

### Prototype Shop cadence

The route should expose roughly **3–4 Shop opportunities** across a typical successful run, with approximately **1–2 normally visited**. Gold generation and Shop pricing must be tuned together so a Shop choice is meaningful rather than automatically optimal or frequently unusable.

## Treasure and miniboss rewards

Treasure rooms may provide a Technique reward, Relic choice, large currency bundle, major temporary capacity, or rare consumable if consumables ship.

A miniboss guarantees meaningful build development and should never award only ordinary Gold or healing. Possible rewards include:

- a Technique reward,
- a Relic opportunity,
- a special encounter reward,
- modest additional Mist or Scrolls.

A miniboss Technique reward may receive better rarity weighting, but it still uses the universal Technique reward screen.

Hushiro, Yomori, and Kagutsuchi each generate one optional miniboss route opportunity in their approved prototype windows. The player may route around it and therefore fights 0–1 minibosses in each region.

### Prototype Treasure and miniboss cadence

- Treasure is not region-guaranteed; a normal successful route should usually contain roughly **1–2 Treasure rooms actually taken**.
- All three miniboss opportunities exist in the generated route network, but the target normal successful run is roughly **1–2 minibosses actually fought**.
- Miniboss rewards must be valuable enough that choosing the harder branch is tempting, but the competing non-miniboss route must remain legitimate.

## Regional boss rewards

The Area 1 and Area 2 bosses provide both persistent and current-run value.

Persistent rewards may include Boss Emblems, Mist, Scrolls, unlocks, and narrative or codex progress.

Current-run rewards may include a Technique reward, Relic opportunity, or major temporary Health or Spirit improvement.

Regional transitions should restore enough Health or Spirit for the next area to begin from a viable state. Blood is not automatically refilled by the reward system.

Keeper and Twin Maws transition into short safe spaces that are **not counted chambers**. These transitions provide the boss reward, viable-state recovery, concise build review, and any separately approved limited preparation without becoming secondary hubs.

Run Infrastructure may later improve approved transition support without removing the need to manage resources during the run.

## Eclipse Shogun and Heart Binding completion

The Eclipse Shogun is fixed at Kagutsuchi Chamber 11 and does not grant additional current-run power during the first six successful clears because the run ends after the Binding ritual.

After defeating him, Akio enters the Heart chamber, offers Returning Blood through the extraction apparatus, breaks one remaining Heart Binding, is dissolved by the Heart, and reconstructs at the Strand.

Heart approach and Binding-completion spaces are outside Kagutsuchi's 11 counted chambers. After all six Bindings are destroyed, the seventh successful story run continues from the Shogun into the Heart with the same active build. Exact recovery/resource handling before that final Heart encounter remains later integration work.

Permanent completion rewards may include destroyed-Binding progress, Mist, Scrolls, Boss Emblems, unlocks, discoveries, codex progress, and results confirmation.

## Relics

`RELICS.md` owns the Relic system and launch roster.

The launch structure uses **one equipped Relic**. Relic ownership persists once unlocked or discovered, while the equipped effect is a run benefit. Relics are separate from Techniques and Prosthetics and do not consume a Technique combat slot.

The approved launch roster contains **10 Relics**. Relics do **not** use Common / Rare / Legendary rarity tiers.

Relic rewards should be relatively uncommon so the system remains a small supporting layer rather than competing constantly with Techniques, Shrines, economy, survival, or Aspect advancement.

Relic acquisition sources remain open. Relics may eventually come from run rewards, quests, discoveries, collectibles, NPC progression, trials, or another approved source, but exact allocation is not needed for current scope.

Relics may be changed through approved limited transition opportunities rather than freely swapped in ordinary rooms. Exact swap timing remains later implementation work.

Relic collection/mastery/progression is managed at the **Forge Bench** when Akio is in the Strand.

## Run Infrastructure reward boundary

Run Infrastructure is a single Bloodwell-owned permanent upgrade category that may affect future-run support around:

- Rest and recovery,
- Shrine support,
- reward possibilities,
- route information or routing assistance,
- regional transitions,
- beneficial special encounters or support conditions,
- and approved persistent-resource opportunities.

This umbrella prevents separate permanent trees for every room or reward subsystem. Exact upgrades and values remain later design.

Run Infrastructure must preserve meaningful route opportunity cost and cannot make high-value rewards, ideal builds, or Aspect advancement automatic.

## Pacing framework

Within the approved 45–50-minute successful-run target:

- **Hushiro:** 12 counted chambers, approximately 14–16 active minutes; establish early direct-action Technique identity and first family/build direction.
- **Yomori:** 10 counted chambers, approximately 12–14 active minutes; expand direct-action coverage and deepen the build through later Technique eligibility and Aspect progression.
- **Kagutsuchi:** 11 counted chambers, approximately 15–17 active minutes; finalize the mature build while facing the most layered standard encounters before the Shogun.

The current regional baseline is **33 counted chambers total**. The route-generation prototype targets roughly **17–19 multi-exit decisions**, **20–22 standard combat chambers**, **7–9 Technique pickups for a Technique-invested successful run**, **4–5 visible Shrine opportunities**, and approximately **1–2 visits each to Shops, Rests, Treasures, and minibosses** in a typical successful route.

These are controlled-procedural prototype targets rather than immutable final counts. The next numerical layer is **Technique offer generation and rarity/source weighting**, followed by Gold/Shop economy and the remaining detailed reward-value tuning.

## Expected build outcomes

The reward structure should continue supporting Tier 0-I Technique-focused runs, Tier II hybrids, Tier III Aspect-heavy runs, and occasional Tier IV high-rolls.

A Technique-heavy route may accumulate more slotless upgrades than an Aspect-heavy route. That is intended opportunity cost rather than a global Technique-cap problem.

## Guardrails

- Do not require an exact Technique combination for a viable run.
- Do not generate three invalid Technique choices.
- A direct Technique cannot stack with another direct Technique in the same combat slot.
- Supporting Techniques must be meaningful enough to justify a reward choice.
- Rare replacement offers must clearly show what current slotted Technique will be lost.
- Prosthetic or Relic permanent upgrades do not belong in Technique reward screens.
- Relics remain a small separate supporting layer and should not become Technique-family upgrades.
- Blood is a combat resource, not a currency or route reward.
- Rare rewards must not invalidate sword combat or boss mechanics.
- Mandatory encounters must not assume a particular Aspect Tier, Blood Art, Technique family, Relic, or ideal build.
- Final percentages may change through playtesting without reopening the underlying routing architecture.

## Current production dependency

The major launch-system audit, all three prototype regional chamber structures, and the first full-route branch/room/reward weighting model are complete at prototype scope.

The next run-design layer is **Technique offer generation and rarity/source weighting** across standard combat rewards, Shops, Treasure, minibosses, and regional bosses. Gold/Shop economy values and detailed combat/economy balance follow after that.