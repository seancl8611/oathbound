---
id: GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
title: Combat Implementation Baseline
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - combat
  - implementation
  - first-playtest
  - health
  - posture
  - spirit
  - movement
  - dash
  - parry
  - backstab
  - perilous-attacks
related:
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-ITEMS-REWARDS
---

# Combat Implementation Baseline

This file owns the approved **first-playtest shared combat values** used to implement Oathbound's common combat layer.

These values are implementation baselines, not immutable final balance law. They should be implemented coherently, measured in Godot, and revised when playtesting provides better evidence.

`COMBAT.md` continues to own shared combat rules and vocabulary. Aspect files own their individual sword kits. This file supplies the initial numeric/common-behavior contract those systems build on.

# Akio shared baseline

| Stat / rule | First-playtest value |
|---|---:|
| Max Health | **100** |
| Base Posture | **100** |
| Max Spirit | **100** |
| Move speed | **200 px/sec** |
| Dash distance | **96 px** |
| Dash duration | **0.18 sec** |
| Dash invulnerability | **0.12 sec from dash start** |
| Earliest repeat dash | **0.30 sec after previous dash start** |
| Parry window | **0.12 sec** |
| General input buffer | **0.10 sec** |
| Block coverage | **150° frontal arc** |
| Player posture recovery delay | **0.75 sec** |
| Player posture recovery | **25 posture/sec** |
| Posture recovery while actively blocking | **0** |

Wolf, Wraith, and Ronin use the same neutral movement, dash, invulnerability, parry window, input-buffer foundation, and shared response rules. Aspect identity comes from sword-kit data and the approved modest posture/guard differences rather than different neutral evasion or parry timing.

# Spirit baseline

Akio begins a normal run with **100 / 100 Spirit** unless an approved effect changes starting Spirit.

Spirit has **no passive regeneration** in the first prototype.

Spirit recovery comes only from explicitly approved sources such as:

- room/reward recovery,
- regional transition support,
- Relics,
- Techniques,
- Blood/Aspect effects where approved,
- other authored systems that explicitly restore Spirit.

This preserves Spirit as a managed combat resource rather than a cooldown bar that automatically refills between exchanges.

# Block, parry, and posture rules

## Parry

A successful parry:

- deals **0 Health damage** to Akio,
- deals **0 posture damage** to Akio,
- applies the attack's authored parry-response/posture effect to the attacker,
- preserves the universal Parry Counter opportunity according to the selected Aspect.

Holding the defense input beyond the parry window transitions into ordinary sustained block.

The three launch Aspects do **not** receive different parry windows.

## Block

A successfully blocked ordinary blockable attack:

- deals **0 Health damage**,
- applies the attack's authored **block-posture damage**,
- may produce authored push/recoil where appropriate,
- does not regenerate player posture while the block is held.

## Player posture break

When Akio reaches maximum posture:

1. guard breaks,
2. Akio enters a **0.75 sec** vulnerable posture-break state,
3. normal defensive action is unavailable during that break,
4. posture resets to **40 / 100** when the break resolves.

Aspect-specific posture capacity/recovery modifiers may later alter the appropriate values under their approved kit rules, but the break behavior remains shared.

# Enemy reference profiles

Use **100 Health / 100 posture** as the normalized reference standard enemy.

| Standard-enemy profile | Health target | Posture target |
|---|---:|---:|
| Fragile / swarm | **60–75** | **50–70** |
| Standard | **100** | **100** |
| Defensive / heavy | **125–150** | **130–160** |
| Elite standard enemy | **175–225** | **175–225** |

These ranges are authoring references, not a requirement that every enemy in a role share identical values.

Regional and individual enemy authorities may deliberately move outside the ranges when their gameplay role clearly requires it.

# Enemy posture behavior

Enemy posture is pressure/control, not a second Health bar.

First-playtest shared behavior:

- posture recovery begins after **1.5 sec** without meaningful pressure,
- baseline recovery rate is **20 posture/sec**,
- a direct sword hit, blocked sword contact, or qualifying parry-pressure event resets the recovery delay,
- posture break makes an ordinary enemy Deathblow-ready for **2.5 sec**,
- if the Deathblow is not taken, an ordinary enemy recovers to **50% max posture** when the opening ends.

