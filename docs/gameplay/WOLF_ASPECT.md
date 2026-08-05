---
id: GAMEPLAY-WOLF-ASPECT
title: Wolf Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-05
topics:
  - blood-aspects
  - wolf
  - tier-progression
  - blood-arts
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Wolf Blood Aspect

## Status

Wolf is an approved member of the three-Aspect launch roster. This document owns Wolf's Tier 0 weapon kit and its current fixed Tier I-IV progression package.

Tier II **Blood Hunt** is approved through the current cross-roster audit. Tiers I, III, and IV remain working drafts scheduled for redistribution review now that the Blood Art form is settled. Exact numerical values, frame data, hitboxes, animation timing, resource tuning, and final presentation remain implementation and balance work.

## Weapon identity

**Wolf is the fast close-range pressure and pursuit kit.**

Wolf is defined by:

- the fastest and longest Basic Attack sequence in the launch roster,
- short effective reach,
- player-directed forward movement attached to attacks,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- practical transfer between nearby targets through player aim and attack geometry,
- and dangerous recovery after missed pursuit or extended commitments.

Wolf does not use corrective tracking, hidden homing, or post-input target correction. Its attacks follow the direction selected by the player, their authored arcs, and their authored forward travel.

The player never needs to complete or preserve Wolf's sequence. Each attack must remain useful on its own, and the player may stop, defend, dash, redirect, use a Prosthetic, or disengage whenever necessary.

## Shared systems

Wolf retains universal locomotion, neutral dash, defense input, parry timing, posture rules, deathblows, Technique inventory, and prosthetic controls.

Its aggression comes from the sword kit rather than a stronger neutral dash, automatic targeting, attack invulnerability, or a separate combo meter.

# Tier 0 weapon kit

## Basic Attack sequence

1. **Fang Slash** — fast advancing opener with short reach and moderate pressure.
2. **Rending Cross** — broader returning cut that continues pressure and catches nearby interference.
3. **Raking Fang** — fast pursuit strike with strong forward travel along the player's chosen direction.
4. **Blood Cleave** — broad committed final cut with strong damage and posture pressure but severe miss recovery.

The sequence cadence is:

> fast entry → broader pressure → close pursuit → committed finish

Blood Cleave is not a required finisher. Fang Slash and Rending Cross must provide worthwhile value during short openings, and Raking Fang offers another fast decision before the player chooses whether Blood Cleave is safe.

## Held Attack — Predator's Passage

A long, narrow pursuit lunge that converts distance into close engagement.

- committed player-directed travel,
- fixed attack line after release,
- strong single-target health and posture damage,
- no additional invulnerability,
- severe recovery after a miss.

Predator's Passage closes distance and stops when it reaches an enemy or blocking obstacle. It does not pass through the target.

## Dash Attack — Hunting Slash

A fast advancing re-entry cut after the universal neutral dash.

- quick startup,
- short-to-medium attack reach,
- strong forward movement along the selected direction,
- and a close finishing position or constrained pass-through on a successful hit.

When Hunting Slash strikes an eligible ordinary enemy, Akio may carry through that enemy along the original attack direction only when safe and valid space exists on the far side. Against bosses, elites, heavy enemies, walls, blocked geometry, or invalid destinations, Akio stops on the near side.

The universal dash itself is unchanged. Hunting Slash is an optional offensive commitment after it and never teleports, tracks, or automatically places Akio behind a target.

## Parry Counter — Fang Reversal

A fast advancing retaliatory cut after the universal parry.

- short reach,
- forward step,
- strong enemy-posture pressure,
- moderate health damage,
- limited nearby coverage.

It does not alter parry timing, add invulnerability, or guarantee safety against surrounding enemies.

## Defensive profile

Wolf retains functional blocking and universal parry timing.

Its defensive profile is broadly balanced:

- enough player-posture stability for close engagement,
- no special block-efficiency advantage,
- no automatic posture recovery from ordinary attacking,
- and strong offensive return through Fang Reversal or Hunting Slash.

Wolf is not the roster's strongest guard.

## Combat profile

| Property | Approved direction |
|---|---|
| Preferred range | Close |
| Basic sequence | Four attacks |
| Cadence | Fastest and most sustained |
| Per-hit damage | Moderate |
| Sustained output | Highest while connected |
| Enemy posture | Repeated pressure |
| Attack movement | Strongly forward and player-directed |
| Held identity | Pursuit |
| Main failure state | Overextension after missed or prolonged commitments |

## Firm tradeoffs

- short reach,
- forward overcommitment,
- dangerous whiff recovery,
- side and rear pressure,
- and ranged enemies when approach is denied.

Wolf must not depend on completing its full sequence to produce competitive damage or posture pressure against bosses.

# Fixed Tier progression

Each Wolf Tier provides a concrete net-positive combat benefit while preserving Wolf's inherent pursuit tradeoffs. Stronger movement and pursuit remain player-directed, and poor aim or timing can still leave Akio in an unsafe position. This limitation comes from how Wolf's actions operate rather than from a separate named drawback or added penalty attribute.

## Tier I — Blood Tempo

