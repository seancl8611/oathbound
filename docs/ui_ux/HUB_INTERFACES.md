---
id: UI-HUB-INTERFACES
title: Hub Interfaces
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - hub-ui
  - boat
  - forge
  - merchant
  - codex
  - bloodwell
  - blood-mirror
  - run-results
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-PROGRESSION
---

# Hub Interfaces

The Strand's interfaces should feel like services embodied in physical stations, not disconnected menu screens. Detailed system behavior remains in the linked content and gameplay documents; this file owns shared UI/UX requirements and cross-screen consistency.

## Current interface set

| Interface | Core purpose | Source |
|---|---|---|
| Boat | Fast run start and final Blood Aspect confirmation | [Boat](../content/strand/interactibles/BOAT.md) |
| Forge Bench | Permanent branch planning and combat/tool improvement | [Forge Bench](../content/strand/interactibles/FORGE_BENCH.md) |
| Merchant Stall | Fast buy, compare, and stock evaluation | [Merchant Stall](../content/strand/interactibles/MERCHANT_STALL.md) |
| Discovery Board | Knowledge progression and codex reference | [Discovery Board](../content/strand/interactibles/DISCOVERY_BOARD.md) |
| Bloodwell | Three-branch permanent meta progression and revival anchor | [Bloodwell](../content/strand/interactibles/BLOODWELL.md) |
| Blood Mirror / Trials | Aspect unlocks, previews, repeatable trials, and light mastery upgrades | [Blood Mirror and Trials](BLOOD_MIRROR_TRIALS.md) |
| Run Results | Successful-return rewards and reset summary | [Run Results and Strand Return](RUN_RESULTS.md) |
| Pause / Overview | Current build, active effects, and control review | [Pause and Build Overview](PAUSE_OVERVIEW.md) |

## Shared requirements

- Reuse typography, frames, icon logic, focus states, confirmation behavior, and input prompts.
- Keep the physical station and NPC visible where useful so the interface remains grounded in the world.
- Clearly separate permanent upgrades, run-only choices, discoveries, stock purchases, trials, and currencies.
- Support locked, available, focused, selected, purchased, maxed, completed, mastered, sold-out, and disabled states where applicable.
- Show requirements without revealing unintended narrative spoilers.
- Support controller and keyboard navigation from the first layout pass.
- Preserve localization-safe text areas and readable hierarchy.
- Prioritize rapid repeated use over decorative transition length.

## Visual differentiation

Interfaces share a project-wide language but inherit material cues from their stations:

- **Boat:** dark timber, wet rope, lantern threshold, compact confirmation.
- **Forge:** dark iron, ember accents, sockets, branches, and crafted silhouettes.
- **Merchant:** tagged salvage, cloth-backed item cards, stock and price clarity.
- **Discovery Board:** layered paper, notes, sketches, and partial-discovery states.
- **Bloodwell:** carved stone, blood-lit channels, sacred progression paths.
- **Blood Mirror:** black stone, reflective water, sparse framing, blood-mineral light.
- **Run results:** restrained return summary tied to Bloodwell reformation.
- **Pause:** dark minimal overlay and direct current-build hierarchy.

## Data dependency rule

Final layouts follow documented data fields, progression ownership, and state behavior. Interface art must not invent upgrade branches, currencies, Aspect behavior, trial rules, or unlock requirements that remain unresolved in authoritative gameplay/content files.
