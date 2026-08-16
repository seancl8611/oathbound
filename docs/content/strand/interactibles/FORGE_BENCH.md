---
id: CONTENT-STRAND-FORGE-BENCH
title: Forge Bench
category: content
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - strand
  - forge
  - prosthetics
  - relics
  - permanent-upgrades
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

The Forge Bench is the Strand's shared permanent progression and management station for **Prosthetics and Relics**.

It does **not** own a separate permanent weapon-development system. The older design in which Akio developed multiple weapon options has been replaced by Blood Aspects.

## Lore role

The Smith's open-sided forge is built into a cliff alcove around blood-tempered steel, salvaged fragments, damaged ritual objects, and island-forged components recovered from repeated expeditions. It is one of the few places capable of turning corrupted material into reliable tools and preserving dangerous artifacts for controlled use.

## Visual identity

- coal bed and ember glow,
- tongs and worked fragments,
- dark timber supports,
- dense practical bench,
- hammered metal scraps,
- repaired Relic mounts or storage pieces,
- soot and heat shimmer.

The forge reads as a warm working pocket against the Strand's cold shore.

## Interaction fantasy

The player brings persistent combat tools and recovered artifacts to the Smith, who makes them dependable enough to carry into future runs.

## Progression ownership

### Prosthetics

The Forge owns the eight launch Prosthetics and their permanent individual upgrade paths.

- A Prosthetic is functionally complete when unlocked.
- Current paths are shallow and linear.
- Two upgrades are the default; selected tools use a third only when the base tool already has another meaningful existing property to improve.
- Upgrades improve the tool's existing role rather than adding alternate attacks, unrelated statuses, new combat roles, or another Technique-style build layer.
- **Scrolls** remain the primary persistent currency for Prosthetic development.

Exact Prosthetic paths are owned by `docs/gameplay/PROSTHETICS.md`.

### Relics

The Forge also owns permanent **Relic progression and Strand-side Relic management**.

Relics remain a distinct system from Prosthetics:

- Relic collection ownership persists.
- Only one Relic is equipped at a time.
- Existing kill-earned Relic mastery remains persistent.
- Sharing the Forge does not make Relics another Prosthetic tree or require them to use the same upgrade structure.
- The exact way mastery ranks, upgrade realization, costs, or thresholds are presented at the Forge remains later detailed design.

No separate Relic Reliquary is required in the approved hub scope.

## Screen behavior

The Forge interface should clearly separate two categories:

1. **Prosthetics** — tool selection, permanent upgrade paths, and owned-state review.
2. **Relics** — collection, equipped Relic, mastery/progression state, and permanent upgrade management.

The interface must not assume:

- a generic weapon tree,
- weapon sockets,
- branching weapon classes,
- a second Technique system,
- or identical progression rules for Prosthetics and Relics.

Final Relic rank presentation, exact costs, thresholds, and final selection-flow details remain deferred.

## Currency ownership

- **Scrolls** are the primary Forge currency for Prosthetic development.
- Relic mastery is not itself a currency.
- Any future Relic cost or gate must be explicitly approved rather than inferred from the Prosthetic system.
- **Gold** is run-only and is not a normal Forge currency.

## Presentation goal

Craft-forward and practical: the player should feel that the Smith is reinforcing dangerous equipment and recovered artifacts rather than presenting a generic RPG skill tree.

## Visual language

Dark iron, ember accents, forged silhouettes, mounted tools, artifact trays, and practical repair language support rapid category readability.

## Animation and environment needs

- forge ember flicker,
- heat shimmer,
- faint smoke,
- intermittent tool placement,
- Prosthetic inspection / repair states,
- Relic handling or mounting states,
- Smith work loops integrated with the station.

## Technical notes

- Prosthetic and Relic progression must remain visually distinct within the shared station.
- Tooltips, prerequisites, mastery states, cost states where applicable, and controller/keyboard navigation should be planned from the start.
- The Forge should support future content within the two approved categories without reviving generic weapon development.
