---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - currencies
  - persistent-resources
  - boss-materials
  - mist
  - scrolls
  - gold-economy
  - room-rewards
  - reward-weighting
  - shops
  - recovery
  - temporary-capacity
  - regional-boss-rewards
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

This file owns reward categories, resource ownership, room payouts, Gold/Shop economy, persistent-resource payouts, survival/recovery values, temporary-capacity rewards, and reward cadence. `RUN_STRUCTURE.md` owns chamber counts, branching frequency, route safeguards, and regional opportunity guarantees. Numerical values below are approved **prototype implementation targets** and remain playtest-tunable.

## Reward goals

Rewards should create meaningful competition between:

1. **Build growth** — Techniques, Relic opportunities, Shrine/Aspect advancement.
2. **Survival** — Health, Spirit, recovery, temporary capacity.
3. **Economy** — Gold, Shops, Technique rerolls.
4. **Persistent progress** — Mist, Scrolls, regional boss materials, unlocks, discoveries, and campaign progress.

Persistent rewards should remain worthwhile on failed runs without making the correct route choice automatically `take permanent currency`.

# Resource ownership

## General currencies

| Resource | Persistence | Primary role |
|---|---|---|
| **Mist** | Persistent | Broad meta progression, especially Bloodwell-owned Akio / Run Infrastructure progression and other approved broad upgrades |
| **Scroll / Scrolls** | Persistent | Forge-focused Prosthetic development |
| **Gold** | Run-only | Shops and run economy |

Oathbound does **not** use a general `Boss Emblem` currency.

## Regional boss materials

Each of the three regional bosses drops one **boss-specific permanent material** every time that boss is defeated:

- Keeper of the Gate material,
- Twin Maws material,
- Eclipse Shogun material.

Exact player-facing item names are intentionally deferred to a later item/content naming pass. Mechanically:

- exactly **1** corresponding material is awarded per boss kill,
- the material persists immediately when earned even if Akio later dies in the same run,
- each boss has its own material rather than contributing to one generic boss currency,
- minibosses do not create additional boss-material families,
- quantities remain deliberately small,
- materials are not routine Shop currency and are not used for ordinary repeat purchases,
- and they serve mainly as **secondary requirements for a small number of major permanent upgrades** alongside the upgrade system's normal currency.

The intended cost language is usually **1 material** for an early significant gate, **2** for a stronger gate, and **3** for a major late gate. Costs above 3 should be exceptional because the system should reward repeated mastery without turning bosses into material farms.

Each regional material should have only a few meaningful uses across the base game—roughly **2–4 uses per material** is the current scope target. Basic progression should remain available through its normal currency; boss materials gate selected high-value upgrades rather than every rank.

Progression timing should follow run mastery:

- Keeper material may support earlier major upgrades,
- Twin Maws material primarily supports midgame major upgrades,
- Shogun material primarily supports late-game or high-end upgrades.

## Not currencies

The following are tracked resources or progression states but are not spendable currencies:

- **Corruption** — Shrine-ready Aspect pressure.
- **Blood** — Tier-II-and-later run-only Blood Art resource.
- **Relic mastery** — persistent progression earned while the Relic is equipped.
- **Heart Bindings** — persistent campaign state.

`Mist Shards` remains deprecated.

# Persistent-resource payout prototype

## Standard Combat primary rewards

When a standard Combat room rolls Mist or Scrolls as its previewed primary reward:

| Region | Mist reward | Scroll reward |
|---|---:|---:|
| **Hushiro** | 20 Mist | 1 Scroll |
| **Yomori** | 25 Mist | 1 Scroll |
| **Kagutsuchi** | 30 Mist | 2 Scrolls |

Later rewards increase modestly because choosing permanent progression deeper in the run gives up increasingly valuable immediate build power.

## No ordinary persistent-resource farming

For the first prototype:

- ordinary enemies do **not** randomly drop Mist or Scrolls,
- ordinary breakables do **not** randomly drop Mist or Scrolls,
- persistent progression comes from previewed rewards and deliberate high-value sources.

This prevents enemy farming and avoids making breakable-clearing mandatory for efficient meta progression.

## Treasure persistent rewards

When Treasure resolves into persistent currency, use:

