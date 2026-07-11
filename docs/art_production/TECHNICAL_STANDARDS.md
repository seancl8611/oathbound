---
id: ART-TECHNICAL-STANDARDS
title: Art Technical Standards
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - pixel-art
  - sprite-sheets
  - godot-import
  - naming
  - delivery
related:
  - ART-OUTSOURCING-WORKFLOW
  - ART-MILESTONE-01
---

# Art Technical Standards

These are working production defaults inherited from the polished Milestone 1 outsourcing brief. A separately approved paid Style Test may refine scale, palette, and detail density; once approved, those outputs become binding visual targets for the milestone.

## Visual and engine standards

| Category | Standard |
|---|---|
| Style quality anchor | Blasphemous-tier high-resolution pixel-art polish and silhouette discipline; not its side-view perspective |
| Perspective | Top-down / high-angle 2D |
| Base environment grid | 32×32 px, confirmed or revised through Style Test |
| Direction handling | Down, up, and side with horizontal mirroring; attack vectors remain continuous in engine and independent of sprite facing |
| Animation rate | 12 FPS working default; final per-frame timing tuned in Godot |
| Pivot | Centered horizontally at feet/base; same pivot pixel position across all frames in a row |
| Character palette | Approximately 6–10 body colors per character; shared milestone palette locked after Style Test |
| Outlines | Subtle, partial, or none; avoid heavy black outlines that flatten silhouettes |
| Shadows | Separate soft elliptical ground-shadow sprite per character; never baked into the body sheet |
| Delivery | Transparent PNG sprite sheets, horizontal layout, one row per animation, uniform cell size per row |
| Source | Required for characters, VFX, and UI; Aseprite preferred, layered PSD acceptable |
| Timing notes | Short frame-duration notes required for each animated character and VFX group |
| Engine import | No padding artifacts; consistent cells and pivots; clean SpriteFrames/AnimatedSprite2D import in Godot 4 |

## Working scale ranges

- Akio: 96–128 px tall
- Corrupted Swordsman and comparable humanoids: 96–128 px tall
- Blighted Hound: 64–80 px tall
- Hollow and comparable small humanoids: 72–96 px tall
- Large controller enemies: approximately 112–144 px tall
- Minibosses: approximately 112–192 px depending on role
- Bosses: established relative to Akio and final arena needs
- Environment tile: 32×32 px base

These are planning ranges, not automatic final dimensions. Style Test approval locks the practical scale relationship used for production.

## Layering requirements

Keep the following separate from body sprites where practical:

- ground shadows,
- weapons when required for readability or modularity,
- projectiles,
- chains and ropes,
- fog and smoke,
- hazards and persistent ground fields,
- blood glow and Corruption overlays,
- transformation and Aspect overlays,
- large boss effects.

## Naming

Frames:

`ASSETID_assetname_animationname_##.png`

Examples:

- `PLY-001_akio_quick_slash_03.png`
- `EN-A1-001_swordsman_attack_windup_02.png`
- `ENV-A1-001_hushiro_floor_stone_a.png`

Sheets:

`ASSETID_assetname_sheet.png`

Source:

`ASSETID_assetname.aseprite` or approved layered equivalent.

Preserve the same asset ID across frames, sheets, source files, notes, palettes, previews, inventories, and contractor briefs.

## Delivery-folder baseline

Each production batch uses:

`/Delivery/Batch_##_AssetName/`

Recommended subfolders:

- `/Sheets`
- `/Frames` when individual frames are supplied
- `/Source`
- `/Previews` for optional GIFs or clips
- `/Notes` for timing and implementation notes
- `/Palette`

Reference folders and delivery folders must remain separate so visual references cannot be mistaken for approved deliverables.

## Acceptance checks

- transparent backgrounds are clean,
- cells are uniform,
- pivots do not drift,
- final frames hold clearly where required,
- key states remain distinct at gameplay scale,
- shared palette and shadow style remain consistent,
- sheets import into Godot without manual repair,
- effects and environment art preserve combat readability.
