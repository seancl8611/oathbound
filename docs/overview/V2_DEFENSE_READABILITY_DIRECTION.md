# Combat V2 Defense and Readability Direction

Status: approved current direction, September 2026.

## Purpose

Oathbound's defense/readability model supports fast multi-enemy combat rather than a duel structure built around one universal timed-defense exchange.

The player should primarily read **space, enemy count, target priority, positioning, attack commitment, movement options, and the defensive tools belonging to the active kit**.

## Core resource hierarchy

- **Health** decides normal player and enemy defeat.
- **Poise / interruption resistance** is hidden and decides whether a hit causes immediate flinch, stagger, or action interruption.
- Standard enemies do not expose a second universal control meter.
- Standard enemies die through Health loss; no additional universal finishing interaction is required.
- Bosses/minibosses may use encounter-specific stagger, vulnerability, armor, transition, or recovery states when those improve the encounter.
- Standard enemies should not carry floating internal-state bars. Boss/miniboss Health presentation may remain where it improves encounter readability.

## Poise owns immediate interruption resistance

Poise is not another player-facing resource bar. It answers one local question:

> **Does this hit interrupt this actor's current action right now?**

Current Hushiro role intent remains:

| Role | Neutral | Committed | Result |
| --- | ---: | ---: | --- |
| Hollow / Hound / Archer | 1 | 1 | ordinary sword pressure can interrupt them readily |
| Swordsman / Bilemass | 1 | 2 | easy to disrupt while neutral; committed moves resist lighter hits |
| Warden / brute-control bodies | 2 | 3 | light pressure does not casually erase commitments; heavier tools matter |

Exact values are tuning baselines, not immutable balance law. The architectural distinction is what matters: lighter bodies are easier to interrupt; heavy/brute bodies earn resistance through Poise rather than inflated Health.

## Player defense is kit-specific

There is no requirement that every Blood Aspect expose the same timed defensive action.

### Ronin

Ronin keeps its authored **guard / Reprisal** identity. Reprisal is a Ronin mechanic and should be presented, tuned, documented, and tested as such.

### Other kits

Wolf, Wraith, and future kits may answer danger through different combinations of:

- movement,
- dash,
- spacing,
- attack interruption,
- unique defensive actions,
- invulnerability/avoidance windows where explicitly authored,
- or other kit-specific tools.

Shared runtime helpers may support multiple kits, but shared code does not imply a universal player-facing mechanic.

## Ordinary attack readability

Ordinary enemy attacks should communicate their answer through the actor and the world rather than a large universal icon.

Primary cues are:

- body pose and silhouette,
- weapon direction,
- windup timing,
- movement trajectory,
- weapon trail or impact VFX,
- audio,
- spacing,
- and recovery.

The player should be able to distinguish a committed dangerous action from neutral movement without needing to read an internal combat resource.

## Guard readability

When an enemy guards, the state should be obvious from stance, weapon/shield position, reaction, and impact feedback.

Guard may alter Health damage, Poise pressure, permitted follow-ups, or break behavior according to the enemy's authored guard profile. A blocked hit should clearly communicate that guard caused the result.

## Projectiles

Projectile flight and collision remain authoritative gameplay information. Telegraphs should make origin, trajectory, danger, and impact timing understandable at the accepted high-angle camera.

A projectile does not inherit a special response merely because another enemy attack uses one. Any exceptional counter or reflection behavior must be authored by the projectile/kit that owns it.

## Hazards and ground attacks

Spatial attacks use spatial warnings. Landing zones, puddles, explosions, delayed eruptions, and other arena hazards should communicate:

- affected area,
- activation timing,
- persistence when relevant,
- and whether the zone is safe again.

Do not reuse unrelated defensive language for a positional hazard.

## Forgiveness target

Difficulty should primarily come from:

- enemy groups and composition,
- overlapping intentions,
- target priority,
- movement and geometry,
- ranged/hazard pressure,
- attack commitment and Poise differences,
- waves,
- and recovery openings.

Ordinary combat should not turn every incoming hit into a test of one narrow timing mechanic.

## Boss and miniboss exceptions

Bosses and minibosses can introduce bespoke response rules when the encounter earns them. Examples include authored armor breaks, stagger windows, phase counters, vulnerability windows, reflection mechanics, or unique defensive prompts.

These are encounter-specific rules. They do not redefine the standard enemy or player resource model.

## Presentation budget

Readability systems should spend visual attention where it matters. Standard enemies should rely primarily on animation, silhouettes, VFX, audio, and spatial telegraphs rather than carrying multiple bars and icons.

High-value boss/miniboss mechanics may justify additional UI because the player is solving a bespoke encounter rather than reading a crowded standard room.

## Implementation contract

1. Health remains the normal defeat authority.
2. Hidden Poise/interruption owns immediate reaction resistance.
3. Ronin guard/Reprisal remains character-specific.
4. Standard enemy UI stays compact and avoids exposing internal control state as a universal bar.
5. Boss/miniboss stagger or vulnerability states are authored per encounter.
6. New gameplay content must not infer shared defense mechanics from reusable runtime helpers.
7. Isometric 2D presentation communicates these states without taking gameplay authority from the planar simulation.

This direction is a design authority, not a manual-playtest gate. Continue coherent implementation work and request focused playtests when a runtime or readability question specifically benefits from player evidence.