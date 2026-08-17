---
id: CONTENT-STRAND-FORGE-BENCH
title: Forge Bench
category: content
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - strand
  - forge
  - prosthetics
  - relics
  - permanent-upgrades
  - scrolls
  - boss-materials
related:
  - CONTENT-STRAND-INTERACTIBLES
  - CHAR-STRAND-SMITH
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-RELICS
  - GAMEPLAY-ITEMS-REWARDS
---

# Forge Bench

## Strand function

The Forge Bench is the Strand's shared permanent progression / management station for **Prosthetics and Relics**.

It does not own generic weapon development; Blood Aspects are Akio's run weapon identities.

## Lore / visual role

The Smith's open-sided cliff forge turns salvaged fragments, blood-tempered steel, damaged ritual tools, and dangerous recovered artifacts into reliable equipment.

Visual language: ember glow, worked metal, soot, tongs, mounted tools, artifact trays, practical repair surfaces, and restrained heat shimmer.

## Prosthetic progression

The Forge owns all eight Prosthetic permanent paths.

- A base Prosthetic is complete when unlocked.
- Paths are shallow and linear.
- Two upgrades are the default; selected tools have a third where an existing property justifies it.
- Upgrades strengthen the existing tactical role rather than adding alternate movesets or another Technique layer.
- **Scrolls** are the primary Prosthetic currency.

First prototype Scroll costs:

- first upgrade: **2 Scrolls**,
- second upgrade: **4 Scrolls**,
- third upgrade where present: **6 Scrolls**.

The current 19-upgrade roster therefore costs **66 Scrolls** to fully purchase at prototype values. Final cost tuning may change after playtesting.

Exact tool effects remain owned by `PROSTHETICS.md`.

## Relic progression

The Forge also owns permanent Relic collection/progression and Strand-side equipment management.

- one Relic equipped at a time,
- collection persists,
- only the equipped Relic gains eligible kill mastery,
- mastery persists,
- the Forge is the normal place to choose the Relic equipped when a run begins,
- sharing the Forge does not force Relics to use Prosthetic progression or Scroll costs.

During a run, normal Relic swaps are limited to the safe transitions after Keeper and Twin Maws; a newly discovered Relic also creates an immediate one-time equip-or-keep decision. The Forge does not need to reproduce those run-transition interfaces.

Exact Relic rank realization, thresholds, and costs if any remain later design.

No separate Relic Reliquary is required.

## Regional boss materials

Regional boss materials may be used only when an explicitly approved major Forge upgrade or Relic progression gate calls for one.

They are **not** a routine Forge currency and are not automatically required by Prosthetic upgrades merely because the Forge handles physical equipment.

If a later major Forge gate uses one, it should require a small quantity—normally 1–3—alongside the owning system's normal progression requirement.

## Screen behavior

Two clear categories:

1. **Prosthetics** — selection, owned state, linear upgrade path, Scroll costs.
2. **Relics** — collection, equipped item, mastery/progression state, permanent management.

Do not imply generic weapons, sockets, branching weapon classes, or identical Prosthetic/Relic progression rules.

## Resource ownership

- Scrolls → primary Prosthetic progression.
- Relic mastery → persistent progress, not currency.
- Regional boss materials → only explicitly assigned rare major gates.
- Gold → run-only, not normal Forge currency.
- Generic Boss Emblems → not current design.

## Technical / production notes

- Prosthetic and Relic categories must remain visually distinct.
- Support the approved 2 / 4 / 6 Scroll cost curve without hard-coding it as unchangeable final balance.
- Support occasional specific boss-material requirements without presenting a large crafting inventory.
- Support pre-run Relic selection from the persistent collection.
- Future content should remain within the two approved Forge categories unless scope is explicitly reopened.
