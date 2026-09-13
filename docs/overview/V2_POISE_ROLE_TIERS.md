---
id: OVERVIEW-V2-POISE-ROLE-TIERS
title: Oathbound V2 Poise Role Tiers
category: overview
status: approved
authority: combat-v2-response
last_reviewed: 2026-09-13
topics:
  - v2
  - combat
  - poise
  - interruption
  - enemy-roles
  - hushiro
related:
  - OVERVIEW-V2-COMBAT-DIRECTION
  - OVERVIEW-V2-COMBAT-IMPLEMENTATION-BLUEPRINT
---

# Oathbound V2 Poise Role Tiers

This document locks the first evidence-backed **Area 1 Poise / immediate interruption** baseline for Combat V2. It refines the broader direction in `V2_COMBAT_DIRECTION.md` without merging Poise into Health or Posture.

The motivating September 13 playtest used build `6c9c5b45372517e49166850050ad80dcc3fa69b8`. In that run, ordinary Posture produced only one break and that Swordsman died through Health on the same contact sequence, while Hollow attacks were repeatedly cancelled by ordinary sword contacts. That evidence supports making **immediate flinch/interruption primarily a Poise responsibility** while keeping Posture as a longer-horizon break/control layer.

# Locked semantic split

- **Health** answers how close the enemy is to defeat.
- **Posture / Stagger** answers how close the enemy is to a longer control/break opportunity.
- **Poise** answers whether this particular impact flinches the enemy or interrupts its current action now.
- Taking Health damage does not inherently cancel an action.
- Failing a Poise check does not reduce or erase the strike's authored Health or Posture damage.
- Guard-break resistance remains a separately authored response axis and is not automatically raised when flinch Poise is raised.

# Incoming baseline Poise power

During the current migration, canonical attack `stagger_level` remains the compatibility source for Poise power when explicit `poise_damage` is absent:

| Incoming impact | Poise power |
| --- | ---: |
| Ordinary Quick / Cross baseline (`stagger_level = 0`) | 1 |
| Base Heavy-class impact (`stagger_level = 1`) | 2 |
| Explicit stronger Technique / Prosthetic / future authored impact | `poise_damage = 3+` |

This bridge is not a permanent requirement that every future move use three universal tiers. Explicit `poise_damage` remains the long-term authoring seam.

# Area 1 role baseline

| Enemy | Neutral required | Committed required | Intent |
| --- | ---: | ---: | --- |
| Hollow | 1 | 1 | Fodder. Ordinary clean offense can flinch/cancel it even after commitment. |
| Blighted Hound | 1 | 1 | Light predator. Pack pressure and speed create danger; ordinary offense can knock it out of bite/lunge commitments. |
| Corrupted Archer | 1 | 1 | Fragile ranged body. Reaching it should let Akio suppress shots with ordinary offense. |
| Corrupted Swordsman | 1 | 2 | Standard martial body. Easy to flinch neutral; committed attacks require a heavier impact. |
| Cellar Bilemass | 1 | 2 | Standard hazard body. Neutral movement is easy to disrupt; committed spit/vomit requires a heavier impact. |
| Warden | 2 | 3 | Heavy/control exception. Light basics do not flinch it; Heavy can interrupt neutral behavior; committed actions require an explicitly stronger impact. |

The point is **role contrast**, not a universal mathematical formula. Future enemies may author different thresholds per family or per action state when their fantasy requires it.

# Player-facing combat consequence

The baseline should make early Hushiro offense read as follows:

- Squishier enemies are visibly responsive and can often be knocked out of attacks by taking initiative.
- Standard martial/hazard enemies can still be pressured, but committed actions gain a small protected layer that rewards Heavy attacks, movement, block, parry, or another strong answer.
- The Warden feels physically heavier without gaining extra Health, damage reduction, or a second durability bar.
- Strong future Techniques and Prosthetics can deliberately author `poise_damage = 3+` to create brute-interruption utility without globally increasing sword damage.

# Non-goals of this baseline

This pass does **not** change:

- Area 1 Health targets,
- ordinary or block Posture damage,
- Posture recovery or break rules,
- Deathblow rules,
- guard Health multipliers,
- guard timing or guard-break thresholds,
- player Health damage,
- PressureDirectorV2 spacing,
- wave population,
- attack cadence,
- or boss Poise rules.

Boss and elite Poise remains a later bespoke authoring pass. The current standard-enemy values are playtest baselines and should move only when telemetry or manual playtesting shows a concrete pacing/readability problem.

# Validation contract

Deterministic response validation must prove at minimum:

- power 1 interrupts committed Hollow, Hound, and Archer actions;
- power 1 does not interrupt committed Swordsman or Bilemass actions;
- power 2 does interrupt committed Swordsman and Bilemass actions;
- power 1 does not interrupt a neutral Warden;
- power 2 does interrupt a neutral Warden;
- power 2 does not interrupt a committed Warden;
- explicit power 3 can interrupt a committed Warden;
- and Poise retuning does not silently change separately authored guard-break thresholds.
