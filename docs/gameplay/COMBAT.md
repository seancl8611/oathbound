---
id: GAMEPLAY-COMBAT
title: Combat System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-25
topics:
  - katana
  - posture
  - parry
  - deathblow
  - backstab
  - base-moveset
related:
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

Oathbound uses high-angle 2D action combat centered on katana exchanges, posture pressure, parries, blocks, dodges, contextual counters, deathblows, positional attacks, and readable arena pressure.

## Design goal

The sword system should feel expressive without requiring many new buttons. One attack input supports multiple contextual outputs through repeated presses, hold/release, post-parry follow-up, and dash-to-attack flow.

Blood Aspects use those shared input slots to provide distinct sword weapon kits. The moves' timing, reach, geometry, damage, posture pressure, tracking, commitment, and recovery create the playstyle naturally.

Bosses and larger encounters may use projectiles, ground danger, area denial, adds, movement tests, and clear attack opportunities. Combat should reward mastery without requiring one-mistake death or strict memorization as the default run experience.

## Core resources and states

- **Health:** conventional survival resource.
- **Player posture:** pressure accumulated while Akio blocks or receives certain attacks; breaking it creates vulnerability.
- **Enemy posture:** control pressure that may create a deathblow opening when broken.
- **Spirit Emblems:** resource for Prosthetic-tool use.
- **Corruption:** run-state pressure tied to Returning Blood and Shrine choices.

## Shared control and action framework

The control layout and contextual action slots remain recognizable across Blood Aspects. The exact sword move produced by an offensive input belongs to the selected Aspect.

### Basic Attack

Repeated presses produce the selected Aspect's primary attack sequence.

An Aspect may use:

- a two-, three-, four-, or otherwise justified finite sequence,
- different action names and animations,
- different timing, range, geometry, movement, tracking, commitment, and recovery,
- or another readable attack structure when it better serves the weapon kit.

No universal three-hit chain is required. `Quick Slash`, `Cross Cut`, and `Heavy Cleave` are not mandatory shared move names or roles.

A sequence is a set of attack options, not a required objective. The player may stop, defend, dash, change targets, use a Prosthetic, or abandon the sequence without failing the Aspect's intended gameplay.

The current qualitative roster uses:

- Wolf: four attacks,
- Wraith: two attacks,
- Ronin: three attacks.

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
- stagger,
- and recovery.

It does not need to be one universal thrust or merely a stronger version of Basic Attack.

### Parry Counter

After a successful universal parry, pressing Attack produces the selected Aspect's direct offensive follow-up.

Parry timing and success rules remain shared. The resulting sword attack may differ through reach, geometry, timing, damage, enemy-posture pressure, tracking, stagger, and recovery.

### Dash Attack

Pressing Attack during the approved late-dash window or shortly after a dash produces the selected Aspect's offensive dash follow-up.

The neutral dash remains shared. The chosen attack after it may differ, but it should not require a special finishing position merely to manufacture identity.

### Additional shared action families

- Sustained block
- Timed parry/perfect deflect
- Directional neutral dash with invulnerability timing
- Generic Prosthetic activation
- Deathblow execution

All launch Aspects retain meaningful access to attack, defense, movement, posture pressure, deathblows, Techniques, and the equipped Prosthetic.

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

## Shared defense and player-posture contract

Every launch Aspect retains:

- the same defense input,
- sustained block,
- the same parry timing and success logic,
- the same posture-break behavior,
- the same enemy attack-response rules,
- and access to defense after ordinary movement.

The selected weapon kit may use modest differences in:

- base player-posture capacity,
- posture damage received while blocking,
- natural posture recovery direction,
- access to defense after an Aspect-specific attack completes,
- and Parry Counter payoff.

These differences must remain secondary to the sword moves and must be balanced by the kit's timing, range, movement, tracking, damage, and recovery.

No launch Aspect:

- removes sustained block or parry,
- receives a different parry window,
- gains automatic parries or counters,
- becomes immune to posture break,
- recovers posture freely while actively blocking,
- or cancels committed attacks into defense without an approved recovery window.

Current qualitative direction:

- Wolf uses a balanced guard profile suitable for close engagement.
- Wraith uses a functional baseline guard; its quick-footed identity comes from short attacks and recovery.
- Ronin uses higher posture stability and more efficient blocking, balanced by slower posture recovery and highly committed heavy attacks.

Exact posture and block values remain implementation and playtesting work.

## Universal deathblow contract

Deathblows remain part of the shared combat and execution layer.

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

## Universal backstab contract

A **backstab** is a universal positional hit classification, not a Crimson-only action and not a separate execution prompt.

- A direct eligible sword attack counts as a backstab when it genuinely contacts the target from within the target's rear region relative to that target's facing at the moment of contact.
- Backstab availability does not require a status, Technique, stealth state, scripted enemy animation, or special temporary window.
- Crimson does not make frontal hits count as backstabs, widen the rear region as its core solution, force enemy facing, or manipulate enemy activity to manufacture a positional result.
- Important enemies and bosses must expose a usable facing / rear relationship so positional Technique builds remain viable even when the enemy is non-humanoid.
- Exact rear-angle threshold, collision sampling, and any baseline backstab damage treatment remain implementation and playtesting work.