| Region | Mist Treasure | Scroll Treasure |
|---|---:|---:|
| **Hushiro** | 50 Mist | 2 Scrolls |
| **Yomori** | 60 Mist | 2 Scrolls |
| **Kagutsuchi** | 75 Mist | 3 Scrolls |

These are approximately two to two-and-a-half ordinary persistent-resource rewards and should feel premium without making Treasure automatically superior to every immediate-power reward.

## Miniboss persistent bonus

Every defeated miniboss grants:

- **+10 Mist**,
- **+1 Scroll**,

in addition to its normal high-value primary reward.

The premium current-run reward remains the main reason to take the harder branch. The persistent bonus ensures the victory still matters if the run later fails.

## Regional boss persistent rewards

Each regional boss kill grants:

| Boss | Mist | Boss material |
|---|---:|---:|
| **Keeper of the Gate** | +10 Mist | +1 Keeper material |
| **Twin Maws** | +15 Mist | +1 Twin Maws material |
| **Eclipse Shogun** | +25 Mist | +1 Shogun material |

A complete Shogun route therefore provides **50 guaranteed Mist from regional boss kills** before any optional Mist routes, Treasure, or miniboss bonuses.

Boss materials are awarded on every kill, not only first kills and not only successful Binding runs. This lets players progress through repeated mastery of Keeper or Twin Maws even when they have not yet completed the entire island.

## Failed and successful run retention

Mist, Scrolls, regional boss materials, Relic mastery, discoveries, and other explicitly persistent rewards are saved when earned.

There is:

- no death tax,
- no requirement to finish the run before banking earned persistent resources,
- no automatic loss percentage on failure,
- and no generic victory multiplier applied to already-earned resources.

Successful runs naturally earn more because they reach more reward opportunities and bosses. Heart Binding destruction remains campaign progression rather than a spendable completion token.

## Working earnings targets

These ranges are pacing targets, not guarantees:

| Run depth / routing | Mist | Scrolls | Regional boss materials |
|---|---:|---:|---:|
| Early Hushiro failure | ~0–25 | ~0–1 | 0 |
| Failure after Keeper | ~20–50 | ~0–2 | normally 1 Keeper material |
| Failure after Twin Maws | ~40–80 | ~1–3 | Keeper + Twin Maws materials earned that run |
| Normal successful Binding run | ~80–120 | ~2–4 | 1 of each regional material |
| Persistent-focused successful run | ~130–180+ | ~4–6 | 1 of each regional material |

A persistent-focused route should enter later fights with less immediate run power than a Technique/Shrine/survival-focused route. That opportunity cost is intentional.

# Permanent-cost calibration

`PROGRESSION.md` owns upgrade-system boundaries; this section provides reward-economy calibration targets.

## Scroll cost prototype

The current 19 Prosthetic Forge upgrades use the working sequential cost curve:

- first upgrade in a tool path: **2 Scrolls**,
- second upgrade: **4 Scrolls**,
- third upgrade where one exists: **6 Scrolls**.

Across the current eight-tool / 19-upgrade roster, this produces a working total of **66 Scrolls** to buy every Prosthetic upgrade. This is a prototype cost horizon, not a requirement that the campaign expect full completion.

## Mist cost calibration

Exact Bloodwell and Blood Mirror node inventories are not yet defined, so individual Mist costs remain later design. Use these working bands when those trees are authored:

- small early upgrade: roughly **40–50 Mist**,
- normal meaningful upgrade: roughly **75–100 Mist**,
- major upgrade: roughly **125–175 Mist**,
- exceptional boss-gated major upgrade: roughly **200–250+ Mist plus 1–3 appropriate regional boss materials**.

Boss materials supplement the normal currency rather than replacing it. A major Wraith, Akio, Run Infrastructure, Relic, or other approved permanent upgrade may use an appropriate regional material when its place in progression justifies that mastery gate; exact assignments belong to the owning progression pass.

# Gold economy prototype

Akio begins a normal run at **0 Gold** unless an approved effect changes starting Gold.

## Standard Gold rewards

| Region | Gold reward |
|---|---:|
| **Hushiro** | 60 Gold |
| **Yomori** | 70 Gold |
| **Kagutsuchi** | 80 Gold |

Minor enemy / breakable Gold drops, when generated, are **5–10 Gold**.

Working successful-run economy targets:

