---
id: ART-CHARACTER-BRIEF-STANDARD
title: Character and Enemy Brief Standard
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Character and Enemy Brief Standard

Keep artist-facing briefs short. A production-ready brief should answer only what the artist needs to build, animate, and deliver the character correctly.

## Required fields

- **Identity / role:** player, enemy, elite, miniboss, boss, or NPC; where it appears and what it does in combat.
- **Visual direction:** silhouette, body type, costume, weapon, corruption, and a small set of approved references.
- **Motion identity:** disciplined, feral, stalking, heavy, evasive, restrained, etc.
- **Gameplay readability:** what must be recognizable at the accepted high-angle camera.
- **Required animations:** only the current production batch, not speculative future moves.
- **Technical delivery:** source file, rig where applicable, separate weapon/accessories, stable feet/contact origin, directional render requirements, transparency, naming, and editable source dependencies.
- **Rights/provenance:** agreed commercial modification/derivative rights and disclosure of third-party/AI/mocap/plugin dependencies.

## Combat notes

Describe attack purpose qualitatively: fast opener, committed heavy strike, ranged setup, guard state, hurt reaction, etc. Do not force an animator to match provisional millisecond timings unless an owning gameplay contract explicitly requires it.

Standard enemies do not need a universal Posture-break or Deathblow/execution animation package. Hidden Poise/interruption is gameplay state, not a mandatory visible bar. Add guard, stagger, vulnerability, phase, or special-response animation only when that character/encounter actually owns it.

## Rig-rendered characters

When a character uses the offline 3D -> 2D pipeline, the source rig is the reusable production asset and Godot consumes rendered directional frames. The brief should point to `RIG_RENDERED_2D_PIPELINE.md` for technical details rather than duplicating that pipeline into every commission document.

## Quality rule

If an artist-facing brief becomes long enough to require several companion documents, shorten it. Internal gameplay authorities can remain detailed; the contractor should receive only the relevant production requirements and references.
