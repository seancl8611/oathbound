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
  - gold-economy
  - shops
  - recovery
  - temporary-capacity
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

This file owns reward categories, currency ownership, room payouts, Gold/Shop economy, survival/recovery values, temporary capacity rewards, and the current reward-cadence framework. `RUN_STRUCTURE.md` owns regional chamber counts, branching-frequency targets, and route-network safeguards. Numerical values below are approved **prototype implementation targets** intended for playtesting rather than immutable final balance law.

## Reward goals

The reward framework should:

- make route choices readable before commitment,
- build run power gradually,
- create meaningful competition between Aspect, Technique, survival, economy, and persistent-progression routes,
- keep Technique rewards valuable after all five core combat slots are filled,
- support focused and hybrid Technique builds,
- allow occasional high-roll builds without making ideal builds routine,
- make survival recovery meaningful without fully erasing poor combat performance,
- and avoid severe random failure or exact-combination dependence.

Major rewards support:

1. **Build growth** — Technique rewards, Relic opportunities, and optional Aspect Tier advancement through Shrine routes.
2. **Survival** — Health, Spirit, recovery, temporary capacity.
3. **Economy** — Gold, Shops, rerolls.
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

# Gold economy prototype

Akio begins a normal run at **0 Gold** unless a Relic or another explicitly approved persistent effect changes starting Gold.

## Standard Gold rewards

A standard Combat-room Gold primary reward currently pays:

| Region | Gold reward |
|---|---:|
| **Hushiro** | 60 Gold |
| **Yomori** | 70 Gold |
| **Kagutsuchi** | 80 Gold |

Later Gold rewards rise modestly because fewer spending opportunities remain, not because Shop prices inflate by region.

Minor enemy / breakable Gold drops, when generated, are **5–10 Gold**. These are flow-smoothing supplements and must not make the primary Gold route reward irrelevant.

Working successful-run economy targets:

- a typical player deliberately takes roughly **3–4 Gold primary rewards**,
- a normal successful run has roughly **220–320 Gold** available across its route and minor drops,
- an economy-focused route may reach roughly **350–450+ Gold**,
- a player largely ignoring Gold may operate around **100–180 Gold**,
- a typical successful run makes roughly **2–4 Shop purchases** across **1–2 visited Shops**,
- and a strongly economy-focused run may make roughly **4–6 purchases**.

These are playtest targets rather than guarantees.

## Late-Gold suppression

Gold remains eligible only while a realistic Shop spending opportunity remains ahead.

After the run has passed the final possible Shop opportunity, **Gold cannot appear as a primary route reward**. Its weight is redistributed among currently eligible Technique, recovery, capacity, reroll, Mist, Scroll, or other approved rewards.

# Pickups and minor drops

- A minor Health pickup restores **5% max Health**.
- A minor Spirit pickup restores **10% max Spirit**.
- A minor Gold drop is **5–10 Gold**.
- Minor enemy and breakable drops may also include small Mist or Scroll value where later approved.
- Blood is generated through the approved Blood Aspect combat rules rather than treated as an ordinary pickup.
- Minor drops support flow but do not replace the room's previewed primary reward.

# Route previews and opportunity cost

The primary reward category should be shown before route commitment through a consistent symbol or environmental marker.

Supported preview categories may include Technique, Relic, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, Rest, Shop, Treasure, Miniboss, and Boss.

Choosing a Shrine can mean giving up a Technique, Relic, economy, survival, or persistent-resource opportunity; choosing another route can delay Aspect advancement.

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

Across a normal completed 33-chamber regional route, the working target is roughly **20–22 standard Combat chambers**, with the remaining non-boss chambers occupied by Shrines, Rests, Shops, Treasure, and optional minibosses according to routing choices and safeguards. This is an expected range rather than a fixed composition.

# Approved regional opportunity safeguards

## Hushiro

Before Keeper, the generated route network contains at least:

- 1 Shrine opportunity,
- 1 Shop opportunity,
- 1 Rest opportunity,
- 1 optional miniboss opportunity,
- 3 Technique-reward opportunities total, including the fixed Chamber 1 Technique reward.

