---
id: ART-DIRECTION
title: Art Direction
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - isometric-2d
  - directional-sprites
  - rig-rendered-2d
  - illustrated-environments
  - fixed-high-angle-camera
  - combat-readability
  - regional-palettes
  - corruption-language
  - materials
  - the-heart
related:
  - ART-TECHNICAL-STANDARDS
  - ART-RIG-RENDERED-2D-PIPELINE
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
  - CONTENT-STRAND-OVERVIEW
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-AREA2-OVERVIEW
  - CONTENT-AREA3-OVERVIEW
---

# Art Direction

## Core style

Oathbound targets a **stylized illustrated 2D presentation viewed through a fixed high-angle/isometric-style Camera2D**. Gameplay characters are small in screen space, read through eight-direction body/weapon silhouettes, and move through layered illustrated environments with independent 2D combat VFX and telegraphs.

The live game is not a real-time 3D character/environment renderer. Gameplay remains authoritative planar 2D. A 3D character, rig, animation scene, material setup, or render camera may be used **offline** to generate final directional 2D frames, but the source 3D asset is a production tool rather than a runtime actor.

Hades remains a useful reference for composition, small-screen readability, authored environment framing, and how character silhouettes survive a high-angle camera. Oathbound is not required to copy Hades' exact rendering method, palette, line treatment, or animation cadence.

The game should feel disciplined, dangerous, elegant, and cursed. Martial clarity is the first priority; atmosphere is the second.

## Global visual rules

### Gameplay-scale character treatment

Akio and standard enemies should occupy a deliberately small screen-space footprint appropriate for multi-enemy combat. Elites and bosses may become larger where role and encounter readability justify it, but size must not turn ordinary enemies into visual walls.

Production art should spend detail where the accepted gameplay camera can actually read it:

- stance and center of mass;
- weapon path and hand placement;
- cloth/armor mass;
- head/shoulder silhouette;
- major corruption landmarks;
- guard or protected posture when relevant;
- anticipation, impact, recoil, and recovery poses.

Fine facial detail, tiny costume ornaments, micro-surface texture, and other close-up information are secondary unless they survive the final runtime treatment.

### Silhouette philosophy

Every unit must read first through stance, weapon shape, body line, and mass. Ornament, costume detail, and corruption accents are secondary. Enemy families may share motifs, but role changes must remain obvious before small details are noticed.

Every important character decision must be reviewed at the accepted Hushiro combat composition, not only in concept art, Blender, or enlarged sprite previews.

### Value and contrast

Foreground gameplay assets must separate clearly from atmospheric backgrounds through controlled value ranges, readable edges, shadows, material treatment, and reduced competition in combat spaces. Dark characters cannot disappear into dark scenery.

Directional actors, danger telegraphs, projectiles, and attack silhouettes take precedence over decorative environment contrast.

### Global palette anchors

The unified palette is built around ash, iron, old wood, blood-red, bone, and cold indigo-violet. Regional shifts may change temperature, saturation, and corruption intensity without abandoning these anchors.

### Corruption language

Beast Blood may appear through:

- branching dark-red veins;
- heat bloom;
- hardened blood growths;
- embedded eyes;
- split tissue;
- ash shedding;
- blood mist;
- biological pressure;
- asymmetrical distortion.

It may be ritualized, deliberately activated, feral, spiritually thinned, or physically unstable, but it must read as the same rare force expressed through a particular bearer, history, duration, and environment.

Deliberate activation, retained intelligence, and elegant mutation do not visually imply true control. Akio alone possesses genuine sovereignty over Beast Blood; Court presentation should communicate false mastery rather than equality with him.

Do not imply a conventional airborne or bite-spread infection. Do not make every victim visually communicate one repeated duty or role as the curse's central meaning.

### Material language

- Steel is dark, burdened, and maintained by use rather than shine.
- Cloth is layered, weathered, and functional.
- Wood is rain-dark, salt-worn, shrine-aged, or lacquered according to region.
- Paper is brittle, ritual-charged, and vulnerable to wind.
- Lacquer is cracked in ruined spaces and unnaturally immaculate in the Court.
- Bone is aged and used sparingly.
- Blood changes according to freshness, curse state, and containment.
- Corruption combines blood, heat, ash, lacquer, mist, and biological pressure rather than reading as generic magic.

