# Three-Quarter / 2.5D Presentation Standard

Status: **adopted game-wide presentation direction**

## Decision

Oathbound uses a fixed high-angle three-quarter / isometric-like presentation for world-space gameplay.

This direction was approved after direct playtesting of the projected camera, dimensional room treatment and upright actor proxies. It is no longer an experiment that competes with the legacy top-down view. New world, character, VFX and environment work should be authored for the three-quarter presentation by default.

The gameplay simulation remains 2D:

- `CharacterBody2D` movement remains authoritative.
- Existing 2D collision shapes and hitboxes remain authoritative.
- Existing enemy AI, navigation, Pressure Director logic and encounter geometry remain authoritative.
- Attack ranges and ground distances are not rewritten merely for presentation.
- The presentation layer projects those authoritative coordinates for the screen.

Architecture rule:

> **2D combat simulation + fixed three-quarter projected presentation + dimensional artwork.**

Do not migrate Oathbound to full `CharacterBody3D` / 3D physics merely to obtain this presentation. A future vertical-gameplay requirement would need its own design justification.

## Projection baseline

`Utility/CameraFollow.gd` owns the global projection profile.

Adopted baseline:

- horizontal camera zoom: `0.94`
- ground-plane vertical compression: `0.84`
- framing offset: `Vector2(0, -18)`
- upright actor art is counter-projected vertically
- world-space interface roots are counter-projected once so labels/prompts remain upright
- player/enemy roots receive Y-derived draw order
- player/enemy contact shadows establish the ground plane
- procedural proxy/shadow attachment is deferred so GameFlow construction cannot race `add_child()`

A world-space circle is expected to read as an ellipse on screen because the circle belongs to the projected ground plane. The simulation-space circle remains unchanged.

`F9` is retained only as a developer A/B/debug switch for checking projection regressions against legacy presentation. It is not a competing player-facing mode.

## Playable-world coverage

The adopted presentation now covers the main world-space game flow:

1. **The Strand / Hub**
2. **Hushiro** — Area 1
3. **Yomori** — Area 2
4. **Kagutsuchi Court** — Area 3
5. **Blood Cavern training**, which runs inside the Strand and uses the same projected actor/depth systems

Title, video and CanvasLayer-only menu screens are screen-space interfaces and do not require world projection conversion.

## The Strand

`World/ThreeQuarterStrandScenery.gd` replaces the old flat hub-image read while the adopted presentation is active.

The conversion deliberately preserves all original gameplay coordinates and scripts. Dimensional placeholders are anchored to the existing stations rather than moving interaction geometry:

- Boat
- Forge
- Discovery Board
- Bloodwell
- Merchant
- Blood Cavern entrance
- Blood Mirror
- Keeper
- Scribe
- Raven
- Undead Samurai
- Smith
- Peddler

The Strand now reads as a carved refuge with a projected floor, cavern walls, station silhouettes, NPC stand-ins and foreground lighting/occlusion cues. These are production-layout placeholders rather than final environment art.

## Hushiro visual language

Hushiro uses the Area 1 authored presentation layer under `Regions/Hushiro/Presentation/`.

Current composition language:

- weathered earth and stone
- retaining walls with visible faces/top surfaces
- ruined torii and shrine forms
- dead grass, rocks, broken fencing and foreground occluders
- blood/ember ritual accents
- sparse feudal-road architecture

Hushiro has dedicated three-quarter wrappers for:

- Combat
- Rest
- Shrine
- Merchant / Shop
- Miniboss
- Boss
- Treasure

The inherited service-room wrappers preserve their existing gameplay scripts and interaction nodes and add presentation only.

## Yomori visual language

Yomori keeps its native combat and Twin Maws boss authority while using the same presentation architecture.

`Utility/ThreeQuarterRegionScenery.gd` gives Area 2 a distinct language:

- wet blue-green / desaturated ground
- broken stone walls
- crooked trees and exposed roots
- reeds and low mist shapes
- ghost lanterns
- root-arch boss framing
- spectral teal readability accents

Rest, Shrine, Merchant / Shop, Miniboss and Treasure use inherited shared three-quarter wrappers. `SceneRegistry` selects those wrappers only while Area 2 is active, so their scenery resolves to Yomori automatically.

## Kagutsuchi Court visual language

Kagutsuchi keeps its native combat and Eclipse Shogun boss authority while using the same presentation architecture.

Area 3 visual rules:

- dark court stone
- crimson lacquered architecture
- gold trim and ritual accents
- tall pillars and strict wall rhythm
- banners, braziers and foreground rails
- monumental Eclipse gate framing

Rest, Shrine, Merchant / Shop, Miniboss and Treasure use the same region-aware inherited service wrappers, resolved as Kagutsuchi by the active Area 3 registry state.

## Directional actor presentation

