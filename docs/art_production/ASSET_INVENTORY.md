---
id: ART-ASSET-INVENTORY
title: Asset Inventory
category: art-production
status: draft
authority: primary
last_reviewed: 2026-09-16
---

# Asset Inventory

High-level production groups only. Detailed moves, timings, mechanics, and VFX stay in their owning gameplay/content authorities.

| Asset group | Current launch planning |
|---|---:|
| Player | 1 Akio source character + base/Aspect animation libraries |
| Blood Aspects | 3 — Wolf, Wraith, Ronin |
| Strand NPCs | 6 |
| Standard enemies | 15 — 6 Hushiro / 4 Yomori / 5 Kagutsuchi |
| Minibosses | 6 — two per region |
| Regional bosses | 3 |
| True-final Heart | 1 encounter / 2 forms |
| Environment sets | Strand + 3 regions + Heart subset |
| Prosthetics | 8 |
| Techniques | 40 Techniques + 6 refinements |
| Relics | 10 |
| Permanent stations | Bloodwell, Forge Bench, Blood Mirror |

## Player character production

Akio is the first source-rig production character. His current Stage 1 commission covers the reusable model/rig/source package plus Idle, Move, Dash, Defend, Hurt, Death, Quick Slash, Cross Cut, and Heavy Cleave. Dedicated Wolf/Wraith/Ronin libraries follow only after the base source asset and directional render treatment are accepted in-game.

The production pipeline is:

`concept -> 3D source model/rig -> animation -> fixed-camera directional masters -> 2D derivatives -> Godot`

Keep high-resolution masters. The current 128x128 profile is a gameplay derivative, not the paid source resolution.

## Combat presentation scope

Do not budget universal assets for:

- player or standard-enemy Posture bars;
- generic posture-break-to-kill presentation;
- Deathblow/execution prompts or shared execution animations;
- a universal parry/counter effect assumed by all Aspects.

Current shared needs include hit confirmation, sword-path readability, movement/dash readability, hurt/death reactions, hidden-Poise interruption/stagger feedback where useful, guard feedback for actors that actually guard, spatial telegraphs, projectile/AoE cues, Corruption/Shrine feedback, and boss-specific vulnerability/phase presentation.

## Technique production

Technique ownership is unlimited/additive for the run. The current launch catalog is **40 Techniques + 6 refinements** across Echo, Rupture, Seal, Rift, and Crimson. Current global action-trigger classifications are Basic Attack, Held Attack, and Dash / Dash Attack; kit-specific mechanics may have explicitly restricted hooks rather than becoming universal trigger assumptions.

Technique VFX should reuse base combat language where possible and add only the family-specific cue required to understand the effect.

## Environment / UI production

- Layered illustrated 2D environments use ground, decals, props, depth-sorted scenery, foreground/occlusion, VFX, and HUD layers.
- Current regional route production supports 12 / 10 / 11 counted chambers through reusable room foundations rather than unique art for every chamber.
- UI covers run combat/readability, Aspect/Tier/Corruption/Blood, Technique offers/build overview, Prosthetic/Relic management, progression stations, route/reward previews, results, records, and release surfaces.

## Explicit exclusions

No asset scope should be preserved solely for retired live Planar3D gameplay presentation, universal Posture/Deathblow systems, old Technique-slot/replacement UI, Prosthetic Techniques, alternate-weapon Forge systems, Relic rarity/Reliquary, generic Boss Emblems, or removed stance families.
