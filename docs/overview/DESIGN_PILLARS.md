---
id: OVERVIEW-DESIGN-PILLARS
title: Oathbound Design Pillars
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-14
topics:
  - combat-readability
  - tragic-horror
  - regional-escalation
  - production-foundations
  - stylized-3d
  - three-quarter-camera
---

# Design Pillars

## Martial clarity first

Combat is demanding but legible. Silhouettes, weapon direction, windups, special-response states, hidden-Poise interruption, hazards, and deliberately authored execution openings must remain understandable at normal gameplay scale. Atmosphere and ornament may intensify the scene, but they cannot obscure response rules.

## Momentum over defensive waiting

The central exchange is movement, attack commitment, spacing, target prioritization, selective defense, and pressure management rather than standing in universal parry/posture loops. Health is the player's primary survival resource. Standard enemies use Health plus hidden Poise/interruption; special parry responses are explicit rather than universal.

## Power with visible consequence

Returning Blood grants strength through Blood Aspects, but each increase in power should communicate mutation, danger, and loss of safety. Embrace and Resist are practical run decisions, not a simple good-versus-evil meter.

Akio is the only known bearer with genuine control over Beast Blood. Other bearers may retain intelligence, skill, ambition, or deliberate mutation use while ultimately losing the ability to reject the Blood's rule.

## Tragic martial horror

The island is frightening because its people accepted a miracle that saved their civilization before revealing its cost.

Corrupted inhabitants retain enough memory, loyalty, recognition, and humanity to remain recognizable while becoming dangerous. The horror comes from seeing the person, kingdom, or relationship that still exists inside the transformation rather than from a mindless infection.

Retained humanity does not equal freedom. Beast Blood can recruit a person's remaining loyalty, ambition, faith, and discipline into defending the force that enslaved them.

## Role-readable silhouettes

Every unit should communicate role through stance, weapon shape, movement, body mass, and attack preparation before secondary costume detail is noticed. Enemy families may share materials and motifs, but blockers, ranged threats, controllers, predators, and elites must remain distinct at a glance.

This requirement becomes more important, not less, in the stylized 3D production direction. Models, rigs, materials, animation, and VFX are judged first at the fixed high-angle gameplay camera distance.

## Fixed high-angle stylized 3D presentation

Oathbound's production presentation is a fixed high-angle three-quarter / isometric-like 3D view.

- production characters and enemies should increasingly use stylized 3D representation;
- combat rooms should increasingly be authored as 3D spaces with real volume, lighting, shadows, and controlled occlusion;
- gameplay decisions remain constrained to the combat ground plane unless a separate system explicitly requires otherwise;
- the camera remains stable and authored rather than becoming a free third-person camera;
- 3D presentation must preserve combat distances, timings, encounter rules, and Pressure Director semantics unless playtesting separately changes those systems;
- hybrid 2D UI/VFX remain valid when they are the clearest solution.

The existing Camera2D projection/procedural-proxy stack is a migration bridge, not the final production target.

## Replacement visuals are exclusive

When a new body representation replaces an older one, the older body art must be hidden or disabled. Custom sprites, AnimatedSprite layers, meshes, rigs, and future production actor roots must never unintentionally render on top of the legacy body representation.

Intentional auxiliary VFX may remain, but replacement character art is exclusive rather than additive.

## Regional curse progression

The three regions reveal increasingly established expressions of the same curse:

- **Hushiro Gate Village — Rupture:** recent corruption, bodily collapse, fear, violence, fragmented community, and desperate faith.
- **Yomori Grove — Adaptation:** long-term predation, persistent spirits, and ecological damage caused by corrupted inhabitants and beasts living around the curse.
- **Kagutsuchi Court — False Ascendancy:** beauty, hierarchy, elite discipline, and advanced mutation used as false evidence that Beast Blood has been mastered.

The progression is thematic rather than a universal biological stage system. Beast Blood does not become environmentally contagious in Yomori.

Kagutsuchi's inhabitants may direct abilities and preserve more intelligence than the outer island's victims. They are more dangerous servants of Beast Blood, not genuine masters equal to Akio.

Escalation should be visible in silhouette, ornamentation, movement language, lighting, materials, architecture, and corruption expression while preserving each region's established setting: gate village, forest, and royal court.

## Build variety without losing the sword game

Blood Aspects, Techniques, Prosthetics, Relics, and items should change tactics without replacing the core katana, movement, spacing, commitment, selective-defense, and pressure-management game.

## Reusable production foundations

Player scale, animation-state clarity, UI language, VFX hierarchy, palettes, pivots, planar-to-3D coordinate rules, 3D actor roots, camera conventions, modular environment standards, and occlusion rules should be established early and inherited by later milestones.

Production should remain divided into reviewable, dependency-aware batches even when the full game is scoped in advance.