`Utility/ThreeQuarterActorProxy.gd` is the temporary production bridge for character art.

Important rules:

- authoritative actor roots, movement, AI and hitboxes are never replaced by the proxy
- facing is quantized into eight sectors to match the intended production animation pipeline
- stopped `AnimationPlayer` playback is a valid state and must never produce errors
- the canonical Player proxy may read existing controller state for facing, attacks, blocks and parries, but it must not write gameplay state
- legacy body sprites may be made transparent while the proxy is active

Current proxy identities cover:

### Akio

- upright ronin silhouette
- katana readability
- crimson identity accents
- controller-aware stationary attack/guard facing

### Hushiro

- Swordsman
- Warden
- Archer
- Hollow
- Hound
- Bilemass

### Yomori

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound
- Rootfang
- Briarthorn

### Kagutsuchi

- Court Guard
- Court Caster
- Elite Defender
- Hollow Vessel
- Court Sentinel
- Eclipse Shogun

These are silhouette/readability specifications, not final character art.

## Projected combat readability

`Utility/ThreeQuarterCombatPresentation.gd` owns presentation-only ground cues.

Current language includes:

- enemy arrival ripples
- melee pressure rings/arcs
- ranged sightlines and target ellipses
- Bilemass area-pressure cues
- hound pressure cues
- larger boss action footprints
- Yomori spectral cue color
- Kagutsuchi court/crimson cue color
- player slash/guard readability through the actor proxy

All ground-space effects are authored in world coordinates. The camera projection converts their circles/ranges into screen ellipses automatically, preserving gameplay truth.

These effects never create damage, change ranges, reserve attack tokens, alter AI or participate in collision.

## Screen-upright vs ground-space rule

Every new world visual must be classified deliberately.

### Ground-space

Project with the arena:

- AoE circles
- target zones
- floor trails
- landing marks
- contact shadows
- range indicators
- decals

### Screen-upright / body-upright

Counter-project or keep in CanvasLayer:

- character bodies
- world interaction labels
- world health/status UI
- damage numbers where applicable
- HUD
- menus
- selected particles intended to rise vertically

Do not allow a world-space Control hierarchy to receive inverse compression more than once; child Controls inherit the correction from their top world-space Control root.

## Depth and occlusion contract

Dimensional props need a meaningful ground anchor.

- ground/floor content stays in the low background z-band
- upright actors use Y-derived depth ordering
- tall props use the same broad Y-anchor convention so Akio can pass behind/in front naturally
- foreground occluders must be placed where temporary player concealment does not make combat unfair
- CanvasLayer HUD is never included in world depth sorting

The current compatibility depth bias exists because many legacy scenes were authored at z=0. Production scenes should increasingly use explicit floor/prop/depth bands instead of relying on accidental draw order.

## Production art pipeline

The engine/presentation conversion is now established. Remaining work is primarily content production and polish.

### Character production

Initial target: up to eight directions where facing materially affects silhouette/readability.

Requirements:

- stable foot/ground anchors
- consistent apparent body height through directions
- silhouettes readable against dark environments
- attack arcs designed for three-quarter screen depth rather than top-down radial motion
- separate body and ground-shadow responsibilities
- animation timing synchronized to existing combat impact windows
- mirroring/reuse allowed when it remains visually convincing

### Environment production

Replace procedural placeholders with painted/dimensional modular assets while preserving the projection contract:

- floors/ground planes
- walls with visible faces and top surfaces
- gates, shrines, houses, cliffs and court structures with explicit ground anchors
- safe foreground occlusion modules
- atmospheric layers outside simulation bounds
- room variants that preserve gameplay geometry

### VFX production

Replace debug/procedural cues with production effects while preserving their ground-space/upright classification and gameplay timing.

## Validation contract

`Regions/Hushiro/Validation/ThreeQuarterPresentationSmoke.gd` and `.github/workflows/three-quarter-presentation-check.yml` protect the adopted architecture.

The contract verifies:

- the Strand owns an active three-quarter presentation layer while preserving core gameplay stations
- Area 1 resolves Hushiro presentation rooms
- Area 2 resolves Yomori native combat/boss rooms plus region-aware three-quarter service rooms
- Area 3 resolves Kagutsuchi native combat/boss rooms plus region-aware three-quarter service rooms
- combat/boss rooms expose projected combat presentation where required
- legacy flat backgrounds are replaced only by presentation layers, not by gameplay rewrites

Regional route contracts remain responsible for route structure, roster and boss authority. Presentation migrations should update those expected resource paths without weakening their gameplay invariants.

## Non-goals

The presentation shift does not justify throwing away the current combat architecture. Player movement, enemy AI, Pressure Director, Health/Poise rules, encounter scheduling, Aspects, Techniques, Relics, Prosthetics, Corruption and other combat systems remain authoritative unless playtesting identifies a separate gameplay problem.
