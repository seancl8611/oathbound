---
id: OVERVIEW-STYLIZED-3D-PRESENTATION
title: Stylized 3D Presentation Direction
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-14
topics:
  - project-identity
  - three-quarter-camera
  - stylized-3d
  - planar-combat
  - character-production
  - environment-production
  - presentation-migration
related:
  - OVERVIEW-GAME
  - OVERVIEW-DESIGN-PILLARS
  - OVERVIEW-V2-COMBAT-DIRECTION
---

# Stylized 3D Presentation Direction

Status: **approved production direction**

## Decision

Oathbound is moving toward a **stylized 3D, fixed high-angle three-quarter action-roguelite presentation**.

The target is Hades-like in the sense that combat is read from a stable elevated camera, rooms are composed as authored arenas, characters and enemies have convincing volume and directional animation, and the player makes fast planar movement/spacing decisions. Oathbound keeps its own dark Japanese-gothic martial-horror identity, combat rules, progression systems, encounter structure, and authored regions.

This is no longer a conventional 2D production target. The existing Camera2D projection and procedural actor proxies are a migration/prototyping bridge, not the intended final character/environment pipeline.

The concise target is:

> **Planar action-roguelite combat + fixed high-angle Camera3D presentation + stylized 3D characters, enemies, rooms, props, lighting, and VFX.**

The project may still use 2D screen-space UI, selected 2D effects, decals, or other hybrid elements where they are the best production choice. "3D presentation" does not require every asset or subsystem to become 3D.

## Not strict mathematical isometric

Oathbound should be described internally as **three-quarter / isometric-like**, not as a strict mathematical isometric game.

The camera pitch, focal treatment, orthographic/perspective choice, framing, and room composition should be tuned for readability and atmosphere rather than for equal-axis isometric geometry.

Player-facing shorthand may eventually call the game a "stylized 3D isometric action roguelite" if that communicates the experience clearly, but the production rule is a fixed high-angle three-quarter camera.

## Simulation boundary

Moving the presentation into 3D does **not** authorize a full third-person/Soulslike simulation rewrite.

The authoritative gameplay remains effectively planar:

- player and standard-enemy movement decisions are evaluated on the combat ground plane;
- attack reach, soft targeting, pressure admission, encounter positions, crowd spacing, and route geometry remain ground-plane concepts;
- the player does not receive a freely orbiting camera;
- ordinary combat does not require vertical aiming;
- vertical platforming, climbing, jumping between arbitrary elevations, or free-flight navigation are not part of this direction;
- existing Health, Poise/interruption, special-response parry, Techniques, Aspects, Relics, Prosthetics, Corruption, encounter scheduling, and Pressure Director rules remain gameplay authorities unless separately changed by playtesting.

A production 3D actor may ultimately use CharacterBody3D, NavigationAgent3D, or another 3D runtime representation, but its gameplay contract must preserve the same ground-plane semantics. Presentation migration is not permission to silently change combat distances, timings, pressure rules, or encounter balance.

## Character and enemy target

Akio and production enemies should increasingly be represented as **actual stylized 3D characters** rather than final 2D sprite sheets.

Priorities at gameplay camera distance:

- strong role-readable silhouettes;
- readable weapons, attack preparation, commitment, and recovery;
- eight-direction-or-better facing behavior where needed, driven naturally by the model/rig rather than pre-rendered sprite directions;
- animation timing synchronized to existing combat impact windows;
- grounded contact shadows and clear feet-to-floor anchoring;
- stylized materials that read under dark environments without requiring close-up detail;
- exaggerated poses and attack arcs where needed for high-angle readability;
- corruption, armor, weapon, and regional identity visible primarily through mass, motion, material, and silhouette.

The fixed camera means production should spend detail budget on **silhouette, animation, materials, lighting, and VFX**, not on cinematic facial detail that the normal play camera cannot resolve.

## Room and environment target

Combat rooms should become authored 3D spaces while retaining their underlying arena function.

Target capabilities include:

- real wall, gate, shrine, house, cliff, tree, fence, court, and ruin volume;
- natural behind/in-front-of occlusion from the camera;
- real height separation for scenery without turning height into unrestricted gameplay navigation;
- region-specific 3D modular kits;
- lighting and shadows that reinforce attack readability;
- safe foreground occluders that never hide critical threats for too long;
- floor decals and VFX attached to the combat plane;
- authored camera bounds and presentation framing per room archetype.

Hushiro remains the first production proving ground. A small representative Hushiro combat room should validate the complete 3D character/environment pipeline before mass-converting all regions.

## Camera target

The production target is a stable high-angle camera, likely Camera3D, with little or no player-controlled rotation.

