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

## 2026-08-18 — Heart suppression ending, canonical postgame, and launch release package locked

The first true-final Heart victory no longer destroys all Beast Blood or makes Akio mortal.

Akio destroys the Heart's manifested combat body and permanently cripples the ancient source so it can **never again produce, release, or spread new Beast Blood**. No new bearer can ever be created, extraction is permanently ended, and the Shogun's mainland expansion plan is defeated.

Existing Beast Blood remains active. Akio retains Returning Blood/reconstruction; the Eclipse Shogun and other existing bearers retain their established regeneration and supernatural sustain. The Heart survives as a faint regenerating remnant that can regrow a local combat manifestation but can never recover its lost propagation ability.

Postgame is therefore canonical continued containment rather than a non-canonical reset. The Boat offers:

- **Standard Expedition** — normal route ending after the Shogun,
- **Heart Suppression** — continues from Shogun into the regenerated Heart manifestation.

Postgame adds no new currency or permanent tree. Completion uses existing systems: Bloodwell, Blood Mirror, Prosthetics, Relics/mastery, Technique/refinement discovery, trials, Discovery Board, and Heart victory with Wolf/Wraith/Ronin.

Launch also locks:

- approximately **30 achievements**,
- **3 save slots**,
- front-end/settings/accessibility/localization/credits requirements,
- English as required launch language with localization-ready text systems,
- no required launch Heat/Pact system, New Game+, endless mode, daily challenge, postgame enemy/room variant package, fourth Aspect, second campaign, new meta tree, or new persistent currency.

This closes **top-level launch architecture at paper-design depth**. The active design sequence now moves to authored standard encounters, miniboss/boss/Heart encounter design, exact content realization, and playable tuning.

**Authority:** `docs/overview/ENDGAME_POSTGAME_RELEASE.md`, `docs/lore/BEAST_BLOOD.md`, `docs/lore/RETURNING_BLOOD.md`, `docs/lore/ECLIPSE_SHOGUN.md`, `docs/lore/STORY_OVERVIEW.md`, `docs/gameplay/RUN_STRUCTURE.md`, `docs/content/area_3/TRUE_FINAL_HEART.md`.

## 2026-08-18 — Silent protagonist, unscripted first attempt, and launch narrative delivery locked

Akio became explicitly a **fully silent protagonist**: no spoken dialogue, written responses, dialogue choices, internal monologue, or narrated thoughts.

The first attempt became the normal full route rather than a scripted prologue. Pre-awakening uses base katana + Beast-Bane Whistle, ordinary Technique/reward/room flow, and Shrine support, while Blood Aspect/Corruption/Tier/Blood-Art/Relic/permanent-upgrade systems remain inactive.

The first death is not forced at a specific enemy or room. An exceptional player may reach the Heart before first death; no Binding can be broken until Returning Blood awakens.

Narrative production scope locked at approximately:

- 5 major controlled in-engine sequences,
- 7 awakened Shogun states + 1 rare pre-awakening fallback,
- 6 states of one reusable Binding ritual,
- 30–36 major Strand conversations,
- 4–6 reactive line sets per Strand NPC,
- 20–25 substantive Lore / Records entries,
- 15,000–20,000 narrative words,
- no full spoken-dialogue VO requirement.

The mortality/Heart-destruction ending described at this stage was superseded later on 2026-08-18 by the approved Heart-suppression/postgame decision above.

**Authority:** `docs/gameplay/FIRST_ATTEMPT.md`, `docs/narrative/NARRATIVE_DELIVERY.md`, `docs/characters/AKIO.md`.

## 2026-08-17 — Launch permanent-progression content package locked

Approved launch content volume:

- 10 Akio Bloodwell nodes,
- 8 Run Infrastructure nodes,
- 9 Blood Mirror nodes,
- 2 Relic mastery ranks per Relic / 20 milestones,
- 19 Prosthetic upgrades,
- exactly 6 boss-material-gated Bloodwell nodes.

All foundational permanent systems are structurally available after the first Binding clear; later clears focus on completion/mastery.

**Authority:** `docs/gameplay/PROGRESSION.md`, `docs/gameplay/RELICS.md`, Strand Bloodwell/Forge authorities.

## 2026-08-17 — Regional enemy lineage rule restored from production bible

Standard enemies are region-native by default. Cross-region continuation requires a deliberately authored evolved regional variant rather than unchanged reuse/stat scaling.

Only approved launch lineage: **Blighted Hounds → Stalker Hound** in Yomori. No other Hushiro continuation and no Kagutsuchi continuation is approved.

