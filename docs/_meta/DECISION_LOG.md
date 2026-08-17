---
id: META-DECISION-LOG
title: Decision Log
category: meta
status: approved
authority: summary
last_reviewed: 2026-08-17
topics:
  - decisions
  - design-history
---

# Decision Log

Concise index of major approved directions that materially changed Oathbound's game shape. Detailed iteration remains recoverable through Git history; current authoritative files always override this history.

## 2026-08-17 — Keeper and Twin Maws current-run Boss Rewards locked

Keeper of the Gate and Twin Maws now use the same separate **three-card current-run Boss Reward** after victory. Persistent Mist/material payouts and automatic regional-transition recovery remain separate.

The player chooses exactly one of:

- a guaranteed **Premium Technique** card using the normal three-choice Technique screen with regional-boss source quality,
- a guaranteed **Enhanced Capacity** card, rolling Health or Spirit at 50/50,
- a generated **Flex** card: **30% eligible Relic / 35% Premium Technique / 20% opposite Enhanced Capacity / 15% +2 Technique rerolls**, with unavailable Relic weight redistributed.

Enhanced Capacity uses the existing Treasure-tier values: **+20% starting max Health** or **+25% starting max Spirit**, including matching current resource. Ordinary Gold, Mist, Scrolls, pure healing, consumables, and permanent upgrades are excluded from the three-card reward.

The exact cards are revealed only after the mandatory boss fight rather than previewed before entry. Keeper naturally functions as early build establishment while Twin Maws uses the same rules to refine a more mature build before Kagutsuchi.

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
