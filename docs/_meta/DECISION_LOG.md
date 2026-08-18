---
id: META-DECISION-LOG
title: Decision Log
category: meta
status: approved
authority: summary
last_reviewed: 2026-08-18
topics:
  - decisions
  - design-history
---

# Decision Log

Concise index of major approved directions that materially changed Oathbound's game shape. Detailed iteration remains recoverable through Git history; current authoritative files always override this history.

## 2026-08-18 — Silent protagonist, unscripted first attempt, and launch narrative delivery locked

Akio is now explicitly a **fully silent protagonist**. He has no spoken dialogue, written responses, dialogue choices, internal monologue, or narrated thoughts. NPCs, intelligent enemies, minibosses, and bosses may speak; Akio communicates through action, stillness, physical reaction, and continued opposition.

The first attempt is **not a scripted prologue route**. The player begins directly in the normal Hushiro route and may progress through the complete 12 / 10 / 11 regional structure using normal routing, authored encounters, Technique rewards, Rest/Shop/Treasure/miniboss flow, persistent rewards, and other eligible run systems.

Pre-awakening loadout/rules:

- base katana core kit,
- **Beast-Bane Whistle** as the default starting Prosthetic,
- ordinary Technique rewards remain available and modify the base-katana action tags,
- Shrines remain valid rooms and use their no-Aspect/below-full support result,
- Blood Aspects, Corruption/Tier growth, Blood, Blood Arts, Relic loadout, and permanent upgrades are not active yet.

The first death is not forced at any normal-route enemy or chamber. A mastery-level player may theoretically defeat Keeper, Twin Maws, and the Eclipse Shogun and reach the Heart before dying. Without awakened Returning Blood the player cannot break a Binding; Heart contact becomes the exceptional first-death/awakening endpoint, and the normal six-Binding campaign begins afterward with no Binding progress skipped.

Launch narrative delivery is now scoped at production-planning depth:

- approximately **5 major controlled in-engine sequences**,
- **7 awakened Shogun confrontation states + 1 rare pre-awakening fallback**,
- bloodline recognition/recruitment at the third awakened Shogun confrontation,
- **6 visual/campaign states of one reusable Binding ritual**,
- approximately **30–36 major Strand conversations**,
- approximately **4–6 short reactive line sets per Strand NPC**,
- approximately **20–25 substantive Lore / Records entries** beyond normal gameplay codex descriptions,
- one final pre-Heart state/conversation for each Strand NPC,
- approximately **15,000–20,000 narrative words**,
- text-led dialogue with **no full spoken-dialogue VO requirement**.

Mandatory story information is communicated directly; the Discovery Board owns optional depth. The Heart does not speak. The ending remains action-led: destroying the Heart ends Returning Blood, stops Shogun reconstruction, and leaves Akio mortal and silent.

This closes narrative-delivery scope and advances the remaining top-level question to endgame/postgame/release scope.

**Authority:** `docs/gameplay/FIRST_ATTEMPT.md`, `docs/narrative/NARRATIVE_DELIVERY.md`, `docs/characters/AKIO.md`, `docs/lore/RETURNING_BLOOD.md`, `docs/lore/ECLIPSE_SHOGUN.md`.

## 2026-08-17 — Launch permanent-progression content package locked

Permanent progression remains deliberately compact and execution-supportive rather than becoming another oversized power tree.

Approved launch content volume:

- **10 Akio Bloodwell nodes**: 3 foundation, 4 combat-stability, 3 regional mastery,
- **8 Run Infrastructure nodes**,
- **3 Blood Mirror nodes per Aspect / 9 total**, using Tier 0 Handling → Signature Reliability → Blood Discipline roles,
- **2 Relic mastery ranks per Relic** after Base, creating 20 mastery milestones across the 10-Relic roster,
- existing **19 Prosthetic upgrades** remain unchanged,
- exactly **6 regional-boss-material-gated Bloodwell nodes**: one Akio mastery node and one Infrastructure passage node per regional boss material.

Campaign cadence is staged:

- first return opens the Bloodwell foundation,
- first Keeper opens the next Bloodwell band and Blood Mirror Node 1,
- first Twin Maws opens the next band and Blood Mirror Node 2,
- first Shogun / first Binding clear opens the final boss-material gates and Blood Mirror Node 3.