The Hushiro miniboss opportunity appears within Chambers 5–8 and selects either Village Ogre or The Collector for that run.

## Yomori

Before Twin Maws, the generated route network contains at least:

- 1 Shrine opportunity,
- 1 Shop opportunity,
- 1 Rest opportunity,
- 1 optional miniboss opportunity,
- 2 Technique-reward opportunities.

The Yomori miniboss opportunity appears within Chambers 4–7 and selects either The Embered Pilgrim or Rotwood Host for that run.

## Kagutsuchi

Before the Eclipse Shogun, the generated route network contains at least:

- 1 Shrine opportunity,
- 1 Shop opportunity,
- 1 Rest opportunity,
- 1 optional miniboss opportunity,
- 2 Technique-reward opportunities,
- 1 meaningful final-preparation opportunity across Chambers 9–10.

The Kagutsuchi miniboss opportunity appears within Chambers 4–7 and selects either Blood Lotus or Eternal Swordsman for that run.

These safeguards define availability across the route network, not guaranteed player pickups.

# Standard Combat rewards

A standard Combat room awards one previewed primary reward after completion.

Eligible rewards include Gold, Mist, Scrolls, Health or Spirit recovery, temporary capacity, a Technique reward, and an approved reroll resource.

Combat rooms are the **primary source of Technique rewards**, but not the only source.

## Prototype standard-combat reward weights

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

Relics are **not** part of the ordinary standard-Combat reward table. They remain a rarer supporting layer associated with approved Treasure, miniboss, Shop, boss, discovery, or other special sources.

Consumables have **0% primary room-reward weight** in the first route-generation prototype. If consumables remain in launch scope, they should initially enter through Shops, Treasure, or another contained source rather than becoming another ordinary primary reward category.

## Standard recovery rewards

When the recovery category is generated, the route preview identifies **Health** or **Spirit** before commitment.

- **Health Recovery:** restore **25% max Health**.
- **Spirit Recovery:** restore **35% max Spirit**.

Recovery cannot exceed the current maximum.

## Standard temporary-capacity rewards

A normal capacity reward lasts until the run ends:

- **Health Capacity:** +**15% of starting max Health**.
- **Spirit Capacity:** +**20% of starting max Spirit**.

Capacity rewards also grant the same amount as current resource immediately. For example, a +15% starting-max Health reward raises both maximum and current Health by that amount, up to the new maximum.

Multiple capacity rewards stack **additively from the run's starting maximum**, not multiplicatively. The first prototype uses no separate hard pickup cap; route scarcity and opportunity cost are the constraint.

# Universal Technique reward

A Technique reward always opens the same underlying three-choice Technique reward screen and follows the eligibility, composition, rarity, source-quality, refinement, replacement, Cross-family, Legendary, and reroll rules in `TECHNIQUES.md`.

A Technique reward may come from:

- a standard Combat room,
- a Shop purchase,
- Treasure,
- a miniboss,
- a regional boss,
- or another explicitly approved source.

The source does not make the reward inherently a refinement reward, Legendary reward, or another separate Technique subtype.

There is no global Technique inventory cap. The main cap on Technique growth is how many Technique rewards the player chooses and receives during the run.

The player may decline all Technique choices for a displayed lower-value fallback when that source allows a decline.

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

# Shrine rooms

Shrines own Blood Aspect stabilization and optional escalation.

- At full Corruption: present Resist or Embrace.
- Embrace advances the fixed Aspect Tier.
- Resist keeps the Tier and provides its separately approved stabilization support.
- Below full Corruption: the Shrine may provide one modest support result of **20% max Health recovery** or **25% max Spirit recovery**.
- Shrines do not normally present ordinary Technique rewards.
- Blood Art charge is separate from Corruption and does not pay for Embrace.

The below-full support values do not create an additional large automatic heal alongside a full-Corruption Resist/Embrace choice.

Permanent **Run Infrastructure** upgrades may later improve approved Shrine support, but they cannot reduce or bypass the fixed Tier path, grant permanent Tier progress, or unlock Blood early.

## Prototype Shrine cadence

