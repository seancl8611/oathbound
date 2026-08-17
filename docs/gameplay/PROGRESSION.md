---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - currencies
  - mist
  - scrolls
  - boss-materials
  - relics
  - run-infrastructure
  - heart-bindings
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-INTERACTIBLES
  - META-OPEN-QUESTIONS
---

# Progression

Oathbound uses three progression layers:

1. **run-only build progression**,
2. **persistent progression between runs**,
3. **persistent campaign progression**.

This file owns persistence and progression-system boundaries. Detailed Aspect kits, Technique content, Prosthetic upgrade effects, Relic effects, and reward payouts remain in their own authoritative files.

# Run-only progression

Run-only state includes:

- selected Blood Aspect and current Tier,
- Corruption,
- Blood and Blood Art state after Tier II,
- five direct slotted Techniques,
- slotless Supporting / Cross-family / Legendary Techniques,
- refinements and replacement state,
- current equipped Relic benefit,
- Gold,
- room progress,
- temporary Health / Spirit capacity,
- approved run-only consumables or encounter states.

These reset after failed death-return or successful completion unless another authority explicitly says otherwise.

## Run-build investment rule

The selected Blood Aspect is Akio's weapon foundation. Deeper Aspect investment competes with Technique, survival, economy, Relic, and persistent-resource routes.

Viable outcomes must continue to include:

- Technique-focused Tier 0–I runs,
- common Tier II hybrids,
- deliberate Tier III Aspect-heavy runs,
- occasional Tier IV high-roll runs.

Mandatory encounters cannot assume a specific Tier, Blood Art, Technique family, Legendary, Relic, heavily upgraded Prosthetic, ideal economy, or ideal survival route.

`BLOOD_ASPECTS.md` and the individual Aspect files own Tier content. `TECHNIQUES.md` and `TECHNIQUE_CATALOG.md` own Technique structure/content.

# Permanent upgrade architecture

Current launch scope uses exactly **three permanent upgrade stations**.

## Bloodwell — Akio + Run Infrastructure

The Bloodwell owns:

- **Akio** permanent progression,
- **Run Infrastructure** permanent progression.

### Akio

Akio upgrades apply broadly rather than to one Aspect, Technique family, Prosthetic, or Relic. Exact node inventory and values remain a later detailed-design pass.

### Run Infrastructure

Run Infrastructure is one umbrella for persistent improvements to future-run support, including approved improvements to:

- Rest support,
- Shrine support without bypassing Tier rules,
- reward possibilities,
- routing information/support,
- regional-transition support,
- beneficial expedition conditions,
- persistent-resource opportunities.

It is **not** split into separate permanent Rest, Shrine, route, reward, or transition trees.

Run Infrastructure cannot:

- grant permanent Aspect Tiers,
- unlock Blood before Tier II,
- replace Technique choices,
- directly upgrade a particular Prosthetic or Relic,
- or remove the need for combat execution.

## Forge Bench — Prosthetics + Relics

The Forge owns permanent progression/management for:

- **Prosthetics**,
- **Relics**.

### Prosthetics

The eight launch Prosthetics are functionally complete when unlocked and use shallow linear permanent paths. Exact upgrade effects belong to `PROSTHETICS.md`.

Scrolls remain the primary Prosthetic upgrade currency.

Working Forge cost curve:

- first upgrade in a tool path: **2 Scrolls**,
- second upgrade: **4 Scrolls**,
- third upgrade where approved: **6 Scrolls**.

The current 19-upgrade roster therefore has a working full-purchase cost of **66 Scrolls**. The campaign does not assume the player buys all 19 upgrades.

### Relics

Relics use persistent collection, individual mastery, and permanent progression while remaining a small supporting system.

- one Relic equipped at a time,
- collection ownership persists,
- only the equipped Relic gains eligible kill mastery,
- mastery persists through death, success, and swapping,
- mastery strengthens the Relic's existing benefit rather than adding unrelated branches,
- Forge Bench owns Strand-side Relic progression and management.

Sharing the Forge does **not** automatically make Scrolls a Relic currency. Exact Relic costs, if any, remain later design.

There is no separate Relic Reliquary.

## Blood Mirror — Blood Aspects

The Blood Mirror owns permanent Blood Aspect progression.

- it begins locked,
- unlocks later through campaign/onboarding progression,
- its exact unlock event remains deferred,
- permanent Aspect progression remains small, capped, and reliability-oriented.

Blood Mirror progression cannot:

- grant major Tier mechanics early,
- bypass the Tier 0–IV Shrine/Embrace path,
- unlock Blood before Tier II,
- turn run Tier growth into uncapped permanent scaling,
- remove a kit's inherent commitments/tradeoffs.

No separate permanent Blood Art upgrade tree is approved.

# Persistent resource architecture

## Mist

Mist is the broad persistent meta currency. It is the natural currency for Bloodwell-owned progression and may support other approved broad permanent upgrades.

Exact node costs are authored with the owning tree. Current economy calibration targets are:

- small early upgrade: roughly **40–50 Mist**,
- normal meaningful upgrade: roughly **75–100 Mist**,
- major upgrade: roughly **125–175 Mist**,
- exceptional boss-gated major upgrade: roughly **200–250+ Mist** plus an appropriate low-count regional boss material.

These are prototype cost bands rather than a finished upgrade tree.

## Scrolls

Scrolls are persistent and remain primarily focused on Prosthetic Forge development. Their current 2 / 4 / 6 sequential cost curve is approved for the first prototype.

Do not casually add unrelated Scroll sinks; doing so would weaken their clear ownership.

## Regional boss materials

Oathbound uses **three boss-specific permanent materials**, one from each regional boss, rather than a generic Boss Emblem currency.

- Keeper of the Gate drops exactly 1 Keeper-specific material per kill.
- Twin Maws drop exactly 1 Twin-Maws-specific material per kill.
- Eclipse Shogun drops exactly 1 Shogun-specific material per kill.

Exact player-facing item names are deferred.

Boss materials:

- persist immediately when earned,
- are retained even if the run later fails,
- are low-count upgrade materials rather than general spending currency,
- are mainly secondary requirements attached to selected major permanent upgrades,
- normally use costs of **1–3 materials**,
- should have only a few meaningful uses per boss material,
- are never created for minibosses in the current scope.

Basic progression should not require repeated late-game boss farming. Keeper material may support earlier gates, Twin Maws material midgame gates, and Shogun material late/high-end gates.

A major upgrade may require its normal Mist or other owning-system currency **plus** the relevant boss material. Boss material requirements prove repeated mastery; they do not replace the normal economy.

`ITEMS_AND_REWARDS.md` owns exact payout values and expected run earnings.

## Gold

Gold is run-only and exists only for the current run's Shop economy. It resets at run end.

## Not currencies

The following are not spendable currencies:

- Corruption,
- Blood,
- Relic mastery,
- destroyed Heart Bindings.

`Mist Shards` and generic `Boss Emblems` are not current resources.

# Non-upgrade persistent systems

The following may persist or unlock content but are not separate permanent upgrade trees:

- Technique-pool unlocks,
- Blood Cavern / Blood Mirror trial completion,
- Discovery Board and codex progress,
- Merchant stock/service state where approved,
- narrative discoveries,
- Heart Binding campaign state,
- story and postgame state.

The Blood Cavern is a training/trial space. The Discovery Board is a knowledge archive. The Merchant is a service. The Boat is run-start confirmation.

# Campaign progression

The Heart was imprisoned by seven Bindings. The Court destroyed the outermost before the game, leaving six intact.

Each successful Binding run destroys one remaining Binding. Failed runs do not advance the Binding count.

After all six are destroyed, the next successful full route becomes the seventh and final story run and continues from the Eclipse Shogun into the Heart.

Heart Bindings are campaign state, not currency, and cannot be spent or lost.

# Trial reward boundary

Blood Cavern and Blood Mirror trials may award approved persistent currency, Aspect access/progression, Technique-pool unlocks, cosmetics, lore, mastery marks, or Relic unlocks where assigned.

Trials may not:

- permanently pre-equip run Techniques,
- create persistent Blood,
- add alternate Aspect Tiers,
- bypass the Shrine progression path.

# Return processing

Returning Blood reconstructs Akio at the Strand after failed runs and successful Binding completions.

Persistent rewards are saved **when earned**, not only on successful completion. This includes Mist, Scrolls, regional boss materials, Relic mastery, and other explicitly persistent rewards.

A successful Binding return additionally saves Binding progress, clears run-only state, presents results, and triggers relevant hub/codex/Heart updates.

There is no death tax on already-earned persistent resources.

# Persistence matrix

| Category | After death | After completion |
|---|---:|---:|
| Narrative / codex progress | Persists | Persists |
| Destroyed Bindings | Persists | Persists |
| Permanent upgrades / unlocks | Persists | Persists |
| Run Infrastructure upgrades | Persists | Persists |
| Relic collection / mastery / progression | Persists | Persists |
| Mist / Scrolls | Persists | Persists |
| Regional boss materials | Persists | Persists |
| Blood Aspect Tier | Resets | Resets |
| Corruption | Resets | Resets |
| Blood / Blood Art state | Resets | Resets |
| Techniques / refinements / replacement state | Resets | Resets |
| Equipped Relic run benefit | Ends | Ends |
| Gold | Resets | Resets |
| Temporary Health / Spirit capacity | Resets | Resets |
| Room progress | Resets | Resets |
| Consumables | Item-specific | Item-specific |

# Current design dependency

Permanent station ownership and the first persistent-resource economy are complete at prototype paper-design depth.

Remaining progression work is nested under the owning systems rather than a new architecture question: exact Bloodwell nodes, Blood Mirror nodes, Relic mastery/cost realization, boss-material assignment to selected major upgrades, and final numerical tuning after playtests.

The active full-run design dependency is now regional-boss current-run reward composition and Relic acquisition / transition-swap placement.