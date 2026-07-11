---
id: ART-TECHNICAL-STANDARDS
title: Art Technical Standards
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Art Technical Standards

These defaults inherit from the Milestone 1 outsourcing brief and may be refined only through explicit approval.

| Category | Standard |
|---|---|
| Perspective | Top-down / high-angle 2D |
| Base environment grid | 32×32 px |
| Direction handling | Down, up, and side with horizontal mirroring; attack vectors may remain continuous in engine |
| Animation rate | 12 FPS working default; final timing tuned in Godot |
| Pivot | Centered horizontally at feet/base; stable across frames in a row |
| Shadows | Separate soft elliptical ground-shadow layer; not baked into the body sprite |
| Character palette | Limited stylized palette; shared regional and project color discipline |
| Outlines | Subtle, partial, or none; avoid heavy black outlines |
| Delivery | Transparent PNG sheets, horizontal animation rows, uniform cells per row |
| Source | Aseprite preferred; layered PSD acceptable |
| Timing notes | Required for animated characters and VFX groups |
| Engine | Clean Godot 4 SpriteFrames/AnimatedSprite2D import |

## Working scale ranges

- Akio and standard humanoids: approximately 96–128 px tall
- Small/low enemies: approximately 64–96 px high
- Large controller enemies: approximately 112–144 px tall
- Minibosses: approximately 112–192 px depending on role
- Bosses: established relative to Akio and arena needs

These are planning ranges, not automatic final dimensions.

## Layering requirements

Keep projectiles, chains, fog, hazards, blood glow, transformation overlays, weapons, and large boss effects separate from body sprites where practical.

## Naming

Use stable asset IDs and descriptive animation names:

`ASSETID_assetname_animationname_##.png`

Preserve the same asset ID in source files, sheets, notes, and milestone inventories.