The full route should expose roughly **4–5 Shrine opportunities** during a typical run, while a normal player may actually choose approximately **2–3**. An Aspect-focused player may deliberately take four or more when routing and Corruption timing support it.

This cadence should make Tier II a common hybrid outcome, Tier III a deliberate Aspect-heavy investment, and Tier IV possible without becoming automatic. Mandatory encounters continue to support lower-Tier Technique-focused outcomes.

# Rest rooms

Rest rooms provide:

- **35% max Health recovery**,
- **50% max Spirit recovery**,
- read-only build review,
- and short narrative breathing room where appropriate.

A Rest does **not** fully heal or fully refill Spirit by default. Its value comes from restoring both major run resources at once in exchange for choosing the Rest route over another reward.

The retired reserve-slot model does not support routine Technique swapping at Rest rooms.

Permanent **Run Infrastructure** upgrades may later improve Rest support or introduce approved additional recovery opportunities. Exact permanent upgrades remain later detailed design.

## Prototype Rest cadence

The route should expose roughly **3–4 Rest opportunities** across a typical successful run, with approximately **1–2 normally visited**. Increased pre-boss weighting makes recovery more available when it matters without making a free heal automatic.

# Shops

Run Shops use Gold and present **3 purchasable items**. The player may buy every displayed item they can afford; there is no one-purchase-per-Shop limit.

Shop prices remain **stable across regions** in the first prototype. Later regional Gold rewards rise modestly, but the item itself does not become more expensive merely because Akio reached Yomori or Kagutsuchi.

## Shop inventory structure

Each Shop uses three functional inventory slots:

1. **Survival slot** — Health recovery, Spirit recovery, or an appropriate stronger recovery option.
2. **Build slot** — Technique reward, temporary max Health, temporary max Spirit, or reroll resource.
3. **Flex / premium slot** — Technique reward, temporary capacity, reroll, stronger recovery, occasional Relic opportunity, or another later-approved high-value run item.

The first prototype does **not** allow refreshing or rerolling the Shop's three-item inventory. Technique rewards purchased from a Shop may still use Technique-screen rerolls normally.

When an eligible Relic opportunity is available, the flex slot has approximately a **10% chance** to become a Relic opportunity. Seeing zero or one Shop Relic opportunity over a complete run should be normal.

## Prototype Shop prices and values

| Purchase | Price | Effect |
|---|---:|---|
| Moderate Health restore | 35 Gold | +25% max Health |
| Moderate Spirit restore | 30 Gold | +30% max Spirit |
| Large Health restore | 55 Gold | +45% max Health |
| Large Spirit restore | 50 Gold | +50% max Spirit |
| Reroll resource | 45 Gold | +1 Technique reroll resource |
| Temporary max Health | 65 Gold | +15% starting max Health and matching current Health |
| Temporary max Spirit | 60 Gold | +20% starting max Spirit and matching current Spirit |
| Technique reward | 100 Gold | Open the normal Shop-quality Technique reward screen |
| Relic opportunity | 140 Gold | Present the approved Relic opportunity when eligible |

One ordinary Gold reward should therefore provide useful spending power without automatically converting into a Technique. Gold offers flexibility, but immediate Technique routing remains more directly efficient for pure build growth.

# Treasure and miniboss rewards

Treasure rooms may provide a Technique reward, Relic opportunity, large currency bundle, major recovery, enhanced temporary capacity, or rare consumable if consumables ship.

## Treasure survival values

A Treasure survival reward may be:

- **Major Health recovery:** +50% max Health,
- **Major Spirit recovery:** +65% max Spirit,
- **Enhanced Health Capacity:** +20% starting max Health and matching current Health,
- **Enhanced Spirit Capacity:** +25% starting max Spirit and matching current Spirit.

Treasure survival rewards intentionally outperform ordinary Combat-room survival rewards.

## Miniboss rewards

A miniboss guarantees meaningful build development and should never award only ordinary Gold or pure healing.

Possible primary rewards include:

- a premium Technique reward,
- a Relic opportunity,
- a special encounter reward,
- **Enhanced Health Capacity: +20% starting max Health and matching current Health**,
- **Enhanced Spirit Capacity: +25% starting max Spirit and matching current Spirit**,
- plus modest additional Mist or Scrolls where approved.

