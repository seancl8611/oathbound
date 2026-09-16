---
id: ART-CORE-VFX
title: Core Combat and Corruption VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Core Combat and Corruption VFX

Shared effects communicate hit direction, danger, movement, state changes, and impact without hiding actor silhouettes or enemy telegraphs at the accepted high-angle camera.

## Shared combat bundle

### Hit Spark
Ordinary damage confirmation. Compact, directional, and short-lived. Stronger attacks may use heavier variants without becoming screen-filling explosions.

### Sword Trail
Clarifies Akio's blade path. Stage 1 needs a light Quick Slash trail, a clearly different Cross Cut path, and a heavier Heavy Cleave treatment. Trails support animation readability; they do not define hitboxes or impact timing.

### Interruption / heavy-impact response
Hidden Poise is not a visible meter, but a meaningful stagger/interruption may receive a brief body-centered impact/recoil cue when animation alone is insufficient. This is feedback for a resolved reaction, not a universal posture-break state.

### Guard contact
Actors that actually own Guard may use a compact guarded-contact cue distinct from a normal Health hit. Ronin Reprisal may receive a stronger authored response cue when unlocked. Do not imply that every Aspect or enemy owns the same Guard/counter rules.

### Danger / spatial telegraphs
Projectiles, AoEs, grabs, committed lunges, hazards, and boss mechanics use shape/timing language appropriate to the threat. Telegraphs remain separate from actor body sprites where practical.

## Retired shared cues

Do **not** produce universal assets for a player/enemy Posture bar, generic Posture Break, Deathblow availability, or shared execution prompt. Those systems are not part of the current standard combat loop.

Boss/miniboss encounters may still commission bespoke vulnerability, stagger, armor-break, phase-transition, or punish-window cues when their own encounter authority requires them.

## Corruption / Shrine cues

- **Corruption Full:** restrained dark-crimson pressure showing that Shrine resolution is available.
- **Embrace:** controlled Returning Blood surge communicating Aspect Tier advancement.
- **Resist:** cooler stabilization/release language communicating restraint without advancement.

## Delivery rule

VFX source files and game-ready 2D outputs must remain readable over Hushiro, Yomori, and Kagutsuchi with multiple enemies and atmosphere active. Effects may follow gameplay events but never become combat authority.
