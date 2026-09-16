---
id: OVERVIEW-DESIGN-PILLARS
title: Oathbound Design Pillars
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - combat-readability
  - tragic-horror
  - regional-escalation
  - production-foundations
  - isometric-2d
  - directional-sprites
  - high-angle-camera
---

# Design Pillars

## Martial clarity first

Combat is demanding but legible. Silhouettes, weapon direction, windups, guard states, hit reactions, hidden-Poise interruption, hazards, and authored vulnerability windows must remain understandable at normal gameplay scale. Atmosphere and ornament may intensify the scene, but they cannot obscure response rules.

## Momentum over defensive waiting

The central exchange is movement, attack commitment, spacing, target prioritization, selective kit-specific defense, and pressure management. Health is the player's primary survival resource. Standard enemies use Health plus hidden Poise/interruption and should remain vulnerable to sustained aggressive play rather than forcing repeated duel resets.

## Power with visible consequence

Returning Blood grants strength through Blood Aspects, but each increase in power should communicate mutation, danger, and loss of safety. Embrace and Resist are practical run decisions, not a simple good-versus-evil meter.

Akio is the only known bearer with genuine control over Beast Blood. Other bearers may retain intelligence, skill, ambition, or deliberate mutation use while ultimately losing the ability to reject the Blood's rule.

## Tragic martial horror

The island is frightening because its people accepted a miracle that saved their civilization before revealing its cost.

Corrupted inhabitants retain enough memory, loyalty, recognition, and humanity to remain recognizable while becoming dangerous. The horror comes from seeing the person, kingdom, or relationship that still exists inside the transformation rather than from a mindless infection.

Retained humanity does not equal freedom. Beast Blood can recruit a person's remaining loyalty, ambition, faith, and discipline into defending the force that enslaved them.

## Role-readable silhouettes

Every unit should communicate role through stance, weapon shape, movement, body mass, and attack preparation before secondary costume detail is noticed. Enemy families may share materials and motifs, but blockers, ranged threats, controllers, predators, and elites must remain distinct at a glance.

This requirement is evaluated at the accepted high-angle gameplay camera. Directional character art, animation, VFX, shadows, and environment contrast must preserve silhouettes at the actual screen-space size used in combat.

## Authoritative 2D, isometric-style presentation

Oathbound's production runtime uses an authoritative planar 2D simulation with a fixed high-angle/isometric-style presentation.

- gameplay actors remain `Node2D` / `CharacterBody2D`-based unless an owning system explicitly says otherwise;
- Camera2D framing keeps the accepted high-angle composition;
- characters and enemies use eight-direction 2D presentation;
- feet/contact points anchor actor placement and Y-based depth sorting;
- environments use layered illustrated 2D construction, controlled overlap, shadows, and occlusion;
- combat VFX and telegraphs remain independent 2D presentation layers;
- presentation must preserve gameplay distances, timings, target selection, pressure admission, crowd spacing, and encounter rules;
- UI and presentation never become combat authority.

Offline 3D rigs are valid art-production tools for rendering directional 2D frames. The source rig is not a live runtime actor.

## Small-screen readability is the production test

Akio and enemies are intentionally small in screen space. Character art is successful when the silhouette, weapon, facing, locomotion, anticipation, impact, guard state, and major role cues survive at gameplay scale.

A model, render, sprite, or effect that looks impressive only in close-up is not production-ready.

## Replacement visuals are exclusive

When a new body representation replaces an older one, the older body art must be hidden or disabled. Directional sprites, temporary procedural proxies, and future final actor art must never unintentionally render on top of one another.

Intentional auxiliary VFX may remain, but replacement character art is exclusive rather than additive.

## Regional curse progression

The three regions reveal increasingly established expressions of the same curse:

- **Hushiro Gate Village — Rupture:** recent corruption, bodily collapse, fear, violence, fragmented community, and desperate faith.
- **Yomori Grove — Adaptation:** long-term predation, persistent spirits, and ecological damage caused by corrupted inhabitants and beasts living around the curse.
- **Kagutsuchi Court — False Ascendancy:** beauty, hierarchy, elite discipline, and advanced mutation used as false evidence that Beast Blood has been mastered.

The progression is thematic rather than a universal biological stage system. Beast Blood does not become environmentally contagious in Yomori.

Kagutsuchi's inhabitants may direct abilities and preserve more intelligence than the outer island's victims. They are more dangerous servants of Beast Blood, not genuine masters equal to Akio.

Escalation should be visible in silhouette, ornamentation, movement language, lighting, materials, architecture, corruption expression, VFX, and environmental composition while preserving each region's established setting: gate village, forest, and royal court.

## Build variety without losing the sword game

Blood Aspects, Techniques, Prosthetics, Relics, and items should change tactics without replacing the core katana, movement, spacing, commitment, selective-defense, target-priority, and pressure-management game.

Global progression content must not assume a kit-specific combat event. Kit-specific hooks are valid when eligibility and ownership are explicit.

## Reusable production foundations

Player scale, eight-direction conventions, animation-state clarity, UI language, VFX hierarchy, palettes, feet anchors, frame canvases, camera conventions, Y-depth rules, modular environment standards, and occlusion rules should be established early and inherited by later milestones.

Production should remain divided into reviewable, dependency-aware batches even when the full game is scoped in advance.