All foundational permanent systems are therefore structurally available after the first Binding clear. Later Binding clears focus on completion/mastery rather than introducing additional meta trees.

Relic mastery is earned through eligible kills while equipped and normally spends no Mist, Scrolls, boss material, duplicate Relic, or separate mastery currency. Normal Prosthetic ranks, Relic mastery, and Blood Mirror nodes do not use regional boss materials at launch.

Exact numerical values, Mist prices, mastery kill thresholds, and individual Blood Mirror effect values remain later tuning.

**Authority:** `docs/gameplay/PROGRESSION.md`, `docs/gameplay/RELICS.md`, Strand Bloodwell/Forge authorities, `docs/gameplay/BLOOD_CAVERN_TRIALS.md`.

## 2026-08-17 — Regional enemy lineage rule restored from production bible

Standard enemies are **region-native by default** rather than automatically carrying forward unchanged as the run progresses. When an earlier enemy concept continues into a later region, it does so through a deliberately authored evolved regional variant whose new behavior expresses the later area's identity instead of through simple Health/damage scaling.

The only approved launch lineage currently defined is **Blighted Hounds → Stalker Hound** in Yomori Grove. Stalker Hound is a separate Area 2 elite predator that retains recognizable hound-family foundations while adding stalking, mist repositioning, and pounce timing. No other Hushiro enemy has an approved Yomori continuation, and Kagutsuchi's five standard enemies remain a fully native Court roster with no approved earlier-region continuation.

This resolves the cross-region availability question without inventing a 15-enemy reuse matrix. Detailed standard-encounter authoring remains deferred until encounter production.

**Authority:** regional `docs/content/area_*/ENEMIES.md`, `docs/gameplay/RUN_STRUCTURE.md`.

## 2026-08-17 — Authored standard-encounter model locked

Standard Combat rooms use **deliberately authored encounter scripts**, not procedurally assembled enemy threat budgets. One encounter is one Combat-room sequence from combat start until room completion and owns its intended enemy composition/theme plus counts, waves, or spawn sequencing where applicable.

Each region will have a finite authored encounter pool. When the route generates a standard Combat chamber, it selects an eligible encounter from that regional pool.

The route's opening/main/pre-boss bands do **not** create a mandatory three-tier encounter-pool structure. By default, an authored encounter may appear throughout its region; an individual encounter may later receive a minimum-chamber or narrow eligibility rule when its teaching role or difficulty clearly requires one.

Regional escalation comes primarily from the enemies and encounter compositions authored for later regions rather than automatic threat-budget inflation. Encounter counts and every individual script are deferred until encounter production.

**Authority:** `docs/gameplay/RUN_STRUCTURE.md`, regional `docs/content/area_*/ENEMIES.md`.

## 2026-08-17 — Launch consumables cut; remaining design refocused on scope closure

Oathbound does **not** include a general run-consumable inventory or one-use item reward layer at launch. Shops, Treasure, recovery/capacity, Technique rerolls, Techniques, Relics, and Prosthetics already cover the intended tactical/reward roles without another inventory/UI subsystem.

