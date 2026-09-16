---
id: GAMEPLAY-COMBAT
title: Combat System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - katana
  - health
  - poise
  - interruption
  - guard
  - reprisal
  - backstab
  - base-moveset
  - crowd-pressure
related:
  - OVERVIEW-V2-COMBAT-DIRECTION
  - CHAR-AKIO
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - UI-HUD
---

# Combat System

Oathbound uses high-angle 2D action combat centered on katana attacks, free planar movement, authored attack commitment, target switching, spacing, interruption, selective kit-specific defense, positional attacks, and readable multi-enemy pressure.

## Design goal

Combat should feel responsive and aggressive without becoming weightless. Akio should be able to maintain momentum through a room, redirect between threats, and use movement or the current kit's defensive tools to answer danger.

Health is the normal defeat resource. Hidden Poise/interruption rules determine whether attacks disrupt an action. Standard enemies do not require a separate visible control meter or a mandatory finishing interaction before they can die.

## Core combat resources

- **Health:** player and enemy survival resource; reaching zero is the normal defeat condition.
- **Poise / interruption resistance:** hidden combat state controlling flinch, stagger, and interruption response. It is not a second visible Health bar.
- **Spirit Emblems:** resource for Prosthetic-tool use.
- **Corruption:** run-state pressure tied to Returning Blood and Shrine choices.
- **Blood / Aspect resources:** owned by their relevant Aspect/run systems rather than by the shared combat core.

## Shared movement and action framework

The shared combat layer provides locomotion, action execution, targeting, dashing, damage resolution, hit reaction, and integration hooks. Blood Aspects define the authored sword kit that fills those shared action roles.

Actions can independently define:

- startup, active, and recovery timing,
- reach and hit geometry,
- Health damage,
- Poise pressure,
- hit reaction and interruption strength,
- authored movement/displacement,
- steering allowance,
- tracking behavior,
- cancel/transition permissions,
- and presentation cues.

Movement should not be globally disabled merely because an attack is active. Each action owns its intended commitment.

## Basic Attack

Repeated Attack presses produce the selected Aspect's primary sequence.

An Aspect may use a two-, three-, four-, or otherwise justified finite sequence. Sequence length is not a global balance rule. The player may stop, dash, change targets, use another legal action, or abandon a sequence without failing the kit's intended gameplay.

Current qualitative launch identities remain:

- **Wolf:** fast, mobile pressure and sustained offense.
- **Wraith:** deliberate spacing, positional/rear access, and burst opportunities.
- **Ronin:** measured commitment, guard discipline, and Reprisal-centered defensive identity.

Exact move lists remain owned by the Aspect documents and runtime action definitions.

## Held Attack

Holding and releasing Attack produces the selected Aspect's major secondary or committed sword action. Held attacks can vary substantially in startup, reach, movement, damage, Poise pressure, tracking, release behavior, and positional payoff.

Held Attack is a shared input role, not a requirement that every Aspect use the same animation or attack archetype.

## Dash and Dash Attack

Dash is a fast repositioning action used both defensively and offensively. The player should be able to use it to cross danger, redirect pressure, gain positional advantage, or connect into an Aspect-authored Dash Attack where supported.

Dash behavior should remain readable and deterministic enough that enemy pressure can be learned and avoided without requiring a universal timed-defense response.

## Guard and Reprisal

Guard is not assumed to be the defining defensive action of every kit.

The **Ronin** retains a specific guard / Reprisal identity. Its defensive timing, resource interaction, follow-up opportunities, and animation language belong to the Ronin kit and should not be generalized into a global combat rule simply because the shared runtime exposes reusable support code.

Other kits may rely more heavily on dash, spacing, offense, movement, or their own authored defensive actions.

## Damage, Poise, and interruption

A landed hit can resolve several independent effects:

1. Health damage.
2. Poise/interruption pressure.
3. Visible flinch or recoil.
4. Cancellation or continuation of the target's current action.
5. Knockback/displacement.
6. Technique, Aspect, Relic, Prosthetic, or encounter hooks.

These effects do not need a universal ratio.

Examples:

- A light enemy may take Health damage and be interrupted by ordinary sword pressure.
- A committed swordsman attack may take Health damage but resist weak interruption until the commitment ends.
- A heavy beast may keep moving through a light hit while still losing Health.
- A guarding enemy may reduce or negate frontal Health damage while still receiving meaningful guard/Poise pressure according to its authored guard profile.

Poise values may vary by enemy role and by action state. They remain internal unless a later enemy-specific mechanic explicitly requires a dedicated readable indicator.

## Enemy guard

Enemy guard is authored per enemy rather than solved through one global block formula.

A guard profile can define:

- directional coverage,
- Health damage treatment,
- Poise/guard pressure,
- attacks that break or bypass guard,
- reaction to heavy attacks,
- legal follow-ups,
- and recovery before guarding again.

Guard frequency and duration are AI decisions. Guard should create a tactical problem without repeatedly freezing room flow.

## Backstabs and positional attacks

Rear-position attacks remain a valid authored combat language. A genuine backstab requires the player to earn the appropriate relative position/facing state; Techniques may reward that state without fabricating it.

Backstab bonuses, Vulnerable interactions, or Aspect-specific positional attacks should remain readable at the high-angle camera and should never depend on presentation-only sprite orientation when gameplay facing says otherwise. Gameplay facing remains authoritative.

## Enemy pressure and encounter flow

Standard encounters are multi-enemy pressure problems. Enemies may simultaneously:

- approach,
- flank,
- aim,
- prepare attacks,
- reposition,
- defend,
- or create hazards.

The Pressure Director or equivalent shared scheduling layer coordinates high-severity impact timing so difficulty comes from readable overlapping intentions rather than unavoidable hitbox stacks.

Enemy AI should be role-driven and deterministic enough for mastery. Randomness may vary choices and timing within authored bounds but should not substitute for coherent behavior.

## Enemy durability roles

- **Fodder/light:** low Health and low interruption resistance; easy to redirect through.
- **Standard:** moderate Health with one or two recognizable mechanics; responsive to offense.
- **Heavy/elite:** higher interruption resistance, stronger commitments, and more meaningful defensive behavior.
- **Boss/miniboss:** bespoke encounter logic, richer attacks, authored phase/stagger/vulnerability states, and dedicated UI where useful.

Standard enemies should not be miniature bosses.

## Bosses and authored vulnerability

Bosses may use bespoke stagger, vulnerability, transition, armor, phase, or recovery states. Those states are defined by the encounter and may create punish windows or change the spatial problem.

Boss combat should emphasize learnable patterns and changing phase problems rather than forcing one universal defensive solution across every attack.

## Technique integration

The Technique system may subscribe to approved current action events such as Basic Attack, Held Attack, Dash/Dash Attack, damage, kills, backstabs, family-specific effects, and kit-specific events when those events actually exist for the active kit.

A global Technique must not require an event that only one Aspect can produce unless eligibility explicitly restricts it to that kit.

## Presentation boundary

Gameplay combat remains authoritative in planar 2D. Camera projection, directional sprites, sprite animation, depth sorting, shadows, VFX, and telegraphs visualize the result but do not own:

- movement authority,
- attack timing,
- gameplay facing,
- target selection,
- hit geometry,
- damage,
- Poise/interruption,
- guard outcome,
- or AI decisions.

Offline 3D rigs may produce 2D directional animation frames. The rendered source rig is an art-production tool, not a runtime combat actor.

## Readability requirements

At normal gameplay scale the player should be able to identify:

- enemy role and facing,
- meaningful windup and impact timing,
- dangerous spatial zones,
- guard/protected states when relevant,
- clear hit confirmation,
- interruption or resistance feedback,
- target/focus feedback when used,
- and kit-specific defensive opportunities without covering the screen in universal markers.

Body animation, weapon motion, VFX, sound, and spatial telegraphs should carry most combat information. UI should supplement combat rather than duplicate every internal state.

## Current implementation rule

New combat work must follow this document and `V2_COMBAT_DIRECTION.md`. If older scripts, scenes, tests, UI, reward definitions, or documents encode a superseded shared-defense/finisher model, update or remove those assumptions rather than preserving them as current gameplay authority.