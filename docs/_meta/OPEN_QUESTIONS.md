---
id: META-OPEN-QUESTIONS
title: Open Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-21
---

# Open Questions

This page records approved answers and remaining design questions. Detailed production rules remain authoritative in their linked documents.

# Resolved production and gameplay decisions

## Blood Aspect persistence

Unlocked Aspects and the selected loadout option persist. Blood Aspect Tier and Corruption begin at baseline each run and reset after death or successful completion.

**Status:** resolved

## Corruption and Resist rules

Corruption is gained through combat accomplishments and major encounter progress. Resist keeps the current Tier, lowers Corruption to approximately 75%, and grants a short-term support reward. Exact values remain tuning variables.

**Status:** resolved

## Area 2 encounter structure

The Embered Pilgrim and Rotwood Host are the two Yomori Grove minibosses. Rootfang and Briarthorn form the Twin Maws boss. Both begin active, and the first defeated transfers part of the bond to the survivor.

**Status:** resolved

## Area 3 encounter classification

Blood Lotus is Area 3 Miniboss #1, Eternal Swordsman is Area 3 Miniboss #2, and Eclipse Shogun is the principal regional boss. The endgame continues beyond him to persistent Heart Binding progress and an intended true-final Heart encounter.

**Status:** resolved at regional-roster level

## Currency families

- Mist is the base persistent meta currency.
- Scrolls are the primary Forge currency.
- Boss Emblems are rare persistent boss-derived currency.
- Gold is run-only shop currency.
- `Mist Shards` is deprecated unless intentionally restored as a separate denomination.

**Status:** resolved

## Technique structure

Akio has four active Technique slots and one inactive reserve. Slots begin empty. Most Techniques are independently useful, may receive at most one slotless refinement, and do not require deep prerequisite chains.

Blood Aspects are the central vertical run identity. Techniques provide limited horizontal customization around the selected Aspect.

**Status:** resolved at structural level

## Room reward ownership

Standard combat routes may preview a primary payout. Selected encounters offer Techniques. Shrines own Resist/Embrace or support, rest rooms own recovery and reserve swapping, shops use Gold, and treasure/miniboss rewards are higher value. The Eclipse Shogun opens the Heart Binding completion step.

**Status:** resolved at structural level

# Open production and gameplay questions

## Milestone 1 Posture Break Cue assignment

Is the separate Posture Break Cue included in Milestone 1, and if so, which paid batch owns it?

**Affected files**

- `docs/art_production/CORE_VFX.md`
- `docs/art_production/milestones/MILESTONE_01.md`
- `docs/art_production/ASSET_INVENTORY.md`

**Status:** open

## Elite Defender revival behavior

Does the Elite Defender use Kagutsuchi Court's one-time revival mechanic or remain a pure shield-and-spear positional defender?

**Affected files**

