---
id: META-SOURCE-OF-TRUTH
title: Source of Truth
category: meta
status: approved
authority: primary
---

# Source of Truth

Each major subject should have one authoritative file. Other files should summarize and link to it rather than duplicating the complete definition.

| Subject | Authoritative location |
|---|---|
| Game identity, pitch, and pillars | `docs/overview/` |
| Core mechanics and player-facing systems | `docs/gameplay/` |
| Canon, history, factions, and supernatural rules | `docs/lore/` |
| Akio and named characters | `docs/characters/` |
| Area rosters, enemies, bosses, rooms, and regional content | `docs/content/` |
| Art direction, technical standards, asset inventory, and milestone scope | `docs/art_production/` |
| HUD, menus, and interface behavior | `docs/ui_ux/` |
| Contractor-facing exports and records | `docs/external/` and `contractor_docs/` |

## Conflict rule

When two files conflict, use the file assigned authority here. Update dependent summaries after resolving the authoritative file. If authority is unclear, record the conflict in `OPEN_QUESTIONS.md` instead of inventing a resolution.

## Duplication rule

Detailed definitions belong only in their authoritative file. Dependent files should contain the minimum context needed for their purpose and link back to the authoritative source.
