---
id: RELIC-RUNTIME-IMPLEMENTATION
title: Relic Runtime Implementation Boundary
category: gameplay
status: approved
last_reviewed: 2026-08-22
topics:
  - relics
  - runtime
  - mastery
  - forge
  - shop
  - playtest
---

# Relic Runtime Implementation Boundary

This file records what the current Godot Relic implementation owns. `RELICS.md` remains the design authority. Values explicitly described below as **first-playtest tuning** are implementation parameters, not newly approved paper-design numbers.

## Current runtime ownership

The current Relic layer is implemented under `game/oathbound/Core/Relics/` and installed through `OathboundGameFlow.gd`.

Current rules represented in runtime:

- one equipped Relic at a time;
- Relic ownership/discovery persists independently of runs;
- Relic mastery persists independently for each Relic;
- only the currently equipped Relic gains mastery from eligible enemy kills;
- mastery follows Base -> Mastery I -> Mastery II / Complete;
- discovery is saved immediately before the player chooses Equip Now or Keep Current;
- Relic swapping is available at the Forge, immediately on discovery, after Keeper, and after Twin Maws;
- Relics do not occupy Technique or Prosthetic slots.

## Launch roster implemented

All ten approved launch identities/effects have runtime hooks:

1. **Traveler's Coin** — additional run-start Gold.
2. **Merchant's Seal** — first successful Shop purchase in each region receives the regional discount; Base remains the approved 20%.
3. **Iron Prayer Bead** — maximum Health increase.
4. **Spirit Tassel** — maximum Spirit increase.
5. **Execution Bead** — committed Deathblows restore Spirit.
6. **Wayfarer's Charm** — room entry restores Health.
7. **Last Oath** — once per run, lethal damage leaves Akio at the approved Base 25 HP instead of killing him.
8. **Unbroken Cord** — standard Combat chamber clears with no Health damage taken grant bonus Gold.
9. **Scribe's Lens** — the first Technique reward in a region presents a fourth choice at Base; rerolls preserve the earned four-card width without consuming another regional use.
10. **Blood Moon Shard** — successfully committed Blood Arts restore Spirit.

Iron Prayer Bead and Spirit Tassel are isolated from temporary Shop capacity. Swapping or mastering them adds/removes only the Relic-owned bonus rather than resetting other current-run capacity changes.

## First-playtest tuning, not locked design

`RelicCatalog.gd` currently uses provisional values so every effect can be exercised in one build. These remain tunable until playtesting establishes better numbers.

- Mastery I threshold: 15 eligible kills.
- Mastery II threshold: 40 eligible kills.
- Traveler's Coin: +40 / +60 / +80 Gold.
- Merchant's Seal: 20% / 25% / 30% regional first-purchase discount. Only Base 20% is already design-approved.
- Iron Prayer Bead: +10 / +15 / +20 maximum Health.
- Spirit Tassel: +15 / +20 / +25 maximum Spirit.
- Execution Bead: +10 / +15 / +20 Spirit on Deathblow.
- Wayfarer's Charm: +3 / +5 / +7 Health on room entry.
- Last Oath: 25 / 30 / 35 surviving HP. Only Base 25 HP is already design-approved.
- Unbroken Cord: +15 / +25 / +35 Gold.
- Scribe's Lens: first 1 / 2 / 3 Technique reward screens per region receive the extra card. Base first-screen behavior is approved; increased Mastery frequency is first-playtest tuning of the same effect.
- Blood Moon Shard: +8 / +12 / +16 Spirit on Blood Art use.

These values should be adjusted from telemetry/playtest results without reopening the Relic structure unless a structural contradiction appears.

## Forge and safe swaps

The current Forge menu includes a Relic collection view with:

- discovered Relics only;
- equipped state;
- mastery rank and eligible-kill count;
- approved core-effect description;
- current first-playtest effect value;
- Equip / Unequip controls.

After Keeper and Twin Maws, `OathboundGameFlow` can present a safe swap screen containing already-unlocked Relics. This screen never discovers new Relics.

## Discovery plumbing and intentionally deferred source identities

The generic discovery presentation exists and follows the approved rule: a discovered Relic is persisted immediately, then the player chooses **Equip Now** or **Keep Current**.

`RELICS.md` intentionally leaves the exact identities assigned to these acquisition groups for later content sequencing:

- 4 guaranteed campaign / Strand Relics;
- 2 Blood Cavern / challenge Relics;
- 4 run-discovered Relics.

This implementation therefore does **not** arbitrarily assign those ten identities into a 4 / 2 / 4 split. Treasure, boss-flex, Shop-flex, campaign, and challenge callers should use the generic discovery flow once that source mapping is authored.

The current Shop preserves the approved "~10% Relic opportunity when eligible" rule structurally, but does not roll a Relic until an eligible run-discovery pool has been configured by content progression. That is intentional, not a missing random fallback.

## Current Shop reconciliation

Because Merchant's Seal depends on the live Shop, the Relic package also retires the imported Boon / Mist Shard / Boss Emblem Shop inventory and restores the approved three-item current model:

- **Survival** — moderate Health or Spirit recovery;
- **Build** — Technique, temporary max Health, temporary max Spirit, or Technique reroll;
- **Flex / premium** — Technique, capacity, reroll, stronger recovery, and an eligible Relic opportunity.

The stable prototype prices and recovery/capacity percentages come from `ITEMS_AND_REWARDS.md`. Exact non-Relic Flex weighting remains first-playtest tuning. The documented Relic opportunity remains approximately 10% when eligible.

## Runtime ownership correction

`RunScene.gd` no longer directly instantiates legacy `res://Player/player.tscn`. `OathboundGameFlow` is the one current Player factory and creates `res://Player/aspect_player.tscn`, whose active script is `OathboundCombatPlayer.gd`.

This is a required runtime invariant and is checked by the Godot project workflow. A successful compile with the old Stability Player active is considered a failed integration.

## Playtest Lab

The current Playtest Lab contains a **Relics** tab that can:

- unlock the whole roster for testing;
- equip/unequip a selected Relic;
- force Base, Mastery I, or Mastery II;
- display the selected Relic's approved effect and current tuning value.

Run-start and starting-capacity effects should be validated on a fresh run after choosing them. Event-driven Relics can also be switched during a focused debug session.

## Next dependency-sized package

After this package is runtime-stable, the next current-player-build package is **Corruption / Shrine integration**. That pass should connect the already-approved Resist / Embrace rules, call the existing Aspect Tier advancement API from Embrace, clear Corruption correctly, and reconcile its HUD/feedback without creating a second Blood authority.
