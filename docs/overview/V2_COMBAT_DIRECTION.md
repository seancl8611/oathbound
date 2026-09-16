---
id: OVERVIEW-V2-COMBAT-DIRECTION
title: Oathbound V2 Combat Direction
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - v2
  - combat-direction
  - player-movement
  - enemy-pressure
  - stagger
  - poise
  - guard
  - bosses
  - blood-aspects
  - hunter-fantasy
related:
  - OVERVIEW-GAME
  - OVERVIEW-DESIGN-PILLARS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
---

# Oathbound V2 Combat Direction

This document is the approved high-level authority for Oathbound's current Combat V2 direction. Runtime, gameplay documentation, encounter design, and presentation should converge on this model.

## Combat identity

Oathbound is a Japanese supernatural dark-fantasy action roguelite. Akio should feel like an aggressive supernatural hunter moving through corrupted warriors, spirits, monsters, and beasts rather than a character forced into a sequence of formal one-on-one duels.

The target combat fantasy is:

> **Move aggressively, attack into openings, stagger and interrupt vulnerable enemies, reposition through danger, switch targets fluidly, use the defensive tools belonging to the current kit, and keep momentum through the room.**

## 1. Player movement is free-flow and action-specific

Neutral locomotion, authored action displacement, steering, dashes, knockback, and other impulses should combine according to the current action instead of being suppressed by one global attacking state.

Different actions can preserve different amounts of steering and commitment. Fast attacks may carry substantial motion while heavy attacks may plant Akio more firmly. Movement restriction belongs to the authored action.

Dashes are both defensive and aggressive repositioning tools. Target changes and legal action transitions should feel immediate enough to support multi-enemy combat.

## 2. Standard combat is about room pressure, not duel chains

Standard encounters should contain enemies that are individually readable and reasonably quick to damage, interrupt, stagger, or kill. Difficulty should come primarily from:

- target prioritization,
- movement and positioning,
- overlapping enemy intentions,
- attack geometry,
- ranged and spatial pressure,
- enemy combinations,
- and maintaining offensive momentum safely.

Ordinary enemies do not require a second visible break meter or a special finisher before they can be defeated. **Health is the standard defeat condition.**

## 3. Health, hidden Poise, and hit reaction have separate jobs

Combat V2 uses separate concepts for durability and control:

- **Health** answers how close an actor is to defeat.
- **Poise / interruption resistance** is an internal combat value used to decide whether incoming pressure causes stagger, interruption, recoil, or another authored loss-of-control state.
- **Hit reaction** is the visible response to impact and can vary independently from raw Health damage.

Poise is not a universal visible player-facing meter. It exists to support authored reaction and interruption rules.

A hit can independently determine Health damage, Poise pressure, flinch/recoil, action interruption, and displacement. This lets a light enemy recoil from ordinary strikes while a heavy beast can continue a committed action through weaker impacts without becoming immune to Health damage.

## 4. Enemy tiers have distinct resistance and pressure roles

### Fodder / light enemies

- Low durability and low interruption resistance.
- Usually one clear combat job.
- Frequently vulnerable to clean offense.
- Support movement, target switching, build interactions, and room rhythm.

### Standard enemies

- Moderate durability.
- One or two recognizable mechanics or attack families.
- Still responsive to offense and should not feel like miniature bosses.
- Become more dangerous through combinations with other roles.

### Heavy / elite enemies

- Higher interruption resistance and more meaningful commitments.
- May use authored guard, armor, evasive, counter, or other defensive behavior.
- Preserve more of Oathbound's martial-duel DNA without imposing it on every encounter.

### Bosses

- Bespoke scripted encounters with richer patterns, arena interaction, transformations, phase changes, and deliberate punish windows.
- May use authored stagger or vulnerability states, but those states are encounter-specific rather than a shared global kill loop.

## 5. Defense is kit-specific where identity demands it

