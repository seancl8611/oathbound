---
id: ART-ASSET-INVENTORY
title: Asset Inventory
category: art-production
status: draft
authority: primary
last_reviewed: 2026-09-16
topics:
  - asset-counts
  - characters
  - environments
  - ui
  - vfx
  - items
  - techniques
  - relics
  - boss-materials
  - progression
  - isometric-2d
  - the-heart
related:
  - OVERVIEW-FULL-SCOPE
  - OVERVIEW-PRODUCTION-ROADMAP
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Asset Inventory

High-level production groups and known counts only. Detailed states, moves, timings, and VFX requirements belong in their owning gameplay/content/art files.

The runtime presentation target is eight-direction 2D characters plus layered illustrated 2D environments. Offline 3D source work is counted as production source for those 2D deliverables, not as a second live-runtime asset family.

# Master counts

| Asset group | Planned count | Boundary |
|---|---:|---|
| Player character | 1 | Akio base + introductory combat + three Aspect libraries |
| Blood Aspects | 3 | Wolf, Wraith, Ronin |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Standard enemies | 15 | 6 Hushiro / 4 Yomori / 5 Kagutsuchi |
| Minibosses | 6 | Two authored per region |
| Regional bosses | 3 | Keeper, Twin Maws, Eclipse Shogun |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart + Vessel of Continuance |
| Environment sets | 4 + Heart subset | Strand + Areas 1–3 + Heart spaces |
| Permanent upgrade stations | 3 | Bloodwell, Forge Bench, later-unlocked Blood Mirror |
| Prosthetics | 8 | One production family per tool |
| Technique catalog | 40 + 6 refinements | Unlimited run-owned collection; five families; current runtime/catalog authority owns exact eligibility |
| Relics | 10 | One equipped; Base -> Mastery I -> Mastery II |
| General currency icon families | 3 | Mist, Scrolls, Gold |
| Regional boss-material object/icon families | 3 | One each for Keeper, Twin Maws, Shogun; exact names/concepts TBD |
| Heart Binding campaign states | 7 original / 6 player clears | Historical breach + six removable states |

# Character-production shape

Every combatant eventually needs a directional 2D presentation package appropriate to its role.

For rig-rendered characters, production scope includes two tiers:

- editable/high-resolution source and master-render package;
- runtime derivative package consumed by Godot.

Current actor-production gating is intentionally not roster-wide:

1. custom Akio Proof A;
2. Akio Stage 1 completion;
3. one Corrupted Swordsman;
4. roster expansion only after the pair passes the production/readability gate.

Do not quote or schedule the entire roster as custom rig-rendered production until this gate is accepted.

# Player / run-build production

Requires:

- Akio base combat and shared movement presentation;
- kit-specific defensive presentation rather than a universal visible player-Posture layer;
- three approved Aspect presentation families through Tier IV;
- Blood resource/Blood Art states after Tier II;
- eight Prosthetic icon/VFX families;
- reusable Technique card/family/rarity/refinement/reroll states for an additive unlimited collection;
- ten Relic object/icon identities plus Forge collection/equip/mastery presentation;
- recovery/capacity/persistent-resource reward icons.

Additional Aspects and the old alternate-weapon system are outside launch scope.

# Combatants

- **Hushiro:** six standard enemies, Village Ogre, The Collector, Keeper of the Gate.
- **Yomori:** four standard enemies, Embered Pilgrim, Rotwood Host, Twin Maws.
- **Kagutsuchi:** five standard enemies, Blood Lotus, Eternal Swordsman, Eclipse Shogun.
- **Endgame:** two-form Heart encounter.

Standard enemies use Health + hidden Poise/interruption. Do not create a universal visible enemy-Posture/Deathblow production layer for the roster.

Exact Shogun and Heart animation/VFX counts remain later encounter work.

# Environment / hub production

- Strand hub/docks and six NPC service locations.
- Bloodwell presentation for Akio + Run Infrastructure.
- Forge Bench presentation for Prosthetics + Relics.
- Blood Cavern + initially sealed Blood Mirror.
- No separate Relic Reliquary.
- No generic weapon-upgrade/socket station.
- Reusable layered illustrated foundations for Hushiro, Yomori, Kagutsuchi.
- Regional miniboss/boss arenas.
- Heart chamber, extraction apparatus, six Binding states, fully exposed state, true-final support.

