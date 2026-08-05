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

Wolf is an approved member of the three-Aspect launch roster. This document owns Wolf's Tier 0 weapon kit and its fixed Tier I-IV progression package.

Tier I **Blood Tempo**, Wolf's **Feral Momentum** Tier-growth rule, Tier II **Blood Hunt**, Tier III **Fanged Guard**, and Tier IV **Apex Mauling** are approved through the current cross-roster audit. Exact numerical values, frame data, hitboxes, animation timing, resource tuning, slow strength and duration, and final presentation remain implementation and balance work.

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

Each Wolf Tier provides a concrete net-positive combat benefit while preserving Wolf's inherent pursuit tradeoffs. Stronger movement and pursuit remain player-directed, and poor aim or timing can still leave Akio in an unsafe position.

Beginning at Tier I, every further Embrace also advances **Feral Momentum**, a small deterministic growth rule tied to successfully connected Basic-sequence continuations. Feral Momentum is a supporting reward rather than a separate meter, objective, or replacement for each Tier's headline mechanic.

## Tier I — Blood Tempo

Successful Wolf sword contact may flow into the Basic Attack sequence earlier during the current attack's contact recovery.

Approved continuations are:

- Fang Slash → Rending Cross,
- Rending Cross → Raking Fang,
- Raking Fang → Blood Cleave,
- Predator's Passage → Rending Cross,
- Hunting Slash → Rending Cross,
- Fang Reversal → Rending Cross.

The following boundaries apply:

- Every continuation is optional.
- The benefit exists only during the current attack's contact recovery and is not stored.
- Missed attacks receive no Blood Tempo continuation.
- The player manually selects the direction of every continued attack.
- Blood Cleave does not loop directly into Fang Slash.
- Block, parry, dash, Prosthetic use, and other defensive or utility actions are not accelerated.
- Blood Tempo does not reduce whiff recovery.
- Blood Tempo adds no tracking, corrective turning, extra travel, rear-hit bonus, or automatic target selection.

The resulting Tier I rhythm is:

> enter through successful Wolf contact → decide whether continued pressure is safe → flow into the Basic sequence or stop and respond

### Feral Momentum — Tier growth

Feral Momentum gives a modest deterministic payoff to later Basic Attacks reached through successful Blood Tempo continuations.

- Rending Cross receives the smallest additional Health-damage and enemy-posture payoff.
- Raking Fang receives a larger additional payoff.
- Blood Cleave receives the largest additional payoff.
- Fang Slash remains the baseline opener and receives no sequence-position bonus.
- Predator's Passage, Hunting Slash, and Fang Reversal may enter at Rending Cross after successful contact; that Rending Cross receives the normal second-position Feral Momentum payoff and may continue escalating through Raking Fang and Blood Cleave.
- A later Basic Attack receives Feral Momentum only when the preceding approved attack successfully connected and the player uses the Blood Tempo continuation.
- Continuing the ordinary sequence after a miss does not grant the connected-sequence bonus.
- Each Embrace from Tier I through Tier IV modestly increases the Feral Momentum payoff applied to these later connected sequence positions.

Feral Momentum does not:

- create random critical-hit chance,
- use a separate meter, stack counter, or persistent combo timer,
- increase Predator's Passage, Hunting Slash, Fang Reversal, Blood Hunt, or Blood Fang damage,
- increase attack travel,
- reduce miss recovery,
- require Blood Cleave to be used,
- or prevent the player from stopping the sequence to defend, move, dash, or use another action.

The reward is intentionally deterministic rather than critical-hit based so the player can understand why a connected sequence became stronger. Exact Health-damage and enemy-posture values at Tiers I-IV remain tuning work. Presentation should use modestly intensifying hit feedback on the eligible sequence positions without creating a new HUD meter.

The removed Hunting Slash rear-Rending-Cross bonus and the removed Raking Fang and Hunting Slash travel increases do not move automatically to another Wolf Tier. They remain available only for later reconsideration as ordinary Technique space if the catalog requires them.

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

Fanged Guard protects Wolf's most committed ordinary offensive moments without granting general armor or changing shared defense rules.

### Predator's Passage

While charging Predator's Passage, Akio forms a Blood wolf jaw around the front of his body. The first frontal blockable enemy attack that reaches Akio:

- is blocked using normal player-posture rules,
- does not cancel Predator's Passage,
- and immediately completes Predator's Passage's charge.

The player still chooses when and where to release the attack. The charge receives one Fanged Guard block allowance per use.

### Connected Basic sequence

When **Raking Fang** or **Blood Cleave** is reached through a successful Blood Tempo continuation, a Blood wolf jaw briefly guards Akio's front during that attack's approved early committed startup window.

