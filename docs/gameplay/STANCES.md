---
id: GAMEPLAY-STANCES
title: Stances
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - stances
  - storm
  - frost
  - ember
  - hex
  - shadow
related:
  - ART-STANCE-VFX
  - CHAR-AKIO
  - ART-MILESTONE-04
---

# Stances

Stances are combat modifiers that reshape Akio's base swordplay without replacing the approved katana moveset. The current five identities are approved at the tactical and visual level; exact numerical mechanics, switching rules, and upgrade paths remain design and balance work.

## Storm

**Identity:** aggressive multi-target pressure through chain lightning and Shock.

**Design direction:** rewards awareness of clustered enemies and maintaining tempo. The first hit remains primary; secondary chains are controlled rather than random room-wide damage.

## Frost

**Identity:** buildup, slow, freeze, and deliberate punish windows.

**Design direction:** rewards repeated application and timing a strong follow-up against a clearly frozen or brittle target.

## Ember

**Identity:** sustained Burn pressure and limited scorched-area control.

**Design direction:** supports close-range offense and anti-defense pressure through damage over time without turning every attack into a large fire spell.

## Hex

**Identity:** curse buildup and delayed punishment.

**Design direction:** rewards planning around marked targets, meaningful thresholds, and delayed payoff rather than immediate raw damage.

## Shadow

**Identity:** mark-and-consume play tied to evasive timing, parries, dashes, exposed targets, and single-target punishment.

**Design direction:** rewards precise windows and cashing out marks through disciplined attacks rather than permanent stealth.

## Shared constraints

- Stances modify or add effects to base attacks; they do not require five replacement player animation libraries.
- Weapon arcs, parry states, enemy tells, and Akio's final position remain readable.
- Stance status language must be consistent with HUD, damage numbers, prosthetics, boons, and enemy states.
- Stances should offer build identity without invalidating posture, parry, and deathblow combat.

## Remaining design work

Each stance still requires final decisions for:

- activation and switching,
- exact modified attacks or triggers,
- resource costs or cooldowns,
- stack thresholds and durations,
- Aspect and prosthetic synergies,
- upgrade paths,
- failure cases and balance caps.

The authoritative visual language belongs in [Combat Stance VFX](../art_production/STANCE_VFX.md).
