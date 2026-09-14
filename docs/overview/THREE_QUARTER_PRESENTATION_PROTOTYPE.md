# Three-Quarter / 2.5D Presentation Direction

Status: **direction adopted; Hushiro V2 route presentation implemented**

Branch: `agent/three-quarter-pov-prototype`

## Decision

Oathbound is moving toward a fixed high-angle three-quarter / isometric-like presentation.

The first camera-only playtest was intentionally crude and exposed the main weakness of a projection-only approach: old top-down environment art simply looks compressed when viewed through non-uniform zoom. The useful result of that test was the spatial direction itself. The project now builds authored presentation content around the new view rather than asking legacy art to carry the conversion.

This remains a 2D gameplay simulation:

- `CharacterBody2D` movement remains authoritative.
- Current 2D collision shapes and hitboxes remain authoritative.
- Current 2D enemy AI, navigation, pressure logic and encounter geometry remain authoritative.
- Attack ranges and ground distances are not rewritten merely for presentation.
- The renderer/presentation layer projects those coordinates for the screen.

Architecture rule:

> **2D combat simulation + fixed three-quarter projected presentation + dimensional artwork.**

Do not migrate Oathbound to full `CharacterBody3D` / 3D physics merely to obtain this camera style unless a later prototype proves that actual vertical gameplay is required.

## V2 projection baseline

`CameraFollow.gd` owns the reversible global camera profile.

Current defaults:

- horizontal camera zoom: `0.94`
- ground-plane vertical compression: `0.84`
- framing offset: `Vector2(0, -18)`
- legacy body art is counter-projected vertically when used
- player/enemy roots receive Y-derived draw order
- player/enemy contact shadows establish a visible ground plane
- shadow/proxy creation is deferred so GameFlow room construction cannot race `add_child()`
- F9 restores legacy sprites, z-order, zoom and presentation content for a clean A/B comparison

The projection is deliberately gentler than V1 (`0.72` compression). V2 relies more on authored depth cues, vertical silhouettes and foreground occlusion instead of forcing the entire visual effect through camera distortion.

A world-space circle still reads as an ellipse on screen, which is expected for a circular ground-space range viewed from a high angle. Physics remains circular in simulation space.

## Hushiro combat environment

`Regions/Hushiro/Presentation/ThreeQuarterHushiroPrototype.gd` provides temporary procedural scenery for the canonical Hushiro combat chamber.

It is presentation-only and adds no collision or combat authority. Current placeholders include:

- a bounded trapezoidal combat floor rather than an infinite dirt field;
- sparse diagonal ground guides and worn central combat space;
- a far retaining wall with visible top faces;
- a ruined torii with hanging talisman remnants;
- roadside shrine ruins and rock clusters;
- foreground broken fences and dead grass that can occlude actors;
- Y-anchored prop depth using the same broad ordering convention as actors.

This is not intended to become final vector art. Its purpose is to test composition, depth readability and the production rules future painted assets must obey.

## Hushiro route-wide service chamber presentation

Area 1 now overrides the shared service-room scenes through `SceneRegistry` with inherited Hushiro wrappers. The wrappers preserve the existing shared gameplay scripts and interaction nodes, then add only the presentation layer.

Covered Hushiro rooms:

- Combat
- Rest
- Shrine
- Merchant / Shop
- Miniboss
- Boss
- Treasure

`Regions/Hushiro/Presentation/ThreeQuarterServiceChamberScenery.gd` supplies reusable profile-specific scenery:

- **Rest:** ember basin, low bedroll/debris shapes and quiet haze;
- **Shrine:** blood altar, talisman posts and ritual floor mark;
- **Merchant:** dimensional stall, crates and lantern silhouettes;
- **Miniboss:** duel circle and standing stones;
- **Boss:** larger ritual arena, monumental gate and banners;
- **Treasure:** dimensional chest proxy and reward-floor glow.

Each wrapper hides its legacy dirt background only while V2 is active. The replacement floor remains in the background z-band so inherited prompts and interaction UI stay visible. Tall props use the same Y-derived depth convention as actors and can create controlled foreground occlusion.

Yomori and Kagutsuchi continue using their existing scenes; Hushiro presentation wrappers are selected only for Area 1.

## V2 directional actor placeholders

`Utility/ThreeQuarterActorProxy.gd` is the temporary character-art bridge.

While V2 is active, `CameraFollow.gd` can make the old top-down body sprite transparent and attach an upright procedural proxy to the same authoritative actor root. The proxy reads movement and existing animation state but never writes gameplay state.

Current role language:

