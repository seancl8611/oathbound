---
id: UI-HUD
title: Run HUD and Combat Feedback
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-23
topics:
  - hud
  - posture
  - corruption
  - blood-resource
  - blood-arts
  - techniques
  - deathblow
  - damage-numbers
  - enemy-indicators
related:
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - UI-TECHNIQUE-REWARDS
  - ART-CORE-VFX
---

# Run HUD and Combat Feedback

The Run HUD displays immediate combat state, current build tools, and run-only progression without competing with enemy telegraphs. It is assembled in Godot from modular art elements rather than delivered as a fixed scene.

## Core modules

- Player HP bar
- Player posture bar
- Ten Spirit emblem segments in the current Milestone 1 baseline
- Equipped prosthetic icon and cooldown or charge state
- Compact active-Technique indicators where a Technique has combat-relevant state
- Run currency counters
- Status-effect row
- Corruption meter
- Selected Blood Aspect and current Tier
- Integrated Blood Art buildup, ready, activation, and unavailable states after Tier II
- Enemy health and posture indicators
- Miniboss and boss bars
- Damage numbers
- Deathblow prompt

The reserve Technique does not need a persistent combat-HUD slot because it is inactive. Full active/reserve build review belongs in the pause and reward interfaces.

## Technique HUD behavior

Most Techniques are passive modifications and should not add persistent HUD clutter.

Show a Technique indicator during combat only when the player needs immediate state information, such as:

- a stack or Focus threshold,
- a temporary activation window,
- an internal cooldown,
- a stored charge,
- a marked target,
- a ready refinement payoff.

When no state requires tracking, the Technique remains visible only in the build overview and reward screens.

The HUD should support up to four active Technique icons in a compact build strip or contextual state area without implying four separate ability buttons.

## Information hierarchy

1. HP and immediate survival
2. Player and enemy posture
3. Spirit and active prosthetic availability
4. Deathblow state
5. Ready or active Blood Art state and urgent Technique or status conditions
6. Corruption and Aspect Tier
7. Blood buildup when not yet ready
8. Currency and non-urgent run information

Corruption becomes more prominent when full and Shrine-ready, but it remains secondary to immediate survival during combat. Blood Art readiness may become prominent when full or active, but ordinary Blood buildup should remain visually quieter than enemy telegraphs and posture state.

## Player bars and resources

### HP bar

Muted warm life-red with a clear low-HP reference state. Low health should read even if pulse animation is missed. Frame and fill may use restrained segmented divisions.

### Posture bar

Must use a different shape, fill behavior, or framing language from HP. It should feel loaded as it approaches break, with a clearly different broken state.

### Spirit emblems

Ten countable segments in the current baseline, with unmistakable full and empty states. The row should inherit Order ritual language rather than modern ammunition UI.

## Corruption and Blood Aspect module

The Corruption and Aspect presentation share one coherent Returning Blood module while preserving their separate gameplay purposes.

### Corruption states

- hidden before unlock,
- empty,
- filling,
- near full,
- full and Shrine-ready,
- after Resist,
- after Embrace,
- maximum Tier.

The module shows selected Aspect and Tier I–IV after unlock. Corruption uses dark crimson pressure language and must not resemble mana. Full-state feedback connects to the [Corruption Full Cue](../art_production/CORE_VFX.md#corruption-full-cue).

### Blood Art states

Before Tier II, Blood Art buildup is hidden, locked, or otherwise clearly unavailable without implying an error.

After Tier II, the Aspect module must support:

- empty Blood,
- Blood building through combat,
- near-ready state,
- Blood Art ready,
- activation confirmation,
- active or resolving Blood Art,
- consumed or rebuilding state,
- and any later approved retained-Blood state.

Blood is mechanically tracked as a combat resource, but the interface is not required to use a separate large horizontal meter. The preferred direction is to integrate buildup into the existing Aspect emblem, seal, segments, veins, fill treatment, or another compact visual language.

The player must still be able to understand whether the Blood Art is unavailable, building, ready, or active. The exact amount, segmentation, numeric display, duration treatment, and variation between different Blood Art types remain pending UI and gameplay design.

The HUD must not assume that every Blood Art is a temporary buff. It should support immediate, contextual, defensive, movement, focused-attack, control, and duration-based Arts through reusable shared states plus limited Aspect-specific presentation.

The selected Aspect should remain more visually prominent than any single passive Technique because it is the run's central identity.

## Enemy health and posture indicators

### Standard enemies

Compact floating bars appear only while engaged or recently damaged. Posture uses the stronger visual channel because near-break state is the critical tactical read.

### Minibosses

Larger screen-anchored bar with name plate and optional portrait space.

### Bosses

Full-width presentation with name, health, posture, and phase markers where required. Multi-cycle encounters such as Blood Lotus need clear Heart vulnerability and deathblow-chunk progress without inventing unsupported values.

## Damage numbers and status language

Use a hand-inked, gameplay-readable style rather than a clean modern UI font. Numbers rise and fade quickly to avoid stacking.

Current approved color language:

- red: HP damage,
- pale yellow: posture damage,
- orange: Burn,
- pale blue: Shock,
- separate restrained treatment for healing and critical hits.

Frost and Hex are no longer baseline player status families after removal of the stance system. Do not retain their HUD or damage-number requirements unless a future approved enemy, Technique, Relic, or encounter reintroduces them with a defined mechanic.

Color cannot be the only differentiator; weight, outline, prefix, icon, or motion should reinforce type where practical. Critical values use subtle scale or weight changes rather than dramatic spectacle.

## Deathblow prompt

The input prompt appears alongside the persistent world-space Deathblow Cue and should be understood in approximately 0.3 seconds. The cue and input prompt must read together without competing.

The persistent execution indicator stays anchored over the enemy's upper body for the entire valid window, pulses subtly, and remains distinct from posture break, damage numbers, Technique markers, Aspect marks, and status icons.

## World-space cue relationship

The HUD complements rather than duplicates [Core Combat and Corruption VFX](../art_production/CORE_VFX.md). Parry, Posture Break, Deathblow, Corruption Full, target marks, Blood Art activation, and Technique-trigger cues originate in world space or on Akio; the HUD provides persistent context and resource state.

## Delivery requirements

The artist supplies modular bars, fills, frames, icons, markers, number style sheets, Technique-state examples, and required active/inactive states. Godot owns layout, values, responsive anchoring, timing, fill motion, spawning, and visibility logic.

The Blood Art framework should reuse a shared Aspect-module location and common locked, building, ready, activated, and consumed logic. Exact Art-specific target, duration, charge, and active-state treatments remain later production requirements after the three Arts are designed.

All elements must remain legible over Hushiro, Yomori, and Kagutsuchi backgrounds. Critical state should be understood in under one second without pulling attention away from attack windups.
