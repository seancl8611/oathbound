---
id: META-CHANGELOG
title: Documentation Changelog
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - changelog
  - documentation-history
---

# Documentation Changelog

This is a concise record of major documentation passes. Detailed file-level history remains available through Git commits and merged pull requests.

## 2026-08-17 — Persistent resources, boss materials, and repository tightening

- Removed the generic **Boss Emblem** currency from current design.
- Locked Mist/Scroll persistent payout targets by region, Treasure, miniboss, and regional boss source.
- Set ordinary enemy/breakable Mist/Scroll random drops to zero for the first prototype.
- Locked persistent rewards as saved when earned with no death tax or success-only banking requirement.
- Added three unique low-count regional boss-material families: one each for Keeper, Twin Maws, and Eclipse Shogun; exactly one material drops per boss kill.
- Defined boss materials as secondary requirements for a small number of major permanent upgrades, generally using quantities of 1–3; exact player-facing names remain deferred.
- Locked the first Prosthetic Scroll cost curve at 2 / 4 / 6 sequential Scrolls, 66 total across the current 19 upgrades.
- Added Mist cost calibration bands for later permanent-tree authoring.
- Updated boss encounter docs, reward art, results presentation, Full Game Scope, roadmap, gameplay index, terminology, source-of-truth ownership, and progression/reward authorities.
- Reduced duplicated live rules in `PROGRESSION.md`, `FULL_GAME_SCOPE.md`, and other summaries.
- Rebuilt `OPEN_QUESTIONS.md` as an unresolved-only agenda instead of a duplicate approved-design database.
- Tightened `ASSISTANT_WORKFLOW.md`, `DOCUMENT_MAP.md`, and `UPDATE_PROTOCOL.md` with an explicit direct-read fallback for unavailable GitHub code search.
- Condensed Decision Log / Changelog so detailed iteration remains in Git rather than live design summaries.
- Advanced the next full-run dependency to regional-boss current-run rewards and Relic acquisition / limited swap placement.

## 2026-08-16 — Full-route generation, Technique offers, economy, and survival

- Locked the complete **33-chamber** regional route: 12 Hushiro / 10 Yomori / 11 Kagutsuchi.
- Locked one optional miniboss opportunity per region and pre-boss preparation safeguards.
- Added first branching probabilities, room-type weights, regional standard-Combat reward weights, and route fairness safeguards.
- Added the first three-choice Technique offer generator with regional/source rarity weighting and replacement/refinement/Cross-family/Legendary rules.
- Added Gold/Shop prototype: 60/70/80 regional Gold rewards, three-item Shops, stable prices, Technique/Relic purchase anchors, dead-late-Gold suppression.
- Added survival/recovery/capacity prototype and regional transition / Shogun-to-Heart recovery floors.
- Updated dependent regional, UI, scope, roadmap, and history docs for consistency.

## 2026-08-16 — Permanent progression architecture

- Locked three permanent upgrade stations:
  - Bloodwell → Akio + Run Infrastructure,
  - Forge Bench → Prosthetics + Relics,
  - later-unlocked Blood Mirror → Blood Aspects.
- Removed the separate Relic Reliquary, old generic weapon-development Forge, and fixed Bloodwell three-branch structure from live scope.
- Defined Run Infrastructure as one umbrella rather than multiple permanent room/reward trees.

## 2026-08-15 — Relic mastery and Prosthetic Forge progression

- Locked kill-earned persistent Relic mastery for the equipped Relic.
- Locked eight shallow linear Prosthetic paths with 19 total upgrades.
- Kept Scrolls as the primary Prosthetic Forge currency.
- Removed Prosthetic Techniques from the run-build system.

## 2026-08-14 — Launch Technique and Relic rosters

- Locked 50 actual Techniques + 10 refinements and their rarity/prerequisite structure.
- Locked 10 Relics, one equipped slot, persistent collection/mastery/progression, and no Relic rarity tiers.

## 2026-08-12 to 2026-08-13 — Crimson redesign and direct Technique matrix

- Superseded Crimson Burst with universal genuine backstabs plus Crimson Vulnerable/direct-Health specialization.
- Completed the 25-Technique direct five-by-five matrix.

## 2026-08-09 to 2026-08-11 — Technique architecture rebuild

- Replaced the four-active-plus-reserve Technique model with five direct action slots plus slotless supporting growth.
- Stabilized Echo, Rupture, Seal, Rift, and later Crimson family identities.
- Removed Prosthetic Techniques and moved tool progression fully to the persistent Forge.

## 2026-08-05 to 2026-08-07 — Blood Aspect packages completed

- Completed qualitative Tier 0–IV packages for Wolf, Wraith, and Ronin.

## 2026-07-20 to 2026-07-22 — Campaign/run structure

- Locked six player Heart Binding clears followed by the seventh true-final Heart story run.
- Locked the approximately 45–50-minute normal successful-run target.

## 2026-07-10 to 2026-07-11 — Project architecture

- Established seven production milestones plus paid Style Test.
- Established version-controlled Markdown authorities and documentation workflow.
- Replaced the old stance/alternate-weapon direction with Blood Aspects as the central run weapon identities.