For hand-painted 2D assets these qualities are authored directly. For offline 3D source rigs or environment studies, painterly albedo/value control, restrained material response, stylized lighting, selective outline/rim treatment, and deliberate shadow shapes are valid tools when they survive the final 2D render.

The runtime art should not depend on physically correct material response that disappears after prerender/downsample treatment.

### Animation clarity

Startup, impact, follow-through, recovery, recoil, interruption, guard/protected state, special response, and death require distinct body language where the gameplay action needs them. Busy costumes may not obscure the weapon path or body line.

Character motion may be hand-authored directly in 2D or created on an offline 3D rig. In either case:

- source animation should be authored for convincing motion and readable combat phases;
- gameplay owns damage timing, collision, action travel, invulnerability, and legal transitions;
- attack presentation follows normalized authoritative action progress rather than moving hit windows;
- source animation authoring FPS and exported runtime sprite cadence are separate decisions;
- no production sprite sequence should encode authoritative gameplay root motion.

An animator does not need to reproduce every current prototype millisecond exactly. The motion must expose clear anticipation/strike/recovery structure so Godot can map the accepted animation over the authoritative action timeline.

## Character-production route

Oathbound supports two production sources for directional characters:

1. hand-drawn/painted directional animation; or
2. custom offline 3D character -> rig -> animation -> fixed-camera eight-direction render -> 2D runtime frames.

Both routes must end at the same Godot contract: directional 2D frames with stable feet registration and presentation-only animation.

For the current Akio proof, the source 3D asset is intended to be a **custom Akio**, not a generic universal-base placeholder. The first paid source should be good enough to judge Akio's real silhouette, movement, sword language, and long-term production viability.

Keep high-resolution transparent master renders/source files. The current Godot proof consumes a 128 x 128 runtime derivative, but paid source delivery must not be limited to 128 x 128 masters. This preserves the ability to compare clean prerender, larger clean sprites, deliberate downsample/pixel treatment, or later hand cleanup without rebuilding the character from scratch.

## Readability rules

- Telegraphs must read from the normal gameplay camera without text labels.
- Attack direction and guard/protected state must remain legible in crowded rooms.
- Family resemblance cannot erase role distinction.
- Atmosphere, fog, particles, and foreground occlusion must not hide critical threats for too long.
- Frequent effects stay restrained; major interruptions, kit-specific counters, boss phase changes, Shrine choices, and other high-importance events receive stronger priority.
- Character art, animation, and VFX must be tested at final gameplay scale before close-up polish is approved.
- Eight directions must preserve handedness, weapon placement, costume asymmetry, and readable orientation; do not assume four-direction mirroring is sufficient for production.

## Environment presentation

Environment art uses layered illustrated 2D construction rather than live 3D room geometry as the production target.

The standard composition language is:

1. ground/base painting;
2. floor wear, blood, ash, roots, ritual marks, and other low decals;
3. low props that do not meaningfully occlude actors;
4. actors, enemies, pickups, and gameplay objects;
5. Y/depth-sorted mid-height props;
6. tall scenery and occluders;
7. foreground silhouettes/frames where useful;
8. world VFX and telegraphs;
9. screen-space HUD.

Tall props may be split into ground/base and upper/foreground pieces so the actor can pass visually behind them without corrupting gameplay collision. Depth ordering is based on the object's ground-contact point, not the top of its artwork.

## Regional escalation

### The Strand

**Identity:** the last threshold before the island—black shoreline, salt, lantern warmth, old Order function, and quiet dread.

**Palette:** rain-dark timber, charcoal stone, wet shoreline rock, faded indigo banners, parchment tan, muted moss, cold blue-gray sea, indigo-violet mist, and restrained lantern/forge warmth. Crimson remains a distant island-linked accent.

**Materials:** salt-worn planks, rough beams, soot-stained forge surfaces, old rope, faded cloth, brittle paper, cliff rock, shrine-aged markers, and maintained structures worn by wind and spray.

**Architecture:** a compact cliff-bound threshold station with role-specific structures—forge, formal Order house, keeper/scholar building, merchant lean-to, dock, central shrine marker, cliff access, and an offshore torii aligned toward the island.