Pure Health or Spirit restoration is not a primary miniboss reward in the first prototype.

Hushiro, Yomori, and Kagutsuchi each generate one optional miniboss route opportunity in their approved prototype windows. The player may route around it and therefore fights 0–1 minibosses in each region.

## Prototype Treasure and miniboss cadence

- Treasure is not region-guaranteed; a normal successful route should usually contain roughly **1–2 Treasure rooms actually taken**.
- All three miniboss opportunities exist in the generated route network, but the target normal successful run is roughly **1–2 minibosses actually fought**.
- Miniboss rewards must be valuable enough that choosing the harder branch is tempting, but the competing non-miniboss route must remain legitimate.

# Regional boss rewards and transitions

The Area 1 and Area 2 bosses provide both persistent and current-run value.

Persistent rewards may include Boss Emblems, Mist, Scrolls, unlocks, and narrative or codex progress.

Current-run rewards may include a premium Technique reward, Relic opportunity, or enhanced temporary Health / Spirit capacity. **Boss reward selection is separate from automatic regional-transition recovery**, so the player is not forced to sacrifice the boss's interesting reward merely to enter the next region alive.

## Automatic regional-transition recovery

After Keeper and after Twin Maws, the non-counted safe transition restores:

- **20% max Health**,
- **35% max Spirit**.

After applying that restoration, enforce minimum next-region entry floors of:

- **35% max Health**,
- **50% max Spirit**.

The floor prevents an otherwise successful boss clear from beginning the next region effectively dead. It does not reset a damaged run to full. Blood is not automatically refilled.

Run Infrastructure may later improve approved transition support without removing the need to manage resources during the run.

# Eclipse Shogun and Heart handoff

The Eclipse Shogun is fixed at Kagutsuchi Chamber 11 and does not grant additional ordinary current-run power during the first six successful clears because those runs end after the Binding ritual.

After defeating him, Akio enters the Heart chamber, offers Returning Blood through the extraction apparatus, breaks one remaining Heart Binding, is dissolved by the Heart, and reconstructs at the Strand.

Heart approach and Binding-completion spaces are outside Kagutsuchi's 11 counted chambers.

After all six Bindings are destroyed, the seventh successful story run continues from the Shogun into the Heart with the same active build. Because this route adds the two-form final encounter after the full island and Shogun, the Heart handoff restores:

- **30% max Health**,
- **50% max Spirit**,

then enforces minimum Heart-entry floors of:

- **40% max Health**,
- **60% max Spirit**.

This is a partial final-encounter reset, not a full refill. A player who defeats the Shogun in strong condition keeps that advantage; a player who barely survives receives enough recovery for the Heart to remain a legitimate final fight rather than implicitly requiring a near-perfect Shogun clear. Blood is not automatically refilled unless the Heart encounter later explicitly requires a different rule.

Permanent completion rewards may include destroyed-Binding progress, Mist, Scrolls, Boss Emblems, unlocks, discoveries, codex progress, and results confirmation.

# Relics

`RELICS.md` owns the Relic system and launch roster.

The launch structure uses **one equipped Relic**. Relic ownership persists once unlocked or discovered, while the equipped effect is a run benefit. Relics are separate from Techniques and Prosthetics and do not consume a Technique combat slot.

The approved launch roster contains **10 Relics**. Relics do **not** use Common / Rare / Legendary rarity tiers.

Relic rewards should be relatively uncommon so the system remains a small supporting layer rather than competing constantly with Techniques, Shrines, economy, survival, or Aspect advancement.

Relic acquisition sources remain open beyond the approved occasional Shop opportunity. Relics may eventually come from run rewards, quests, discoveries, collectibles, NPC progression, trials, or another approved source; exact allocation remains later design.

Relics may be changed through approved limited transition opportunities rather than freely swapped in ordinary rooms. Exact swap timing remains later implementation work.

Relic collection/mastery/progression is managed at the **Forge Bench** when Akio is in the Strand.

# Run Infrastructure reward boundary