When Fang Slash, Rending Cross, or Raking Fang successfully hits an enemy, Akio may begin the next Basic Attack earlier during the current attack's recovery.

After Predator's Passage, Hunting Slash, or Fang Reversal successfully hits, Akio may instead continue directly into Rending Cross during that attack's recovery. The sequence may then continue normally into Raking Fang and Blood Cleave.

When Hunting Slash carries Akio through an eligible ordinary enemy, the immediate Rending Cross deals increased health and enemy-posture damage if it strikes that same enemy from behind.

- These continuations are always optional.
- The rear follow-up does not automatically turn Akio toward the crossed enemy.
- The rear bonus is lost if Akio performs another action first or Rending Cross does not strike the same enemy from behind.
- The benefit exists only during the current attack's recovery and is not stored.
- Missed attacks receive no benefit.
- Block, parry, dash, and Prosthetic actions are not accelerated.
- This is an authored Wolf interaction rather than a universal backstab-damage rule.

Raking Fang and Hunting Slash travel slightly farther along the direction chosen by the player. Hunting Slash may therefore carry Akio farther through an eligible ordinary enemy when the hit and destination are valid. Neither attack can turn, home, or correct its path after it begins.

Blood Tempo remains a working Tier I draft and will be reviewed for possible simplification during Wolf Tier redistribution.

## Tier II — Blood Hunt

Tier II unlocks Wolf's Blood meter and immediate Blood Art.

Wolf gains Blood through meaningful sword damage, enemy-posture contribution, Fang Reversal after a parry, posture breaks, and deathblows. Blood Hunt requires a full meter, activates manually, consumes the stored Blood, and generates no Blood while the immediate Art is resolving. Blood generation resumes after Blood Hunt ends.

Exact capacity, gain values, activation timing, travel, collision, and anti-farming thresholds remain tuning work.

### Blood Art — Blood Hunt

Akio releases a violent Blood howl, selects a direction during a brief readable preparation, and launches into a long committed pursuit while a massive Blood wolf form manifests around him. The rush tears through eligible ordinary enemies before ending in **Blood Fang**, a crushing jaw strike.

Blood Hunt compresses Wolf's pressure-and-pursuit identity into one decisive action:

> create close-range disorder → choose a line through the encounter → tear through the pack → finish on the priority target

### Guaranteed activation value

When Blood Hunt commits:

- Akio restores a limited amount of Health,
- a short-range Blood howl briefly staggers nearby ordinary enemies,
- and stronger enemies and bosses receive modest enemy-posture pressure without automatic stagger.

These effects resolve when the Blood meter is spent and do not depend on the pursuit or Blood Fang connecting. Blood Hunt therefore provides practical value even when the chosen route later misses, is interrupted by an overriding attack, or cannot reach the intended target.

Blood Hunt does not clear player posture. Immediate Health recovery is Wolf's primary activation recovery direction.

### Pursuit line

After the howl, Akio commits along the player-selected direction.

- The direction is fixed once the pursuit launches.
- Blood Hunt cannot curve, turn, track, home, retarget, or correct toward an enemy.
- It grants no additional neutral-dash invulnerability.
- The rush travels farther and carries greater force than Predator's Passage.
- Eligible ordinary enemies crossed directly take reduced Health damage and meaningful enemy-posture damage.
- Each crossed enemy may be damaged only once by the pursuit portion.
- Akio may pass through an eligible ordinary enemy only when safe and valid space exists along the original line.
- The pursuit stops against elites, bosses, heavy enemies, walls, blocked geometry, or invalid destinations.

Blood Hunt is not a locked multi-target cinematic. It resolves only against enemies and geometry occupying the line selected by the player.

### Blood Fang

When the pursuit reaches a stopping target or obstacle, or reaches its maximum authored distance, the manifested wolf jaws snap shut in Blood Fang.

Blood Fang provides:

- strong direct Health damage,
- strong enemy-posture damage,
- powerful ordinary-enemy stagger where enemy rules permit,
- a wider contact area than Predator's Passage,
- and heavy impact feedback.

Against a boss or elite, Blood Hunt functions as a committed direct approach ending in Blood Fang. Against groups, the player may line up ordinary enemies before finishing on a priority target or at the route endpoint.

The final bite does not restore additional Health by default. Blood Hunt's limited Health recovery is guaranteed at activation rather than dependent on landing the endpoint.

### Interruption and damage rules

During the launched high-speed pursuit, light ordinary enemy hits do not interrupt Blood Hunt.

- Those hits still deal their full normal Health damage, player-posture damage, status buildup, and other valid effects.
- A posture break interrupts the Art.
- Lethal damage interrupts the Art.
- Perilous or unblockable attacks, authored grabs, launches, and overriding knockdowns interrupt normally.
- The protection applies only after the pursuit launches; the brief directional preparation remains vulnerable under ordinary rules.
- Blood Hunt provides no block, parry, damage reduction, invulnerability, automatic counter, posture restoration, or protection during ending recovery.

The activation howl helps create a brief close-range opening, but it does not guarantee a safe route or prevent stronger enemies from responding.

### Failure state

