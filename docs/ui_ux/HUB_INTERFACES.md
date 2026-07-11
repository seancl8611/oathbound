---
id: UI-HUB-INTERFACES
title: Hub Interfaces
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - hub-ui
  - boat
  - forge
  - merchant
  - codex
  - bloodwell
  - blood-mirror
  - techniques
  - run-results
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - UI-STRAND-HUD-PROMPTS
---

# Hub Interfaces

The Strand's interfaces should feel like services embodied in physical stations, not disconnected menu screens. Detailed behavior remains in linked content and gameplay documents; this file owns shared UI/UX requirements and cross-screen consistency.

## Current interface set

| Interface | Core purpose | Source |
|---|---|---|
| Boat | Fast run start and final Blood Aspect confirmation | [Boat](../content/strand/interactibles/BOAT.md) |
| Forge Bench | Permanent branch planning and combat/tool improvement | [Forge Bench](../content/strand/interactibles/FORGE_BENCH.md) |
| Merchant Stall | Fast buy, compare, and stock evaluation | [Merchant Stall](../content/strand/interactibles/MERCHANT_STALL.md) |
| Discovery Board | Knowledge progression and codex reference, including discovered Techniques | [Discovery Board](../content/strand/interactibles/DISCOVERY_BOARD.md) |
| Bloodwell | Three-branch permanent meta progression and revival anchor | [Bloodwell](../content/strand/interactibles/BLOODWELL.md) |
| Blood Mirror / Trials | Aspect unlocks, previews, repeatable trials, Technique demonstrations, and light mastery upgrades | [Blood Mirror and Trials](BLOOD_MIRROR_TRIALS.md) |
| Run Results | Successful-return rewards and reset summary | [Run Results and Strand Return](RUN_RESULTS.md) |
| Pause / Overview | Current Aspect, active Techniques, reserve, Relic, effects, and control review | [Pause and Build Overview](PAUSE_OVERVIEW.md) |
| Strand HUD | Persistent resources and interaction prompts outside runs | [Strand HUD and Prompts](STRAND_HUD_AND_PROMPTS.md) |

## Boat Aspect selection and run start

The Boat screen is a practical departure confirmation with ritual framing.

Required contents after Aspect unlock:

- selected Aspect,
- list of unlocked Aspects,
- locked-state requirements without spoilers,
- concise role description,
- equipped prosthetic summary when available,
- Start Run,
- Change Aspect,
- Cancel/back.

Technique slots begin empty and are not preconfigured at the Boat.

Visual anchors include the Boat lantern, dark timber, wet rope, mist crossing, and compact Aspect cards or icons. Before Aspect unlock, the screen may remain minimal.

## Blood Mirror and Aspect trials

The Blood Mirror presents self-confrontation rather than shopping or a generic skill tree.

Required contents:

- Aspect list,
- trial categories,
- locked and unlocked states,
- reward preview,
- Tier I-IV preview,
- standardized trial loadout where applicable,
- permanent upgrade ranks,
- Technique-pool unlock state where applicable,
- completed and mastered states.

The screen uses sparse black stone, reflective water, blood-mineral light, distorted player reflection, and Aspect silhouettes. The data model must support future boss rematches or challenge ladders without rebuilding the interface foundation.

Technique demonstration cards must read as temporary trial conditions and must not resemble a persistent pre-run loadout.

## Shared requirements

- Reuse typography, frames, icon logic, focus states, confirmation behavior, and input prompts.
- Keep the physical station and NPC visible where useful so the interface remains grounded in the world.
- Clearly separate permanent upgrades, run-only choices, discovered Technique records, stock purchases, trials, and currencies.
- Support locked, available, focused, selected, purchased, maxed, completed, mastered, sold-out, and disabled states where applicable.
- Show requirements without revealing unintended narrative spoilers.
- Support controller and keyboard navigation from the first layout pass.
- Preserve localization-safe text areas and readable hierarchy.
- Prioritize rapid repeated use over decorative transition length.

## Visual differentiation

- **Boat:** dark timber, wet rope, lantern threshold, compact confirmation.
- **Forge:** dark iron, ember accents, sockets, branches, and crafted silhouettes.
- **Merchant:** tagged salvage, cloth-backed item cards, stock and price clarity.
- **Discovery Board:** layered paper, notes, sketches, and partial-discovery states.
- **Bloodwell:** carved stone, blood-lit channels, sacred progression paths.
- **Blood Mirror:** black stone, reflective water, sparse framing, blood-mineral light.
- **Run results:** restrained return summary tied to Bloodwell reformation.
- **Pause:** dark minimal overlay and direct current-build hierarchy.

## Data dependency rule

Final layouts follow documented data fields, progression ownership, currency names, Technique capacity, and state behavior. Interface art must not invent upgrade branches, costs, Aspect behavior, Technique ownership, trial rules, or unlock requirements that remain unresolved.
