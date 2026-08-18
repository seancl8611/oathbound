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
| Blood Mirror / Trials | Aspect progression/trials/previews after first Keeper |
| Run Results | Retained rewards / run reset summary |
| Pause / Overview | Current run build review |
| Strand HUD | Lightweight persistent wallet / prompts |

## Permanent upgrade ownership

- **Bloodwell:** 10 Akio nodes + 8 Run Infrastructure nodes.
- **Forge Bench:** 19 Prosthetic upgrades + 10 Relics with Base / Mastery I / Mastery II progression.
- **Blood Mirror:** 3 nodes per Aspect / 9 total, unlocked after first Keeper.

No separate Relic Reliquary, generic weapon tree, weapon sockets, or old fixed Bloodwell three-branch UI.

## Persistent resource presentation

General persistent currencies are:

- **Mist**,
- **Scrolls**.

Gold is run-only.

The three regional boss materials are low-count specific mastery materials, not a normal persistent wallet. At launch they are assigned only to the six approved Bloodwell mastery gates: one Akio mastery node and one Infrastructure passage node per regional boss.

Show them contextually when:

- a result screen reports one earned,
- one of those Bloodwell upgrades requires one,
- a collection/reference screen needs to show ownership.

Do not dedicate always-visible hub counters or a generic Boss Emblem category to them.

## Boat

After systems unlock, the Boat may summarize selected Aspect, equipped Prosthetic, equipped Relic, and run-start expectations, then provide Start Run / loadout navigation / cancel.

Direct Technique slots begin empty. No reserve slot exists.

## Bloodwell

Clearly separate:

- **Akio — 10 nodes**,
- **Run Infrastructure — 8 nodes**.

The interface must support campaign-gated bands across first return, first Keeper, first Twin Maws, and first Shogun / first Binding clear.

Show Mist costs and, only for the six approved major gates, the specific regional boss-material requirement. Do not present boss materials as another broad Bloodwell currency tree.

## Forge Bench

Clearly separate:

- **Prosthetics** — shallow linear paths with the first 2 / 4 / 6 Scroll cost prototype,
- **Relics** — collection/equip plus Base → Mastery I → Mastery II / Complete progression.

Relic mastery progress is earned through eligible kills while equipped; normal mastery ranks do not display Mist, Scroll, boss-material, duplicate-copy, or mastery-currency costs.

Sharing one station does not imply identical currencies or progression structures.

## Blood Mirror

Requires sealed/unavailable opening state until the **first Keeper defeat**, then shows the three permanent nodes for each unlocked Aspect.

Node availability:

- Tier 0 Handling after first Keeper,
- Signature Reliability after first Twin Maws,
- Blood Discipline after first Shogun / first Binding clear.

Normal Blood Mirror nodes do not use regional boss materials at launch. The interface must not imply that permanent Aspect progression grants Tier mechanics or Blood early.

## Shared requirements

- Reuse typography, frames, focus/confirm behavior, icons, and input prompts.
- Keep physical station/NPC context visible where useful.
- Distinguish permanent upgrades, run-only choices, purchases, trials, and discoveries.
- Support locked / available / focused / selected / purchased / maxed / completed / mastered / sold-out / disabled as applicable.
- Requirements cannot reveal unintended story spoilers.
- Support controller/keyboard and localization-safe layouts from the first pass.
- Optimize for rapid repeated use.

## Data dependency rule

UI follows documented progression ownership, resource names, costs, Technique capacity, and state behavior. Interface art must not invent upgrade branches, boss-material requirements, Relic currencies, or unlock rules beyond the approved progression authorities.
