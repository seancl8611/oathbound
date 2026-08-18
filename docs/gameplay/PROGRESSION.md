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
- encounter-specific temporary states where authored.

Oathbound does **not** include a general run-consumable inventory or one-use item progression layer at launch.

These run-only states reset after failed death-return or successful completion unless another authority explicitly says otherwise.

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

Current launch scope uses exactly **three permanent upgrade stations**:

1. **Bloodwell — Akio + Run Infrastructure**
2. **Forge Bench — Prosthetics + Relics**
3. **Blood Mirror — Blood Aspects**, unlocked after the first Keeper defeat

The launch permanent-progression package is deliberately compact. Permanent growth should improve reliability, resilience, and long-term goals without replacing sword execution, route decisions, run-built Techniques, Aspect Tier progression, or Prosthetic/Relic choices.

# Bloodwell — Akio

The Bloodwell contains **10 Akio nodes**. Akio upgrades apply broadly rather than to one Aspect, Technique family, Prosthetic, or Relic.

## Foundation nodes

1. **Vitality** — permanent maximum-Health growth.
2. **Composure** — permanent maximum player-posture growth.
3. **Spirit Reserve** — permanent maximum-Spirit growth.

These form the first Bloodwell band after Akio's first return to the Strand.

## Combat-stability nodes

4. **Posture Recovery** — modestly improves Akio's normal posture recovery.
5. **Recovery Efficiency** — modestly improves approved Health recovery received from Rest and recovery rewards.
6. **Deflection Stability** — successful parries provide a small player-posture stabilization benefit.
7. **Execution Stability** — Deathblows clear a modest amount of accumulated player posture.

These reinforce successful use of the existing combat loop rather than providing passive damage scaling.

## Major mastery nodes

8. **Body Mastery** — major universal Health/posture resilience upgrade; requires Mist plus a Keeper-specific material.
9. **Resource Mastery** — major universal Spirit/resource-management upgrade; requires Mist plus a Twin-Maws-specific material.
10. **Returning Blood Mastery** — high-end universal resilience upgrade; requires Mist plus a Shogun-specific material.

Exact numerical values and final Mist prices remain tuning work. These nodes may not become permanent attack-speed scaling, large damage multipliers, enlarged parry windows, repeatable permanent revives, or other effects that remove core combat risk.

# Bloodwell — Run Infrastructure

Run Infrastructure remains one umbrella rather than separate Rest, Shrine, route, reward, or transition trees. Launch scope contains **8 Run Infrastructure nodes**.

1. **Field Rest** — improves Rest-room recovery/support.
2. **Shrine Stabilization** — improves the benefit of choosing Resist without changing Embrace requirements, Tier limits, or Blood availability.
3. **Expedition Preparation** — begins a normal run with **+1 Technique reroll**.
4. **Route Intelligence** — improves approved route-choice information without allowing unrestricted route rewriting.
5. **Salvage Protocol** — modestly improves persistent-resource efficiency from approved reward sources; it does not create random enemy/breakable Mist or Scroll drops.
6. **Keeper Passage** — improves the existing Keeper → Yomori transition support; requires Mist plus Keeper material.
7. **Twin Passage** — improves the existing Twin Maws → Kagutsuchi transition support; requires Mist plus Twin Maws material.
8. **Heart Passage** — improves the existing Shogun → Heart support package; requires Mist plus Shogun material.

Run Infrastructure cannot:

- grant permanent Aspect Tiers,
- unlock Blood before Tier II,
- replace Technique choices,
- directly upgrade a particular Prosthetic or Relic,
- remove the need for combat execution,
- or guarantee an ideal route/build.

Exact percentages and final Mist costs remain later tuning.

# Forge Bench — Prosthetics + Relics

The Forge owns permanent progression/management for **Prosthetics** and **Relics**.

## Prosthetics

The eight launch Prosthetics are functionally complete when unlocked and use the already-approved shallow linear permanent paths. Exact upgrade effects belong to `PROSTHETICS.md`.

Scrolls remain the primary Prosthetic upgrade currency.

Working Forge cost curve:

- first upgrade in a tool path: **2 Scrolls**,
- second upgrade: **4 Scrolls**,
- third upgrade where approved: **6 Scrolls**.

The current 19-upgrade roster therefore has a working full-purchase cost of **66 Scrolls**. The campaign does not assume the player buys all 19 upgrades.

Regional boss materials are not part of normal Prosthetic ranks in the launch package.

## Relics

Relics use persistent collection and use-based mastery while remaining a small supporting system.

- one Relic equipped at a time,
- collection ownership persists,
- all 10 launch Relics are obtainable before the canonical story ending,
- acquisition uses **4 guaranteed campaign/Strand + 2 Blood Cavern/challenge + 4 run-discovered Relics**,
- until the collection is complete, eligible discoveries prioritize undiscovered Relics rather than duplicates,
- only the equipped Relic gains eligible kill mastery,
- mastery persists through death, success, and swapping,
- mastery strengthens the Relic's existing benefit rather than adding unrelated branches,
- Forge Bench owns Strand-side Relic progression and pre-run equipment management.

