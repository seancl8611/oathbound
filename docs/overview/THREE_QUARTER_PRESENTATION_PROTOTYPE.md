# Three-Quarter / 2.5D Presentation Prototype

Status: **playtest prototype**

Branch: `agent/three-quarter-pov-prototype`

## Purpose

Test Oathbound from a fixed high-angle three-quarter presentation before committing the project to a full art conversion or any 3D rewrite.

This prototype deliberately keeps the gameplay simulation 2D:

- `CharacterBody2D` movement remains authoritative.
- Current 2D collision shapes and hitboxes remain authoritative.
- Current 2D enemy AI, navigation, pressure logic and encounter geometry remain authoritative.
- Attack ranges and ground distances are not rewritten.
- The presentation layer projects those coordinates for the screen.

## Prototype projection

`CameraFollow.gd` now supports a reversible three-quarter profile.

Default prototype values:

- horizontal camera zoom: `0.88`
- ground-plane vertical compression: `0.72`
- framing offset: `Vector2(0, -28)`
- character art is counter-scaled vertically so bodies remain upright
- player/enemy roots receive Y-derived draw order
- player/enemy contact shadows establish a visible ground plane

The non-uniform camera zoom is intentional. A world-space circle therefore reads as an ellipse on screen, which is the expected projection of a circular ground-space range in a high-angle view. Physics remains circular in simulation space.

## Playtest controls

Press **F9** at runtime to switch instantly between:

1. the three-quarter prototype, and
2. the legacy top-down presentation.

A small upper-left badge shows which mode is active.

## What this prototype can answer

Use it to judge:

- whether more arena context on screen improves multi-enemy combat;
- whether compressed ground depth feels closer to the desired Hades-like spatial presentation;
- whether Akio and enemies remain readable while moving through projected depth;
- whether current attack ranges and enemy spacing still feel natural after projection;
- how much larger/taller future character artwork should be;
- whether foreground occlusion and architectural layering are worth the production cost.

## What it cannot answer yet

The current sprites were authored for the old view. This branch does **not** pretend they are final three-quarter assets.

A production-quality conversion would still need:

- three-quarter environment art and taller architecture;
- directional character art/animation (initial production target: eight directions where needed);
- authored foreground/occlusion layers;
- perspective-aware VFX and decals;
- final shadow shapes and lighting language;
- height-aware props and sorting anchors;
- review of projectiles and UI elements that should remain upright rather than ground-projected.

The point of this branch is to decide whether the projected spatial feel is correct **before** paying those art and content costs.

## Architecture rule if adopted

Keep gameplay coordinates and presentation coordinates conceptually separate:

> **2D combat simulation + fixed three-quarter projected presentation + dimensional artwork.**

Do not migrate Oathbound to full `CharacterBody3D` / 3D physics merely to obtain this camera style unless later prototypes prove that actual vertical gameplay is required.