Blood Hunt preserves and intensifies Wolf's normal pursuit risk.

A poorly selected route may cause Akio to:

- pass the intended target,
- stop against the wrong enemy or obstacle,
- finish in a surrounded position,
- or complete Blood Fang into empty space at maximum distance.

A missed or poorly positioned final bite receives severe authored recovery. Blood Hunt does not place Akio safely behind a target, return him to his starting point, or protect him after the action ends.

Blood Hunt remains distinct from Predator's Passage. Predator's Passage is Wolf's repeatable single-target Held pursuit; Blood Hunt is a full-meter encounter-crossing line attack with guaranteed activation recovery, through-enemy pressure, and a major Blood Fang endpoint.

The resulting Tier II rhythm is:

> build Blood through aggressive sword combat → activate for immediate Health recovery and close-range disruption → choose one committed pursuit line → tear through eligible ordinary enemies → finish in Blood Fang and accept the resulting position

## Tier III — Fanged Guard

Tier III currently upgrades Predator's Passage while it is being charged.

While charging Predator's Passage, Akio forms a Blood jaw around the front of his body. The first frontal blockable enemy attack that reaches Akio:

- is blocked using normal player-posture rules,
- does not cancel the Held Attack,
- and immediately completes Predator's Passage's charge.

The player still chooses when and where to release the attack.

Fanged Guard does not protect against attacks from the side or rear or against unblockable attacks. It can block only one attack during each charge.

Fanged Guard helps Akio complete Predator's Passage but does not make the resulting pursuit safe. The attack retains its selected direction and severe miss recovery.

Fanged Guard no longer applies to Blood Fang because Blood Fang is now the endpoint of the immediate Blood Hunt Art rather than a charged Held Attack. Tier III remains a working draft scheduled for review during Wolf Tier redistribution.

## Tier IV — Apex Feast

Any successful deathblow, including a boss-phase deathblow, currently triggers Apex Feast.

When Apex Feast activates:

- Returning Blood erupts in a short radius around Akio,
- nearby ordinary enemies are briefly staggered,
- stronger nearby enemies receive enemy-posture damage,
- Akio restores a limited amount of Health,
- and Akio's next Predator's Passage begins fully charged.

The primed Predator's Passage may be released immediately without waiting through its normal charge. The benefit does not stack and expires when the encounter ends.

Apex Feast does not automatically release the Held Attack or select its direction. The primed pursuit retains its full travel and miss recovery.

Apex Feast is explicitly a working draft. Its current deathblow-only trigger is not considered sufficient for final Tier IV because it may provide little or no value during bosses or encounters without frequent deathblows. Wolf Tier redistribution must replace or broaden this capstone after Blood Hunt's later-Tier interactions are reviewed.

# Progression summary

- **Tier I — Blood Tempo:** successful contact improves Wolf's offensive flow, alternate sequence entries, and selected pursuit follow-ups; exact breadth remains under review.
- **Tier II — Blood Hunt:** activation restores limited Health and disrupts nearby ordinary enemies before one long player-directed pursuit tears through eligible ordinary enemies and ends in Blood Fang.
- **Tier III — Fanged Guard:** the current draft blocks one frontal blockable attack while charging Predator's Passage; redistribution review remains pending.
- **Tier IV — Apex Feast:** the current deathblow-triggered draft erupts, heals, and primes Predator's Passage; the capstone must be broadened or replaced during redistribution review.

The current progression is:

> successful entries connect Wolf's ordinary pressure → Blood Hunt converts a full meter into one explosive encounter-crossing pursuit → later Tiers remain to be redistributed around the approved immediate Art

Wolf's short reach, directional pursuit, unsafe misses, and dangerous ending position remain part of the weapon kit rather than separate Tier penalties.

# Technique space

Universal Techniques may reinforce, broaden, compensate for, or hybridize Wolf through shared action tags. They must not simply duplicate Blood Tempo, Blood Hunt's activation howl and encounter-crossing pursuit, Blood Fang, Fanged Guard, or the final approved Tier IV package.

Wolf does not own every aggressive, Basic Attack, Held Attack, deathblow, posture, healing, or movement Technique.

# Production requirements

The working package establishes requirements for:

- Blood Tempo chain-window and alternate-entry feedback,
- Hunting Slash pass-through constraints and the empowered rear Rending Cross,
- Blood Hunt full-meter readiness, activation Health recovery, Blood howl, directional preparation, pursuit line, pass-through collision, interruption categories, stopping logic, and ending recovery,
- the Blood wolf manifestation and Blood Fang endpoint animation,
- Fanged Guard charge and block feedback while its current draft remains active,
- replacement or broadening of Apex Feast during Wolf Tier redistribution,
- Blood unavailable, building, ready, activated, consumed, resolving, and rebuilding HUD states,
- Shrine Tier summaries and action-specific behavior changes,
- and Wolf teaching and mastery-trial coverage.

Exact animation counts, timing, sprite overlays, VFX density, audio, HUD layout, damage, posture, healing, Blood gain, pursuit distance, interruption resistance, collision, stopping priority, and recovery values remain implementation, production, and playtesting work.
