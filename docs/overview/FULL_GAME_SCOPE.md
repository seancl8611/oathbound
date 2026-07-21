---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-07-21
topics:
  - full-scope
  - asset-counts
  - areas
  - strand
  - techniques
  - the-heart
  - heart-bindings
  - campaign-clears
  - true-final-heart
  - postgame
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - CONTENT-AREA3-TRUE-FINAL-HEART
---

# Full Game Scope

This document records the current production-level shape of Oathbound. Exact balance values, frame counts, room counts, Technique and Relic catalog sizes, detailed Heart attacks, and implementation values remain subject to design lock and playtesting.

## Master scope summary

| Asset group | Planned count | Current scope note |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, and complete combat animation library |
| Blood Aspects | 3 | Wolf, Wraith, and Ronin with Tier 0–IV progression |
| Technique loadout | 4 active + 1 reserve | Run-only Techniques with shallow refinements; final catalog size remains open |
| Prosthetic tools | 8 | Distinct tactical tools using shared activation where practical |
| Run-scoped Relic capacity | 1 initial slot | Final Relic catalog size remains open |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, and Scribe |
| Area 1 standard enemies | 6 | Grounded village/garrison corruption roster |
| Area 2 standard enemies | 4 | Forest, spirit, and predator roster |
| Area 3 standard enemies | 5 | Court and inner-sanctum roster |
| Miniboss encounters | 6 | Two per main area |
| Regional major bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach, six player-destroyed Bindings, then the final story run |
| True-final Heart encounter | 1 encounter / 2 forms | Unbound Heart followed by the enormous Vessel of Continuance |
| Environment sets | 4 + Heart subset | Strand plus Areas 1–3; Heart chamber supports Binding and true-final states |
| Cross-area room types | 6 | Combat, Shrine, rest, shop, treasure/miniboss, boss |
| Current currency families | 4 | Mist, Scroll, Boss Emblem, Gold |
| Relic rarity tiers | 4 | Common, Uncommon, Rare, Legendary |

## Player

- Akio base character and full combat animation library
- Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, and Dash Slash
- Katana combat, posture, parry, block, dash, deathblow, and prosthetic activation
- Blood Aspects: Wolf, Wraith, and Ronin
- Tier 0 through Tier IV run-only mutation progression
- Four empty active Technique slots and one empty reserve at run start
- Standalone Techniques with natural shared-verb synergy
- At most one slotless refinement per Technique
- Blade, Deflection, Execution, Movement, Prosthetic, and General Technique categories
- Prosthetics: Beast-Bane Whistle, Thunder Rod, Smoke Gourd, Fang Harpoon, Mirror Umbrella, Flame Vent, Mist Raven, Bloodletting Gourd
- One equipped prosthetic in the initial run structure
- One initial run-scoped Relic slot
- Akio is the only known bearer with genuine control over Beast Blood

The former Storm, Frost, Ember, Hex, and Shadow stance system is removed. Burn and Shock remain where owned by approved prosthetics or other explicitly documented content. Frost and Hex are not baseline player status families.

## Run-build structure

- Blood Aspect defines the broad run identity.
- Corruption and Shrine Embrace advance the fixed Aspect Tier path.
- Techniques customize specific combat verbs without replacing the Aspect.
- Active Technique capacity is four, with one inactive reserve.
- A full Technique inventory does not exist.
- Reserve swapping occurs only at Technique reward screens and rest rooms.
- Prosthetic Techniques use normal active slots and may receive one slotless refinement.
- Relics use a separate slot.
- Run-only build state resets after death or successful Heart Binding completion.
- Destroyed Heart Bindings and equivalent campaign progress persist across all later runs.
- The final story run carries the active build from the Shogun into the Heart encounter.
- Story completion and postgame Heart-route access persist.

## Persistent hub — The Strand

Six primary recurring NPCs:

- Keeper
- Peddler
- Smith
- Raven
- Undead Samurai
- Scribe

Primary interactibles and services:

