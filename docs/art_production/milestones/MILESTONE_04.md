---
id: ART-MILESTONE-04
title: Milestone 4 — Player Combat Depth
category: art-production
status: draft
authority: primary
last_reviewed: 2026-08-12
---

# Milestone 4 — Player Combat Depth

## Goal

Complete the visual identities and interface support for Akio's major build-shaping systems after the base character, combat VFX hierarchy, Shrine foundation, and core room framework are stable.

The milestone must support optional Aspect Tier investment, five direct Technique slots, and continued Technique development through slotless supporting upgrades and other approved post-slot rewards.

## Authoritative design sources

- [Akio](../../characters/AKIO.md)
- [Combat System](../../gameplay/COMBAT.md)
- [Blood Aspect System](../../gameplay/BLOOD_ASPECTS.md)
- [Wolf Blood Aspect](../../gameplay/WOLF_ASPECT.md)
- [Wraith Blood Aspect](../../gameplay/WRAITH_ASPECT.md)
- [Ronin Blood Aspect](../../gameplay/RONIN_ASPECT.md)
- [Corruption and Shrines](../../gameplay/CORRUPTION_AND_SHRINES.md)
- [Progression](../../gameplay/PROGRESSION.md)
- [Technique System](../../gameplay/TECHNIQUES.md)
- [Prosthetic Tools](../../gameplay/PROSTHETICS.md)
- [Blood Aspect VFX](../ASPECT_VFX.md)
- [Technique VFX](../TECHNIQUE_VFX.md)
- [Run HUD and Combat Feedback](../../ui_ux/HUD.md)

## Planned scope

- Three distinct Tier 0 Aspect combat-presentation families.
- Fixed Tier I-IV escalation for Wolf, Wraith, and Ronin.
- Tier II Blood buildup, readiness, activation, resolving, consumed, and rebuilding states.
- Three Blood Art packages.
- Eight Prosthetic VFX/icon families.
- Reusable Technique card, rarity, family, direct-slot, supporting, refinement, replacement, warning, decline, reroll, and comparison states.
- Five direct Technique slots: Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow.
- Post-fill Technique offers supporting slotless upgrades, refinements, rare same-slot replacements, cross-family effects, and eligible higher-rarity or Legendary opportunities as approved by the final catalog.
- Read-only rest/pause build review rather than reserve swapping.
- Relic card family and one initial Relic slot.
- Currency, Health, Spirit, capacity, route-marker, breakable, treasure, and reward-object art.

The direct five-by-five Technique matrix must be approved before unique Technique icon/VFX production is scoped. The five family mechanics—Echo, Rupture, Seal, Rift, and Burst—are already defined at qualitative core-rule depth.

## Locked Aspect scope

| Aspect | Tier I | Tier II | Tier III | Tier IV | Supporting growth |
|---|---|---|---|---|---|
| **Wolf** | Blood Tempo | Blood Hunt | Fanged Guard | Apex Mauling | Feral Momentum |
| **Wraith** | Pale Barrage | Wraith's Reach | Spectral Passage | Beyond the Veil | Spectral Edge |
| **Ronin** | Steadfast Reprisal | Falling Mountain | Unbroken Resolve | Shattering Wake | Maximum player-posture capacity |

### Wolf production needs

- Tier 0 close-range pressure/pursuit readability.
- Blood Tempo valid-contact continuation.
- Feral Momentum connected-sequence escalation.
- Blood Hunt activation, limited healing, howl, fixed pursuit, stopping, Blood Fang, and recovery.
- Fanged Guard one-use frontal protection with normal posture interaction.
- Apex Mauling consolidated claw package and movement-only slow.

### Wraith production needs

- Distinct Veil Cut, Passing Arc, Pale Lance, Ghostline Slash, and Veil Reversal geometry.
- Pale Barrage continuation and stationary commitment.
- Spectral Edge physical-range versus eligible spectral-only contact.
- Wraith's Reach opening sweep, long fixed corridor, delayed same-geometry echo.
- Spectral Passage primary/secondary impacts and stopping-body readability.
- Beyond the Veil longer Pale Lance/Ghostline geometry, Tier IV Spectral Edge expansion, clear-path extended deathblow approach, and Veilstride.

### Ronin production needs

- Distinct Severing Cut, Crushing Cross, Bloodfall, Stillness Draw, Breaching Slash, and Answering Steel impact/timing reads.
- Strongest-guard and slow-posture-recovery readability.
- Tier I-IV posture-capacity growth through the existing posture HUD; no separate buff state.
- Steadfast Reprisal block opportunity and planted Reprisal Cut.
- Falling Mountain posture relief, channel, direct slam, compact burst, fixed-point Deep Rupture, and recovery.
- Unbroken Resolve commitment-preservation cue plus Measured Weight and Perfect Weight readiness/consumption.
- Shattering Wake contact-origin transfer through the primary target.

All three packages may guide high-level scoping. Exact counts still require implementation briefs and playable validation.

## Suggested internal order

1. Final Aspect icons and Tier 0 VFX identity prototypes.
2. Prototype Wolf Tier I-IV package.
3. Prototype Wraith Tier I-IV package.
4. Prototype Ronin Tier I-IV package and posture-capacity HUD scaling.
5. Complete final cross-roster presentation/readability pass.
6. Complete Blood buildup/readiness and all three Blood Arts.
7. Complete Prosthetic VFX/icons.
8. Complete reusable Technique card/build framework for five direct slots plus slotless supporting upgrades.
9. Complete Technique reward/replacement/refinement/supporting states.
10. Complete currency, pickup, Relic, breakable, treasure, and reward-object families.
11. Complete approved Technique icon catalog and bespoke combat cues after the direct matrix and later catalog layers are locked.
12. Full HUD, Shrine, reward-screen, and mixed-build integration.

## Dependency rules

- Final overlays inherit approved Akio sheets.
- Effects follow approved weapon-kit behavior and cannot imply tracking, homing, teleportation, invulnerability, or protection not present in gameplay.
- All three Tier 0-IV packages support high-level planning; final frame/effect counts require implementation briefs.
- Ronin posture-capacity growth reuses existing posture UI rather than creating a new status family.
- Spectral Passage and Beyond the Veil should reuse existing attack/deathblow/locomotion families wherever practical.
- Techniques reuse base combat and Aspect VFX before new production is authorized.
- Prosthetic progression is a separate persistent Forge package and does not create temporary Prosthetic-Technique reward states.
- Additional Aspects are excluded.
- No duplicate Aspect-specific Blood Art progression tree is included.
- Superseded Prey Mark, Dire Hunt transformation, Apex Feast, Wraith duration-state reach, Veiled Guard, Pale Procession, perfect-dodge/Mist-Step/spinning Art, Ronin Counter Cut/Focus, and reserve-Technique assets are excluded.

## Completion test

- Wolf, Wraith, and Ronin are immediately distinguishable in the first combat room.
- Tier 0-I Technique-focused, Tier II hybrid, and deeper Aspect-investment builds remain readable.
- Blood Arts clearly communicate activation payoff, direction/target, commitment, and resolution.
- Tier growth is readable without unnecessary extra meters or status families.
- Ronin's posture growth reads through the normal posture system rather than a new mechanic.
- Wraith range effects do not resemble teleportation or detached projectiles.
- Wolf pursuit does not resemble automatic targeting.
- Technique choices, five direct slots, supporting upgrades, rarity, refinements, replacements, and warnings remain understandable as the build develops.
- Enemy telegraphs remain readable under mixed Aspect, Technique, Prosthetic, and Blood effects.