Approved mechanics may reward the classification. The Crimson status **Vulnerable**, for example, causes genuine backstabs against that enemy to deal substantially increased direct Health damage while the status is active.

## Technique trigger relationship

The run Technique layer may react to exactly five shared combat-action trigger classifications:

- Basic Attack,
- Held Attack,
- Dash / Dash Attack,
- Parry / Counter,
- Deathblow.

These are **trigger classifications, not equipment slots**. Oathbound has no global Technique inventory cap, and multiple owned Techniques may modify or respond to the same combat action when their individual effects permit it. Acquiring a Technique associated with one trigger does not make other Techniques associated with that trigger ineligible.

Slotless Supporting Techniques may interact with approved shared combat states such as posture, movement, family buildup, target state, backstab classification, or other existing mechanics. Prosthetic progression is separate and persistent; ordinary Techniques do not temporarily upgrade a particular Prosthetic.

A Technique uses one rule across every Aspect. It may produce different practical value because the underlying moves differ, so high-frequency and multi-hit interactions require normalization.

Techniques must not:

- replace the Aspect's sword foundation with unrelated spell rotations,
- create a new button for every Technique,
- obscure attack direction or enemy response rules,
- make parry, posture, movement, or deathblows broadly optional,
- depend on an exact multi-Technique combination to function,
- or require separate Wolf, Wraith, and Ronin versions of an ordinary effect.

The [Technique System](TECHNIQUES.md) owns Technique rules. This file owns shared controls, movement, defense, deathblows, backstab classification, response language, and action-trigger vocabulary. The selected Aspect owns the sword attacks assigned to the offensive actions.

## Response rules

Enemy attacks should communicate intended responses through silhouette, timing, and consistent visual language:

- **Standard attacks:** block, parry, dodge, or interrupt depending on context.
- **Perilous thrusts:** narrow forward commitment with a specific counter opportunity.
- **Sweeps:** broad low or circular threat requiring movement or the implemented sweep response.
- **Grabs/restraints:** special escape, parry, or avoidance rule.
- **Persistent hazards:** repositioning and space management.
- **Ranged pressure:** line awareness, deflection, dodge, or target prioritization.

## Enemy posture and deathblows

Enemy posture is not a second health bar. It represents control of the exchange. When posture breaks, the enemy enters a visually distinct execution-vulnerable state and may become deathblow-ready. This posture-break state is separate from the capitalized Crimson status **Vulnerable**.

Deathblows are punctuation and reward. Their cues, animation weight, and contact points must remain clear even in crowded encounters or when Deathblow Techniques add effects.

## Damage-number feedback contract

Floating enemy damage numbers represent **Health damage only**. They are not posture numbers, attack-power readouts, or a generic confirmation that a hit connected.

- A blocked strike that removes no enemy Health may still add enemy posture, but it produces **no floating damage number**.
- Pure posture pressure from attacks, parries, deflects, Techniques, or other effects produces no floating damage number by itself.
- A hit that removes Health and also adds posture may show a floating number for its Health-damage component; the posture portion remains separate presentation.
- Enemy posture is communicated through the posture bar, guard/block reactions, hitstop, VFX, and audio rather than through Health-style numbers.
- The damage-number accessibility setting may hide Health numbers entirely without changing Health or posture mechanics.

## Animation requirements

Akio requires one shared defensive, movement, hurt, death, deathblow, and Prosthetic-use language.

Each approved Aspect may require distinct offensive animations for:

- its Basic Attack sequence,
- Held Attack,
- Parry Counter,
- Dash Attack,
- and any explicitly approved contextual attack transition.

Reuse is preferred where it preserves identity and readability. Wolf, Wraith, and Ronin are locked at qualitative paper-design depth; exact final animation counts remain implementation-brief and playable-validation work.

## VFX requirements

- Frequent sword trails must communicate attack direction and reach.
- Held, counter, and dash attacks require readable treatment appropriate to the selected Aspect.
- Backstab and Vulnerable feedback must reinforce positional contact without obscuring enemy facing or implying a stealth state when none exists.
- Blood forms must not obscure guard state, parry timing, hazards, enemy telegraphs, or deathblow readiness.
- Technique cues should reuse approved combat and Aspect language before requiring bespoke effects; established shared VFX may also be reused where mechanically accurate.

## Readability hierarchy

From quietest to strongest visual priority:

1. Frequent movement and idle effects
2. Normal hit and passive Technique feedback
3. Standard attack trails and projectiles
4. Technique thresholds, parry, and mechanic-specific warnings
5. Posture break and deathblow opening
6. Boss phase transition, Shrine choice, or major system state change

## Implementation boundary

Exact frame data, damage values, posture formulas, invulnerability durations, input buffers, cancel rules, rear-angle thresholds, Technique values, and encounter tuning belong in implementation documentation or code.

This file owns the shared control, neutral movement, defense, deathblow, backstab, response, damage-number feedback, and action-trigger contracts. The Aspect documents own the exact sword kits.
