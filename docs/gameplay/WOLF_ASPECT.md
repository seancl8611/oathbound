---
id: GAMEPLAY-WOLF-ASPECT
title: Wolf Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - wolf
  - tier-0
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

Wolf is an approved member of the three-Aspect launch roster. This document owns Wolf's qualitative Tier 0 weapon kit and its boundaries.

Exact numerical values, frame data, hitboxes, chain windows, animation, Blood presentation, Tier I-IV package, drawback family, Blood rules, Blood Art, Technique exceptions, and production counts remain later design or implementation work.

## Weapon identity

**Wolf is the fast close-range pressure and pursuit kit.**

Wolf is defined by:

- the fastest and longest Basic Attack sequence in the launch roster,
- short effective reach,
- forward movement attached to attacks,
- strong correction toward nearby aimed enemies,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- practical transfer between nearby targets,
- and dangerous recovery after missed pursuit or extended commitments.

The player never needs to complete or preserve Wolf's sequence. Each attack must remain useful on its own, and the player may stop, defend, dash, redirect, use a Prosthetic, or disengage whenever necessary.

## Shared systems

Wolf retains the universal locomotion, neutral dash, defense input, parry timing, posture rules, deathblows, Technique inventory, and prosthetic system.

Its aggression comes from the sword kit rather than a stronger dash, altered parry, automatic posture recovery, attack invulnerability, or a separate combo meter.

## Tier 0 kit

### Basic Attack sequence

1. **Fang Slash** — fast advancing opener with short reach and moderate pressure.
2. **Rending Cross** — broader returning cut that continues pressure and catches nearby interference.
3. **Raking Fang** — fast pursuit strike with strong forward correction toward a nearby aimed enemy.
4. **Blood Cleave** — broad committed final cut with strong damage and posture pressure but severe miss recovery.

The sequence cadence is:

> fast entry → broader pressure → close pursuit → committed finish

Blood Cleave is not a required finisher. Fang Slash and Rending Cross must provide worthwhile value during short openings, and Raking Fang offers another fast decision before the player chooses whether Blood Cleave is safe.

### Held Attack — Predator's Passage

A long, narrow pursuit lunge that converts distance into close engagement.

- committed travel,
- limited correction after release,
- strong single-target damage and posture pressure,
- no additional invulnerability,
- severe recovery after a miss.

Wolf may pass through a valid ordinary enemy only when the destination is safe and valid. Against bosses, elites, heavy enemies, walls, hazards, pits, blocked geometry, or invalid destinations, Wolf stops on the near side.

Exact passage eligibility and collision behavior remain implementation work.

### Dash Attack — Hunting Slash

A fast advancing re-entry cut after the universal neutral dash.

- quick startup,
- short-to-medium attack reach,
- strong movement toward a nearby aimed enemy,
- moderate correction,
- close finishing position.

The universal dash itself is unchanged. Hunting Slash is an optional offensive commitment after it.

### Parry Counter — Fang Reversal

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
- no automatic posture recovery from attacking,
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
| Attack movement | Strongly forward |
| Tracking | Strong against nearby aimed enemies |
| Held identity | Pursuit |
| Main failure state | Overextension after missed or prolonged commitments |

## Strengths

- close-range pressure,
- pursuit of nearby or retreating enemies,
- sustained health and posture output,
- fast return to offense after dash or parry,
- and practical target transfer within a nearby group.

## Firm tradeoffs

- short reach,
- forward overcommitment,
- dangerous whiff recovery,
- side and rear pressure,
- ranged enemies when approach is denied,
- and hazards that make direct pursuit unsafe.

Wolf must not depend on completing its full sequence to produce competitive damage or posture pressure against bosses.

## Encounter role

- **Mixed groups:** pressure a priority nearby target while broader cuts, aiming, defense, and movement handle interference.
- **Crowds:** transfer pressure through a nearby group without automatic chaining, full-circle coverage, or attack invulnerability.
- **Ranged pressure:** approach through universal dash, Predator's Passage, Hunting Slash, normal movement, and prosthetics.
- **Elites and bosses:** gain value from individual early attacks and sustained openings while respecting retaliation.
- **Hazards:** require deliberate aim and safe destination awareness during forward commitments.

## Technique space

Universal Techniques may:

- **reinforce** pursuit, fast Basic Attacks, repeated contact, and sustained posture pressure,
- **broaden** crowd coverage, ranged handling, Held Attack use, or target transfer,
- **compensate** for whiff recovery, spacing, reach, defense, or disengagement,
- **hybridize** through parry counters, dash attacks, deathblows, posture, or prosthetics.

Wolf does not own every aggressive, Basic Attack, pursuit, posture, or dash Technique.

## Blood-katana presentation

Wolf's Blood-formed katana should feel dense, predatory, forceful, close-ranged, and committed to direct contact.

It must not gain a permanently extended blade that erases the kit's range weakness.

## Remaining Wolf design work

Define:

- fixed Tier I-IV benefits,
- one evolving drawback family,
- Tier II Blood generation and activation rules,
- Wolf's Blood Art,
- limited direct Technique interactions if approved,
- final animation, VFX, audio, HUD, Shrine, selection, and trial requirements.

Exact timing, range, tracking, damage, posture, stagger, recovery, collision, and presentation values remain implementation and playtesting work.
