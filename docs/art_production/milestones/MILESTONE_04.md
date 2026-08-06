---
id: ART-MILESTONE-04
title: Milestone 4 — Player Combat Depth
category: art-production
status: draft
authority: primary
last_reviewed: 2026-08-06
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
- Wraith approved Tier 0 extended blade lines, distinct attack geometry, restrained movement, deliberate frontal control, Spectral Edge contact, and Spectral Passage formation-penetration presentation
- Ronin Tier 0 concentrated power, heavy impact, guard stability, and slow-recovery presentation
- Three Aspect icons and selection states
- Fixed optional Tier I-IV escalation with action-specific commitment and tradeoff presentation
- Tier II Blood buildup, readiness, activation, resolving, consumed, and rebuilding states
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

- **Tier I — Blood Tempo:** valid-contact continuation cue
- **Feral Momentum:** sequence-position and Tier escalation treatment for Rending Cross, Raking Fang, and Blood Cleave
- **Tier II — Blood Hunt:** activation, limited-healing feedback, Blood howl, fixed pursuit line, eligible ordinary-enemy pass-through, stopping behavior, Blood Fang endpoint, and ending recovery
- **Tier III — Fanged Guard:** action-specific frontal guard availability, one-hit consumption, normal posture interaction, and Predator's Passage charge-complete feedback
- **Tier IV — Apex Mauling:** consolidated Blood-claw mauling, compact outer coverage, posture and guard recoil, and movement-only slow feedback

Blood Hunt is one immediate authored action rather than a transformation. Blood Fang is an effect attached to Akio's final endpoint strike, not a companion or independent actor. Wolf's ordinary animation library should be reused wherever the approved action does not require a distinct animation.

### Wraith package available through Tier III

- **Tier 0:** distinct Veil Cut line, Passing Arc sweep, Pale Lance focused reach, Ghostline Slash re-entry, and Veil Reversal posture-counter presentation
- **Tier I — Pale Barrage:** continuation from Pale Lance into rapid repeated thrusts while Akio remains stationary and committed to the selected direction
- **Spectral Edge:** physical-range versus spectral-only contact distinction and modest Tier-scaled posture and guard-pressure treatment
- **Tier II — Wraith's Reach:** full-meter activation, short directional preparation, compact broad frontal opening sweep, one very long fixed corridor strike, one weaker delayed repetition along the exact same geometry, and ending recovery
- **Tier III — Spectral Passage:** continuous qualifying spectral geometry through ordinary-enemy bodies, dominant primary impact, reduced secondary impacts, and clear termination against elites, bosses, protected heavy enemies, solid geometry, and authored blockers

Wraith's Reach is an immediate authored Blood Art rather than a duration state. It requires no persistent reach aura or ordinary-attack afterimage system. The delayed spectral Wraith appears only to repeat the approved corridor and must not read as an autonomous companion.

Spectral Passage should reuse the existing attack animation and trail families. Its production burden is primarily collision ownership, impact hierarchy, stopping feedback, and safeguards against extra reach, tracking, bouncing, repeated same-enemy hits, secondary Blood, and unrestricted proc presentation.

The current Tier IV candidate remains provisional:

- **Tier IV candidate — Pale Procession:** two reduced-power adjacent barrage shades and limited player-directed frontal steering

Wraith Tier 0-III may guide high-level scoping. Do not lock final Tier IV animation, VFX, audio, HUD, Shrine, trial, or full-package counts until the capstone audit is complete.

### Ronin package available for high-level scoping

- **Tier I — Steadfast Reprisal:** qualifying-block opportunity cue and slow standalone Reprisal Cut
- **Tier II — Falling Mountain:** Blood activation, player-posture relief, planted channel, direct slam, compact impact burst, fixed-point Deep Rupture anticipation, delayed rupture, and severe recovery
- **Tier III — Unbroken Resolve:** narrow costly commitment-preservation cue plus Measured Weight and Perfect Weight readiness and consumption
- **Tier IV — Shattering Wake:** contact-origin reduced-Health and strong-posture transfer through the primary target into enemies behind it

Ronin effects remain grounded, fixed-direction, and impact-focused. Falling Mountain and Unbroken Resolve provide narrow interruption-resistance exceptions without turning the entire kit into armored offense.

The former five stance families and superseded Wolf Prey Mark, Dire Hunt transformation, Apex Feast, Wraith duration-state reach buff, Veiled Guard, Wraith perfect-dodge/Mist-Step/spinning Art, and Ronin Counter Cut/Focus packages are not part of this milestone.

## Suggested internal order

1. Final Wolf, Wraith, and Ronin icons and Tier 0 VFX identity prototypes
2. Prototype Wolf Blood Tempo, Feral Momentum, Blood Hunt, Blood Fang, Fanged Guard, and Apex Mauling using the approved package
3. Prototype Ronin Steadfast Reprisal, Falling Mountain, Unbroken Resolve, and Shattering Wake using the approved package
4. Prototype Wraith Tier 0, Pale Barrage, Spectral Edge, immediate Wraith's Reach, and Spectral Passage using the approved Tier 0-III package
5. Resolve Wraith Tier IV and its remaining production group
6. Resolve Ronin's growth-rule and roster-wide minor-support questions
7. Complete the final cross-roster Tier I-IV presentation and production audit
8. Complete Blood buildup, readiness, activation, and all three Blood Arts
9. Prosthetic tool VFX and icons
10. Technique card, rarity, category, slot, reserve, refinement, and comparison framework
11. Technique reward, replacement, post-fill offer, decline, reroll, and rest-room management screens
12. Currency, pickup, capacity, and route-marker family
13. Relic, breakable, treasure, and reward-object family
14. Approved Technique icon catalog and required bespoke combat cues
15. Full HUD, Shrine, reward-screen, and mixed-build readability integration

