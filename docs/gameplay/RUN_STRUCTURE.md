---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-10-03
topics:
  - runs
  - first-attempt
  - death
  - returning-blood
  - successful-return
  - heart-bindings
  - campaign-clears
  - true-final-heart
  - postgame
  - strand
  - techniques
  - room-rewards
  - blood-moon
  - regional-routing
  - chamber-structure
  - branching-frequency
  - authored-encounters
  - enemy-lineage
related:
  - GAMEPLAY-FIRST-ATTEMPT
  - LORE-RETURNING-BLOOD
  - LORE-STORY-OVERVIEW
  - LORE-BARRIER-BLOOD-MOON
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-ITEMS-REWARDS
  - NARRATIVE-DELIVERY
  - OVERVIEW-ENDGAME-POSTGAME-RELEASE
  - CONTENT-ROOM-TYPES
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-AREA2-OVERVIEW
  - CONTENT-AREA3-OVERVIEW
  - CONTENT-STRAND-BLOODWELL
  - CONTENT-STRAND-BOAT
  - UI-RUN-RESULTS
---

# Run Structure

A standard post-awakening run begins after preparation and final confirmation at the Boat in the Strand. The Keeper stabilizes the controlled passage through the barrier, and the Boat carries Akio to the island.

A run ends through death, successful destruction of one Heart Binding after the Shogun, completion of the first true-final Heart route, a postgame Shogun-ending expedition, or a postgame Heart-suppression clear.

The campaign takes place beneath the Blood Moon. The game does not define how much ordinary time passes between repeated runs.

## Introductory first attempt

The first attempt is an **authored opening expedition already in progress**, not the normal repeatable 33-chamber roguelite route. `FIRST_ATTEMPT.md` owns its exact pre-awakening gameplay contract.

Before the player takes control, Akio has already reached the Strand, met its recurring NPCs, crossed onto the island, and progressed deep into the expedition as an ordinary Order swordsman with no Beast Blood.

The playable opening teaches essential combat through real gameplay and advances to the Eclipse Shogun. The first Shogun encounter is mechanically playable and should respect player performance, but its narrative outcome is fixed:

1. Akio is defeated and mortally wounded.
2. The Shogun becomes interested in the human who reached him without Beast Blood.
3. The Shogun calls a large, source-near concentration of ordinary Beast Blood from the island/Heart and forces it into Akio.
4. Akio dies.
5. Returning Blood forms and reconstructs Akio at the Strand.
6. The normal repeated-run preparation/progression loop begins.

The Shogun does not deliberately stabilize or weaken Akio's transformation. He is testing what the Blood will make of him, not intentionally creating Returning Blood.

The exact playable opening length, encounter count, and route slice are production/playtest decisions. It does **not** need to reproduce the entire normal Hushiro → Yomori → Kagutsuchi route before the scripted Shogun confrontation.

## Regional flow

After Returning Blood awakens, the intended full repeatable route is:

1. Hushiro Gate Village
2. Yomori Grove
3. Kagutsuchi Court
4. Eclipse Shogun
5. temporary access to the Heart chamber
6. one Binding completion during the first six successful post-awakening clears, the canonical true-final Heart encounter after all six Bindings are destroyed, or an approved postgame endpoint after Story Complete

All three regions have approved **prototype chamber structures**. Their chamber counts, structural bands, and the prototype branching-frequency model below are planning targets for implementation and playtesting rather than immutable final balance values. Exact standard-combat encounter scripts, encounter-pool counts, authored room-variant counts, and final tuned percentages remain later content/playable-validation work.

## Chamber and route model

A **counted chamber** is a room that represents an actual run node. Standard combat rooms, Shrine, Rest, Shop, Treasure, Miniboss, and regional Boss rooms can count as chambers. Small entrance corridors, boss exits, loading connectors, regional transition spaces, Heart approach spaces, and Binding-completion spaces do not count toward the regional chamber total.

The run uses a Hades-like chamber-routing model:

- each region has a broadly fixed chamber destination and fixed final boss,
- chamber-index bands determine which room functions and special opportunities are eligible,
- eligible room functions and rewards are selected procedurally through weighted generation,
- when a standard Combat chamber is selected, its combat content comes from the region's authored encounter pool rather than from an automatically assembled threat budget,
- hard generation safeguards prevent important opportunity types from disappearing from the full route network,
- route exits preview the upcoming room function and/or primary reward before commitment,
- one or two exits are the normal route presentation,
- branches may reconverge later,
- and there is no routine backtracking after choosing an exit.