- roughly **3–4** Gold primary rewards taken,
- roughly **220–320 Gold** available on a normal successful route,
- roughly **350–450+** on an economy-focused route,
- roughly **100–180** when largely ignoring Gold,
- roughly **2–4 Shop purchases** across **1–2 visited Shops**,
- roughly **4–6 purchases** on a strongly economy-focused route.

After the final realistic Shop opportunity has been passed, Gold cannot appear as a primary route reward; its weight is redistributed among eligible rewards.

# Minor pickups

- minor Health pickup: **5% max Health**,
- minor Spirit pickup: **10% max Spirit**,
- minor Gold drop: **5–10 Gold**.

Blood is generated through Blood Aspect combat rules rather than as an ordinary pickup. Mist and Scrolls are excluded from ordinary random minor drops in the current prototype.

# Route rewards

Route exits preview the primary reward category before commitment. Supported categories include Technique, Relic, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, Rest, Shop, Treasure, Miniboss, and Boss.

`RUN_STRUCTURE.md` owns all regional minimum-opportunity safeguards and branch topology. This file does not duplicate those tables.

## Prototype room-type weighting

| Room type | Opening | Main stretch | Pre-boss / final stretch |
|---|---:|---:|---:|
| Standard Combat | 82% | 70% | 58% |
| Shrine | 6% | 8% | 5% |
| Rest | 4% | 7% | 13% |
| Shop | 2% | 7% | 13% |
| Treasure | 6% | 8% | 11% |

Minibosses are deliberately injected into their approved windows and regional bosses are fixed endpoints rather than rolls from this table.

## Prototype standard-Combat reward weights

| Reward | Hushiro | Yomori | Kagutsuchi |
|---|---:|---:|---:|
| Technique | 36% | 32% | 28% |
| Gold | 20% | 20% | 18% |
| Mist | 11% | 10% | 9% |
| Scrolls | 7% | 8% | 8% |
| Health / Spirit recovery | 12% | 12% | 16% |
| Temporary capacity | 7% | 10% | 11% |
| Reroll resource | 7% | 8% | 10% |

Relics are not part of the ordinary standard-Combat table. Consumables have **0% ordinary primary-room reward weight** in the first prototype.

# Technique rewards

A Technique reward uses the universal three-choice screen and generation rules in `TECHNIQUES.md` regardless of source. Standard Combat is the primary source; Shops, Treasure, minibosses, regional bosses, and explicitly approved sources may use the same system with their approved source-quality weighting.

Current pickup targets for a Technique-invested successful run are roughly:

- Hushiro: **3** including the fixed Chamber 1 reward,
- Yomori: **2–3** more,
- Kagutsuchi: **2–3** more,
- full run: roughly **7–9**, with focused routes potentially reaching **10–12+**.

There is no global Technique inventory cap.

# Survival and temporary capacity

## Standard Combat recovery

- Health: **+25% max Health**.
- Spirit: **+35% max Spirit**.

## Standard temporary capacity

- Health: **+15% of starting max Health**.
- Spirit: **+20% of starting max Spirit**.

Capacity rewards also grant the same amount as current resource and stack additively from starting maximum.

## Shrine support below full Corruption

- Health support: **+20% max Health**, or
- Spirit support: **+25% max Spirit**.

Full-Corruption Resist/Embrace behavior remains owned by `CORRUPTION_AND_SHRINES.md`.

## Rest

Rest restores:

- **35% max Health**,
- **50% max Spirit**.

Rest does not fully reset attrition and does not provide Technique respec behavior.

## Treasure survival rewards

- major Health recovery: **+50% max Health**,
- major Spirit recovery: **+65% max Spirit**,
- enhanced Health capacity: **+20% starting max Health** plus matching current Health,
- enhanced Spirit capacity: **+25% starting max Spirit** plus matching current Spirit.

## Miniboss survival rewards

A miniboss may use enhanced Health or Spirit capacity as its premium primary reward. Pure healing is not a primary miniboss reward in the first prototype.

A normal successful run is expected to take roughly **1–2** capacity improvements total; a survival-focused route may take roughly **3–4** at the cost of other rewards.

# Shops

Run Shops use Gold and present **3 purchasable items**:

1. **Survival** — Health/Spirit recovery.
2. **Build** — Technique, temporary capacity, or reroll.
3. **Flex / premium** — Technique, capacity, reroll, stronger recovery, occasional Relic, or another approved premium item.