**Motion:** restrained NPC routine and watchfulness; most life comes from smoke, tide, cloth, paper, lanterns, mist, and wind.

### Area 1 — Hushiro Gate Village / Rupture

**Identity:** a militarized village threshold where recent corruption violently breaks ordinary people and community. Human ruin first, monstrosity second.

**Palette:** rain-dark timber brown, soot-black tile, clay-mud earth, wet stone gray, smoke fog, faded shrine red, dried blood brown-black, dim lantern amber, and restrained dark crimson.

**Materials:** soaked timber, warped clay walls, cracked tile, damp stone, soot-stained paper, rotting shrine wood, rusted iron, old cloth, household debris, and barricade materials. Corruption appears as localized residue, staining, root intrusion, and structural warping.

**Architecture:** dense narrow paths, leaning homes, close rooflines, shallow balconies, worn torii, small shrines, guard points, barricaded interiors, and visible evidence of failed defense.

**Motion:** villagers twitch, hesitate, watch, retreat, rush, or lash out; soldiers retain fragments of stance discipline and formation behavior. Environmental motion remains subtle and oppressive.

Heart worship may appear through limited crude symbols, altered household shrines, or desperate offerings without turning the whole region into a formal religious complex.

### Area 2 — Yomori Grove / Adaptation

**Identity:** a haunted hunting region where long-term Beast Blood corruption has become part of predation, spirit persistence, and the environment's normal condition.

**Palette:** rot-black bark, bone-white trunks, wet earth, corpse-gray stone, deep moss green-black, cold fog, crimson leaves, dark blood-red sap, pale spirit light, and cyan-blue fungal glow.

**Materials:** root-knotted earth, swollen bark, red-veined trunks, slick stone, damp moss, fungal bloom, shrine lanterns, trail markers, and blood-rich sap. The forest should feel biologically pressurized and spiritually unstable without requiring a separate curse.

**Architecture:** swallowed hunting paths, shrine trails, torii, lantern markers, wayfinding stones, abandoned rest sites, and broken crossings overtaken by roots.

**Motion:** beasts stalk, observe, circle, withdraw, and lunge; spirits flicker, glide, and partially manifest with greater calm or purpose than Area 1's ruptured victims. Mist, fungi, branches, and shadow movement support uncertainty without making combat unreadable.

### Area 3 — Kagutsuchi Court / False Ascendancy

**Identity:** an immaculate inner court where elite retainers preserve culture, loyalty, hierarchy, and advanced mutation while mistaking dependence on Beast Blood for mastery.

**Palette:** lacquer black, deep vermilion, ceremonial red, warm lantern gold, muted ivory stone, blue-black water, blossom pink, dusk lavender, and restrained gilded accents.

**Materials:** polished lacquer, gilded trim, clean stone, mirror-still water, silk banners, refined tile, and immaculate blossom-covered courtyards. Corruption appears through elegant specialized mutation, impossible maintenance, and hidden Blood use rather than ordinary decay.

**Architecture:** grand halls, open courtyards, reflecting pools, curved bridges, stone paths, blossom-lined approaches, and richly ornamented gates arranged with symmetry and processional hierarchy. Kagutsuchi Court remains the approved setting.

**Motion:** soldiers and retainers move with precise, elegant discipline. Environmental motion is soft and measured: blossoms, water, banners, and lantern light reinforce apparent control and concealed enslavement rather than mindless ritual repetition.

## The Heart visual boundary

The source is canonically the Heart: an ancient living godlike organ or supernatural core. Its exact anatomy, size, surrounding structure, and final encounter form remain unapproved.

Concept work may suggest a divine organ, island core, vessel, remnant, or part of something larger, but it must not conclusively explain the Heart's origin or default to a simple oversized realistic human heart.

## Production rule

The current production default is **authoritative 2D gameplay with isometric-style 2D presentation**.

Live Planar3D/Camera3D presentation code and temporary Quaternius assets remain historical research/reference only. They are not the production target and must not be used to justify new live-runtime 3D character or environment work unless the project explicitly reopens that decision.

Regional art may become more ornate as the game advances, but combat communication must remain consistent. Every character, environment layer, animation, and VFX delivery should be reviewed at gameplay scale before detail polish is approved.
