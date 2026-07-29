---
id: ART-MILESTONE-04
title: Milestone 4 — Player Combat Depth
category: art-production
status: draft
authority: primary
last_reviewed: 2026-07-28
---

# Milestone 4 — Player Combat Depth

## Goal

Complete the visual identities and interface support for Akio's major build-shaping systems after the base character, combat VFX hierarchy, shared Shrine foundation, and core room framework are stable.

## Authoritative design sources

- [Akio](../../characters/AKIO.md)
- [Combat System](../../gameplay/COMBAT.md)
- [Blood Aspect System](../../gameplay/BLOOD_ASPECTS.md)
- [Wolf Blood Aspect](../../gameplay/WOLF_ASPECT.md)
- [Wraith Blood Aspect](../../gameplay/WRAITH_ASPECT.md)
- [Ronin Blood Aspect](../../gameplay/RONIN_ASPECT.md)
- [Corruption and Shrines](../../gameplay/CORRUPTION_AND_SHRINES.md)
- [Progression](../../gameplay/PROGRESSION.md)
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

- Wolf Tier 0 attack, player-directed pursuit, contact, and overcommitment presentation
- Wraith Tier 0 extended blade lines, broad arcs, and precise connected-melee presentation
- Ronin Tier 0 concentrated power, heavy impact, guard stability, and slow-recovery presentation
- Three Aspect icons and selection states
- Fixed Tier I-IV escalation and evolving drawback presentation
- Tier II Blood buildup, readiness, activation, active or resolving, consumed, and rebuilding states
- Three Blood Art presentation packages after their gameplay designs are approved
- Modular mutation overlays only where required by approved Tier or narrative presentation
- Eight prosthetic VFX families
- Reusable Technique card and icon language
- Four active Technique slots and one reserve slot
- Technique offer, refinement, replacement, reserve, overwrite-warning, decline, reroll, and comparison states
- Rest-room reserve-swapping presentation
- Contextual HUD support for Techniques with tracked combat state
- Technique combat VFX only where existing sword, Aspect, or prosthetic language is insufficient
- Relic card family and separate initial Relic slot
- Currency, Health, Spirit, temporary-capacity, route-marker, breakable, treasure, and reward-object art
- Status markers and damage-number extensions required by approved prosthetics, Techniques, enemies, and Relics

### Wolf package now available for high-level scoping

- **Tier I — Blood Tempo:** valid-contact cue for the earlier next-Basic input
- **Tier II — Dire Hunt:** activation howl, immediate recovery feedback, active transformation, consumed or ending state
- **Blood Fang:** principal new Wolf attack animation and Blood-jaw effect
- **Tier III — Fanged Guard:** charge guard, one frontal block, charge-complete feedback
- **Tier IV — Apex Feast:** deathblow eruption, limited recovery feedback, and fully charged next-Held state

Wolf's transformed ordinary sword attacks should reuse the existing Wolf animation library with stronger Blood presentation where practical. The Blood jaw is an effect attached to Akio's attack, not a companion or independent actor.

The former five stance families and superseded Wolf Prey Mark, Wraith perfect-dodge/Mist-Step, and Ronin Counter Cut/Focus packages are not part of this milestone.

## Suggested internal order

1. Final Wolf, Wraith, and Ronin icons and Tier 0 VFX identities
2. Prototype Wolf Blood Tempo, Dire Hunt, and Blood Fang using the approved working package
3. Define Wraith and Ronin Tier packages and Blood Arts
4. Complete cross-roster Tier I-IV escalation and drawback presentation
5. Complete Blood buildup, readiness, activation, and all three Blood Arts
6. Prosthetic tool VFX and icons
7. Technique card, category, slot, reserve, refinement, and comparison framework
8. Technique reward, replacement, decline, reroll, and rest-room management screens
9. Currency, pickup, capacity, and route-marker family
10. Relic, breakable, treasure, and reward-object family
11. Approved Technique icon catalog and required bespoke combat cues
12. Full HUD, Shrine, reward-screen, and mixed-build readability integration

## Dependency rules

- Final overlays inherit approved Akio sheets.
- Aspect effects follow the approved weapon-kit identities rather than superseded behavioral mechanics.
- All attacks remain player-directed; effects cannot imply corrective tracking or homing.
- Wolf's current package supports high-level planning, but final animation and effect counts require an implementation brief.
- Wraith and Ronin Tier and drawback effects require approved fixed Tier I-IV packages.
- Wraith and Ronin Blood Art effects require approved gameplay actions, timing, targeting, and state behavior.
- Aspect effects inherit shared Returning Blood and Shrine language from Milestone 2.
- Tool effects follow approved tool role, timing, footprint, and status behavior.
- Technique effects follow the approved slot, reserve, refinement, and trigger rules.
- Techniques reuse approved base combat, Aspect, and prosthetic VFX before new production is authorized.
- Techniques must not duplicate Blood Tempo, Blood Fang, Fanged Guard, or Apex Feast without explicit approval.
- Wolf, Wraith, and Ronin must remain distinct rather than becoming color variants.
- Wraith effects must remain visually separate from Mist Raven and must not imply teleportation.
- Status markers and damage-number types must remain consistent across prosthetics, enemies, Techniques, Relics, and HUD.
- Technique, Relic, item, and consumable quantities must be locked before a final fixed quote; reusable templates may be produced before final catalog size.
- Additional Aspects are excluded from this milestone.
- No duplicate Aspect-specific Blood Art progression tree is included in current scope.
- Removed Frost and Hex stance statuses remain excluded unless another approved mechanic explicitly reintroduces them.

## Completion test

- Wolf, Wraith, and Ronin are immediately distinct and remain the central run identities.
- Wolf reads as close pressure and player-directed pursuit without requiring a mark, combo meter, tracking, or companion.
- Dire Hunt has an obvious activation payoff and Blood Fang is readable as its signature attack.
- Fanged Guard clearly protects one frontal blockable hit without implying full invulnerability.
- Apex Feast clearly communicates nearby impact and the fully charged next Held Attack.
- Wraith reads as extended connected-melee reach without teleport, homing, or perfect-dodge effects.
- Ronin reads as heavy impact and stability without tracking or a generic Focus state.
- Tier escalation is visible, modular, and compatible with the base player sheet.
- Blood unavailable, building, ready, active, and consumed states are understandable.
- Each approved Blood Art communicates activation payoff, target, timing, and resolution without obscuring enemy tells.
- All eight prosthetics communicate footprint, target, status, and active state.
- Technique choices, active slots, reserve, refinements, replacements, and loss warnings are understandable without tutorial text.
- Technique combat feedback strengthens existing sword actions without creating one unique VFX family per card.
- Currency, pickup, Technique, Relic, route-marker, breakable, and reward families connect world sprites to UI icons and cards.
- Build-related icons and statuses remain understandable at gameplay and menu scale.