Each launch Relic has exactly **two mastery ranks after its base state**:

- **Base**
- **Mastery I**
- **Mastery II / complete**

Mastery progression is earned through eligible kills while equipped. It does **not** normally cost Mist, Scrolls, boss materials, or duplicate Relics. Exact kill thresholds and numerical improvement per rank remain later tuning.

Normal in-run Relic swaps occur after Keeper and after Twin Maws. A newly discovered Relic also creates an immediate equip-or-keep decision while being permanently collected either way. Rest rooms, Shops, combat, ordinary rooms, and the pause menu do not provide routine free swapping.

# Blood Mirror — Blood Aspects

The Blood Mirror owns permanent Blood Aspect progression. It begins locked and **unlocks after the player's first Keeper defeat**.

Launch scope contains exactly **3 permanent nodes per Aspect**, for **9 Blood Mirror nodes total** across Wolf, Wraith, and Ronin.

Each Aspect uses the same structural roles while receiving Aspect-specific effects:

1. **Tier 0 Handling** — modest reliability/handling improvement to the base Aspect without removing its defining weakness.
2. **Signature Reliability** — modestly supports the Aspect's characteristic run-earned Tier mechanics after those mechanics have been earned normally.
3. **Blood Discipline** — modestly improves reliability, recovery, or resource consistency surrounding that Aspect's Blood Art after Tier II/Blood has been reached normally.

Broad intended identities:

- **Wolf:** pursuit/commitment handling → pressure reliability → Blood Hunt recovery/control.
- **Wraith:** spectral-attack handling → spectral commitment/reposition reliability → Wraith's Reach recovery/control.
- **Ronin:** heavy-contact handling → defensive/posture reliability → Falling Mountain recovery/control.

Blood Mirror progression is small, capped, and reliability-oriented. It cannot:

- grant major Tier mechanics early,
- bypass the Tier 0–IV Shrine/Embrace path,
- unlock Blood before Tier II,
- turn run Tier growth into uncapped permanent scaling,
- remove a kit's inherent commitments/tradeoffs,
- grant Wraith's Tier-IV range/deathblow rules early,
- reproduce Ronin's run-only Tier posture-capacity growth as uncapped permanent scaling,
- or create a separate permanent Blood Art tree.

The first Blood Mirror node for each unlocked Aspect becomes available after the first Keeper defeat, the second after the first Twin Maws defeat, and the third after the first Shogun defeat / first Binding clear. Exact individual effects, values, and any normal Mist costs remain later detailed tuning.

# Regional boss-material gate structure

Oathbound uses exactly **six boss-material-gated permanent nodes** in the launch progression package: two uses for each regional boss material.

| Boss material | Akio gate | Run Infrastructure gate |
|---|---|---|
| Keeper material | Body Mastery | Keeper Passage |
| Twin Maws material | Resource Mastery | Twin Passage |
| Shogun material | Returning Blood Mastery | Heart Passage |

Each gate uses the appropriate boss material as a secondary mastery requirement **alongside Mist**. Boss materials remain low-count keys rather than routine currency.

No normal Prosthetic rank, Relic mastery rank, or ordinary Blood Mirror node requires a regional boss material at launch.

# Persistent resource architecture

## Mist

Mist is the broad persistent meta currency. It is the natural currency for Bloodwell-owned progression and may support approved Blood Mirror purchases where later tuning calls for it.

Current economy calibration targets remain:

- small early upgrade: roughly **40–50 Mist**,
- normal meaningful upgrade: roughly **75–100 Mist**,
- major upgrade: roughly **125–175 Mist**,
- exceptional boss-gated major upgrade: roughly **200–250+ Mist** plus an appropriate low-count regional boss material.

These are prototype cost bands rather than final node prices.

## Scrolls

Scrolls are persistent and remain primarily focused on Prosthetic Forge development. Their current 2 / 4 / 6 sequential cost curve is approved for the first prototype.

Do not casually add unrelated Scroll sinks.

## Regional boss materials

- Keeper of the Gate drops exactly 1 Keeper-specific material per kill.
- Twin Maws drop exactly 1 Twin-Maws-specific material per kill.
- Eclipse Shogun drops exactly 1 Shogun-specific material per kill.

Exact player-facing item names remain deferred.

Boss materials:

- persist immediately when earned,
- are retained even if the run later fails,
- are low-count upgrade materials rather than general spending currency,
- normally use costs of **1–3 materials** when attached to an approved gate,
- are never created for minibosses in the current scope.

The six-node gate table above is the complete launch boss-material assignment unless scope is deliberately reopened.

## Gold

Gold is run-only and exists only for the current run's Shop economy. It resets at run end.

## Not currencies

The following are not spendable currencies:

- Corruption,
- Blood,
- Relic mastery,
- destroyed Heart Bindings.

`Mist Shards` and generic `Boss Emblems` are not current resources.

# Campaign unlock cadence

Permanent progression is introduced in stages so the player does not receive every meta system at once.

## Introductory attempt