Current route budgets are 12 / 10 / 11 counted chambers. Production uses reusable environment foundations, prop families and authored composition variants rather than one unique scene/art set per chamber.

# UI / UX production families

- Run HUD / combat feedback.
- Health, Spirit, Aspect / Tier / Corruption / Blood states where applicable.
- Technique collection/build overview with family, rarity, refinement and current eligibility language.
- Technique offer/refinement/reroll presentation; acquisition remains additive and does not overwrite another Technique merely because it affects the same gameplay action.
- Forge Prosthetic + Relic management.
- Bloodwell Akio + Run Infrastructure categories.
- Blood Mirror locked/unlocked progression/trial states.
- Pause/build overview.
- Route reward previews and Shop/Rest/Shrine service screens.
- Persistent-resource summaries: Mist, Scrolls, three regional boss materials.
- Failed-run / Binding-return / final-Heart results.
- Heart Binding campaign progress and completed-save/postgame states.

Regional boss materials should appear in results/permanent-progression UI when relevant but do not require normal route-marker icons because they are fixed boss drops.

Do not preserve UI scope for player Posture, universal enemy Posture bars, a universal Deathblow prompt, or universal Parry/Counter states when the owning current combat system does not require them.

# Shared VFX families

Current shared combat VFX production should prioritize effects that still exist across the Combat V2 runtime:

- ordinary hit confirmation;
- sword trails / weapon-path readability;
- guard/protected-contact impact where relevant;
- interruption/stagger/recoil confirmation where a visible distinction is useful;
- perilous/unblockable or spatial-danger telegraph families owned by attack semantics;
- projectile and ground-AoE readability;
- corruption-full / Embrace / Resist / Stabilize presentation;
- boss/miniboss transition/vulnerability effects as encounter-specific packages.

Ronin Reprisal/parry-like cues, enemy-specific guard breaks, boss vulnerability, and other specialized responses belong to their owning kit/enemy/encounter rather than the global shared bundle.

Aspect, Prosthetic, and Technique VFX are owned by their dedicated art authorities.

# Item / reward art

Required families:

- Mist;
- Scrolls;
- Gold;
- **three source-specific regional boss materials**;
- Health / Spirit recovery;
- temporary capacity/support rewards where still present in the owning reward authority;
- route markers;
- Technique reward presentation;
- 10 Relics;
- regional breakables / Treasure.

There is **no generic Boss Emblem token family** and no general launch consumable-inventory art family unless launch scope changes explicitly.

# Explicitly excluded superseded production

Do not preserve asset scope for:

- live real-time 3D actor/environment production as the normal runtime;
- four-active-plus-reserve Technique UI;
- exclusive per-action Technique equipment/replacement presentation;
- Prosthetic Techniques;
- universal player Posture HUD;
- universal standard-enemy Posture/Deathblow loop;
- generic Parry/Counter presentation required by every player kit;
- Crimson Burst-ready/recharge states;
- old Storm/Frost/Ember/Hex/Shadow stance system;
- generic alternate-weapon progression;
- Relic rarity badges / Reliquary;
- old fixed Bloodwell three-branch presentation;
- generic Boss Emblem tokens;
- general launch consumable inventory.

# Inventory rules

- Add a production group only after its gameplay/narrative role is approved.
- Reuse existing animation/VFX/UI families when mechanics modify existing actions rather than create new actions.
- Do not create separate UI/VFX for balance values that can reuse existing presentation.
- Technique art/UI must communicate the current catalog without implying equipment slots or a global inventory cap.
- Current 40-Technique + 6-refinement, 10-Relic, eight-Prosthetic, three-station, 33-chamber, and three-boss-material structures are sufficient for current high-level production planning.
- Final interface density, exact permanent node values, mastery thresholds, reward probabilities, and tuning remain later work.
- Character-production counts must include source/master/runtime-derivative work when the rig-rendered route is chosen; do not hide that cost behind a single sprite-line item.