It must preserve:

- predictable combat framing;
- readable enemy approach vectors;
- visible room exits/rewards where appropriate;
- enough screen space around Akio for pressure decisions;
- consistent perceived attack range;
- controlled foreground occlusion;
- compatibility with telegraphs, ground AoEs, target marks, and combat VFX.

Camera shake, hit emphasis, zoom accents, and boss framing may be layered on top of this stable baseline but should never make ordinary combat tracking unreliable.

## 2D-to-3D migration architecture

Migration should be staged rather than rewriting the entire game at once.

### Phase A — lock contracts and remove conflicting legacy assumptions

- Treat this document as the authoritative presentation direction.
- Keep Combat V2/Health-Poise/special-parry rules authoritative.
- Remove player-Posture progression/UI assumptions that conflict with the current combat model.
- Improve combat telemetry where playtests reveal ambiguous damage accounting.
- Enforce replacement-visual exclusivity so temporary/new visuals never stack over old body art.

### Phase B — one vertical 3D combat slice

Build a representative Hushiro combat room with:

- fixed high-angle Camera3D;
- 3D ground/architecture/occluders;
- 3D Akio stand-in with locomotion, dash, and the base katana sequence;
- at least two representative 3D enemy roles, preferably Swordsman plus Hound;
- 3D contact shadows/lighting;
- current encounter and pressure rules bridged onto the ground plane;
- current HUD/reward flow preserved.

The goal is not final art. The goal is to prove that the existing combat still feels correct when rendered through the intended production representation.

### Phase C — shared 3D actor/runtime bridge

After the vertical slice proves the direction:

- establish a common planar-to-3D coordinate contract;
- establish shared 3D player/enemy presentation roots;
- map current attack/action states to AnimationTree/3D animation playback;
- migrate hitboxes/hurtboxes only where necessary while preserving authored timings and ranges;
- establish 3D ground telegraph/VFX helpers;
- establish room/camera/occlusion authoring conventions;
- validate save/progression/encounter compatibility.

### Phase D — Hushiro production conversion

Convert Area 1 first. Do not mass-convert Yomori/Kagutsuchi until Hushiro proves:

- combat readability;
- animation pipeline speed;
- navigation reliability;
- performance budget;
- visual identity;
- room-authoring throughput;
- stable telemetry and validation.

### Phase E — later-region conversion

Yomori and Kagutsuchi inherit the shared 3D foundations while retaining their own combat/boss ownership and regional visual language.

## Replacement visual exclusivity

This is a hard production rule:

> **A replacement actor visual is exclusive, not additive.**

When a new custom sprite, texture, AnimatedSprite, 3D mesh, rig, or production actor representation replaces an older body visual, the previous body representation must be hidden or disabled.

Requirements:

- old body art must not render underneath replacement art;
- nested/multi-part legacy Sprite2D/AnimatedSprite2D stacks must be considered, not only one direct Sprite2D;
- intentional auxiliary VFX may remain when explicitly classified as effects rather than body art;
- migration bridges must restore legacy visuals correctly when a developer debug mode disables the replacement;
- production 3D actors should own a clear visual root so replacement/handoff is deterministic rather than heuristic.

The current Camera2D/proxy bridge should enforce this rule for compatibility actors until those actors move to the production 3D path.

## Art direction implications

Do not spend large production effort creating final bespoke 2D enemy body sprites for actors expected to migrate to 3D.

2D concept art remains valuable for:

- silhouette exploration;
- costume/material callouts;
- corruption motifs;
- regional palettes;
- weapon design;
- boss composition;
- VFX concepts;
- UI/portrait/illustration work.

Production character work should increasingly feed a stylized 3D modeling/rigging/animation pipeline.

## Non-goals

This decision does not turn Oathbound into:

- a free-camera third-person action game;
- a Soulslike camera/lock-on simulation;
- a vertical platformer;
- an open-world 3D game;
- a physics-sandbox combat game;
- a requirement to rewrite stable gameplay systems solely because 3D equivalents exist.

The purpose of 3D is to improve dimensional presence, animation, environment depth, lighting, occlusion, and production-quality presentation while preserving the fast authored roguelite combat that current playtests are converging on.

## Current immediate priorities

1. keep validating the Health + hidden-Poise + special-response combat model through real playtests;
2. reconcile first-return/Bloodwell progression with the no-player-Posture contract;
3. instrument the Hound/player damage path so telemetry reports raw damage, modifiers, and actual Health lost before balance changes;
4. harden temporary replacement-visual hiding so old and new actor bodies cannot overlap;
5. begin the representative Hushiro 3D vertical slice rather than investing further in final 2D body art.
