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

Regional boss materials are not part of normal Prosthetic ranks in the launch package.

Exact tool effects remain owned by `PROSTHETICS.md`.

## Relic progression

The Forge also owns permanent Relic collection/progression and Strand-side equipment management.

- one Relic equipped at a time,
- collection persists,
- only the equipped Relic gains eligible kill mastery,
- mastery persists,
- every launch Relic progresses **Base → Mastery I → Mastery II / Complete**,
- there are exactly **2 mastery milestones per Relic / 20 across the 10-Relic launch roster**,
- mastery strengthens the same Relic effect rather than creating branches or extra abilities,
- normal mastery does not spend Scrolls, Mist, boss materials, duplicate Relics, or a separate mastery currency,
- the Forge is the normal place to choose the Relic equipped when a run begins.

During a run, normal Relic swaps are limited to the safe transitions after Keeper and Twin Maws; a newly discovered Relic also creates an immediate one-time equip-or-keep decision. The Forge does not need to reproduce those run-transition interfaces.

Exact mastery kill thresholds and numerical improvements remain later tuning.

No separate Relic Reliquary is required.

## Regional boss materials

The launch permanent-progression package assigns regional boss materials to exactly six **Bloodwell** gates: one Akio mastery node and one Run Infrastructure passage node per regional boss.

They are therefore **not** normal Forge requirements at launch.

If future Forge scope is deliberately reopened, any boss-material use would require a separate explicit approval rather than being inferred from physical equipment crafting.

## Screen behavior

Two clear categories:

1. **Prosthetics** — selection, owned state, linear upgrade path, Scroll costs.
2. **Relics** — collection, equipped item, Base/Mastery I/Mastery II state, mastery progress, permanent management.

Do not imply generic weapons, sockets, branching weapon classes, or identical Prosthetic/Relic progression rules.

## Resource ownership

- Scrolls → primary Prosthetic progression.
- Relic mastery → persistent progress, not currency.
- Regional boss materials → assigned to approved Bloodwell mastery gates at launch, not routine Forge progression.
- Gold → run-only, not normal Forge currency.
- Generic Boss Emblems → not current design.

## Technical / production notes

- Prosthetic and Relic categories must remain visually distinct.
- Support the approved 2 / 4 / 6 Scroll cost curve without hard-coding it as unchangeable final balance.
- Support Base / Mastery I / Mastery II display for all 10 Relics.
- Support pre-run Relic selection from the persistent collection.
- Future content should remain within the two approved Forge categories unless scope is explicitly reopened.
