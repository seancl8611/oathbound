---
id: GAMEPLAY-WRAITH-ASPECT
title: Wraith Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-29
topics:
  - blood-aspects
  - wraith
  - tier-0
  - tier-progression
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Wraith Blood Aspect

## Status

Wraith is an approved member of the three-Aspect launch roster. This document owns Wraith's qualitative Tier 0 weapon kit, its current Tier I working draft, and its boundaries.

It supersedes the earlier forced-reposition concept. Wraith's spacing identity comes from reach, short commitments, player aim, recovery, and rapid spectral weapon expressions rather than mandatory lateral movement, target correction, or special evasion.

Exact numerical values, frame data, hitboxes, animation, Blood presentation, Tier II-IV package, drawback family, Blood Art, justified exceptions to the shared Blood defaults, Technique exceptions, and production counts remain later design or implementation work.

## Weapon identity

**Wraith is the extended spectral reach and frontal-control kit.**

Wraith is defined by:

- the longest effective melee reach in the launch roster,
- a short two-hit Basic Attack sequence,
- narrow long-reaching lines and broad spectral arcs,
- short commitments and quick return to movement or defense,
- restrained forward movement,
- moderate per-hit damage,
- controlled frontal and lane coverage,
- fixed player-directed attack lines after commitment,
- rapid spectral blade expressions on selected committed attacks,
- and weakness when enemies enter inside its preferred range.

Wraith does not use corrective tracking, hidden homing, or automatic rotation. The player may use one precise attack, add the second attack, defend, dash, reposition normally, use a Prosthetic, or disengage.

## Shared systems

Wraith retains universal locomotion, neutral dash, defense input, parry timing, posture rules, deathblows, Technique inventory, and prosthetic controls.

It is not defined by teleportation, additional invulnerability, automatic movement behind targets, forced offsets, or a stronger neutral dash.

## Tier 0 kit

### Basic Attack sequence

1. **Veil Cut** — narrow extended opener with medium-to-long reach, moderate pressure, limited movement, and quick recovery.
2. **Passing Arc** — broad long-reaching spectral sweep with wider frontal coverage and moderate recovery.

The sequence cadence is:

> precise extended poke → broad spectral sweep

The player may stop after Veil Cut without losing a bonus. Passing Arc may use a small natural step or turn as part of its authored animation, but it does not chase a target, force Wraith across the enemy, or end at a special offset.

### Held Attack — Pale Lance

A long, narrow Blood-formed thrust or blade extension connected to the physical katana.

- Wraith's longest focused melee reach,
- very narrow attack line,
- moderate-to-strong health damage,
- strong focused posture pressure,
- minimal forward movement,
- fixed direction after release,
- meaningful miss recovery.

Pale Lance is not a projectile. Its advantage is reach rather than Ronin-level impact.

### Dash Attack — Ghostline Slash

A quick extended cut after the universal neutral dash.

- fast startup,
- medium-to-long spectral reach,
- moderate damage and posture pressure,
- limited movement beyond the dash,
- fixed authored arc after release,
- quick recovery into movement or defense.

It does not require a special offset or add invulnerability to the dash.

### Parry Counter — Veil Reversal

A precise extended counter slash after the universal parry.

- longer reach than Wolf's counter,
- narrow-to-medium frontal arc,
- moderate health damage,
- strong posture pressure,
- limited forward movement,
- controlled recovery.

It does not teleport, move behind the enemy, force an off-axis finish, rotate toward a target after release, or alter parry timing.

## Defensive profile

Wraith retains functional blocking and universal parry timing.

Its mobility impression comes from short attack commitments, quick recovery after Veil Cut, the universal dash, and Ghostline Slash's return to neutral.

Wraith does not require a dramatically weaker guard. Its natural defensive weakness is pressure inside the effective reach of its extended attacks and attacks arriving outside its focused front.

## Combat profile

| Property | Approved direction |
|---|---|
| Preferred range | Medium-to-long |
| Basic sequence | Two attacks |
| Cadence | Short quick-to-moderate pokes with selected rapid spectral commitments |
| Per-hit damage | Moderate |
| Sustained output | Moderate and lower than Wolf outside committed openings |
| Enemy posture | Focused extended pressure |
| Attack movement | Restrained and player-directed |
| Held identity | Reach and focused multi-hit commitment after Tier I |
| Main failure state | Enemies collapse inside preferred range or attack from several directions |

## Strengths