Combat V2 does not assume one universal timed-counter mechanic shared by every player kit.

The Ronin identity retains its authored **guard / Reprisal** relationship. Other kits may solve pressure through movement, offense, dashes, spacing, unique defensive actions, or other kit-specific rules.

Reprisal should be documented and implemented as a Ronin-facing mechanic. Sustained guard, where available, should preserve the owning kit's identity rather than become the default answer to every room.

## 6. Enemy guard is authored behavior

Enemy blocking is a specific defensive behavior, not a universal Health-to-control conversion formula. A relevant enemy can own a guard profile defining properties such as:

- Health damage treatment while guarding,
- Poise/interruption pressure while guarding,
- directional coverage,
- attacks that break or bypass guard,
- reaction to heavy impacts,
- guard-break consequences,
- and special-effect behavior through guard.

AI behavior independently controls when the enemy chooses guard, how long it may hold it, what ends it, and what follow-up actions are legal.

Guard must remain readable and must not repeatedly erase room momentum.

## 7. Enemy AI is purposeful and consistent

Enemies should use authored roles, stable attack scripts, deliberate decision intervals, tactical movement goals, readable commitment, and readable recovery. Randomness may modify choices, but should not replace authored behavior with frame-by-frame noise.

Defensive choices belong to the same model. Guard, evasions, counters, protected attacks, and retreats should be intentional actions with understandable start and end conditions.

## 8. Crowd pressure overlaps intentions without creating unreadable impact stacks

Combat V2 uses a pressure-oriented encounter model rather than a strict single-attacker turn system.

Several enemies may approach, flank, aim, wind up, reposition, or create spatial pressure at once. High-severity damaging impacts should still be coordinated enough that the player can read and answer the room.

More enemies should create more spatial decisions, not unavoidable simultaneous hitboxes.

## 9. Beasts, spirits, and martial enemies behave according to their fantasy

Beasts and transformed enemies can rush, circle, pounce, retreat, use unusual geometry, or carry committed actions through weak impacts according to authored rules. Spirits can apply movement or spatial pressure that would be inappropriate for a human swordsman.

Disciplined martial enemies remain valuable because they contrast with this wider enemy population rather than defining all combat pacing.

## 10. Boss phases change the problem

Boss encounters should change what the player is solving through tools such as:

- new attack families,
- transformation or mutation,
- arena or hazard changes,
- changed movement rules,
- summons when they serve the encounter,
- changed ranges and pressure zones,
- authored stagger/vulnerability rules,
- and different punish windows.

Bosses may enter authored stagger, vulnerability, phase-transition, or recovery states. Those states are bespoke encounter rules, not a universal standard-enemy system.

## Techniques and progression

Techniques may react to approved current combat events, but their taxonomy must follow the current runtime and owning kit. Global Technique definitions must not assume a defense event that only one kit owns.

Kit-specific hooks such as Ronin Reprisal may be used where the owning kit supports them. Counts, trigger sets, and unlock totals are owned by the current Technique catalog/runtime rather than by obsolete fixed-action matrices.

## Presentation boundary

Combat authority remains planar 2D. The approved high-angle/isometric-style Camera2D presentation, directional 2D actors, feet-based depth sorting, illustrated environments, and 2D VFX communicate combat but do not determine hit timing, movement authority, targeting, damage, Poise, guard, or AI outcomes.

Offline 3D rigs may be used to render directional 2D art. Live 3D actors are not part of the runtime combat model.

## Validation standard

A Combat V2 change is successful when it improves one or more of the following without violating the rules above:

- movement responsiveness,
- attack flow,
- target switching,
- hit readability,
- interruption clarity,
- enemy-role readability,
- multi-enemy pressure,
- kit identity,
- boss phase readability,
- or the player's ability to understand why damage, guard, stagger, or interruption occurred.

When implementation and documentation disagree, reconcile both around this current direction rather than preserving superseded assumptions for compatibility.