A guaranteed **opportunity** means the generated route network contains at least one accessible offer of that type. It does not mean the player is forced to enter that room. Choosing a competing route can intentionally give up the guaranteed opportunity.

## Standard combat encounter model

A normal **encounter** is one authored Combat-room sequence from combat start until the room is cleared. The encounter definition owns the intended enemy composition, theme, counts, waves/spawn sequencing where applicable, and any encounter-specific restrictions.

Launch encounter construction follows these rules:

- each region has a finite pool of deliberately authored and playtested standard encounters,
- the route generator selects an eligible authored encounter when it creates a standard Combat chamber,
- encounters should usually center on a coherent enemy combination or tactical idea rather than being arbitrary mixes,
- there is **no required opening/main/pre-boss encounter-pool split** merely because the route itself has chamber bands,
- by default, an encounter in a regional pool may appear throughout that region,
- an individual authored encounter may later receive a minimum-chamber or other narrow eligibility requirement when its mechanics, teaching role, or difficulty clearly require one,
- regional difficulty progression comes primarily from the enemies and encounter compositions designed for that region; later regions naturally contain more demanding enemy mechanics rather than relying on automatic threat-budget inflation,
- encounter-pool size and every individual encounter script are intentionally deferred until the dedicated encounter-authoring pass.

Standard enemies are **region-native by default**. An enemy does not automatically carry forward unchanged into later regions simply because the run has progressed. When an earlier enemy concept continues, it should do so through a separately authored evolved regional variant whose behavior expresses the later area's identity rather than through simple stat inflation.

For launch, the only approved standard-enemy lineage across regions is **Blighted Hounds → Stalker Hound** in Yomori Grove. Stalker Hound is a separate Area 2 enemy built on the earlier hound family with new stalking, mist-repositioning, and pounce behavior. No other Hushiro standard enemy has an approved Yomori continuation, and no earlier-region standard enemy or evolved continuation is currently approved for Kagutsuchi. Regional `ENEMIES.md` files own the detailed roster boundary.

## Prototype branching frequency

Branch count is rolled from the current chamber band before room/reward contents are generated:

| Chamber band | 1 exit | 2 exits | 3 exits |
|---|---:|---:|---:|
| Opening | 50% | 50% | 0% |
| Main stretch | 25% | 70% | 5% |
| Pre-boss / final stretch | 45% | 55% | 0% |

Additional route-generation safeguards:

- three-exit choices may occur only during a region's main stretch and are capped at **one per region**,
- a normal two-exit choice should present different primary reward categories rather than duplicate the same choice,
- no region main stretch should generate more than two consecutive ordinary forced one-exit chambers,
- ordinary routing should not place two safe service rooms such as Rest and Shop back-to-back,
- a miniboss route must compete against at least one non-miniboss route,
- if a guaranteed regional opportunity has not appeared by the end of its valid window, generation forces it into an upcoming eligible branch,
- and pre-boss preparation safeguards override ordinary weights when needed.

Across the 33-chamber regional route, the current prototype target is roughly **17–19 multi-exit routing decisions** on a normal successful run. This is a pacing target rather than a hard per-run quota.

`ITEMS_AND_REWARDS.md` owns prototype room-type weights, standard-combat reward weights, Gold/Shop values, recovery/capacity values, and expected reward cadence. Final values remain subject to playtesting.

## Area 1 — Hushiro Gate Village prototype structure

Hushiro uses **12 counted chambers**, including Keeper of the Gate at Chamber 12. The current active-time target is approximately **14–16 minutes**.

### Chambers 1–3 — Opening stretch

- **Chamber 1 is fixed:** a standard combat encounter followed by a guaranteed Technique reward.
- Chambers 2–3 introduce the normal previewed route-choice structure.
- Chamber 1's authored encounter should function as an accessible opening combat test; further encounter-specific early gating is assigned only during encounter authoring when needed.
- Hushiro's build purpose is to establish the first **Action Technique** modifications and the first recognizable family/build direction, not to finish the build.

### Chambers 4–8 — Main stretch

The complete normal Hushiro room/reward pool is eligible here. Combat remains the majority experience, while route choices may lead toward Technique, Gold, Mist, Scrolls, Shrine, Rest, Shop, Treasure, or Miniboss opportunities.

