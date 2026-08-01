---
id: ART-MILESTONE-04
title: Milestone 4 — Player Combat Depth
category: art-production
status: draft
authority: primary
last_reviewed: 2026-08-01
---

# Milestone 4 — Player Combat Depth

## Goal

Complete the visual identities and interface support for Akio's major build-shaping systems after the base character, combat VFX hierarchy, shared Shrine foundation, and core room framework are stable.

The milestone must support optional Aspect Tier investment and continued Technique development after the four active slots are filled.

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
- Wraith Tier 0 extended blade lines, broad arcs, restrained movement, and deliberate connected-melee presentation
- Ronin Tier 0 concentrated power, heavy impact, guard stability, and slow-recovery presentation
- Three Aspect icons and selection states
- Fixed optional Tier I-IV escalation with action-specific commitment and tradeoff presentation
- Tier II Blood buildup, readiness, activation, active or resolving, consumed, and rebuilding states
- Three Blood Art presentation packages after their gameplay designs are approved
- Modular mutation overlays only where required by approved Tier or narrative presentation
- Eight prosthetic VFX families
- Reusable Technique card, rarity, category, and icon language
- Four active Technique slots and one reserve slot
- Technique offer, refinement, replacement, reserve, overwrite-warning, decline, reroll, rarity, and comparison states
- Post-fill Technique offers that communicate refinement, compatible or higher-rarity replacement, and wildcard opportunities
- Rest-room reserve-swapping presentation
- Contextual HUD support for Techniques with tracked combat state
- Technique combat VFX only where existing sword, Aspect, or prosthetic language is insufficient
- Relic card family and separate initial Relic slot
- Currency, Health, Spirit, temporary-capacity, route-marker, breakable, treasure, and reward-object art
- Status markers and damage-number extensions required by approved prosthetics, Techniques, enemies, and Relics

### Wolf package available for high-level scoping

- **Tier I — Blood Tempo:** valid-contact cue for the earlier next-Basic input
- **Tier II — Dire Hunt:** activation howl, immediate recovery feedback, active transformation, consumed or ending state
- **Blood Fang:** principal new Wolf attack animation and Blood-jaw effect
- **Tier III — Fanged Guard:** charge guard, one frontal block, charge-complete feedback
- **Tier IV — Apex Feast:** deathblow eruption, limited recovery feedback, and fully charged next-Held state

Wolf's transformed ordinary sword attacks should reuse the existing Wolf animation library with stronger Blood presentation where practical. The Blood jaw is an effect attached to Akio's attack, not a companion or independent actor.

### Wraith package available through Tier II

- **Tier I — Pale Barrage:** continuation from Pale Lance into rapid repeated thrusts while Akio remains stationary and committed to the selected direction
- **Tier II — spinning Blood Art:** full-meter activation, fixed identical rotations, slower player-directed movement, body-blocking, no ordinary action access, direct Health exposure, and uninterrupted sequence presentation

Wraith Tier III-IV remain later gameplay work. Ronin Tier I-IV remain unresolved and should be defined one Tier at a time.

The former five stance families and superseded Wolf Prey Mark, Wraith perfect-dodge/Mist-Step, and Ronin Counter Cut/Focus packages are not part of this milestone.

## Suggested internal order

1. Final Wolf, Wraith, and Ronin icons and Tier 0 VFX identities
2. Prototype Wolf Blood Tempo, Dire Hunt, and Blood Fang using the approved working package
3. Prototype Wraith Pale Barrage and the Tier II spinning Blood Art using the approved working package
4. Define and prototype Wraith Tier III, then Tier IV
5. Define Ronin's Tier package one Tier at a time and prototype its Blood Art after Tier II is approved
6. Complete cross-roster Tier I-IV escalation and inherent-tradeoff presentation
7. Complete Blood buildup, readiness, activation, and all three Blood Arts
8. Prosthetic tool VFX and icons
9. Technique card, rarity, category, slot, reserve, refinement, and comparison framework
10. Technique reward, replacement, post-fill offer, decline, reroll, and rest-room management screens
11. Currency, pickup, capacity, and route-marker family
12. Relic, breakable, treasure, and reward-object family
13. Approved Technique icon catalog and required bespoke combat cues
14. Full HUD, Shrine, reward-screen, and mixed-build readability integration