- **Akio**: dark blue/charcoal upright ronin silhouette, crimson sash/scarf and readable katana;
- **Swordsman / generic melee**: corrupted humanoid silhouette with blade;
- **Warden**: heavier humanoid proportion;
- **Archer**: humanoid silhouette plus bow profile;
- **Hollow**: smaller pale/ashen humanoid;
- **Hound**: low quadruped silhouette;
- **Bilemass**: low organic mass rather than a humanoid stand-in.

Movement direction drives the proxy facing and front/back treatment. This establishes the intended directional production target without pretending these procedural shapes are final animation assets.

## Projected combat readability

`Utility/ThreeQuarterCombatPresentation.gd` provides temporary world-space combat cues underneath actors.

Current cues include:

- enemy arrival ripples;
- player/enemy melee action rings;
- Bilemass area-pressure read;
- Archer projected sightline and target ellipse;
- hurt/stagger ground feedback;
- proxy-local slash/guard/dash readability.

The important rule is that ground-space cues are authored in world coordinates. Camera projection turns circles/ranges into the expected screen ellipses automatically, so gameplay geometry stays truthful.

These effects are presentation only. They do not create damage, change range, reserve attack tokens, alter AI or participate in collision.

## Playtest controls

Press **F9** at runtime to switch instantly between:

1. the three-quarter V2 presentation, and
2. the legacy top-down presentation.

The comparison switch controls the camera profile, procedural actor proxies, contact shadows, Hushiro scenery/background replacement and projected combat FX together.

## What the V2 playtest should answer

Judge the route on:

- whether Hushiro now reads consistently as a dimensional place rather than a stretched texture;
- whether combat, rest, shrine, merchant and boss-facing rooms feel like members of the same visual language;
- whether Akio/enemies remain readable while moving through Y depth;
- whether role silhouettes are distinguishable before final art exists;
- whether foreground props make scenes feel dimensional without obscuring combat unfairly;
- whether the gentler projection preserves natural movement and spacing;
- whether attack ranges and enemy pressure still feel correct visually;
- whether projected telegraphs remain understandable during multi-enemy pressure;
- what size and silhouette production Akio/enemy art should target;
- whether the fixed camera exposes enough arena context for Hades-like multi-enemy combat.

Do **not** judge final character-art quality. The proxy layer exists specifically because production directional animation has not been authored yet.

## Production conversion roadmap

### 1. Camera and depth foundation — implemented for V2

- stable fixed three-quarter profile;
- actor/prop depth anchors;
- contact shadows;
- foreground occlusion policy;
- screen-upright vs ground-projected element policy;
- reversible legacy comparison.

### 2. Hushiro combat presentation vertical slice — implemented for V2

- deliberately authored combat chamber placeholder;
- Akio directional placeholder;
- six standard Hushiro role placeholders;
- representative melee/ranged/AoE telegraphs;
- slash, guard, dash, arrival and pressure readability adapted to projection.

### 3. Hushiro route presentation — implemented for V2

- Hushiro-specific inherited wrappers for shared service rooms;
- profile-specific placeholder scenery for rest/shrine/merchant/miniboss/boss/treasure;
- legacy background replacement only while V2 is active;
- Area 1 registry overrides isolated from later regions.

### 4. Character art pipeline — next production content phase

Initial production target: up to eight directions where silhouette/facing materially matters. Not every animation needs eight unique drawings if mirroring or authored directional reuse remains readable.

Character art needs:

- stable foot/ground anchors;
- consistent body height through directional frames;
- silhouettes that remain readable against dark environments;
- weapon arcs authored around screen depth rather than top-down radial motion;
- separate ground shadow from body artwork;
- animation timing that continues to match existing combat impact windows.

### 5. Environment production — next production content phase

Replace procedural placeholders with dimensional Hushiro modules:

- floor/ground planes;
- walls with visible faces and top surfaces;
- gates, shrines, houses and cliffs with explicit ground anchors;
- foreground modules designed to occlude only safe combat space;
- atmospheric background layers outside the simulation bounds;
- room variants that preserve the same projection/depth contract.

### 6. VFX and UI production — baseline implemented, production assets pending

Classify every effect as either:

- **ground-space**: projected with the arena (AoE rings, target zones, floor trails, landing marks), or
- **screen/upright**: kept visually upright (damage numbers, most HUD, status labels, selected particles).

This classification prevents the stretched-overlay problem from returning as more content is converted.

## Non-goals

The presentation shift does not require throwing away the current combat architecture. Player movement, enemy AI, Pressure Director, Health/Poise rules, encounter scheduling, Aspects, Techniques, Relics and other combat systems remain useful unless playtesting reveals a separate gameplay reason to change them.
