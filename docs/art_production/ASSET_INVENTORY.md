---
id: ART-ASSET-INVENTORY
title: Asset Inventory
category: art-production
status: draft
authority: primary
last_reviewed: 2026-08-16
topics:
  - asset-counts
  - characters
  - environments
  - ui
  - vfx
  - items
  - techniques
  - relics
  - progression
  - the-heart
related:
  - OVERVIEW-FULL-SCOPE
  - OVERVIEW-PRODUCTION-ROADMAP
  - META-OPEN-QUESTIONS
---

# Asset Inventory

This file records high-level production groups and known counts. Detailed states and animation lists belong in individual gameplay, VFX, UI, encounter, and milestone files.

## Master counts

| Asset group | Planned count | Boundary |
|---|---:|---|
| Player character | 1 | Akio base character plus introductory combat and three Aspect libraries |
| Blood Aspect families | 3 | Wolf, Wraith, Ronin |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 enemies | 6 | Hushiro standard roster |
| Area 2 enemies | 4 | Yomori standard roster |
| Area 3 enemies | 5 | Kagutsuchi standard roster |
| Minibosses | 6 | Two designed encounters per area |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Heart Binding campaign | 7 original / 6 player clears | Historical breach plus six removable states |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart, Vessel of Continuance |
| Environment sets | 4 + Heart subset | Strand, Areas 1–3, Heart chamber |
| Permanent upgrade stations | 3 | Bloodwell, Forge Bench, later-unlocked Blood Mirror |
| Prosthetic families | 8 | One family per tool |
| Technique direct-slot UI | 5 slots | Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow; Supporting/Cross-family/Legendary Techniques are slotless |
| Relic capacity | 1 | One equipped Relic |
| Launch Relics | 10 | Persistent collectible objects; no rarity tiers |
| Currency families | 4 | Mist, Scroll, Boss Emblem, Gold |

## Player and run-build art

- Akio concept/base sprite and introductory combat library.
- Reusable Blood-formed katana framework where practical.
- Three approved Aspect combat families with Tier 0 Basic/Held/Dash/Parry Counter presentation.
- Tier I-IV presentation according to locked packages.
- Blood resource and Blood Art states after Tier II.
- Shared defense, execution, input, and enemy-response language.
- Eight Prosthetic icons/VFX families.
- Technique card, rarity, family, direct-slot, Supporting, Cross-family, Legendary, refinement, replacement, warning, decline, reroll, comparison, and post-fill offer states.
- Ten Relic object/icon identities plus one shared collection/equip/mastery presentation family integrated with the Forge.

Additional Aspect families are outside launch scope.

## Locked Aspect production groups

| Aspect | Tier I | Tier II | Tier III | Tier IV | Supporting growth |
|---|---|---|---|---|---|
| Wolf | Blood Tempo | Blood Hunt | Fanged Guard | Apex Mauling | Feral Momentum |
| Wraith | Pale Barrage | Wraith's Reach | Spectral Passage | Beyond the Veil | Spectral Edge |
| Ronin | Steadfast Reprisal | Falling Mountain | Unbroken Resolve | Shattering Wake | Maximum player-posture capacity |

### Wolf

Production groups include valid-contact continuation, Feral Momentum escalation, Blood Hunt activation/howl/pursuit/Blood Fang/recovery, Fanged Guard one-hit frontal protection, Apex Mauling, and Blood HUD states.

### Wraith

Production groups include distinct Tier 0 spectral geometry, Pale Barrage, Spectral Edge, Wraith's Reach sweep/corridor/echo, Spectral Passage primary/secondary impacts and stopping feedback, Beyond the Veil range/deathblow/Veilstride states, and Blood HUD states.

### Ronin

Production groups include distinct Tier 0 heavy actions, guard/posture readability, Steadfast Reprisal, Falling Mountain/Deep Rupture, Unbroken Resolve plus Measured/Perfect Weight, Shattering Wake, and Blood HUD states.

Ronin's repeated maximum-posture growth uses the existing player-posture HUD/capacity language and does not create a new VFX/status family.

All three packages may guide high-level production grouping. Exact animation/effect counts remain implementation-brief and playable-validation work.

## Combatants

- **Area 1:** six standard enemies, Village Ogre, The Collector, Keeper of the Gate.
- **Area 2:** four standard enemies, Embered Pilgrim, Rotwood Host, Twin Maws.
- **Area 3:** five standard enemies, Blood Lotus, Eternal Swordsman, Eclipse Shogun.
- **True endgame:** Unbound Heart and Vessel of Continuance as one encounter package.