- `docs/content/area_3/enemies/ELITE_DEFENDER.md`
- `docs/content/area_3/ENEMIES.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** open

## Twin Maws transition implementation

How are transition invulnerability, survivor health and posture, inherited attacks, transition duration, and difficulty normalization handled after the first Twin Maw dies?

**Locked boundary:** both twins begin active; the first defeated empowers the survivor, which remains recognizably itself.

**Status:** open

## Blood Lotus cycle tuning

What are the final Heart-cycle count, Stalk timer, punishment threshold, deathblow HP chunks, Stalk relocation rules, and posture-reset behavior?

**Status:** open

## Blood Cavern trial rewards and upgrade caps

What are the final trial counts, unlock sequence, reward tables, mastery conditions, Technique-pool unlock rules, and numerical caps for permanent Blood Aspect reliability upgrades?

**Locked boundary:** trials cannot add new Tiers, remove Embrace danger, or permanently pre-equip a run Technique.

**Status:** open

## Technique catalog and tuning

What are the final Technique count, effects, rarity weights, Aspect weighting, combat-verb tags, refinements, unlock sequence, and unique VFX/icon requirements?

**Locked boundaries**

- Four active slots and one reserve.
- Most Techniques are standalone.
- At most one slotless refinement per Technique.
- No exact deep multi-Technique dependency.
- Selected Aspect weights but does not fully restrict offers.

**Status:** open

## Prosthetic tuning and Prosthetic Techniques

What are the final Spirit costs, cooldowns, durations, immunity rules, Forge paths, eligible Prosthetic Techniques, refinements, and balance caps for the eight prosthetics?

**Locked boundary:** the initial run structure uses one equipped prosthetic, and only that tool's Prosthetic Techniques enter the reward pool.

**Status:** open

## Reward cadence and room economy

What are the final room counts, branching structure, reward probabilities, anti-streak rules, Technique opportunities, fallback values, reroll economy, shops, capacity values, miniboss rewards, and regional-boss recovery values?

**Locked boundaries**

- Reward categories are previewed before route commitment where applicable.
- Techniques are not awarded after every combat room.
- Areas 1–2 form the build; Area 3 refines or replaces it.
- Shrines do not normally grant Techniques.

**Status:** open

## Relic and consumable catalog

What are the final Relic and consumable counts, effects, rarity weights, drop tables, and persistence rules?

**Locked boundary:** the initial framework uses one run-scoped Relic slot separate from Techniques and the selected Blood Aspect.

**Status:** open

# Story-spine design lock questions

These questions are resolved in dependency order before the complete story spine, ending, and final Milestone 6 scope are locked.

## 1. Ancient source identity and agency

**Resolution**

The source of Beast Blood is the Heart: an ancient living godlike organ or supernatural core associated uniquely with the island.

It is physically real but not an ordinary organ. Its ultimate origin remains deliberately ambiguous. It possesses primal agency centered on survival, regeneration, growth, continuation, resistance to restraint, and incorporation rather than a human personality or fully explained plan.

The Eclipse Shogun remains the central character antagonist; the Heart is the deeper supernatural threat.

**Status:** resolved

## 2. Discovery of the Heart

**Resolution**

The Heart was already buried beneath the island. Royal excavation beneath Kagutsuchi Court exposed an ancient complex built around it.

The Heart was dormant and enclosed by layered ancient Heart Bindings that limited its influence and protected its deeper body. The Shogun's civilization did not create the Bindings.

**Deliberately unresolved:** the ancient builders, complete original purpose, cause of discovery, and relationship between the complex and later barrier design.

**Status:** resolved

## 3. Physical access to usable Beast Blood

**Resolution**

The intact Heart Bindings prevented the Court from reaching living Heart tissue. During the plague, the Shogun authorized researchers to breach or destroy the outermost Binding, awakening the Heart enough to expose part of it.

The Shogun's civilization then built an extraction apparatus against the exposed Heart. Researchers placed a small measure of fresh human blood into the apparatus. The offering flowed inward, and the Heart released Beast Blood outward into a collection vessel. The process did not require death or human sacrifice.

Collected Blood must be deliberately consumed or introduced. Ordinary contact, proximity, wounds, environmental exposure, and merely dying on the island do not create bearers.

Once active within a bearer, Beast Blood does not require repeated doses or continued supply.

**Status:** resolved at story-foundation level

## 4. Plague-era fall and escaped royal bloodline

**Resolution**

A deadly plague pushed the kingdom toward extinction. Beast Blood genuinely cured it, but delayed corruption allowed use to spread before the danger became clear. The Shogun remains responsible for continuing to defend and expand the Blood after its cost became visible.

During the early Beast Blood era, the Shogun and the child's mother had both taken Beast Blood but had not yet undergone severe transformation. The child was conceived after both parents were altered and developed while the mother already carried Beast Blood. The child carried a dormant inherited expression of the Blood.

Before the barrier was completed, the child was secretly taken from the island by the mother and a trusted retainer. The bloodline survived outside the containment and eventually produced Akio.

This child supersedes the earlier removed daughter premise only as Akio's ancestry. The child's gender, name, protectors, escape details, and later life remain unresolved. The child is not required to motivate the Shogun's original plague decision.

**Status:** resolved at history and lineage-foundation level

## 5. Shogun's goal, mindset, and relationship to Akio

**Resolution**

The Shogun intends to end containment and extend his kingdom through conquest and forced Beast Blood salvation. He remains intelligent and responsible rather than a direct puppet of the Heart.

His mastery is false because he cannot abandon the Heart, end extraction, accept the kingdom's natural death, permit rejection of his salvation, or imagine a future without Beast Blood and his rule.

His repeated relationship with Akio develops through:

1. dismissal,
2. fascination with Returning Blood and controlled Aspects,
3. recognition of Akio as a descendant of the escaped royal child and recruitment as an heir or champion,
4. fear and hatred when Akio rejects the claimed inheritance and attacks the Heart.

**Status:** resolved at major narrative and relationship level

## 6. Corrupted inhabitants, loyalty, and Area 2 spirits

**Resolution**

Corrupted inhabitants may retain memory, relationships, ambitions, training, customs, and organized behavior while losing the ability to reject Beast Blood or act against its continuation.

The Shogun's followers do not require a hive mind. Yomori's wraiths are true spirits persisting as incomplete memories or remnants. The damaged ecology is a consequence of corrupted inhabitants rather than a contagious environmental form of Beast Blood.

**Status:** resolved at continuity and regional-context level

## 7. Order knowledge and mission

**Resolution**

The modern Order knows that organized, regenerative Beast Blood users remain on the island, that the barrier prevents reliable entry, and that the Blood Moon creates a rare opportunity. It does not know the Heart's identity, plague-era history, extraction process, Shogun's conquest plan, Akio's lineage, or destruction consequences.

Akio's one-way mission is to destroy the cursed forces and leader and find and destroy whatever source sustains them.

The Order is a background faction supplying training, warding, equipment, mission authority, and the Strand operation.

**Status:** resolved at background-faction and mission level

## 8. Barrier origin, Blood Moon, and Strand crossing

**Resolution**

Survivors and ritual authorities who became the Order created the barrier after the kingdom's fall. It contains the corrupted population and deliberate transport of Beast Blood or source material.

The Blood Moon is the visible result of a recurring active Heart cycle. Existing Beast Blood becomes stronger and the barrier comes under pressure.

The Strand is the controlled threshold. The Keeper, a former Court noble bound to the anchor, stabilizes the route used by the Order-sealed Boat. The campaign remains beneath the Blood Moon without defining elapsed ordinary time.

**Status:** resolved at world-history, hub-function, and campaign-setting level

## 9. Returning Blood origin, first death, and Akio's control

**Resolution**

Akio unknowingly descends from the Shogun's escaped child. That child was conceived after the Shogun and the child's mother had both taken Beast Blood and developed while the mother already carried it. The child carried a dormant inherited form of the alteration, which continued through the bloodline outside the barrier.

Akio begins the game without active Beast Blood abilities. He is the first known descendant of the escaped bloodline to:

- return inside the barrier,
- do so during a Blood Moon,
- and suffer death after the dormant inherited Blood has been fully stirred.

The player's first attempt uses the base sword kit without Blood Aspects, Shrine evolution, or advanced Blood Techniques. The attempt ends in Akio's first death.

That death activates the inherited Blood's regenerative power. Because Akio's body developed naturally around the dormant condition, it reconstructs his established human form instead of immediately fixing him into an ordinary corrupted transformation. He returns to the Strand carrying the first known Returning Blood.

The first reconstruction establishes the stable human pattern and Strand destination followed by later returns. The deeper transport remains deliberately mysterious rather than becoming a separate anchor system.

Previous Order warriors did not carry this inherited condition. Earlier descendants remained outside the barrier and never combined Akio's awakening circumstances.

Resolve does not create Returning Blood. Akio's lineage and first death explain why he returns. His discipline and resolve explain why he can later control and evolve the awakened Blood without surrendering himself to it.

The Order's warding may protect Akio as ordinary field protection but does not create the revival. The Keeper, Boat, and Bloodwell do not create Returning Blood. No new dose is introduced during the opening attempt.

Neither Akio nor the Shogun initially knows their relationship. The Shogun eventually recognizes Akio as the descendant of the escaped royal child, deepening his attempt to claim him as an heir.

**Deliberately unresolved**

- the escaped child's gender, name, protectors, and exact escape,
- the cause and location of Akio's first death,
- whether the first attempt ends through a scripted event or designed unwinnable encounter,
- the deeper metaphysics behind the preserved return imprint,
- how and when the bloodline is confirmed,
- and whether any other dormant descendants exist.

**Affected files**

- `docs/lore/RETURNING_BLOOD.md`
- `docs/lore/BEAST_BLOOD.md`
- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/lore/THE_ORDER.md`
- `docs/characters/AKIO.md`
- `docs/gameplay/CORE_LOOP.md`
- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/overview/GAME_OVERVIEW.md`

**Status:** resolved at lineage, awakening, and control-foundation level

## 10. Successful-run Heart Bindings and forced return

**Resolution**

The Heart was already imprisoned by multiple ancient Heart Bindings created by an unknown power. The Bindings keep it dormant, limit its influence, and protect its deeper body. The Shogun's civilization did not build them.

During the plague, the Shogun's researchers breached the outermost Binding and built an extraction apparatus against the exposed Heart. Ordinary extraction offers fresh human blood inward and receives Beast Blood outward.

After each Shogun victory, Akio uses the same apparatus and offers Returning Blood. The Heart recognizes its own power and attempts to absorb and reclaim it, but Akio's controlled Blood resists. The rejection creates a violent pulse that breaks one remaining Binding.

The Heart immediately retaliates through the same contact and dissolves Akio's current body into blood. Returning Blood then reconstructs him at the Strand using the stable pattern and destination established by his first return.

The Binding remains destroyed because it is an external ancient restraint that the Heart did not create and cannot regenerate. Akio can complete only one per run because the retaliation kills his current body immediately after the rupture.

The sequence is intentionally simple and reusable: blood offering, Heart reaction, one Binding rupture, Akio's dissolution, and Strand reconstruction. It does not require a separate mechanism, puzzle, or unique win condition for every Binding.

Destroying Bindings both exposes the Heart's vulnerable body and releases more of its influence. Existing Beast Blood becomes more agitated and Akio's temptation toward the curse grows stronger, but no physical channel or continued Blood supply is required.

**Affected files**

- `docs/lore/BEAST_BLOOD.md`
- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/RETURNING_BLOOD.md`
- `docs/gameplay/CORE_LOOP.md`
- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/overview/GAME_OVERVIEW.md`
- `docs/art_production/milestones/MILESTONE_06.md`
- `docs/_meta/TERMINOLOGY.md`

**Status:** resolved at story-foundation and successful-run-loop level

## 11. Campaign clear count and changes after each clear

**Resolution**

The Heart's ancient prison originally contained seven Heart Bindings. The Shogun's researchers destroyed the outermost Binding before the game, leaving six intact Bindings when Akio begins the campaign.

Akio must complete six successful Binding runs. Each successful run defeats the Shogun, destroys one remaining Binding through the reusable Returning Blood ritual, dissolves Akio's current body, and reconstructs him at the Strand. Failed runs do not advance the count.

After the sixth remaining Binding is destroyed, the next successful full run becomes the seventh and final campaign run. No Binding remains, so Akio does not repeat the extraction ritual or suffer its automatic dissolution. He can make the Shogun's defeat permanent and continue into the true-final Heart encounter.

The six-clear requirement is a roguelite mastery objective supported by alternate Blood Aspects, Techniques, prosthetics, Relics, routes, rewards, permanent progression, and player execution. The six clears are not six unique story missions.

Mandatory clear-to-clear production remains concentrated in:

- one historical broken outer Binding,
- six removable or destroyed Binding states around the same Heart chamber,
- progressively greater Heart exposure and stronger room-local pulse, movement, sound, and reaction,
- a fully exposed Heart state,
- clear Binding-progress presentation,
- and concise Shogun, NPC, results, or codex updates where appropriate.

The base scope does not require island-wide visual transformations, universal enemy modifiers, new regional environment sets, new enemy families, or entirely different Shogun fights after every clear. Those remain optional future expansion ideas.

**Still open within this structure:** exact clear rewards, dialogue allocation, whether the Shogun receives limited clear-state variations, his reconstruction presentation, and the exact permanent-death method.

**Status:** resolved at campaign-count, roguelite-progression, and production-boundary level

## 12. True-final Heart encounter, ending, and postgame

**Question**

What happens after the Shogun's permanent defeat, what form does the Heart confrontation take, what does Akio ultimately do with Beast Blood, and why can gameplay continue after the canonical ending?

Establish the Heart encounter, final vulnerability, fate of the Shogun and island, Akio's final condition, credits trigger, and postgame explanation.

**Locked boundary:** the Shogun remains the central character antagonist. The Heart is the deeper supernatural threat and intended true-final encounter. The confrontation occurs on the seventh successful full run after six Binding clears.

**Status:** open; next and final story-spine dependency

## 13. Eclipse Shogun final character and production identity

**Question**

What final body type, costume, weapon, movement language, and beast transformation distinguish the Shogun from the game's other samurai bosses?

**Current direction:** use Kokushibo from _Demon Slayer_ as a high-level reference for composed aristocratic menace, severe discipline, restrained speech, overwhelming swordmaster presence, and controlled inhuman escalation. The Eclipse Shogun must remain an original design and must not copy Kokushibo's distinctive eyes, anatomy, costume, sword, moon motifs, effects, silhouette, or exact mannerisms.

**Locked boundary:** the three phases remain Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed. Existing armor, mask, polearm, and animation concepts remain reopened.

**Status:** open before Milestone 6 quotation