Run Infrastructure is a single Bloodwell-owned permanent upgrade category that may affect future-run support around:

- Rest and recovery,
- Shrine support,
- reward possibilities,
- route information or routing assistance,
- regional transitions,
- beneficial special encounters or support conditions,
- and approved persistent-resource opportunities.

This umbrella prevents separate permanent trees for every room or reward subsystem. Exact upgrades and values remain later design.

Run Infrastructure must preserve meaningful route opportunity cost and cannot make high-value rewards, ideal builds, recovery, or Aspect advancement automatic.

# Survival and capacity pacing target

A normal successful run should generally take roughly **1–2 temporary max-capacity improvements total** across Health and Spirit.

A player deliberately prioritizing survivability / Spirit capacity may take roughly **3–4** at the cost of Techniques, Shrines, Gold, persistent resources, or other run power.

Because capacity stacks additively from starting maximum, three ordinary Health-capacity rewards produce **145% of starting max Health**, not multiplicative compounding.

The first prototype does not add a unique automatic pre-boss heal. Pre-boss safeguards expose existing Rest, Shop, Technique, Treasure, or other approved preparation choices instead.

# Pacing framework

Within the approved 45–50-minute successful-run target:

- **Hushiro:** 12 counted chambers, approximately 14–16 active minutes; establish early direct-action Technique identity and first family/build direction.
- **Yomori:** 10 counted chambers, approximately 12–14 active minutes; expand direct-action coverage and deepen the build through later Technique eligibility and Aspect progression.
- **Kagutsuchi:** 11 counted chambers, approximately 15–17 active minutes; finalize the mature build while facing the most layered standard encounters before the Shogun.

The current regional baseline is **33 counted chambers total**. The route-generation prototype targets roughly **17–19 multi-exit decisions**, **20–22 standard Combat chambers**, **7–9 Technique pickups for a Technique-invested successful run**, **4–5 visible Shrine opportunities**, and approximately **1–2 visits each to Shops, Rests, Treasures, and minibosses** in a typical successful route.

The Gold/Shop and survival/recovery values in this file are now part of the same controlled prototype and should be validated together rather than independently.

# Expected build outcomes

The reward structure should continue supporting Tier 0-I Technique-focused runs, Tier II hybrids, Tier III Aspect-heavy runs, and occasional Tier IV high-rolls.

A Technique-heavy route may accumulate more slotless upgrades than an Aspect-heavy route. An economy-heavy route may convert Gold flexibility into several purchases. A survival-heavy route may accumulate substantially more max Health / Spirit but gives up other reward categories. These are intended opportunity costs.

# Guardrails

- Do not require an exact Technique combination for a viable run.
- Do not generate unusable Technique choices; detailed offer rules belong to `TECHNIQUES.md`.
- A direct Technique cannot stack with another direct Technique in the same combat slot.
- Prosthetic or Relic permanent upgrades do not belong in Technique reward screens.
- Relics remain a small separate supporting layer and should not become Technique-family upgrades.
- Blood is a combat resource, not a currency or route reward.
- Rare rewards must not invalidate sword combat or boss mechanics.
- A Rest or regional transition must not routinely erase all attrition.
- Gold must not remain a primary reward after its final realistic spending opportunity.
- Temporary capacity is run-only and must not become disguised permanent character progression.
- Mandatory encounters must not assume a particular Aspect Tier, Blood Art, Technique family, Relic, ideal economy, or ideal survival build.
- Final percentages and values may change through playtesting without reopening the underlying reward architecture.

# Current production dependency

The major launch-system audit, all three prototype regional chamber structures, the first full-route branch/room/reward weighting model, Technique offer-generation model, Gold/Shop economy, and survival/recovery/capacity prototype are complete at paper-design depth.

The next reward-value layer is **persistent-resource payout design**: Mist and Scroll quantities, Boss Emblem cadence/ownership, and the opportunity-cost relationship between permanent progression rewards and immediate run power. After that, remaining full-run integration includes regional-boss reward mix, Relic acquisition allocation / transition-swap placement, encounter composition and clear-time tuning, and playable validation of the 45–50-minute successful-run target.