Exact Shogun and Heart attack/animation/VFX counts remain later encounter work.

## Environment and room art

- Strand hub, docks, NPC stations, Blood Cavern, and the later-unlocked Blood Mirror chamber.
- **Bloodwell** presentation for Akio + Run Infrastructure progression and Returning Blood reformation.
- **Forge Bench** presentation for Prosthetic + Relic progression/management.
- No separate Relic Reliquary asset family.
- No generic weapon-upgrade / weapon-socket station assets.
- Hushiro modular kit, functional rooms, miniboss spaces, boss arena.
- Yomori modular kit, functional rooms, miniboss spaces, Twin Maws arena.
- Kagutsuchi modular kit, functional rooms, miniboss spaces, Shogun arena.
- Heart chamber, six removable Binding states, extraction apparatus, reusable ritual, fully exposed state, true-final support.

Cross-area room functions: combat, Shrine, rest, shop, treasure/miniboss, boss.

Exact room counts, topology, route markers, branch frequency, and authored layout counts remain prototype work unless testing proves they require more production groups.

## UI and UX art

Required families include:

- Run HUD/combat feedback.
- Selected Aspect and Tier 0-IV states.
- Corruption, Resist, Embrace, Stabilize.
- Blood unavailable/building/ready/resolving/consumed states.
- Wolf Feral Momentum/Fanged Guard/Blood Hunt feedback where needed.
- Wraith Spectral Edge, Wraith's Reach, Spectral Passage, extended deathblow, and Veilstride feedback where needed.
- Ronin posture-capacity changes through existing posture HUD, Falling Mountain, Measured/Perfect Weight, and Shattering Wake feedback where needed.
- Five direct Technique slots plus Supporting/Cross-family/Legendary/rarity/refinement/replacement/comparison states.
- Forge Prosthetic category and Relic collection/equip/mastery/progression states without rarity badges.
- Bloodwell Akio + Run Infrastructure category states without assuming final node layout.
- Blood Mirror sealed/locked opening state plus later Aspect progression/trial states.
- Pause/build overview.
- Enemy/boss Health and posture.
- Deathblow prompts.
- Strand/persistent-currency UI.
- Route reward previews and service screens.
- Six-clear Heart Binding progress, final Heart, ending/credits, repeat-clear results, and postgame access.

## Shared VFX families

Core shared VFX include Parry Spark, Hit Spark, Deathblow Cue, Sword Trail, Posture Break Cue, Corruption Full, Embrace, Resist, and Tier IV Stabilize where needed.

Aspect VFX follow `ASPECT_VFX.md`; Prosthetic VFX follow `PROSTHETIC_VFX.md`; Technique-family presentation follows `TECHNIQUE_VFX.md`.

Superseded Prey Mark, Dire Hunt transformation, Apex Feast, Wraith duration-state reach, Veiled Guard, Pale Procession, perfect-dodge/Mist-Step/spinning Art, Ronin Counter Cut/Focus, reserve-Technique UI, formal drawback-badge assets, Crimson Burst-ready/recharge assets, generic weapon-development UI, and Relic rarity-badge/Reliquary families remain excluded.

## Item and reward art

- Mist, Scroll, Boss Emblem, Gold.
- Health and Spirit pickups.
- Temporary capacity rewards.
- Route markers.
- Technique rarity/refinement presentation.
- Ten approved Relics.
- Regional breakables and treasure.
- Consumables only if included in the final launch catalog.

## Inventory rules

- Add production groups only after their gameplay/narrative role is approved.
- Wolf, Wraith, and Ronin are the fixed launch Aspect identities.
- Do not imply corrective tracking, homing, or protection that gameplay does not provide.
- Do not create separate drawback icons for inherent weapon limitations.
- Reuse existing attack, deathblow, movement, and HUD families when a Tier modifies existing actions.
- No duplicate Aspect-specific Blood Art upgrade tree is included.
- Do not preserve assets for superseded mechanics.
- The 50-Technique roster, 10-Relic roster/mastery direction, eight Prosthetic Forge paths, and three-station progression ownership are approved for current paper-design scope.
- Exact permanent-upgrade node counts, mastery thresholds, reward probabilities, and interface density remain later design/playtest work.
- Additional Aspects, postgame modifiers, enemy variants, challenge systems, and route algorithms are outside initial inventory unless intentionally promoted.