The player may buy every displayed item they can afford. Shop inventory itself does not reroll in the first prototype.

When an eligible Relic opportunity exists, the flex slot has approximately a **10%** chance to become one.

| Purchase | Price | Effect |
|---|---:|---|
| Moderate Health restore | 35 Gold | +25% max Health |
| Moderate Spirit restore | 30 Gold | +30% max Spirit |
| Large Health restore | 55 Gold | +45% max Health |
| Large Spirit restore | 50 Gold | +50% max Spirit |
| Reroll resource | 45 Gold | +1 Technique reroll resource |
| Temporary max Health | 65 Gold | +15% starting max Health + matching current Health |
| Temporary max Spirit | 60 Gold | +20% starting max Spirit + matching current Spirit |
| Technique reward | 100 Gold | Shop-quality Technique screen |
| Relic opportunity | 140 Gold | Approved Relic opportunity when eligible |

Prices remain stable across regions in this prototype.

# Treasure, miniboss, and boss reward hierarchy

Treasure may provide a Technique, Relic opportunity, persistent-resource bundle, major recovery, enhanced capacity, or approved rare consumable if consumables remain in launch scope.

A miniboss always provides meaningful build development rather than only ordinary Gold or healing, plus its fixed **+10 Mist / +1 Scroll** persistent bonus.

Regional bosses combine:

- their fixed persistent Mist payout,
- their fixed boss-specific material drop,
- narrative/codex progression where applicable,
- and, for Keeper / Twin Maws, a separate current-run boss reward before the regional transition.

The exact **current-run reward mix** for Keeper and Twin Maws remains the next reward-side integration question. Boss materials do not replace those run rewards.

# Regional transition recovery

After Keeper and Twin Maws, the non-counted safe transition restores:

- **20% max Health**,
- **35% max Spirit**,

then enforces next-region floors of:

- **35% max Health**,
- **50% max Spirit**.

The boss's interesting reward is separate from this automatic viability support.

# Eclipse Shogun and Heart handoff

During the first six successful Binding clears, the Shogun grants his persistent boss rewards but no additional ordinary current-run power because the run proceeds into the Binding-completion sequence.

On the seventh story run, the same active build continues from Shogun to the true-final Heart. The handoff restores:

- **30% max Health**,
- **50% max Spirit**,

then enforces Heart-entry floors of:

- **40% max Health**,
- **60% max Spirit**.

Blood is not automatically refilled unless later Heart encounter integration explicitly changes that rule.

Heart Binding destruction is campaign progress, not spendable currency.

# Relics

`RELICS.md` owns the 10-Relic launch roster, one equipped slot, persistent collection/mastery/progression, and run-active benefits. Relics have no rarity tiers.

Relic acquisition remains intentionally uncommon. The current Shop flex slot may occasionally surface a Relic opportunity; final acquisition allocation and transition-swap placement remain later integration work.

# Run Infrastructure boundary

Run Infrastructure may improve approved future-run support around Rest, Shrines, reward possibilities, routing, regional transitions, and persistent-resource opportunities. It may not eliminate route opportunity cost or make high-value rewards, ideal builds, recovery, or Aspect advancement automatic.

# Guardrails

- Persistent currencies and boss materials are retained when earned; do not add a failure tax.
- Do not reintroduce a generic Boss Emblem currency.
- Do not create boss-specific materials for minibosses.
- Keep regional boss material costs low enough that bosses do not become mandatory farming chores.
- Basic permanent progression should not require repeated late-game boss kills.
- Scrolls remain Prosthetic-focused unless another use is explicitly approved.
- Gold remains run-only and disappears at run end.
- Blood is a combat resource, not a currency or route reward.
- Temporary capacity is run-only.
- Final values may move through playtesting without reopening the ownership model.

# Current production dependency

The route structure, room/reward weights, Technique offer generation, Gold/Shop economy, survival/recovery/capacity model, and first persistent-resource payout model are now complete at prototype paper-design depth.

The next reward-side integration layer is **regional-boss current-run reward composition and Relic acquisition / transition-swap placement**. Full-run integration then continues through consumables include/cut confirmation, encounter composition and clear-time tuning, 45–50-minute run simulation, and playable validation of the prototype values.