The first frontal blockable enemy attack that reaches Akio during an eligible window:

- is blocked using normal player-posture rules,
- does not cancel the qualifying Basic Attack,
- and consumes Fanged Guard for that connected Basic sequence.

Only one Fanged Guard block may occur during one connected Basic sequence. If Raking Fang consumes the block, Blood Cleave receives no second block during that sequence. If Raking Fang is not challenged or the eligible window passes without a block, Blood Cleave may still use the sequence's one allowance if it is reached through continued successful contact.

Returning to neutral, missing or abandoning the sequence, or performing another action ends that sequence's allowance. Predator's Passage uses a separate one-block allowance because it is a distinct Held Attack use.

### Boundaries

Fanged Guard does not protect:

- Fang Slash or Rending Cross,
- Raking Fang or Blood Cleave reached without the required successful Blood Tempo continuation,
- Blood Hunt or Blood Fang,
- attack recovery,
- side or rear attacks,
- perilous or unblockable attacks,
- authored grabs, launches, or overriding knockdowns,
- or any second qualifying hit after its allowance has been spent.

The block applies normal player-posture damage. If that blocked hit breaks Akio's posture, the qualifying Wolf attack is cancelled through ordinary posture-break rules.

Fanged Guard provides no damage reduction beyond the normal block, posture immunity, automatic counter, Health recovery, tracking, direction correction, attack acceleration, damage increase, or protection after a miss. Preserving an attack does not guarantee that the attack connects or that its resulting position is safe.

Tier III also advances Feral Momentum by one normal Tier step, modestly improving the deterministic Health and enemy-posture payoff of connected Rending Cross, Raking Fang, and Blood Cleave. This is Tier III's existing repeated growth reward rather than a separate third mechanic.

The resulting Tier III rhythm is:

> connect Wolf's offense → choose whether to commit into Raking Fang or Blood Cleave under frontal pressure → allow one normal posture-costing block to preserve the sequence → complete or abandon the hunt based on the remaining threats

## Tier IV — Apex Mauling

When a qualifying Wolf strike directly hits an enemy or is guarded, Returning Blood tears across the contact point as a rapid series of dense Blood-claw slashes. The effect resembles violent mauling marks rather than spectral wolves, autonomous companions, or repeated copies of Akio.

Qualifying strikes are:

- **Blood Cleave** reached through a successful Blood Tempo continuation,
- **Predator's Passage**,
- **Fang Reversal**,
- and **Blood Fang**, the endpoint of Blood Hunt.

Fang Slash, Rending Cross, Raking Fang, Hunting Slash, Blood Hunt's travel hits, deathblows, misses, and scenery contact do not trigger Apex Mauling. Each qualifying strike may create at most one mauling sequence.

### Primary mauling

After the qualifying strike resolves, several fast claw marks tear across the primary target from alternating authored angles around the original contact point.

- The primary target receives meaningful additional Health damage.
- The complete mauling delivers strong enemy-posture damage and powerful guard recoil.
- Eligible ordinary enemies receive strong stagger.
- Although several claw marks appear, the effect is balanced and resolved as one consolidated Tier IV package.
- A large enemy or boss does not receive extra damage because more claw marks overlap its body.
- The mauling remains fixed to the original contact point and originating attack direction.
- It does not track, retarget, rotate toward, or independently select an enemy after activation.

### Nearby coverage

The outer claw arcs may catch enemies positioned in a compact area immediately beside the primary target.

- A secondary enemy may be struck at most once by one Apex Mauling activation.
- Secondary enemies receive reduced Health damage, meaningful enemy-posture pressure, and eligible ordinary-enemy stagger.
- The secondary coverage does not search for targets, widen toward enemies, or continue traveling through the encounter.

Apex Mauling therefore gives Wolf compact group payoff around caught prey without becoming Wraith-like lane control, a projectile, or a room-wide crowd clear.

### Wounded-prey slow

The final claw briefly reduces the primary target's movement speed.

The slow may affect ordinary walking, pursuit, retreating, and eligible repositioning movement. It does not alter:

- attack startup or animation speed,
- attack recovery,
- block or parry timing,
- projectile speed,
- perilous-attack timing,
- scripted movement,
- phase transitions,
- grabs, leaps, or overriding authored actions.

Ordinary enemies may receive the full brief movement slow. Elites and bosses receive reduced strength, reduced duration, or immunity during protected actions according to their encounter rules. The slow does not guarantee Wolf another attack and does not prevent the enemy from attacking normally.

### System interactions

A connected Blood Cleave enhanced by Feral Momentum also strengthens Apex Mauling's enemy-posture damage, guard recoil, and eligible ordinary-enemy stagger. Feral Momentum does not substantially multiply the mauling's additional Health damage.