No permanent upgrade interface is active. Akio fights as an ordinary Order swordsman and dies for the first time.

## First return to the Strand

The **Bloodwell opens**.

Initial available Bloodwell content:

- Vitality,
- Composure,
- Spirit Reserve,
- Field Rest,
- Expedition Preparation.

This gives early Mist an immediate purpose while keeping onboarding focused.

## First Keeper defeat

Unlock the second progression band:

- Akio combat-stability nodes begin opening,
- Shrine Stabilization and Route Intelligence become available,
- Keeper-material gates Body Mastery and Keeper Passage become visible/eligible according to their normal Mist/material requirements,
- the **Blood Mirror unlocks**,
- Blood Mirror Node 1 / Tier 0 Handling becomes available for each unlocked Aspect.

## First Twin Maws defeat

Unlock the third progression band:

- remaining midgame Bloodwell support becomes available, including Salvage Protocol,
- Twin-Maws-material gates Resource Mastery and Twin Passage become visible/eligible,
- Blood Mirror Node 2 / Signature Reliability becomes available for each unlocked Aspect.

## First Shogun defeat / first Binding clear

Unlock the final permanent-progression band:

- Shogun-material gates Returning Blood Mastery and Heart Passage become visible/eligible,
- Blood Mirror Node 3 / Blood Discipline becomes available for each unlocked Aspect,
- all permanent progression systems are now structurally available.

The remaining Binding clears do **not** need to introduce additional foundational permanent systems. Repeated runs instead support completing favored Bloodwell nodes, Prosthetic paths, Relic mastery, Blood Mirror progression, Relic collection, trials, and other already-approved persistent goals before the seventh story run into the Heart.

# Relic acquisition cadence

The approved **4 / 2 / 4** acquisition split remains unchanged.

Working sequencing direction:

- the **4 guaranteed campaign/Strand Relics** are distributed across early-to-mid campaign progression rather than awarded together; one may arrive soon after the first return, one around Keeper progression, one around Twin Maws progression, and one by the first Binding clear,
- the **2 Blood Cavern/challenge Relics** come from two authored first-time challenge milestones, with one earlier and one more advanced,
- the **4 run-discovered Relics** continue to appear through approved Treasure, Boss Reward Flex, and occasional Shop Flex opportunities, prioritizing undiscovered Relics until the collection is complete.

Exact Relic identities within those acquisition slots remain content sequencing rather than progression architecture.

# Non-upgrade persistent systems

The following may persist or unlock content but are not separate permanent upgrade trees:

- Technique-pool unlocks,
- Blood Cavern / Blood Mirror trial completion,
- Relic collection unlocks,
- Discovery Board and codex progress,
- Merchant stock/service state where approved,
- narrative discoveries,
- Heart Binding campaign state,
- story and postgame state.

The Blood Cavern is a training/trial space. The Discovery Board is a knowledge archive. The Merchant is a service. The Boat is run-start confirmation.

# Heart Binding campaign progression

The Heart was imprisoned by seven Bindings. The Court destroyed the outermost before the game, leaving six intact.

Each successful Binding run destroys one remaining Binding. Failed runs do not advance the Binding count.

After all six are destroyed, the next successful full route becomes the seventh and final story run and continues from the Eclipse Shogun into the Heart.

Heart Bindings are campaign state, not currency, and cannot be spent or lost.

# Trial reward boundary

Blood Cavern and Blood Mirror trials may award approved persistent currency, Aspect access/progression, Technique-pool unlocks, cosmetics, lore, mastery marks, or Relic unlocks where assigned.

The launch Relic acquisition model reserves **two permanent first-time Relic unlocks** for authored Blood Cavern / challenge milestones. Repeating those challenges does not create duplicate Relics or repeatable Relic currency.

Trials may not:

- permanently pre-equip run Techniques,
- create persistent Blood,
- add alternate Aspect Tiers,
- bypass the Shrine progression path.

# Return processing

Returning Blood reconstructs Akio at the Strand after failed runs and successful Binding completions.

Persistent rewards are saved **when earned**, not only on successful completion. This includes Mist, Scrolls, regional boss materials, Relic mastery, newly discovered Relics, and other explicitly persistent rewards.

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

# Locked launch permanent-progression scope

The permanent-progression content structure is now complete at paper-design depth:

- **10 Akio nodes**,
- **8 Run Infrastructure nodes**,
- **3 Blood Mirror nodes per Aspect / 9 total**,
- **2 mastery ranks per Relic / 20 mastery milestones across 10 Relics**,
- existing **19 Prosthetic upgrades**,
- exactly **6 boss-material-gated Bloodwell nodes**,
- staged availability from first return → Keeper → Twin Maws → first Binding clear.

Remaining work is balance/content realization: exact numerical values, final Mist prices, mastery kill thresholds, individual Blood Mirror effects within the approved node roles, exact Relic-to-source sequencing, UI polish, and playtest tuning.

The next top-level scope dependency is **narrative delivery and campaign presentation**, as tracked in `docs/_meta/OPEN_QUESTIONS.md`.