- Boat and run-start confirmation
- Forge Bench and permanent combat/tool improvement
- Merchant Stall
- Discovery Board/codex
- Bloodwell permanent meta progression
- Blood Cavern training space and Blood Mirror Aspect trials

Postgame route control may later be attached to the Boat or another clear Strand interface. Its exact form is not yet locked.

## Area 1 — Hushiro Gate Village / Rupture

Standard enemies:

- Corrupted Swordsman
- Corrupted Archer
- Blighted Hounds
- Hollow
- Cellar Bilemass
- Warden

Minibosses:

- Village Ogre
- The Collector

Boss:

- Keeper of the Gate — Ashen Duelist and Collapse phases

The regional identity emphasizes recent corruption, violent bodily collapse, fragmented community, and limited desperate Heart worship.

## Area 2 — Yomori Grove / Adaptation

Standard enemies:

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound

Minibosses:

- The Embered Pilgrim
- Rotwood Host

Boss:

- Twin Maws — Rootfang and Briarthorn

Both twins begin active. The first defeated transfers its half of the corrupted bond to the survivor. Exact transition invulnerability, health/posture handling, inherited move timing, and difficulty normalization remain implementation questions.

The regional identity emphasizes long-term predation, spirit persistence, and Beast Blood absorbed into the forest's ecological and spiritual condition.

## Area 3 — Kagutsuchi Court / False Ascendancy

Standard enemies:

- Court Guard
- Court Caster
- Elite Defender
- Hollow Vessel
- Court Sentinel

Minibosses:

- Blood Lotus — Heart and Stalk multi-cycle encounter
- Eternal Swordsman — focused duel encounter

Regional boss:

- Eclipse Shogun — Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed phases

Kagutsuchi Court remains the approved immaculate royal-court setting. Its elites retain intelligence, hierarchy, and advanced mutation but remain unable to reject Beast Blood. Their apparent mastery is false.

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost before the game, leaving six intact campaign Bindings.

Successful Binding-run completion adds:

- temporary access beyond the Shogun to the Heart chamber,
- use of the Shogun-built extraction apparatus with Akio's Returning Blood,
- one persistent Heart Binding rupture,
- dissolution of Akio's current body through the Heart's retaliation,
- successful reconstruction at the Strand,
- and permanent Binding-progress presentation.

The completion sequence is one reusable ritual rather than a unique apparatus, puzzle, or win condition for every Binding. Akio completes six successful Binding runs.

Required clear-to-clear presentation is concentrated in the Heart chamber:

- one historical broken outer Binding,
- six removable or destroyable remaining Binding layers,
- progressively greater Heart exposure,
- stronger room-local pulse, movement, sound, and reaction,
- a fully exposed final state,
- and a clear Binding-progress display.

The base scope does not require island-wide visual transformations, universal enemy modifiers, new regional environment sets, new enemy families, or entirely different Shogun encounters after every successful clear.

## True-final Heart and ending

After the sixth Binding is destroyed, the next successful full run becomes the seventh and final story run.

The player completes the normal island route, defeats the Shogun's current body, and continues into the Heart encounter without ending the run between those bosses.

The true-final encounter has two conceptual phases:

1. **The Unbound Heart** — the Heart tears free from the prison and apparatus, grows malformed limbs, and becomes a mobile beastlike organ.
2. **The Vessel of Continuance** — the Heart builds an enormous nonhuman defensive beast body around itself while remaining visibly central to the form.

The Heart is not a humanoid swordsman, does not create another samurai duel, and does not require a weak-point or body-part targeting subsystem. Exact attacks, timings, tuning, posture behavior, arena rules, and transition implementation remain dedicated encounter-design and playtest work.

The first Heart victory canonically destroys the source of Beast Blood. Active Beast Blood becomes inert; the Shogun's reconstruction stops and his body dies; corrupted inhabitants are released before their sustained bodies fail; corrupted beasts collapse; Yomori's spirits pass on; the Blood Moon ends; and the barrier weakens safely.