Blood Fang creates Apex Mauling only at the final stopping impact. Enemies crossed during Blood Hunt do not create separate maulings.

The visual claw series:

- generates no Blood,
- cannot trigger another Apex Mauling,
- uses weighted or restricted per-hit Technique and healing interactions,
- and does not count each visible claw as an independent full-power proc opportunity.

Apex Mauling grants no Health recovery, player-posture recovery, damage reduction, invulnerability, interruption resistance, tracking, recovery cancellation, or safer ending position. Every qualifying Wolf action retains its existing commitment, miss recovery, and positional risk.

Tier IV also applies Feral Momentum's final normal Tier increase to connected Rending Cross, Raking Fang, and Blood Cleave.

The resulting Tier IV rhythm is:

> catch the prey with a major Wolf impact → maul the contact point with rapid Blood claws → briefly hinder the prey's escape → accept the original action's recovery and resulting position

# Progression summary

- **Tier I — Blood Tempo:** successful Wolf contact may continue earlier into the Basic sequence through one unified set of optional routes.
- **Feral Momentum — Tier growth:** every Embrace modestly increases the deterministic Health and enemy-posture payoff of later Basic Attacks reached through successful Blood Tempo continuations.
- **Tier II — Blood Hunt:** activation restores limited Health and disrupts nearby ordinary enemies before one long player-directed pursuit tears through eligible ordinary enemies and ends in Blood Fang.
- **Tier III — Fanged Guard:** one normal posture-costing frontal block may preserve Predator's Passage charge, or one connected Raking Fang or Blood Cleave startup per Basic sequence.
- **Tier IV — Apex Mauling:** connected Blood Cleave, Predator's Passage, Fang Reversal, and Blood Fang trigger a consolidated Blood-claw mauling with strong posture pressure, compact secondary coverage, and a brief movement-only slow on the primary target.

The progression is:

> successful contact connects Wolf's ordinary pressure and strengthens later sequence hits → Blood Hunt converts a full meter into one explosive encounter-crossing pursuit → Fanged Guard preserves one selected high-risk ordinary commitment under frontal pressure → Apex Mauling turns major successful contact into a violent Blood-claw culmination that hinders the prey's escape

Wolf's short reach, directional pursuit, unsafe misses, side and rear vulnerability, posture risk, and dangerous ending position remain part of the weapon kit rather than separate Tier penalties.

# Technique space

Universal Techniques may reinforce, broaden, compensate for, or hybridize Wolf through shared action tags. They must not reproduce Blood Tempo's complete contact-routing package, Feral Momentum's full Tier-scaled connected-sequence escalation, Blood Hunt's activation howl and encounter-crossing pursuit, Blood Fang, Fanged Guard's action-specific one-block preservation, or Apex Mauling's complete qualifying-strike, claw-package, and movement-slow behavior.

General Basic Attack damage, posture, critical, movement, slow, block, multi-hit, or sequence Techniques remain possible when they use one universal cross-Aspect rule and do not duplicate Wolf's exact fixed progression behavior.

Wolf does not own every aggressive, Basic Attack, Held Attack, deathblow, posture, healing, critical-hit, slow, block, multi-hit, or movement Technique.

# Production requirements

The approved package establishes requirements for:

- Blood Tempo contact-continuation windows and alternate-entry feedback,
- Feral Momentum sequence-position, connected-state, and Tier-scaling feedback without a separate HUD meter,
- Hunting Slash pass-through constraints without a fixed rear-damage reward,
- Blood Hunt full-meter readiness, activation Health recovery, Blood howl, directional preparation, pursuit line, pass-through collision, interruption categories, stopping logic, and ending recovery,
- the Blood wolf manifestation and Blood Fang endpoint animation,
- Fanged Guard's Predator's Passage charge state, eligible connected-sequence startup windows, one-use sequence state, frontal block, posture-break interaction, and spent-state feedback,
- Apex Mauling's qualifying-hit recognition, rapid Blood-claw presentation, consolidated damage and posture package, compact secondary coverage, movement-only slow, boss and elite scaling, and restricted multi-hit interactions,
- Blood unavailable, building, ready, activated, consumed, resolving, and rebuilding HUD states,
- Shrine Tier summaries and action-specific behavior changes,
- and Wolf teaching and mastery-trial coverage.

Exact animation counts, timing, sprite overlays, VFX density, audio, HUD layout, damage, posture, Feral Momentum scaling, Fanged Guard windows, Apex Mauling claw count and cadence, slow values, healing, Blood gain, pursuit distance, interruption resistance, collision, stopping priority, and recovery values remain implementation, production, and playtesting work.