Hushiro's single miniboss opportunity is eligible during **Chambers 5–8**. Each run selects one candidate from:

- Village Ogre
- The Collector

The miniboss path is optional. A normal Hushiro run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 9–11 — Pre-boss stretch

- Minibosses leave the eligible pool.
- Standard Combat still draws from the authored Hushiro encounter pool; any encounter reserved for later Hushiro chambers must be explicitly tagged that way during encounter authoring rather than belonging to a mandatory separate pre-boss pool.
- No new major system is introduced here; the purpose is to consolidate the current build and prepare for Keeper.
- **Chamber 11 guarantees a meaningful pre-boss support opportunity in the available route**, such as Rest, Shop, or another approved high-value preparation choice. This does not require a free full heal.

### Chamber 12 — Keeper of the Gate

Keeper is fixed at Chamber 12 and ends Hushiro. All routes converge on the old gate boss encounter.

### Hushiro route-network safeguards

Before Keeper, the generated route network must contain at least:

- **1 Shrine opportunity**,
- **1 Shop opportunity**,
- **1 Rest opportunity**,
- **1 optional miniboss opportunity**,
- **3 Technique-reward opportunities total**, including the fixed Chamber 1 Technique reward.

These are network opportunities rather than mandatory visits.

## Area 2 — Yomori Grove prototype structure

Yomori uses **10 counted chambers**, including Twin Maws at Chamber 10. The current active-time target is approximately **12–14 minutes**.

Yomori is intentionally shorter than Hushiro because its normal enemies, minibosses, and paired regional boss are mechanically more complex.

### Chambers 1–2 — Opening stretch

- Branching begins immediately.
- There is no fixed guaranteed Technique reward on Yomori Chamber 1; the player already enters with an established run build.
- Standard Combat draws from the authored Yomori encounter pool. Any encounter that must be delayed until later chambers receives an explicit encounter-level eligibility requirement during authoring rather than relying on a universal opening encounter tier.

### Chambers 3–7 — Main stretch

The main Yomori room/reward pool is active here. Area 2's build purpose is to add or deepen useful **Action Techniques** while expanding the existing build through Supporting Techniques, refinements, Cross-family eligibility, continued Aspect progression after awakening, and other reward choices. Multiple Action Techniques may modify or respond to the same combat trigger under the current Technique rules.

Yomori's single miniboss opportunity is eligible during **Chambers 4–7**. Each run selects one candidate from:

- The Embered Pilgrim
- Rotwood Host

The miniboss path is optional. A normal Yomori run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 8–9 — Pre-boss stretch

- Minibosses leave the eligible pool.
- Standard Combat continues using eligible authored Yomori encounters rather than switching to a separate mandatory late-region encounter pool.
- At least one available route across Chambers 8–9 should provide meaningful pre-boss preparation without making full recovery automatic.
- The stretch should feel like convergence toward the grove's heart rather than the introduction of another system.

### Chamber 10 — Twin Maws

Twin Maws — Rootfang and Briarthorn are fixed at Chamber 10 and end Yomori. All routes converge on the paired boss encounter.

### Yomori route-network safeguards

Before Twin Maws, the generated route network must contain at least:

- **1 Shrine opportunity**,
- **1 Shop opportunity**,
- **1 Rest opportunity**,
- **1 optional miniboss opportunity**,
- **2 Technique-reward opportunities**.

These are network opportunities rather than mandatory visits. Treasure remains an eligible high-value route rather than a guaranteed regional service.

## Area 3 — Kagutsuchi Court prototype structure

Kagutsuchi uses **11 counted chambers**, including the Eclipse Shogun at Chamber 11. The current active-time target is approximately **15–17 minutes**.

Kagutsuchi is the mature-build region. Its standard enemies are inherently more demanding because Court enemies combine revival, ranged ritual pressure, directional defense, spawning, frenzy, and more disciplined coordinated behavior.

### Chambers 1–2 — Court entrance

- Branching begins immediately.
- There is no fixed opening Technique reward; the player enters with an established build from Hushiro and Yomori.
- Standard Combat draws from the authored Kagutsuchi encounter pool. Encounter-specific minimum-chamber restrictions may be added later when a particular composition needs them.
- Kagutsuchi should become dangerous immediately through enemy behavior and composition rather than simple Health inflation.

### Chambers 3–7 — Main Court