Akio survives in his current human body but loses Returning Blood, Blood Aspects, supernatural regeneration, and future reconstruction. He becomes mortal. The ending and credits follow.

## Postgame continuation

The completed save remains playable after the ending.

Normal roguelite runs and the Heart route may be repeated. Repeat Heart victories are gameplay challenges only and do not advance the story, create new canonical endings, reverse the first ending, or imply another Heart.

The initial game requires a clear postgame way to determine whether a run ends after the Shogun or continues into the harder Heart route, but the exact Boat control, modifier, menu label, condition, reward structure, and presentation remain open.

Future difficulty settings, run modifiers, enemy variants, room variants, challenge restrictions, alternate controls or run conditions, special rewards, and mastery records may be explored later. They are explicitly deferred and are not part of the initial game scope.

## Environment and room structure

Top-level environment sets:

- The Strand
- Hushiro Gate Village
- Yomori Grove
- Kagutsuchi Court

Each run area adapts six common room functions: combat, Shrine, rest, shop, treasure/miniboss, and boss. Specialized spaces such as Blood Cavern, Blood Mirror, authored miniboss arenas, the Heart chamber, and the extraction platform remain subsets of their hub or region.

Combat routes support previewed primary rewards. Technique-marked combat rooms use the shared combat-room kit rather than requiring a separate full environment family.

## Items and rewards

Current families include:

- Mist, Scroll, Boss Emblem, and Gold,
- Health and Spirit pickups,
- temporary maximum-Health and maximum-Spirit rewards,
- run-scoped Techniques and refinements,
- eligible Prosthetic Techniques,
- run-scoped Relics with Common, Uncommon, Rare, and Legendary presentation,
- area-specific breakables,
- treasure and major reward objects,
- future consumables and catalog entries as mechanics are approved.

Current reward ownership includes:

- previewed standard combat payouts,
- Technique opportunities at selected combat or milestone rewards,
- Shrine Resist/Embrace or support,
- rest-room recovery and reserve swapping,
- Gold-based run shops,
- high-value treasure and miniboss rewards,
- persistent plus current-run rewards after regional bosses,
- Heart Binding and results processing after the Eclipse Shogun during the first six successful clears,
- first-clear story completion after the Heart,
- and repeat-clear Heart results without additional story progression.

## Interface and presentation

- Run HUD and combat feedback
- Corruption meter, Aspect icon, and Tier indicator
- Contextual active-Technique state indicators
- Equipped prosthetic module
- Technique selection, refinement, replacement, reserve, overwrite-warning, decline, and reroll states
- Four active Technique slots and one reserve in build-overview interfaces
- Damage numbers and approved status types
- Enemy health/posture indicators
- Deathblow prompt
- Strand HUD and persistent resources
- World interaction and route-reward prompts
- Shrine Resist/Embrace screen
- Boat Aspect-selection/run-start screen
- Blood Mirror trial screen
- Boss and miniboss presentation
- Heart Binding completion and six-clear campaign-progress presentation
- Two-phase true-final Heart boss presentation
- First-clear ending and credits
- Shortened repeat-clear Heart results
- Postgame Heart-route access state after its control is approved
- Hub progression interfaces
- Functional room presentation
- Pause, overview, results, settings, controls, save/loading, credits, and completion presentation

## Art-production structure

The current plan uses seven top-level art milestones with independently quoted internal batches. Milestones are dependency and playtest groupings, not equal-size contracts.

Removing five stance families reduces unique player-system VFX and status-art scope. Technique production instead requires reusable card templates, category and slot icons, reserve/replacement states, refinement markers, and only the bespoke combat VFX needed for approved Technique mechanics.

The base Heart Binding ritual, six clear states, and two-form true-final Heart concept are production-scopeable. Exact Heart animation counts, effects, postgame route controls, rewards, and tuning remain unquoted until their gameplay rules are approved.

See [Production Roadmap](PRODUCTION_ROADMAP.md), [Asset Inventory](../art_production/ASSET_INVENTORY.md), and [Art Milestones](../art_production/milestones/README.md).
