---
id: UI-HUD
title: Run HUD and Combat Feedback
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - hud
  - posture
  - corruption
  - deathblow
  - damage-numbers
  - enemy-indicators
related:
  - GAMEPLAY-COMBAT
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-ITEMS-REWARDS
  - ART-CORE-VFX
---

# Run HUD and Combat Feedback

The Run HUD displays immediate combat state, current build tools, and run-only progression without competing with enemy telegraphs. It is assembled in Godot from modular art elements rather than delivered as a fixed scene.

## Core modules

- Player HP bar
- Player posture bar
- Ten Spirit emblem segments in the current Milestone 1 baseline
- Equipped stance icon
- Equipped prosthetic icon and cooldown or charge state
- Run currency counters
- Status-effect row
- Corruption meter
- Selected Blood Aspect and current Tier
- Enemy health and posture indicators
- Miniboss and boss bars
- Damage numbers
- Deathblow prompt

## Information hierarchy

1. HP and immediate survival
2. Player and enemy posture
3. Spirit and active prosthetic availability
4. Deathblow state
5. Active status effects and stance
6. Corruption and Aspect Tier
7. Currency and non-urgent run information

Corruption becomes more prominent when full and Shrine-ready, but it remains secondary to immediate survival during combat.

## Player bars and resources

### HP bar

Muted warm life-red with a clear low-HP reference state. Low health should read even if pulse animation is missed. Frame and fill may use restrained segmented divisions.

### Posture bar

Must use a different shape, fill behavior, or framing language from HP. It should feel loaded as it approaches break, with a clearly different broken state.

### Spirit emblems

Ten countable segments in the current baseline, with unmistakable full and empty states. The row should inherit Order ritual language rather than modern ammunition UI.

## Corruption and Blood Aspect module

Required states:

- hidden before unlock,
- empty,
- filling,
- near full,
- full and Shrine-ready,
- after Resist,
- after Embrace,
- maximum Tier.

The module shows selected Aspect and Tier I-IV after unlock. It uses dark crimson pressure language and must not resemble mana. Full-state feedback connects to the [Corruption Full Cue](../art_production/CORE_VFX.md#corruption-full-cue).

## Enemy health and posture indicators

### Standard enemies

Compact floating bars appear only while engaged or recently damaged. Posture uses the stronger visual channel because near-break state is the critical tactical read.

### Minibosses

Larger screen-anchored bar with name plate and optional portrait space.

### Bosses

Full-width presentation with name, health, posture, and phase markers where required. Multi-cycle encounters such as Blood Lotus need clear Heart vulnerability and deathblow-chunk progress without inventing unsupported values.

## Damage numbers

Use a hand-inked, gameplay-readable style rather than a clean modern UI font. Numbers rise and fade quickly to avoid stacking.

Current color language:

- red: HP damage,
- pale yellow: posture damage,
- orange: Burn,
- cyan: Frost,
- violet: Hex,
- pale blue: Shock,
- separate restrained treatment for healing and critical hits.

Color cannot be the only differentiator; weight, outline, prefix, icon, or motion should reinforce type where practical. Critical values use subtle scale or weight changes rather than dramatic spectacle.

## Deathblow prompt

The input prompt appears alongside the persistent world-space Deathblow Cue and should be understood in approximately 0.3 seconds. The cue and input prompt must read together without competing.

The persistent execution indicator stays anchored over the enemy's upper body for the entire valid window, pulses subtly, and remains distinct from posture break, damage numbers, and status icons.

## World-space cue relationship

The HUD complements rather than duplicates [Core Combat and Corruption VFX](../art_production/CORE_VFX.md). Parry, Posture Break, Deathblow, and Corruption Full cues originate in world space or on Akio; the HUD provides persistent context and resource state.

## Delivery requirements

The artist supplies modular bars, fills, frames, icons, markers, number style sheets, and state examples. Godot owns layout, values, responsive anchoring, timing, cooldown motion, spawning, and visibility logic.

All elements must remain legible over Hushiro, Yomori, and Kagutsuchi backgrounds. Critical state should be understood in under one second without pulling attention away from attack windups.