Normal standard enemies die from one successful Deathblow. Minibosses and bosses use their authored life/phase/deathblow rules rather than this ordinary-enemy assumption.

# Deathblow safety

After a Deathblow activation is successfully confirmed, Akio is invulnerable from the start of the committed execution until normal player control returns.

This prevents the game's primary posture payoff from becoming unsafe merely because another enemy remains active nearby.

Deathblow Techniques may modify approved outcomes without changing the shared activation/safety contract unless explicitly stated.

# Damage and posture data model

Do not use one combined damage statistic.

Every direct attack should support separate first-class data fields for at least:

- `health_damage`
- `posture_damage`
- `block_posture_damage`
- `stagger_level`
- `proc_coefficient`

Additional attack-specific fields may be added when a known mechanic requires them, but Health damage and posture pressure must remain independently tunable.

# Global modifier convention

For ordinary multiplicative combat scaling, use the following conceptual order:

`final_value = base_value × (1 + additive_bonus_total) × special_target_multipliers`

Use the same general ordering for Health damage and posture damage where applicable.

This is a design convention rather than a requirement for one exact code function. The implementation may structure modifiers differently internally as long as the resulting behavior remains equivalent and auditable.

Oathbound has **no generic critical-hit system** in the launch combat baseline.

# Proc normalization

Secondary Technique/proc damage does **not** recursively trigger additional ordinary proc effects by default.

Multi-hit attacks use a proc coefficient/budget so additional hitboxes do not automatically multiply every Technique interaction at full value.

The next player-build implementation pass owns the exact proc coefficients and per-attack values for Wolf, Wraith, Ronin, and the Technique catalog.

# Universal backstab baseline

A backstab remains the universal genuine rear-hit classification defined in `COMBAT.md`.

First-playtest geometry and payoff:

- rear region: **120° total**, approximately **±60° around directly behind the target**,
- eligible direct sword backstab: **1.25× direct Health damage**,
- baseline backstab posture multiplier: **1.0×**,
- no automatic stun,
- no automatic Deathblow,
- no stealth requirement.

Crimson/Vulnerable may substantially increase the payoff of a genuine backstab without changing a frontal hit into a backstab.

# Perilous response contract

| Attack class | Block | Parry | Dash / evade |
|---|---|---|---|
| Standard attack | Yes | Yes | Yes |
| Perilous thrust | **No** | **Yes** | Yes |
| Perilous sweep | **No** | **No** | **Yes** |
| Grab / restraint | **No** | **No by default** | **Yes** |
| Standard projectile | Yes where authored | Yes where authored | Yes |
| Persistent hazard | No | No | Reposition / evade |

A successful parry against a perilous thrust applies **1.5× the attack's normal parry-posture pressure**.

Individual encounters may create clearly communicated exceptions, but exception behavior must be authored deliberately rather than inferred ad hoc in code.

# Shared status convention

Unless an approved mechanic explicitly says otherwise:

- reapplying the same timed status **refreshes its duration** rather than stacking magnitude,
- damage/mark statuses remain usable against bosses unless the status authority defines a boss-specific rule,
- hard movement control may use reduced boss/elite behavior rather than assuming blanket immunity,
- proc-generated secondary damage does not recursively trigger more ordinary procs.

The working first-playtest duration for Crimson **Vulnerable** remains **3.0 sec** unless the player-build/Technique pass deliberately tunes it.

# Implementation exit condition

Pass 1 — Core Combat Implementation Baseline is considered complete when the Godot common combat layer can instantiate:

- Akio shared resources,
- neutral movement/dash,
- block/parry/posture break,
- enemy normalized Health/posture behavior,
- deathblow readiness/safety,
- universal backstab classification,
- perilous attack response classes,
- shared modifier/proc/status conventions.

Final frame-perfect values, enemy-specific stats, Aspect attack data, Technique values, and final difficulty balance remain later implementation/playtest work.
