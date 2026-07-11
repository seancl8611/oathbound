---
id: ART-MILESTONE-04
title: Milestone 4 — Player Combat Depth
category: art-production
status: draft
authority: primary
last_reviewed: 2026-07-11
---

# Milestone 4 — Player Combat Depth

## Goal

Complete the visual identities and interface support for Akio's major build-shaping systems after the base character, combat VFX hierarchy, shared Shrine foundation, and core room framework are stable.

## Authoritative design sources

- [Akio](../../characters/AKIO.md)
- [Combat System](../../gameplay/COMBAT.md)
- [Blood Aspect System](../../gameplay/BLOOD_ASPECTS.md)
- [Corruption and Shrines](../../gameplay/CORRUPTION_AND_SHRINES.md)
- [Technique System](../../gameplay/TECHNIQUES.md)
- [Prosthetic Tools](../../gameplay/PROSTHETICS.md)
- [Items, Currencies, and Rewards](../../gameplay/ITEMS_AND_REWARDS.md)
- [Blood Aspect VFX](../ASPECT_VFX.md)
- [Prosthetic Tool VFX](../PROSTHETIC_VFX.md)
- [Technique VFX](../TECHNIQUE_VFX.md)
- [Item, Pickup, and Reward Art](../ITEM_REWARD_ART.md)
- [Shrine Interface](../../ui_ux/SHRINE_INTERFACE.md)
- [Technique Rewards and Build Management](../../ui_ux/TECHNIQUE_REWARDS.md)
- [Run HUD and Combat Feedback](../../ui_ux/HUD.md)
- [Pause and Build Overview](../../ui_ux/PAUSE_OVERVIEW.md)

## Planned scope

- Wolf Prey Mark, pressure states, and Tier escalation
- Wraith afterimage, perfect-dodge, Mist-Step, and Tier escalation
- Ronin parry, Counter Cut, Focus, and Tier escalation
- Modular Tier I–IV mutation overlays
- Eight prosthetic VFX families
- Final Aspect and prosthetic icons
- Reusable Technique card and icon language
- Four active Technique slots and one reserve slot
- Technique offer, refinement, replacement, reserve, overwrite-warning, decline, reroll, and comparison states
- Rest-room reserve-swapping presentation
- Contextual HUD support for Techniques with tracked combat state
- Technique combat VFX only where existing sword, Aspect, or prosthetic language is insufficient
- Relic card family and separate initial Relic slot
- Currency, Health, Spirit, temporary-capacity, route-marker, breakable, treasure, and reward-object art
- Status markers and damage-number extensions required by approved prosthetics, Techniques, enemies, and Relics

The former five stance VFX families are removed from this milestone.

## Suggested internal order

1. Final Blood Aspect icons and three base VFX identities
2. Tier escalation and modular mutation overlays
3. Prosthetic tool VFX and icons
4. Technique card, category, slot, reserve, refinement, and comparison framework
5. Technique reward, replacement, decline, reroll, and rest-room management screens
6. Currency, pickup, capacity, and route-marker family
7. Relic, breakable, treasure, and reward-object family
8. Approved Technique icon catalog and required bespoke combat cues
9. Full HUD, Shrine, reward-screen, and mixed-build readability integration

## Dependency rules

- Final overlays inherit approved Akio sheets.
- Aspect effects inherit shared Returning Blood and Shrine language from Milestone 2.
- Tool effects follow approved tool role, timing, footprint, and status behavior.
- Technique effects follow the approved slot, reserve, refinement, and trigger rules.
- Techniques reuse approved base combat, Aspect, and prosthetic VFX before new effect production is authorized.
- Wolf, Wraith, and Ronin must remain distinct rather than becoming color variants.
- Mist Raven and Wraith reposition effects require separate silhouette and timing language.
- Status markers and damage-number types must be consistent across prosthetics, enemies, Techniques, Relics, and HUD.
- Technique, Relic, item, and consumable quantities must be locked before a final fixed quote; reusable templates may be produced before final catalog size.
- The removed Frost and Hex stance statuses are not included unless another approved mechanic explicitly reintroduces them.

## Completion test

- Wolf, Wraith, and Ronin are immediately distinct and remain the central run identities.
- Tier escalation is visible, modular, and compatible with the base player sheet.
- All eight prosthetics communicate footprint, target, status, and active state.
- Technique choices, active slots, reserve, refinements, replacements, and loss warnings are understandable without tutorial text.
- Technique combat feedback strengthens existing sword actions without obscuring enemy tells or creating one unique VFX family per card.
- Currency, pickup, Technique, Relic, route-marker, breakable, and reward families connect world sprites to UI icons and cards.
- Build-related icons and statuses remain understandable at gameplay and menu scale.