- longest effective melee reach,
- punishment from outside conventional sword range,
- strong line and frontal arc coverage,
- short ordinary attack commitments,
- quick return to movement or defense after lighter attacks,
- access to ranged enemies without becoming a projectile kit,
- concentrated multi-hit punishment during larger openings after Tier I,
- and punishment of enemy attacks that fall short.

## Firm tradeoffs

- point-blank pressure,
- cramped spaces,
- attacks from several directions,
- fixed attack lines after commitment,
- moderate rather than heavy individual hits,
- lower ordinary sustained output than Wolf,
- meaningful recovery after Pale Lance or other extended misses,
- and increasing exposure when Pale Barrage is held for too long.

Wraith must not combine the safest spacing, strongest damage, and easiest recovery. Reach and rapid spectral weapon expression are its primary advantages, while committed focused attacks must remain punishable when used during the wrong opening.

## Encounter role

- **Mixed groups:** threaten priority enemies at range and use Passing Arc for frontal interference.
- **Crowds:** control a broad front while remaining vulnerable to surrounding collapse.
- **Ranged pressure:** reach exposed ranged enemies through Veil Cut, Pale Lance, Ghostline Slash, universal dash, and prosthetics.
- **Elites and bosses:** punish from the edge of threat range, then use Pale Barrage only during openings long enough to justify its commitment.
- **Hazards:** benefit from not requiring forced offsets while still needing clear lines and deliberate aim.

# Fixed Tier progression

Wraith's Tier I is approved as a working draft for current scoping. Later Tiers must deepen Wraith's rapid spectral weapon identity without turning every action into the same multi-hit attack or erasing its weakness to point-blank and multi-directional pressure.

## Tier I — Pale Barrage

Pale Lance gains a continued held form.

After the initial Pale Lance thrust, continuing to hold the attack input causes Akio to unleash a rapid series of spectral jabs in front of him along the original Pale Lance direction. Releasing the input ends the barrage early, while continuing to hold performs the full current maximum sequence.

- The original single Pale Lance remains available by releasing without continuing into the barrage.
- Each additional jab deals lower individual health and enemy-posture damage than the initial Pale Lance.
- A completed barrage delivers strong combined health and enemy-posture pressure during a sufficiently long opening.
- Akio has limited movement and aim adjustment once the barrage begins.
- The jabs do not track, rotate toward, or independently select enemies.
- The longer Akio continues the barrage, the longer he remains committed and exposed to retaliation, flanking pressure, and enemies outside the focused direction.
- Releasing early gives up the remaining damage but ends the commitment sooner.

Pale Barrage is one authored multi-hit Held Attack rather than a separate status effect, meter, or stored reward. Blood generation, Technique triggers, healing, and other per-hit interactions must be weighted so the additional jabs do not automatically receive full independent proc value; exact rules remain balance work.

The resulting Tier I rhythm is:

> use the ordinary Wraith kit during short exchanges → hold Pale Lance into rapid jabs when a larger opening appears → release before the commitment becomes unsafe

## Technique space

Universal Techniques may:

- **reinforce** reach, line coverage, arc coverage, quick poke recovery, Pale Lance, and Pale Barrage,
- **broaden** close-range handling, pressure, pursuit, or posture continuity,
- **compensate** for fixed attack lines, point-blank pressure, crowd collapse, focused commitment, or whiff recovery,
- **hybridize** through parry counters, dash attacks, deathblows, posture, or prosthetics.

Wraith does not own every range, movement, dash, avoidance, multi-hit, Held Attack, or damage-amplification Technique.

## Blood-katana presentation

Wraith's Blood-formed katana should feel elongated, spectral, precise, light in visual motion, and capable of rapidly reproducing focused thrusts without becoming an independent projectile weapon.

The blade remains visibly connected to Akio's physical katana. Pale Barrage should read as Akio repeatedly driving or manifesting the spectral edge through deliberate weapon motion, not as autonomous homing blades.

## Remaining Wraith design work

Define:

- fixed Tier II-IV benefits,
- one evolving drawback family that incorporates Pale Barrage's focused commitment without making ordinary Wraith attacks uniformly slow,
- Wraith's Tier II Blood Art and how it uses the shared Blood defaults,
- any justified exception required by the approved Blood Art,
- limited direct Technique interactions if approved,
- final animation, VFX, audio, HUD, Shrine, selection, and trial requirements.

Exact timing, jab count, maximum hold duration, range, player-directed movement, damage, posture, recovery, aim adjustment, Blood values, proc weighting, and presentation values remain implementation and playtesting work.