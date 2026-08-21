---
id: UI-HUD
title: Run HUD and Combat Feedback
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-20
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
  - temporary-capacity
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

- Player HP bar with support for temporary maximum-Health growth
- Player posture bar
- Spirit-emblem resource display using ten starting segments in the current Milestone 1 baseline, with support for temporary maximum-Spirit growth
- Equipped Prosthetic icon and cooldown or charge state
- Compact Technique-state indicators only where immediate combat tracking is needed
- Run currency counters
- Status-effect row
- Corruption meter
- Selected Blood Aspect and current Tier
- Integrated Blood Art buildup, ready, activation, and unavailable states after Tier II
- Enemy health and posture indicators
- Miniboss and boss bars
- Damage numbers
- Deathblow prompt

The HUD does not need a permanently visible icon for every owned Technique. Full build review belongs in the pause and reward interfaces.

## Technique HUD behavior

Most Techniques modify existing actions and should not add persistent HUD clutter.

Show a Technique indicator during combat only when the player needs immediate state information, such as:

- a stack or threshold,
- a temporary activation window,
- an internal cooldown,
- a stored charge,
- a marked target,
- a ready refinement payoff,
- or a short-lived Supporting-Technique state.

When no state requires tracking, the Technique remains visible only in the build overview and reward screens.

The HUD must support simultaneous state from any number of owned Action, Supporting, Cross-family, Legendary, and refined Techniques without implying new ability buttons or exclusive action slots. Contextual indicators are preferred over a permanent icon strip when possible.

## Information hierarchy

1. HP and immediate survival
2. Player and enemy posture
3. Spirit and active Prosthetic availability
4. Deathblow state
5. Ready or active Blood Art state and urgent Technique or status conditions
6. Corruption and Aspect Tier
7. Blood buildup when not yet ready
8. Currency and non-urgent run information

Corruption becomes more prominent when full and Shrine-ready, but it remains secondary to immediate survival during combat. Blood Art readiness may become prominent when full or active, but ordinary Blood buildup should remain visually quieter than enemy telegraphs and posture state.

## Player bars and resources

### HP bar

Muted warm life-red with a clear low-HP reference state. Low Health should read even if pulse animation is missed. Frame and fill may use restrained segmented divisions.

The HUD must visually support **run-only maximum-Health increases** without implying permanent character growth. The underlying bar may extend, add restrained capacity markers, or use another readable method, but current Health and increased maximum Health must remain immediately understandable.

### Posture bar

Must use a different shape, fill behavior, or framing language from HP. It should feel loaded as it approaches break, with a clearly different broken state.

### Spirit emblems

Ten countable segments are the current **starting baseline**, with unmistakable full and empty states. The row should inherit Order ritual language rather than modern ammunition UI.

Temporary maximum-Spirit rewards may raise the resource above that starting ten-segment capacity. The HUD must therefore support additional capacity without treating ten as a permanent run ceiling. Acceptable implementation directions include adding compact extra segments, extending the row, or another equally countable presentation that preserves the player's understanding of current versus maximum Spirit.

Final baseline Spirit count and exact capacity-display implementation remain subject to combat/UI prototyping; the approved reward system only requires that temporary percentage-based capacity growth can be represented cleanly.

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

The module shows selected Aspect and Tier I-IV after unlock. Corruption uses dark crimson pressure language and must not resemble mana. Full-state feedback connects to the [Corruption Full Cue](../art_production/CORE_VFX.md#corruption-full-cue).

### Blood Art states

Before Tier II, Blood Art buildup is hidden, locked, or otherwise clearly unavailable without implying an error.

After Tier II, the Aspect module must support empty Blood, Blood building through combat, near-ready state, Blood Art ready, activation confirmation, active or resolving Blood Art, consumed or rebuilding state, and any later approved retained-Blood state.

Blood is mechanically tracked as a combat resource, but the interface is not required to use a separate large horizontal meter. The preferred direction is to integrate buildup into the existing Aspect emblem, seal, segments, veins, fill treatment, or another compact visual language.

The selected Aspect should remain more visually prominent than any single Technique because it is Akio's underlying weapon identity.

## Enemy health and posture indicators

### Standard enemies

Compact floating bars appear only while engaged or recently damaged. Posture uses the stronger visual channel because near-break state is the critical tactical read.

### Minibosses

Larger screen-anchored bar with name plate and optional portrait space.

### Bosses

Full-width presentation with name, health, posture, and phase markers where required.

## Damage numbers and status language

Use a hand-inked, gameplay-readable style rather than a clean modern UI font. Numbers rise and fade quickly to avoid stacking.

Current core damage readability uses red-family treatment for Health damage, pale yellow for posture damage, and a separate restrained treatment for healing. Technique-specific feedback must follow the approved family language rather than the retired elemental prototype:

- Echo — pale silver / twin-slash language,
- Rupture — gold / cracked-crest posture pressure,
- Seal — violet / binding-knot marks,
- Rift — ivory / blade-fracture language,
- Crimson — split-blood-drop / Vulnerable / direct Health-damage language.

Color cannot be the only differentiator; weight, outline, symbol, prefix, animation, or motion should reinforce type where practical.

## Deathblow prompt

The input prompt appears alongside the persistent world-space Deathblow Cue and should be understood in approximately 0.3 seconds. The cue and input prompt must read together without competing.

## World-space cue relationship

The HUD complements rather than duplicates [Core Combat and Corruption VFX](../art_production/CORE_VFX.md). Parry, Posture Break, Deathblow, Corruption Full, target marks, Blood Art activation, and Technique-trigger cues originate in world space or on Akio; the HUD provides persistent context and resource state.

## Delivery requirements

The artist supplies modular bars, fills, frames, icons, markers, number style sheets, Technique-state examples, and required active/inactive states. Godot owns layout, values, responsive anchoring, timing, fill motion, spawning, and visibility logic.

All elements must remain legible over Hushiro, Yomori, and Kagutsuchi backgrounds. Critical state should be understood in under one second without pulling attention away from attack windups.
