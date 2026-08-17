---
id: UI-HUB-INTERFACES
title: Hub Interfaces
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - hub-ui
  - boat
  - forge
  - merchant
  - codex
  - bloodwell
  - blood-mirror
  - relics
  - boss-materials
  - run-results
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-RELICS
  - UI-STRAND-HUD-PROMPTS
---

# Hub Interfaces

Strand interfaces should feel like physical services rather than disconnected menus. Gameplay/content authorities own mechanics and costs; this file owns cross-screen UI consistency.

## Interface set

| Interface | Purpose |
|---|---|
| Boat | Fast run start / final loadout confirmation |
| Forge Bench | Prosthetic + Relic permanent progression/management |
| Merchant Stall | Strand purchasing/service stock |
| Discovery Board | Codex/discovery/Technique records |
| Bloodwell | Akio + Run Infrastructure permanent progression and return presentation |
| Blood Mirror / Trials | Later-unlocked Aspect progression/trials/previews |
| Run Results | Retained rewards / run reset summary |
| Pause / Overview | Current run build review |
| Strand HUD | Lightweight persistent wallet / prompts |

## Permanent upgrade ownership

- **Bloodwell:** Akio + Run Infrastructure.
- **Forge Bench:** Prosthetics + Relics.
- **Blood Mirror:** Blood Aspects after later unlock.

No separate Relic Reliquary, generic weapon tree, weapon sockets, or old fixed Bloodwell three-branch UI.

## Persistent resource presentation

General persistent currencies are:

- **Mist**,
- **Scrolls**.

Gold is run-only.

The three regional boss materials are low-count specific mastery materials, not a normal persistent wallet. Show them contextually when:

- a result screen reports one earned,
- an upgrade requires one,
- a collection/reference screen needs to show ownership.

Do not dedicate always-visible hub counters or a generic Boss Emblem category to them.

## Boat

After systems unlock, the Boat may summarize selected Aspect, equipped Prosthetic, equipped Relic, and run-start expectations, then provide Start Run / loadout navigation / cancel.

Direct Technique slots begin empty. No reserve slot exists.

## Bloodwell

Clearly separate:

- **Akio**,
- **Run Infrastructure**.

Show Mist costs and, only for selected major upgrades, a specific regional boss-material requirement when assigned. Do not present boss materials as another broad Bloodwell currency tree.

## Forge Bench

Clearly separate:

- **Prosthetics** — shallow linear paths with the first 2 / 4 / 6 Scroll cost prototype,
- **Relics** — collection/equip/mastery/permanent progression.

Sharing one station does not imply identical currencies or progression structures.

## Blood Mirror

Requires sealed/unavailable opening state and later unlocked Aspect progression/trial states.

Selected major Aspect upgrades may later show a specific boss-material gate alongside their normal cost if the progression design assigns one. Basic Aspect progression must not imply that repeated boss farming is mandatory.

## Shared requirements

- Reuse typography, frames, focus/confirm behavior, icons, and input prompts.
- Keep physical station/NPC context visible where useful.
- Distinguish permanent upgrades, run-only choices, purchases, trials, and discoveries.
- Support locked / available / focused / selected / purchased / maxed / completed / mastered / sold-out / disabled as applicable.
- Requirements cannot reveal unintended story spoilers.
- Support controller/keyboard and localization-safe layouts from the first pass.
- Optimize for rapid repeated use.

## Data dependency rule

UI follows documented progression ownership, resource names, costs, Technique capacity, and state behavior. Interface art must not invent upgrade branches, boss-material requirements, Relic currencies, or unlock rules that remain unresolved.
