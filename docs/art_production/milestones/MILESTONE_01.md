---
id: ART-MILESTONE-01
title: Milestone 1 — Playable Combat Readability Vertical Slice
category: art-production
status: approved
authority: primary
last_reviewed: 2026-11-03
topics:
  - milestone-1
  - vertical-slice
  - hushiro
related:
  - ART-OUTSOURCING-WORKFLOW
  - ART-TECHNICAL-STANDARDS
  - ART-CORE-VFX
---

# Milestone 1 — Playable Combat Readability Vertical Slice

## Goal and sequencing

Build a **character-first, integrated** visual slice: Akio plus Corrupted Swordsman, one minimal reusable Hushiro room, required combat VFX/HUD, then Blighted Hound and Hollow. The complete slice contains four combatants, but we must test character/environment/effect cohesion **before** commissioning the wider roster. See [visual production roadmap](../VISUAL_ASSET_ROADMAP.md).

This broad **Art Production Milestone 1** is distinct from Hammer's currently signed **Akio Milestone 1 / Proof A** (Akio source rig + Idle/Move/Quick Slash), which does **not** include enemies, room art, VFX or HUD. Each separate artist commission requires its own written scope/approval; the internal milestone is not a purchase order.

## Acceptance gates

1. **Akio Proof A:** Verify source rig, Action/slot/keyframe completeness, all-eight-direction rendering, feet anchor, silhouette and realistic movement/strike playback in Godot. Choose visual treatment only after in-game comparisons. Do not prematurely authorize a full roster.
2. **Akio base library:** After accepted Proof A and separate written authorization, complete the remaining six core Actions and judge full combo/weapon-state continuity. See [proposed Hammer Milestone 2 plan](../../commissions/akio/AKIO_MILESTONE_02_PLANNING.md).
3. **Corrupted Swordsman:** Validate player/enemy silhouette, directional attack anticipation and repeated actor/depth/import costs.
4. **Mini Hushiro environment + effects gate:** Add only one modular combat room kit, a few reusable props, grounding/shadows, basic sword/hit/attack cues, and minimal combat HUD; confirm character size, visual contrast, Y-occlusion and mixed VFX readability.
5. **Four-combatant slice:** Add Blighted Hound and Hollow; verify mixed roles and crowd readability in the benchmark room before significant Area 1 scale-up.

## Included scope (broad art milestone, not one artist contract)

| ID | Asset | Purpose |
|---|---|---|
| PLY-001 | Akio source-rig player | Base nine-Action library through separate approved Akio commission gates |
| EN-A1-001 | Corrupted Swordsman | First enemy, player/enemy presentation comparison |
| ENV-A1-001 | Hushiro benchmark room kit | Ground/path, modular facade/wall, low obstacle, tall occluder, lantern/atmosphere; reuse in at least two layouts |
| VFX-001 | Sword trail | Basic weapon-path readability |
| VFX-002 | Hit spark | Ordinary hit confirmation |
| VFX-003 | Attack/ground cue | Threat direction and enemy windup/spatial warning where needed |
| VFX-004 | Guard feedback (conditional) | Only for character kits that actually guard; no universal parry effect |
| UI-001 | Minimal combat HUD | Health, relevant resources/feedback, readable over Hushiro |
| EN-A1-002 | Blighted Hound | Lunge and pack-pressure differentiation |
| EN-A1-003 | Hollow | Fragile swarm-pressure differentiation |

Combat V2 **does not** need universal player/enemy Posture bars, Posture Break or Deathblow cues, execution prompts or default parry visuals. Health is the usual defeat condition; hidden Poise and kit-specific Guard/Reprisal may require only their actual dependent presentation. Do not inherit retired art scope from old prototype briefs.

## Suggested internal batches

1. Akio Proof A / full base library in separately approved stages; keep current Hammer deliverable boundary intact.
2. Corrupted Swordsman proof, independently scoped.
3. Small Hushiro room/prop kit + necessary sword/hit/attack feedback + minimum HUD, ideally after the player/enemy proof and **before** bulk enemies.
4. Blighted Hound + Hollow with their dependent cues; complete four-combatant integration.

Art teams can work in parallel only when the character style/readability targets and source handoffs are stable. Source models/Actions, environment elements, VFX and UI may be produced by different specialists. Do not presume Hammer owns other crafts.

## Deliverables and completion

- For rig-rendered characters: editable Blender model/rig/Actions, textures/dependencies and timing/Action-range notes; the client generates high-res masters and Godot PNG derivatives. Apply the [canonical source-to-PNG validator procedure](../../../tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md).
- For painted environments: editable/modular elements or agreed layered export, pivot/depth/collision guidance and reusable compositions.
- For VFX/UI: source assets/configuration, purpose/timing notes and checked Godot readability.
- At final slice acceptance: all four characters are distinct at actual gameplay zoom; swords/windups/impact and safe space are clear; the room generates multiple layouts with correct ground-based Y sorting; HUD and effects do not obscure threats; every asset integrates cleanly in Godot.

Commercial terms are governed by each signed agreement; do not apply generic sheet-based 30/70 or a new paid Style Test to the existing Hammer agreement.