## Dependency rules

- Final overlays inherit approved Akio sheets.
- Aspect effects follow the approved weapon-kit identities rather than superseded behavioral mechanics.
- All attacks remain player-directed; effects cannot imply corrective tracking or homing.
- Wolf and Ronin packages support high-level planning through Tier IV, but final animation and effect counts require implementation briefs.
- Wraith Tier 0-III supports high-level planning; final Tier IV and complete-package counts require the capstone revision.
- Blood Art effects require approved gameplay actions, timing, targeting, state behavior, and guaranteed activation payoff.
- Aspect effects inherit shared Returning Blood and Shrine language from Milestone 2.
- No separate mandatory drawback presentation is required. Inherent limitations remain visible through movement, direction, commitment, recovery, collision, and defensive access.
- Tool effects follow approved tool role, timing, footprint, and status behavior.
- Technique effects follow the approved slot, reserve, rarity, refinement, and trigger rules.
- Techniques reuse approved base combat, Aspect, and prosthetic VFX before new production is authorized.
- Techniques must not duplicate Blood Tempo, Feral Momentum, Blood Hunt, Blood Fang, Fanged Guard, Apex Mauling, Pale Barrage, Spectral Edge, Wraith's Reach, Spectral Passage, Steadfast Reprisal, Falling Mountain, Unbroken Resolve, Shattering Wake, or the approved final Wraith Tier IV package without explicit approval.
- Wolf, Wraith, and Ronin must remain distinct rather than becoming color variants.
- Wraith effects must remain visually separate from Mist Raven and must not imply teleportation, a duration transformation, an autonomous companion, or a detached passage projectile.
- Status markers and damage-number types must remain consistent across prosthetics, enemies, Techniques, Relics, and HUD.
- Technique, Relic, item, and consumable quantities must be locked before a final fixed quote; reusable templates may be produced before final catalog size.
- Additional Aspects are excluded from this milestone.
- No duplicate Aspect-specific Blood Art progression tree is included in current scope.
- Removed Frost and Hex stance statuses remain excluded unless another approved mechanic explicitly reintroduces them.

## Completion test

- Wolf, Wraith, and Ronin are immediately distinct and remain the central weapon identities.
- Technique-focused Tier 0-I builds, Tier II hybrid builds, and deeper Aspect-investment builds are all readable in the HUD and build interfaces.
- Wolf reads as close pressure and player-directed pursuit without requiring a mark, combo meter, tracking, companion, duration transformation, or drawback badge.
- Blood Hunt has an obvious activation payoff, fixed direction, stopping behavior, Blood Fang endpoint, and punishable ending position.
- Fanged Guard clearly protects only one approved frontal commitment through normal posture rules.
- Apex Mauling clearly communicates one consolidated claw package and movement-only slow without changing enemy attack timing.
- Wraith reads as deliberate extended frontal control without teleport, homing, perfect-dodge, duration-state reach buff, Veiled Guard, or discarded spinning effects.
- Wraith's Tier 0 actions are individually distinct and satisfying in the first combat room.
- Pale Barrage communicates continuation, stationary commitment, early release, and reduced repeated-hit impact.
- Spectral Edge clearly distinguishes physical contact from correctly spaced spectral-only contact without reading as a critical hit.
- Wraith's Reach clearly communicates its compact frontal sweep, fixed very long corridor, delayed same-geometry echo, ordinary vulnerability, and punishable poor line selection.
- Spectral Passage clearly continues existing geometry through ordinary-enemy formations, distinguishes primary and reduced secondary impacts, stops visibly against protected targets and geometry, and does not read as added reach, tracking, bouncing, or repeated same-target damage.
- Ronin reads as heavy impact and stability without tracking or a generic Focus state.
- Falling Mountain clearly communicates posture relief, direct impact, fixed delayed rupture, and severe commitment.
- Unbroken Resolve distinguishes costly commitment preservation from Measured Weight and Perfect Weight.
- Shattering Wake originates at primary contact and does not multiply damage back onto the primary target.
- Tier escalation is visible, modular, desirable, and compatible with the base player sheet.
- Blood unavailable, building, ready, resolving, and consumed states are understandable.
- Each approved Blood Art communicates activation payoff, target, timing, and resolution without obscuring enemy tells.
- All eight prosthetics communicate footprint, target, status, and active state.
- Technique choices, rarity, active slots, reserve, refinements, replacements, and loss warnings are understandable without tutorial text.
- A filled four-Technique loadout still presents understandable improvement choices through refinement, replacement, rarity, and reserve decisions.
- Technique combat feedback strengthens existing sword actions without creating one unique VFX family per card.
- Currency, pickup, Technique, Relic, route-marker, breakable, and reward families connect world sprites to UI icons and cards.
- Build-related icons and statuses remain understandable at gameplay and menu scale.