The complete normal Kagutsuchi room/reward pool is eligible here. The region's build purpose is to **finish or sharpen the mature run build** through additional Action Techniques, Supporting Techniques, refinements, Cross-family Techniques, eligible Legendaries, continued Shrine decisions after awakening, and competing economy/survival rewards.

Kagutsuchi's single miniboss opportunity is eligible during **Chambers 4–7**. Each run selects one candidate from:

- Blood Lotus
- Eternal Swordsman

The miniboss path is optional. A normal Kagutsuchi run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 8–10 — Final Court / Shogun approach

- Minibosses leave the eligible pool.
- Standard Combat continues using eligible authored Court encounters rather than a separate mandatory final encounter tier; the environment and chosen encounter compositions should still support the approach to the Shogun.
- No new run-build system is introduced here; the purpose is final build decisions and preparation for the Shogun.
- Across **Chambers 9–10**, the generated route must expose at least one meaningful final-preparation opportunity such as Rest, Shop, Technique, Treasure, or another approved high-value preparation choice.
- This safeguard does not guarantee a full heal or automatic ideal build.

### Chamber 11 — Eclipse Shogun

The Eclipse Shogun is fixed at Chamber 11 and completes the normal post-awakening three-region combat route. All Kagutsuchi routes converge on his royal arena.

The Shogun must test a mature run build without assuming a specific Aspect Tier, Blood Art, Technique family, Legendary, Relic, Prosthetic upgrade level, or exact reward history.

This repeatable Chamber 11 confrontation is distinct from the authored opening first-attempt Shogun encounter that creates Returning Blood.

### Kagutsuchi route-network safeguards

Before the Shogun, the generated route network must contain at least:

- **1 Shrine opportunity**,
- **1 Shop opportunity**,
- **1 Rest opportunity**,
- **1 optional miniboss opportunity**,
- **2 Technique-reward opportunities**,
- **1 meaningful final-preparation opportunity across Chambers 9–10**.

These are network opportunities rather than mandatory visits.

## Regional boss transitions

Defeating Keeper or Twin Maws leads into a brief **safe regional transition space** that does not count as an additional chamber.

The transition should:

- grant the approved regional boss reward,
- apply the automatic recovery prototype owned by `ITEMS_AND_REWARDS.md`,
- allow concise build review and an optional **Relic swap** when the Relic system/collection is available,
- visually transition into the next region,
- and preserve run momentum rather than functioning as a second Strand or overloaded menu hub.

The current recovery prototype restores **20% max Health and 35% max Spirit**, then enforces minimum next-region entry floors of **35% max Health and 50% max Spirit**. This is viability support rather than a full reset. Blood is not automatically refilled.

The safe transition after Keeper is the normal in-run Relic swap point before Yomori. The safe transition after Twin Maws is the normal in-run Relic swap point before Kagutsuchi. Newly discovered Relics may also be equipped immediately at discovery; routine swapping is not available in combat, ordinary rooms, Rest rooms, Shops, or the pause menu.

Exact transition-interface presentation and final recovery tuning remain later implementation/playtest decisions.

## Post-Shogun handoff

The Eclipse Shogun does **not** lead to another counted regional transition chamber.

### Awakened campaign clears 1–6

**Shogun → Heart approach → Binding ritual → destroy exactly one remaining Binding → run ends → return to Strand.**

The Heart is not fought normally during these six Binding clears.

### First true-final Heart clear

After all six Bindings have been destroyed:

**Shogun → Heart approach → canonical Heart encounter → Heart source crippled → Story Complete → return to Strand.**

### Postgame Standard Expedition

**Boat selects Standard Expedition → Hushiro → Yomori → Kagutsuchi → Shogun → run ends → return to Strand.**

### Postgame Heart Suppression

**Boat selects Heart Suppression → Hushiro → Yomori → Kagutsuchi → Shogun → regenerated Heart manifestation → suppression clear → return to Strand.**

## Full-route pacing target

The three approved prototype region structures total **33 counted regional chambers**:

- Hushiro: 12
- Yomori: 10
- Kagutsuchi: 11

This excludes non-counted regional transitions, the Heart approach, Binding-completion spaces, and other connector scenes.

The current full successful three-region active-time target is approximately **41–47 minutes before Heart/Binding resolution**, subject to playtesting. Individual chamber duration, encounter density, reward interaction time, and route-choice reading time remain tuning levers rather than reasons to change the locked prototype chamber structure casually.