The remaining design sequence was refocused away from isolated minor questions and toward connected launch-scope passes.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`, `docs/gameplay/PROGRESSION.md`, `docs/_meta/OPEN_QUESTIONS.md`.

## 2026-08-17 — Relic acquisition and in-run swapping locked

All **10 launch Relics are obtainable before the canonical story ending**. Acquisition uses a fixed launch allocation:

- **4** guaranteed campaign / Strand unlocks through NPC progression, discoveries, or campaign milestones,
- **2** Blood Cavern / challenge unlocks,
- **4** run-discovered Relics through approved Relic opportunities such as Treasure, Keeper/Twin Maws Boss Reward Flex cards, and occasional Shop Flex slots.

Until the collection is complete, eligible discoveries prioritize undiscovered Relics rather than duplicates. A newly discovered Relic is permanently added immediately; the player may equip it now or keep the current Relic without forfeiting the discovery.

Normal Relic swaps are limited to the **Forge before a run**, the safe transition **after Keeper**, and the safe transition **after Twin Maws**. A new discovery itself is also a one-time equip opportunity. Rest rooms, Shops, ordinary rooms, combat, and the pause menu do not provide routine swapping.

Only the currently equipped Relic earns future mastery kills; previously earned mastery remains permanent when swapping.

**Authority:** `docs/gameplay/RELICS.md`, `docs/gameplay/ITEMS_AND_REWARDS.md`.

## 2026-08-17 — Keeper and Twin Maws current-run Boss Rewards locked

Keeper of the Gate and Twin Maws use the same separate **three-card current-run Boss Reward** after victory. Persistent Mist/material payouts and automatic regional-transition recovery remain separate.

The player chooses exactly one of:

- a guaranteed **Premium Technique** card using the normal three-choice Technique screen with regional-boss source quality,
- a guaranteed **Enhanced Capacity** card, rolling Health or Spirit at 50/50,
- a generated **Flex** card: **30% eligible Relic / 35% Premium Technique / 20% opposite Enhanced Capacity / 15% +2 Technique rerolls**, with unavailable Relic weight redistributed.

Enhanced Capacity uses the existing Treasure-tier values: **+20% starting max Health** or **+25% starting max Spirit**, including matching current resource. Ordinary Gold, Mist, Scrolls, pure healing, and permanent upgrades are excluded from the three-card reward.

The exact cards are revealed only after the mandatory boss fight rather than previewed before entry.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`.

## 2026-08-17 — Persistent-resource economy and regional boss materials locked

Oathbound's general currencies are **Mist, Scrolls, and run-only Gold**. The generic `Boss Emblem` currency is removed.

Persistent payout prototype:

- standard Mist rewards: **20 Hushiro / 25 Yomori / 30 Kagutsuchi**,
- standard Scroll rewards: **1 / 1 / 2**,
- Treasure persistent bundles: **50/60/75 Mist** or **2/2/3 Scrolls**,
- every miniboss defeated: **+10 Mist +1 Scroll** in addition to its primary reward,
- Keeper / Twin Maws / Shogun: **+10 / +15 / +25 Mist**.

Ordinary enemies and breakables do not randomly drop Mist/Scrolls in the first prototype. Persistent resources are saved when earned with no death tax or success-only banking requirement.

Each regional boss also drops exactly **1 unique low-count permanent boss material per kill**. Keeper, Twin Maws, and Shogun each have one material family; exact player-facing names remain deferred. Materials are used sparingly as secondary requirements on selected major permanent upgrades, normally in quantities of **1–3**, rather than as general currency or miniboss crafting drops.

