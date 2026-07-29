---
id: GAMEPLAY-WOLF-ASPECT
title: Wolf Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-29
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

The Tier package is approved as a working draft for current scoping. It may be revisited after Wraith and Ronin are developed or after playable testing. Exact numerical values, frame data, hitboxes, animation timing, resource tuning, and final presentation remain implementation and balance work.

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

When Hunting Slash strikes an eligible ordinary enemy, Akio may carry through that enemy along the original attack direction only when safe and valid space exists on the far side. Against bosses, elites, heavy enemies, walls, hazards, pits, blocked geometry, or invalid destinations, Akio stops on the near side.

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
- ranged enemies when approach is denied,
- and hazards that make direct pursuit unsafe.

Wolf must not depend on completing its full sequence to produce competitive damage or posture pressure against bosses.

# Fixed Tier progression

Each Wolf Tier has a concrete combat effect and continues the same evolving drawback family: **Predatory Commitment**. Higher Tiers make Wolf's player-directed pursuit more forceful and rewarding while preserving the positional danger of a badly aimed commitment.

The benefits should clearly outweigh the drawbacks. Embrace should feel like a desirable escalation rather than a questionable trade.

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

### Predatory Commitment I

Raking Fang and Hunting Slash travel slightly farther along the direction chosen by the player. Hunting Slash may therefore carry Akio farther through an eligible ordinary enemy when the hit and destination are valid. Neither attack can turn, home, or correct its path after it begins.

## Tier II — Dire Hunt

Tier II unlocks Wolf's Blood meter and Blood Art.

Wolf gains Blood through meaningful sword damage, posture breaks, Fang Reversal after a parry, and deathblows. Dire Hunt requires a full meter, activates manually, and consumes the stored Blood. Blood cannot be generated while the Art is active and all Blood state resets after the run.

Exact capacity, gain values, duration, and anti-farming thresholds remain tuning work.

### Blood Art — Dire Hunt

Akio allows the Wolf expression of Returning Blood to temporarily alter his body and swordsmanship.

When Dire Hunt activates:

- a short-range Blood howl interrupts nearby ordinary enemies,
- Akio clears his accumulated player posture,
- and Akio restores a limited amount of health.

These effects give the activation immediate value even if Akio cannot safely attack afterward.

For the duration of Dire Hunt:

- direct katana hits restore limited health,
- light enemy attacks are less likely to interrupt committed Wolf sword attacks,
- Wolf attacks deal greater health and enemy-posture damage,
- and Predator's Passage is replaced by Blood Fang.

Akio retains normal block, parry, and dash behavior. Dire Hunt does not require successful parries to be useful.

### Blood Fang

Akio performs a committed forward lunge while a large Blood-formed wolf jaw manifests around him and bites at the point of contact.

- Blood Fang follows the direction selected when the attack begins.
- It does not track, turn, or select a target automatically.
- A successful bite restores more health than an ordinary sword hit.
- It deals strong health and enemy-posture damage.
- It may pass through eligible ordinary enemies when safe space exists on the far side.
- It stops against heavy enemies, elites, bosses, walls, hazards, and invalid destinations.
- A miss retains severe recovery.

Blood Fang is Dire Hunt's main new attack and visual centerpiece. The rest of the transformation should reuse Wolf's existing attack library with stronger Blood presentation where practical.

### Predatory Commitment II

Blood Fang and Wolf's existing pursuit attacks carry Akio farther along the selected direction and remain fully committed after release. The transformation is clearly stronger than normal Wolf combat, but careless aim can place Akio in danger.

## Tier III — Fanged Guard

Tier III upgrades Predator's Passage and Blood Fang while they are being charged.

While charging either attack, Akio forms a Blood jaw around the front of his body. The first frontal blockable enemy attack that reaches Akio:

- is blocked using normal player-posture rules,
- does not cancel the Held Attack,
- and immediately completes the Held Attack's charge.

The player still chooses when and where to release the attack.

Fanged Guard does not protect against attacks from the side or rear, grabs, hazards, or unblockable attacks. It can block only one attack during each charge.

### Predatory Commitment III

Fanged Guard helps Akio complete the charge but does not make the resulting pursuit safe. Predator's Passage and Blood Fang retain their selected direction and severe miss recovery.

## Tier IV — Apex Feast

Any successful deathblow, including a boss-phase deathblow, triggers Apex Feast.

When Apex Feast activates:

- Returning Blood erupts in a short radius around Akio,
- nearby ordinary enemies are briefly staggered,
- stronger nearby enemies receive enemy-posture damage,
- Akio restores a limited amount of health,
- and Akio's next Held Attack begins fully charged.

The primed Held Attack may be released immediately without waiting through its normal charge. The benefit is consumed when Predator's Passage or Blood Fang is used, does not stack, and expires when the encounter ends.

Apex Feast does not automatically release the Held Attack or select its direction.

### Predatory Commitment IV

The primed pursuit retains its full travel and miss recovery. Tier IV gives Wolf a concrete transition from a deathblow into another pursuit, but the player must still aim and release it correctly.

# Progression summary

- **Tier I — Blood Tempo:** successful Basic Attacks accelerate the next Basic input; successful pursuit, dash, and parry-counter hits may continue into Rending Cross; crossing an ordinary enemy with Hunting Slash can empower the immediate rear Rending Cross.
- **Tier II — Dire Hunt:** activation immediately restores health, clears posture, interrupts nearby ordinary enemies, and begins a transformation with lifesteal, interruption resistance, increased damage, and Blood Fang.
- **Tier III — Fanged Guard:** charging Predator's Passage or Blood Fang blocks one frontal blockable attack without cancelling the charge.
- **Tier IV — Apex Feast:** deathblows create a nearby Blood eruption, restore limited health, and fully charge the next Held Attack.

The progression is:

> successful entries and hits connect Wolf's offense into a fluid hunt → Dire Hunt guarantees immediate recovery and unlocks Blood Fang → Fanged Guard helps prepare pursuit under pressure → deathblows prime the next hunt

# Technique space

Universal Techniques may reinforce, broaden, compensate for, or hybridize Wolf through shared action tags. They must not simply duplicate Blood Tempo, Dire Hunt, Fanged Guard, Blood Fang, or Apex Feast.

Wolf does not own every aggressive, Basic Attack, Held Attack, deathblow, posture, healing, or movement Technique.

# Production requirements

The working package establishes requirements for:

- Blood Tempo chain-window and alternate-entry feedback,
- Hunting Slash pass-through constraints and the empowered rear Rending Cross,
- Dire Hunt activation, active-state, and ending presentation,
- the Blood Fang animation and Blood-jaw effect,
- Fanged Guard charge and block feedback,
- Apex Feast deathblow eruption and primed-Held state,
- Blood unavailable, building, ready, activated, active, consumed, and rebuilding HUD states,
- Shrine Tier summaries and drawback language,
- and Wolf teaching and mastery-trial coverage.

Exact animation counts, timing, sprite overlays, VFX density, audio, HUD layout, damage, posture, healing, Blood gain, duration, interruption resistance, collision, and recovery values remain implementation, production, and playtesting work.