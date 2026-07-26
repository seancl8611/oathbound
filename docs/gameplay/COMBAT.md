---
id: GAMEPLAY-COMBAT
title: Combat System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - katana
  - posture
  - parry
  - deathblow
  - base-moveset
related:
  - CHAR-AKIO
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - UI-HUD
---

# Combat System

Oathbound uses high-angle 2D action combat centered on katana exchanges, posture pressure, parries, blocks, dodges, contextual counters, deathblows, and readable arena pressure.

## Design goal

The sword system should feel expressive without requiring many new buttons. One attack input supports multiple contextual outputs through repeated presses, hold/release, post-parry follow-up, and dash-to-attack flow.

Blood Aspects use those shared input slots to provide distinct sword weapon kits. The moves' timing, reach, geometry, damage, posture pressure, tracking, commitment, and recovery should create the playstyle naturally.

Bosses and larger encounters may use projectiles, ground danger, area denial, adds, movement tests, and clear attack opportunities. Combat should reward mastery without requiring one-mistake death or strict memorization as the default run experience.

## Core resources and states

- **Health:** conventional survival resource.
- **Posture:** pressure state that creates vulnerability when broken.
- **Spirit Emblems:** resource for prosthetic-tool use.
- **Corruption:** run-state pressure tied to Returning Blood and Shrine choices.

## Shared control and action framework

The control layout and contextual action slots remain recognizable across Blood Aspects. The exact sword move produced by an offensive input belongs to the selected Aspect.

### Basic Attack

Repeated presses produce the selected Aspect's primary attack sequence.

An Aspect may use:

- a one-, two-, three-, or otherwise justified finite sequence,
- different action names and animations,
- different timing, range, geometry, movement, tracking, commitment, and recovery,
- or another readable attack structure when it better serves the weapon kit.

No universal three-hit chain is required. `Quick Slash`, `Cross Cut`, and `Heavy Cleave` are not mandatory shared move names or roles.

A sequence is a set of attack options, not a required objective. The player may stop, defend, dash, change targets, use a Prosthetic, or abandon the sequence without failing the Aspect's intended gameplay.

### Held Attack

Holding and releasing Attack produces the selected Aspect's major secondary or committed sword action.

Held Attack may differ substantially through:

- move type,
- startup,
- reach,
- movement,
- geometry,
- target interaction,
- damage,
- enemy-posture pressure,
- and recovery.

It does not need to be one universal thrust or merely a stronger version of Basic Attack.

### Parry Counter

After a successful universal parry, pressing Attack produces the selected Aspect's direct offensive follow-up.

Parry timing, success rules, and defensive safety remain shared. The resulting sword attack may differ through reach, geometry, timing, damage, posture pressure, tracking, and recovery.

### Dash Attack

Pressing Attack during the approved late-dash window or shortly after a dash produces the selected Aspect's offensive dash follow-up.

The neutral dash remains shared. The chosen attack after it may differ, but it should not require a special finishing position merely to manufacture identity.

### Additional shared action families

- Sustained block
- Timed parry/perfect deflect
- Directional neutral dash with invulnerability timing
- Generic prosthetic activation
- Deathblow execution

All launch candidates retain meaningful access to attack, defense, movement, posture pressure, deathblows, Techniques, and the equipped prosthetic.

## Universal neutral movement and dash contract

Aspect selection must not weaken Akio's dependable ability to evade attacks or navigate combat spaces.

Every launch Aspect shares the same functional neutral:

- running and ordinary locomotion speed,
- dash travel distance,
- dash travel speed,
- startup timing,
- invulnerability window,
- neutral dash recovery,
- repeat-dash availability,
- directional support and steering rules,
- collision and hazard interaction,
- and standard access to movement, block, parry, and other actions after the dash.

Exact numerical values remain implementation and playtesting work, but the functional values are common across Aspects.

Aspects may differ through the optional attack performed after the dash. Attack-bound movement is valid when the sword action itself requires it. Forced offset positioning is not a default identity requirement.

Techniques, Relics, temporary effects, Corruption, or later exceptional mechanics may modify movement only after explicit approval and encounter-wide testing.

## Universal defense and player-posture contract

During the initial three-Aspect identity pass, every launch candidate uses the same functional:

- defense input,
- sustained-block rules and baseline efficiency,
- player-posture capacity,
- player-posture recovery rules,
- posture-break behavior,
- parry timing and success logic,
- and access to defense after ordinary movement and attacks.

Base block efficiency and player-posture size are not current Aspect identity levers.

The roster may revisit defensive differences only after the sword kits are playable and testing demonstrates that a specific variation improves the game enough to justify enemy compatibility, balance, onboarding, accessibility, UI, and production costs.

Removing sustained block is not part of the current launch baseline.

## Universal deathblow contract

Deathblows remain part of the shared combat and execution layer during the identity pass.

All launch Aspects use the same functional:

- enemy eligibility requirements,
- posture-break relationship,
- activation input,
- execution safety rules,
- standard positioning behavior,
- cue hierarchy,
- and base reward behavior.

An Aspect is not currently defined through unique deathblow movement, chaining, positioning, or effects.

Techniques or later explicitly approved systems may modify deathblow outcomes through universal rules.

## Technique relationship

Ordinary Techniques should target shared action categories such as:

- Basic Attack,
- Held Attack,
- Dash Attack,
- Parry Counter,
- Block,
- Parry,
- Deathblow,
- Prosthetic,
- Health,
- Enemy Posture,
- Player Posture,
- and Movement.

A Technique uses one rule across every Aspect. It may produce different practical value because the underlying moves differ.

Techniques must not:

- replace the Aspect's sword foundation with unrelated spell rotations,
- create a new button for every Technique,
- obscure attack direction or enemy response rules,
- make parry, posture, movement, or deathblows broadly optional,
- depend on an exact multi-Technique combination to function,
- or require separate Wolf, Wraith, and Ronin versions of an ordinary effect.

The [Technique System](TECHNIQUES.md) owns Technique rules. This file owns shared controls, movement, defense, deathblows, response language, and action-slot vocabulary. The selected Aspect owns the sword attacks assigned to the offensive slots.

## Response rules

Enemy attacks should communicate intended responses through silhouette, timing, and consistent visual language:

- **Standard attacks:** block, parry, dodge, or interrupt depending on context.
- **Perilous thrusts:** narrow forward commitment with a specific counter opportunity.
- **Sweeps:** broad low or circular threat requiring movement or the implemented sweep response.
- **Grabs/restraints:** special escape, parry, or avoidance rule.
- **Persistent hazards:** repositioning and space management.
- **Ranged pressure:** line awareness, deflection, dodge, or target prioritization.

## Enemy posture and deathblows

Enemy posture is not a second health bar. It represents control of the exchange. When posture breaks, the enemy enters a visually distinct vulnerable state and may become deathblow-ready.

Deathblows are punctuation and reward. Their cues, animation weight, and contact points must remain clear even in crowded encounters or when universal Execution Techniques add effects.

## Animation requirements

Akio requires one shared defensive, movement, hurt, death, deathblow, and prosthetic-use language.

Each approved Aspect may require distinct offensive animations for:

- its Basic Attack sequence,
- Held Attack,
- Parry Counter,
- Dash Attack,
- and any explicitly approved contextual attack transition.

Reuse is preferred where it preserves identity and readability. Exact animation counts remain blocked until the three-Aspect roster and overlap audit are approved.

## VFX requirements

- Frequent sword trails must communicate attack direction and reach.
- Held, counter, and dash attacks require readable treatment appropriate to the selected Aspect.
- Blood forms must not obscure guard state, parry timing, hazards, enemy telegraphs, or deathblow readiness.
- Technique cues should reuse approved combat, Aspect, and prosthetic language before requiring bespoke effects.

## Readability hierarchy

From quietest to strongest visual priority:

1. Frequent movement and idle effects
2. Normal hit and passive Technique feedback
3. Standard attack trails and projectiles
4. Technique thresholds, parry, and mechanic-specific warnings
5. Posture break and deathblow opening
6. Boss phase transition, Shrine choice, or major system state change

## Implementation boundary

Exact frame data, damage values, posture formulas, invulnerability durations, input buffers, cancel rules, Technique values, and encounter tuning belong in implementation documentation or code.

This file owns the shared control, neutral movement, defense, deathblow, response, and action-slot contracts. The Aspect documents own the exact sword kits.
