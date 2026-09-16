---
id: ART-CHARACTER-BRIEF-STANDARD
title: Character and Enemy Brief Standard
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - character-briefs
  - enemy-briefs
  - animation-planning
  - directional-sprites
  - rig-rendered-2d
related:
  - ART-DIRECTION
  - ART-TECHNICAL-STANDARDS
  - ART-RIG-RENDERED-2D-PIPELINE
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
---

# Character and Enemy Brief Standard

Use this structure for playable characters, NPCs, standard enemies, elites, minibosses, and bosses. Not every field requires the same length, but each production-ready brief should answer the relevant questions before outsourcing or internal final-art production.

| Field | Required definition |
|---|---|
| Name / working title | Final or placeholder name used consistently across files |
| Category | Player, NPC, enemy, elite, miniboss, or boss |
| Area / location | Where the character appears |
| Gameplay role | What the unit contributes to the player experience |
| One-sentence fantasy | Cleanest possible identity statement |
| Lore context | Who or what the character is and why it exists in the world |
| Visual identity | Body type, silhouette, costume, weapon, corruption, and status cues |
| Personality in motion | Disciplined, feral, stalking, unstable, restrained, ritualized, or other movement identity |
| Combat readability | What must be recognized immediately at the accepted gameplay camera |
| Directional readability | Which asymmetries, weapon relationships, or role cues must survive all eight directions |
| Required animations | Must-have gameplay and interaction states |
| Optional animations | Ambient, polish, intro, talk, or secondary loops |
| Gameplay-state hooks | Guard/protected state, hidden-Poise reaction, kit-specific counter state, boss vulnerability, or other approved mechanics that need presentation |
| Technical notes | Feet anchor, scale, frame canvas, weapon separation, VFX hooks, layering, occlusion, source-rig needs, and engine constraints |
| Source/delivery requirements | Editable source, master renders, runtime derivatives, naming, rights/provenance, and dependency disclosure |

## Combatant additions

Combatants should also define, where applicable:

- attack and response language;
- Health/hidden-Poise interruption behavior relevant to visible reactions;
- authored guard/protected behavior if the unit actually has it;
- kit-specific defensive/counter states instead of assuming a universal player parry;
- boss/miniboss stagger or vulnerability states when encounter-specific;
- phase or escalation structure;
- arena dependencies;
- VFX and UI dependencies;
- production reuse opportunities;
- completion test at gameplay scale.

Do **not** add a universal visible enemy Posture bar, Deathblow state, player Posture resource, or universal Parry/Counter animation requirement unless the owning gameplay/encounter authority explicitly calls for it.

## Directional character requirements

Production combatants should be evaluated in the eight runtime directions:

`e, se, s, sw, w, nw, n, ne`

A brief should call out anything that makes mirroring unsafe, including:

- weapon hand;
- scabbard placement;
- armor asymmetry;
- corruption asymmetry;
- one-sided props;
- attack path differences;
- readable front/rear relationship.

The actor's ground contact/feet point remains the placement and depth-sorting anchor.

## Rig-rendered source additions

If the character will use the offline 3D -> 2D route, the brief should also define:

- source model/texture/material expectations;
- reusable rig/control-rig expectations;
- separate weapon/scabbard objects when relevant;
- neutral bind/reference pose;
- in-place animation requirement;
- fixed render camera/projection;
- high-resolution transparent master output;
- runtime derivative target or proof target;
- no per-frame auto-cropping;
- stable feet registration;
- source/tool/plugin dependency disclosure;
- commercial use/modification/derivative-render requirements.

## Brief quality rule

A brief is not production-ready if it describes only appearance. It must connect visual identity to gameplay role, movement, telegraph readability, animation scope, directional read, source/render constraints, and technical delivery.

A brief also should not duplicate an obsolete gameplay model. When combat or progression rules change, update the brief around the owning current authority rather than preserving stale posture/deathblow/parry assumptions for art consistency.