Working Prosthetic Scroll costs are **2 / 4 / 6** for sequential upgrades, totaling **66 Scrolls** across the current 19-upgrade roster. Mist cost bands remain calibration targets until permanent trees are authored.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`, `docs/gameplay/PROGRESSION.md`.

## 2026-08-16 — Route generation, Technique offers, Gold economy, and survival prototype locked

The 33-chamber route received its first controlled-generation model:

- band-based branch probabilities,
- combat-dominant room weights,
- regional standard-Combat reward weights,
- roughly 17–19 multi-exit decisions and 20–22 standard Combat rooms per successful route.

Technique rewards use three-choice screens with eligibility-first construction, build-stage Direct/flex requirements, regional/source rarity weighting, and explicit refinement/replacement/Cross-family/Legendary limits.

Gold/Shop prototype uses 60/70/80 Gold primary rewards, three-item Shops, stable prices, no Shop-inventory reroll, and dead-late-Gold suppression.

Survival prototype defines standard/Rest/Shop/Shrine/Treasure recovery, temporary capacity, regional transition floors, and the Shogun→Heart partial recovery handoff.

**Authority:** `RUN_STRUCTURE.md`, `TECHNIQUES.md`, `ITEMS_AND_REWARDS.md`.

## 2026-08-16 — Complete three-region route structure locked

- **Hushiro:** 12 counted chambers; Keeper at 12; ~14–16 min.
- **Yomori:** 10; Twin Maws at 10; ~12–14 min.
- **Kagutsuchi:** 11; Shogun at 11; ~15–17 min.

Each region generates one optional miniboss opportunity from two authored candidates. Heart approach, Binding spaces, and the true-final Heart sit outside the 33 counted regional chambers.

**Authority:** `RUN_STRUCTURE.md`, regional overview files.

## 2026-08-16 — Permanent progression station architecture locked

Exactly three permanent upgrade stations:

- **Bloodwell → Akio + Run Infrastructure**,
- **Forge Bench → Prosthetics + Relics**,
- **Blood Mirror → Blood Aspects**, unlocked later.

Run Infrastructure is one umbrella rather than separate Rest/Shrine/route/reward trees. The old generic weapon-development Forge, fixed Bloodwell three-branch tree, and separate Relic Reliquary are superseded.

**Authority:** `PROGRESSION.md`, Strand interactible files.

## 2026-08-15 — Prosthetic progression and Relic mastery locked

Relics gain persistent individual mastery from eligible kills while equipped. The Forge owns Relic progression/management.

Eight Prosthetics use shallow linear paths with **19 total approved upgrades**; a base tool is complete when unlocked and upgrades strengthen its existing role only.

**Authority:** `RELICS.md`, `PROSTHETICS.md`, `PROGRESSION.md`.

## 2026-08-14 — Technique and Relic launch rosters locked

Technique roster: **50 actual Techniques + 10 refinements**:

- 25 direct,
- 15 Supporting,
- 5 Cross-family,
- 5 Legendary.

Rarity distribution: **10 Common / 18 Uncommon / 17 Rare / 5 Legendary**. Direct, Supporting, Cross-family, Legendary, and refinement eligibility rules are approved.

Relics: **10 launch Relics**, one equipped slot, persistent collection/mastery/progression, no rarity tiers.

**Authority:** `TECHNIQUES.md`, `TECHNIQUE_CATALOG.md`, `RELICS.md`.

## 2026-08-12 to 2026-08-13 — Crimson and direct Technique matrix locked

Backstab became a universal genuine rear-hit classification. Crimson was rebuilt around **Vulnerable**, backstab specialization, and direct Health damage, superseding Crimson Burst.

All 25 direct Techniques across Echo, Rupture, Seal, Rift, and Crimson were then locked at qualitative paper-design depth.

**Authority:** `COMBAT.md`, `TECHNIQUES.md`, `TECHNIQUE_CATALOG.md`.

## 2026-08-09 to 2026-08-11 — Technique architecture and family mechanics rebuilt

The original four-active-plus-reserve model was replaced by five action-specific direct slots plus slotless supporting growth.

Core family identities stabilized around:

- Echo — delayed additional slashes,
- Rupture — posture buildup/proc,
- Seal — progressive movement restriction into Bind,
- Rift — short-fuse direct Health fracture,
- Crimson — later finalized as Vulnerable/backstab/direct Health.

Prosthetic Techniques were removed from the run-build system.

**Authority:** `TECHNIQUES.md`, `TECHNIQUE_CATALOG.md`.

## 2026-08-05 to 2026-08-07 — Launch Blood Aspect packages completed

Wolf, Wraith, and Ronin each reached complete qualitative Tier 0–IV paper-design scope. Their central identities are close-pressure/pursuit, spectral reach/control, and heavy impact/stability respectively.

**Authority:** individual Aspect files + `BLOOD_ASPECTS.md`.

## 2026-07-20 to 2026-07-22 — Heart Binding campaign and run duration locked

The Court historically destroyed one of seven Heart Bindings. Akio destroys the remaining six across six successful Binding runs. The seventh successful story run continues from Shogun into the two-form Heart; first Heart victory canonically ends the story while the save remains playable.

Normal successful Binding runs target roughly **45–50 active minutes**.

**Authority:** `RUN_STRUCTURE.md`, story/Heart authorities.

## 2026-07-11 — Blood Aspects replaced the stance/weapon-development direction

Wolf, Wraith, and Ronin replaced the old Storm/Frost/Ember/Hex/Shadow stance concept as run weapon identities. The prior generic alternate-weapon development direction is no longer current.

## 2026-07-10 — Production/documentation architecture established

Seven production milestones plus a paid Style Test were established, along with version-controlled Markdown authorities, stable document IDs, update protocol, and source-of-truth ownership.
