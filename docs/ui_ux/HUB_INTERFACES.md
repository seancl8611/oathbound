---
id: UI-HUB-INTERFACES
title: Hub Interfaces
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - hub-ui
  - boat
  - forge
  - merchant
  - codex
  - bloodwell
  - blood-mirror
  - relics
  - techniques
  - run-results
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - UI-STRAND-HUD-PROMPTS
---

# Hub Interfaces

The Strand's interfaces should feel like services embodied in physical stations, not disconnected menu screens. Detailed behavior remains in linked content and gameplay documents; this file owns shared UI/UX requirements and cross-screen consistency.

## Current interface set

| Interface | Core purpose | Source |
|---|---|---|
| Boat | Fast run start and final loadout confirmation | [Boat](../content/strand/interactibles/BOAT.md) |
| Forge Bench | Permanent Prosthetic + Relic progression and management | [Forge Bench](../content/strand/interactibles/FORGE_BENCH.md) |
| Merchant Stall | Fast buy, compare, and stock evaluation | [Merchant Stall](../content/strand/interactibles/MERCHANT_STALL.md) |
| Discovery Board | Knowledge progression and codex reference, including discovered Techniques | [Discovery Board](../content/strand/interactibles/DISCOVERY_BOARD.md) |
| Bloodwell | Akio + Run Infrastructure permanent progression and revival anchor | [Bloodwell](../content/strand/interactibles/BLOODWELL.md) |
| Blood Mirror / Trials | Later-unlocked Aspect progression, previews, repeatable trials, Technique demonstrations, and mastery | [Blood Mirror and Trials](BLOOD_MIRROR_TRIALS.md) |
| Run Results | Successful-return rewards and reset summary | [Run Results and Strand Return](RUN_RESULTS.md) |
| Pause / Overview | Current Aspect, five direct Technique slots, supporting Techniques, refinements, Relic, effects, and control review | [Pause and Build Overview](PAUSE_OVERVIEW.md) |
| Strand HUD | Persistent resources and interaction prompts outside runs | [Strand HUD and Prompts](STRAND_HUD_AND_PROMPTS.md) |

## Permanent upgrade-screen ownership

Current launch scope uses three permanent upgrade interfaces:

- **Bloodwell:** Akio + Run Infrastructure.
- **Forge Bench:** Prosthetics + Relics.
- **Blood Mirror:** Blood Aspects after the Mirror unlocks later in the game.

No separate Relic Reliquary interface is required. The old generic weapon-development / weapon-socket Forge interface is removed. The Bloodwell's former fixed three-branch layout is not authoritative; final Akio and Run Infrastructure substructure remains later design.

## Boat loadout confirmation and run start

The Boat screen is a practical departure confirmation with ritual framing.

Required or supported contents after the relevant systems unlock:

- selected Aspect,
- concise Aspect role description,
- equipped Prosthetic summary,
- equipped Relic summary,
- five empty direct Technique slots only as a concise run-start expectation when useful,
- Start Run,
- change/loadout navigation where needed,
- Cancel/back.

Technique slots begin empty and are not preconfigured at the Boat. There is no reserve Technique slot.

Visual anchors include the Boat lantern, dark timber, wet rope, mist crossing, and compact loadout summaries. Before Aspect unlock, the screen may remain minimal.

## Bloodwell

The Bloodwell must clearly separate its two approved progression categories:

- **Akio**
- **Run Infrastructure**

Run Infrastructure is one umbrella for approved permanent improvements to Rest support, Shrine support, rewards, routing/run conditions, regional transitions, and related expedition support. The interface should not present these as unrelated standalone upgrade stations.

Exact node layout, branch names, values, rank counts, and costs remain later detailed design.

## Forge Bench

The Forge interface must clearly separate:

- **Prosthetics** — the locked shallow linear tool paths,
- **Relics** — persistent collection, equipped state, mastery/progression, and permanent upgrade management.

Sharing a screen does not imply identical currencies or progression structures. The Forge must not show the retired generic weapon tree, weapon sockets, or alternate weapon classes.

## Blood Mirror and Aspect trials

The Blood Mirror presents self-confrontation rather than shopping or a generic skill tree.

The **Blood Mirror begins locked**. The interface needs a sealed/unavailable state that can later transition into the full Aspect progression/trial interface after campaign/onboarding unlock.

Unlocked contents may include:

- Aspect list,
- trial categories,
- locked and unlocked states,
- reward preview,
- Tier I-IV preview,
- standardized trial loadout where applicable,
- permanent Aspect progression ranks,
- Technique-pool unlock state where applicable,
- completed and mastered states.

The screen uses sparse black stone, reflective water, blood-mineral light, distorted player reflection, and Aspect silhouettes. Technique demonstration cards must read as temporary trial conditions and must not resemble a persistent pre-run loadout.

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
- **Forge:** dark iron, ember accents, mounted tools/artifacts, practical progression categories.
- **Merchant:** tagged salvage, cloth-backed item cards, stock and price clarity.
- **Discovery Board:** layered paper, notes, sketches, and partial-discovery states.
- **Bloodwell:** carved stone, blood-lit channels, sacred Akio / Run Infrastructure progression.
- **Blood Mirror:** black stone, reflective water, sparse framing, blood-mineral light; sealed/dormant before unlock.
- **Run results:** restrained return summary tied to Bloodwell reformation.
- **Pause:** dark minimal overlay and direct current-build hierarchy.

## Data dependency rule

Final layouts follow documented data fields, progression ownership, currency names, Technique capacity, and state behavior. Interface art must not invent upgrade branches, costs, Aspect behavior, Technique ownership, trial rules, Relic currency rules, or unlock requirements that remain unresolved.