## Dependency rules

- Final overlays inherit approved Akio sheets.
- Aspect effects follow the approved weapon-kit identities rather than superseded behavioral mechanics.
- All attacks remain player-directed; effects cannot imply corrective tracking or homing.
- Wolf's current package supports high-level planning, but final animation and effect counts require an implementation brief.
- Wraith Tier I-II support high-level planning; Tier III-IV require later approved gameplay benefits.
- Ronin Tier effects require approved fixed Tier packages.
- Blood Art effects require approved gameplay actions, timing, targeting, and state behavior.
- Aspect effects inherit shared Returning Blood and Shrine language from Milestone 2.
- No separate mandatory drawback presentation is required. Inherent limitations remain visible through movement, direction, commitment, recovery, and defensive access.
- Tool effects follow approved tool role, timing, footprint, and status behavior.
- Technique effects follow the approved slot, reserve, rarity, refinement, and trigger rules.
- Techniques reuse approved base combat, Aspect, and prosthetic VFX before new production is authorized.
- Techniques must not duplicate Blood Tempo, Blood Fang, Fanged Guard, Apex Feast, Pale Barrage, or the Wraith Blood Art without explicit approval.
- Wolf, Wraith, and Ronin must remain distinct rather than becoming color variants.
- Wraith effects must remain visually separate from Mist Raven and must not imply teleportation.
- Status markers and damage-number types must remain consistent across prosthetics, enemies, Techniques, Relics, and HUD.
- Technique, Relic, item, and consumable quantities must be locked before a final fixed quote; reusable templates may be produced before final catalog size.
- Additional Aspects are excluded from this milestone.
- No duplicate Aspect-specific Blood Art progression tree is included in current scope.
- Removed Frost and Hex stance statuses remain excluded unless another approved mechanic explicitly reintroduces them.

## Completion test

- Wolf, Wraith, and Ronin are immediately distinct and remain the central weapon identities.
- Technique-focused Tier 0-I builds, Tier II hybrid builds, and deeper Aspect-investment builds are all readable in the HUD and build interfaces.
- Wolf reads as close pressure and player-directed pursuit without requiring a mark, combo meter, tracking, companion, or drawback badge.
- Dire Hunt has an obvious activation payoff and Blood Fang is readable as its signature attack.
- Fanged Guard clearly protects one frontal blockable hit without implying full invulnerability.
- Apex Feast clearly communicates nearby impact and the fully charged next Held Attack.
- Wraith reads as slower deliberate extended connected-melee reach without teleport, homing, or perfect-dodge effects.
- Pale Barrage clearly communicates stationary focused commitment.
- Wraith's Tier II Art clearly communicates slower movement, body-blocking, direct Health exposure, and the fixed uninterrupted sequence.
- Ronin reads as heavy impact and stability without tracking or a generic Focus state.
- Tier escalation is visible, modular, desirable, and compatible with the base player sheet.
- Blood unavailable, building, ready, active, and consumed states are understandable.
- Each approved Blood Art communicates activation payoff, target, timing, and resolution without obscuring enemy tells.
- All eight prosthetics communicate footprint, target, status, and active state.
- Technique choices, rarity, active slots, reserve, refinements, replacements, and loss warnings are understandable without tutorial text.
- A filled four-Technique loadout still presents understandable improvement choices through refinement, replacement, rarity, and reserve decisions.
- Technique combat feedback strengthens existing sword actions without creating one unique VFX family per card.
- Currency, pickup, Technique, Relic, route-marker, breakable, and reward families connect world sprites to UI icons and cards.
- Build-related icons and statuses remain understandable at gameplay and menu scale.
