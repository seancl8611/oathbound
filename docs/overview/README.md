# Overview

High-level project identity, scope, combat direction, presentation authority, and production order belong here.

## Current authorities

- [Game Overview](GAME_OVERVIEW.md) — project identity, campaign/run shape, current gameplay architecture, and current production focus
- [Design Pillars](DESIGN_PILLARS.md) — non-negotiable combat, readability, theme, and production principles
- [Combat V2 Direction](V2_COMBAT_DIRECTION.md) — approved hunter-style combat authority: Health defeat, hidden Poise/interruption, room pressure, and kit-specific defense
- [Combat V2 Defense and Readability](V2_DEFENSE_READABILITY_DIRECTION.md) — current defense/resource/readability contract
- [Isometric 2D Presentation Direction](ISOMETRIC_2D_PRESENTATION_DIRECTION.md) — approved runtime/presentation authority for Camera2D, eight-direction actors, Y-depth, illustrated environments, and presentation boundaries
- [Full Game Scope](FULL_GAME_SCOPE.md) — approved launch scope
- [Production Roadmap](PRODUCTION_ROADMAP.md) — dependency order and current production milestones

## Art-production authority

The live game remains authoritative planar 2D. Offline 3D rigs may be used to produce directional 2D frames; they are an art-production source, not a runtime actor system.

See [Rig-Rendered 2D Pipeline](../art_production/RIG_RENDERED_2D_PIPELINE.md) for the current source-rig → directional-frame → Godot import workflow.

## Documentation rule

These overview files provide orientation. Detailed mechanics, canon, encounters, progression, and art requirements remain authoritative in their dedicated sections.

When older implementation notes conflict with the current Combat V2 or isometric 2D authorities, update/remove the stale assumption rather than treating it as a parallel design path.