**Authority:** regional `docs/content/area_*/ENEMIES.md`, `docs/gameplay/RUN_STRUCTURE.md`.

## 2026-08-17 — Authored standard-encounter model locked

Standard Combat rooms use deliberately authored encounter scripts selected from regional pools, not procedurally assembled threat budgets.

There is no mandatory opening/main/pre-boss encounter-pool split. Individual encounters may receive narrow minimum-chamber eligibility later when needed.

**Authority:** `docs/gameplay/RUN_STRUCTURE.md`, regional enemy authorities.

## 2026-08-17 — Launch consumables cut; remaining design refocused on scope closure

No general run-consumable inventory or one-use item reward layer at launch.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`, `docs/gameplay/PROGRESSION.md`.

## 2026-08-17 — Relic acquisition and in-run swapping locked

All 10 launch Relics are obtainable before the canonical ending through **4 campaign/Strand + 2 Blood Cavern/challenge + 4 run-discovered** sources.

Routine swaps are Forge pre-run, post-Keeper, post-Twin Maws, or immediate equip-or-keep on discovery. Only equipped Relic earns future mastery kills.

**Authority:** `docs/gameplay/RELICS.md`, `docs/gameplay/ITEMS_AND_REWARDS.md`.

## 2026-08-17 — Keeper and Twin Maws current-run Boss Rewards locked

Three-card current-run Boss Reward:

- Premium Technique,
- Enhanced Capacity,
- Flex card using the approved Relic/Technique/opposite-capacity/reroll mix.

Persistent Mist/material payouts and automatic transition recovery remain separate.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`.

## 2026-08-17 — Persistent-resource economy and regional boss materials locked

General resources are Mist, Scrolls, run-only Gold, and three unique low-count regional boss materials.

No generic Boss Emblem. Persistent rewards save when earned with no death tax. Boss materials are low-count secondary mastery keys.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`, `docs/gameplay/PROGRESSION.md`.

## 2026-08-16 — Route generation, Technique offers, Gold economy, and survival prototype locked

The 33-chamber route received controlled branching/room/reward weighting; Technique rewards use eligibility-first three-choice generation; Gold/Shop and recovery/capacity prototypes were established.

**Authority:** `RUN_STRUCTURE.md`, `TECHNIQUES.md`, `ITEMS_AND_REWARDS.md`.

## 2026-08-16 — Complete three-region route structure locked

- Hushiro: 12 / Keeper / ~14–16 min.
- Yomori: 10 / Twin Maws / ~12–14 min.
- Kagutsuchi: 11 / Shogun / ~15–17 min.

Heart spaces sit outside the 33 counted chambers.

## 2026-08-16 — Permanent progression station architecture locked

Exactly three permanent upgrade stations: Bloodwell, Forge Bench, Blood Mirror.

## 2026-08-15 — Prosthetic progression and Relic mastery locked

Eight Prosthetics use 19 shallow linear upgrades. Relics gain persistent use-based mastery while equipped.

## 2026-08-14 — Technique and Relic launch rosters locked

Technique roster: **50 actual Techniques + 10 refinements**. Relics: **10 launch Relics**.

## 2026-08-12 to 2026-08-13 — Crimson and direct Technique matrix locked

Backstab became a universal genuine rear-hit classification. Crimson was rebuilt around Vulnerable, backstab specialization, and direct Health damage. All 25 direct Techniques were locked qualitatively.

## 2026-08-09 to 2026-08-11 — Technique architecture and family mechanics rebuilt

Five action-specific direct slots plus slotless supporting growth replaced the prior active/reserve model. Core families stabilized as Echo, Rupture, Seal, Rift, and Crimson.

## 2026-08-05 to 2026-08-07 — Launch Blood Aspect packages completed

Wolf, Wraith, and Ronin each reached qualitative Tier 0–IV paper-design scope.

## 2026-07-20 to 2026-07-22 — Heart Binding campaign and run duration locked

One historical Binding breach leaves six for Akio. Six successful Binding clears unlock the seventh story route into the Heart. Normal successful Binding runs target roughly 45–50 active minutes.

The original assumption that first Heart victory permanently destroyed all Beast Blood was later superseded by the 2026-08-18 Heart-suppression/postgame lock.

## 2026-07-11 — Blood Aspects replaced the stance/weapon-development direction

Wolf, Wraith, and Ronin replaced the old Storm/Frost/Ember/Hex/Shadow stance concept.

## 2026-07-10 — Production/documentation architecture established

Seven production milestones plus a paid Style Test were established, along with version-controlled Markdown authorities, stable document IDs, update protocol, and source-of-truth ownership.
