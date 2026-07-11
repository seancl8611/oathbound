---
id: GAMEPLAY-PROSTHETICS
title: Prosthetic Tools
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - prosthetics
  - spirit-emblems
  - combat-tools
  - prosthetic-techniques
related:
  - GAMEPLAY-TECHNIQUES
  - ART-PROSTHETIC-VFX
  - CHAR-AKIO
  - ART-MILESTONE-04
---

# Prosthetic Tools

Akio carries eight ritualized combat tools operated primarily through a shared generic prosthetic-use animation and tool-specific effects. Each tool solves a distinct tactical problem rather than serving as a generic damage button.

## Current roster

| Tool | Tactical role | Core functional boundary |
|---|---|---|
| Beast-Bane Whistle | Area interrupt and anti-beast stagger | Short-radius pulse; stronger reaction on beast-type enemies |
| Thunder Rod | Precision line attack and Shock setup | Hits the first target in the aimed line and applies Shock |
| Smoke Gourd | Target-break and temporary control zone | Creates a short-lived smoke field that disrupts enemy targeting |
| Fang Harpoon | Interrupt and modest enemy reposition | Medium-range shot that pulls the struck target slightly toward Akio |
| Mirror Umbrella | Timed protection and stored-posture release | Active guard negates hits, then releases stored posture pressure on close |
| Flame Vent | Close-range HP damage and Burn | Short forward cone with readable Burn application |
| Mist Raven | Invulnerable blink and reposition | Very short fixed-distance vanish and reappearance |
| Bloodletting Gourd | Risky recovery and aggression sustain | Trades Spirit for immediate healing and a short healing-on-hit window |

## Loadout boundary

The initial run structure assumes one equipped prosthetic at a time. Permanent progression may unlock tools and improve their baseline behavior through the Forge. Any later second-tool loadout is a separate scope decision and is not required by the Technique system.

## Shared resource model

Prosthetics use Spirit emblems or the project's final equivalent shared tool resource. Exact costs, cooldowns, charges, and upgrade values remain tuning variables until implementation and playtesting define them.

## Permanent and run-only growth

- **Forge:** unlocks prosthetics, improves baseline reliability, and owns permanent branches.
- **Technique system:** offers temporary Prosthetic Techniques for the currently equipped tool.

A major Prosthetic Technique occupies one of Akio's four active Technique slots. Its one-step refinement is slotless and may appear only while the base Prosthetic Technique is active.

Prosthetic Techniques do not use a separate in-run tree or interface.

Example:

- **Scorching Wake:** Flame Vent leaves a small scorched zone.
- **Fed Embers — refinement:** the zone lasts longer and applies greater pressure.

Only the currently equipped tool contributes Prosthetic Techniques to the reward pool.

## Interaction principles

- Tools should create openings, solve positioning problems, or support a build identity.
- Direct-damage tools should not make sword combat, parry, posture, or deathblow play optional.
- Status applications must use the same approved Shock, Burn, and other status definitions used by enemies, HUD, Techniques, and damage numbers.
- Mist Raven and Wraith Aspect must remain mechanically and visually distinct.
- Mirror Umbrella requires explicit active, inactive, and release states.
- Smoke cannot hide essential silhouettes or attack tells.
- Pull, blink, and interrupt behavior must respect boss and elite immunity rules where applicable.
- Prosthetic Techniques should strengthen the tool's existing tactical role rather than transform it into an unrelated ability.

## Required implementation data per tool

- Spirit cost
- cooldown or charge rule
- startup, active, and recovery timing
- valid targets and immunity rules
- hitbox, line, cone, or radius data
- status duration and stack behavior
- posture and HP effects
- permanent Forge upgrade path
- eligible Prosthetic Techniques and one-step refinements
- icon, world object, VFX, sound, and animation dependencies

## Production rule

Most tools should use Akio's shared `prosthetic_use` pose plus layered tool objects and effects. Any tool requiring a unique full-body animation is an explicit scope increase and must be identified before quotation.

Temporary Technique effects should extend the approved prosthetic VFX language rather than require a second complete effect family for the same tool.

The authoritative visual requirements belong in [Prosthetic Tool VFX](../art_production/PROSTHETIC_VFX.md). Technique-specific production rules belong in [Technique VFX](../art_production/TECHNIQUE_VFX.md).
