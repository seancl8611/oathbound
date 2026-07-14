---
id: META-OPEN-QUESTIONS
title: Open Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-14
---

# Open Questions

## Resolved in production bible pages 1–35

### Blood Aspect persistence

**Resolution**

Unlocked Aspects and the selected loadout option persist. Blood Aspect Tier starts at Tier 0 each run and resets after death or successful completion. Corruption also resets.

**Affected files**

- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/ui_ux/SHRINE_INTERFACE.md`

**Status:** resolved

### Corruption and Resist rules

**Resolution**

Corruption is gained through combat accomplishments and major encounter progress. Taking damage is not a universal source in v1. Resist keeps the current Tier, reduces Corruption to approximately 75%, and grants a short-term support reward such as healing. Exact values remain tuning variables.

**Affected files**

- `docs/gameplay/CORRUPTION_AND_SHRINES.md`
- `docs/ui_ux/HUD.md`
- `docs/ui_ux/SHRINE_INTERFACE.md`

**Status:** resolved

## Resolved in production bible pages 71–105

### Area 2 encounter structure

**Resolution**

The Embered Pilgrim and Rotwood Host are Area 2's two minibosses. Rootfang and Briarthorn form the Twin Maws boss. Both twins begin active, and the first defeated transfers its half of the corrupted bond to the survivor.

**Affected files**

- `docs/content/area_2/OVERVIEW.md`
- `docs/content/area_2/MINIBOSSES.md`
- `docs/content/area_2/BOSS.md`
- `docs/art_production/milestones/MILESTONE_05.md`

**Status:** resolved

### Area 3 encounter classification

**Resolution**

Blood Lotus is Area 3 Miniboss #1, Eternal Swordsman is Area 3 Miniboss #2, and Eclipse Shogun is the principal regional boss with Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed phases.

The current endgame direction now continues beyond him to Heart-layer completion and an eventual true-final Heart encounter.

**Affected files**

- `docs/content/area_3/OVERVIEW.md`
- `docs/content/area_3/MINIBOSSES.md`
- `docs/content/area_3/BOSS.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** resolved at regional-roster level

## Resolved in production bible pages 106–132

### Currency family names and broad ownership

**Resolution**

- Mist is the base persistent meta currency.
- Scrolls are the primary Forge currency.
- Boss Emblems are rare persistent boss-derived currency.
- Gold is run-only shop currency.
- `Mist Shards` is deprecated draft wording unless intentionally reintroduced as a separate denomination.

Exact prices and node costs remain balance questions, not naming questions.

**Affected files**

- `docs/gameplay/ITEMS_AND_REWARDS.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/content/strand/interactibles/FORGE_BENCH.md`
- `docs/content/strand/interactibles/BLOODWELL.md`
- `docs/ui_ux/HUD.md`
- `docs/ui_ux/STRAND_HUD_AND_PROMPTS.md`

**Status:** resolved

### Former stance roster

**Resolution**

The production bible defined Storm, Frost, Ember, Hex, and Shadow as five stance families. That roster is now superseded and removed by the approved Technique-system decision. The eight prosthetic identities remain approved.

**Affected files**

- `docs/gameplay/TECHNIQUES.md`
- `docs/gameplay/PROSTHETICS.md`
- `docs/art_production/TECHNIQUE_VFX.md`
- `docs/art_production/PROSTHETIC_VFX.md`
- `docs/art_production/milestones/MILESTONE_04.md`

**Status:** superseded

## Resolved in Technique-system review

### Technique loadout and reserve structure

**Resolution**

Akio has four active Technique slots and one inactive reserve. Slots begin empty. There is no full inventory. New Techniques may fill an empty slot, replace any active Technique, enter reserve, or be declined for a smaller fallback. Replaced active Techniques move to reserve; overwriting occupied reserve loses its previous Technique after confirmation. Swapping is limited to Technique reward screens and rest rooms.

**Status:** resolved

### Technique dependency depth

**Resolution**

Most Techniques are standalone and useful immediately. Natural synergy uses shared combat verbs. A Technique may receive at most one slotless refinement, and no normal Technique requires an exact multi-Technique combination or prerequisite chain deeper than one.

**Status:** resolved

### Blood Aspect and Technique relationship

**Resolution**

Blood Aspects are the central run identity and vertical power path. Techniques are limited horizontal customization. Aspect selection weights Technique offers without fully locking the pool.

**Status:** resolved

### Room reward ownership

**Resolution**

Standard combat routes preview a primary payout. Selected combat and milestone rewards offer Techniques. Shrines own Resist/Embrace or support; rest rooms own recovery and reserve swapping; shops use Gold; treasure/miniboss rewards are high value; regional bosses grant persistent and current-run power. The Eclipse Shogun opens the protected Heart-completion step, which grants persistent campaign progress and ends the run.

**Status:** resolved at structural level

# Open production and gameplay questions

## Milestone 1 Posture Break Cue assignment

**Category:** production | outsourcing

**Question**

Is the separate Posture Break Cue included in Milestone 1, and if so, which batch owns it?

**Why it matters**

The broader production bible defines the effect, but the polished Milestone 1 contractor brief lists only VFX-001 Parry Spark, VFX-002 Hit Spark, VFX-003 Deathblow Cue, and VFX-004 Sword Trail. It should not be silently added to a paid batch.

**Affected files**

- `docs/art_production/CORE_VFX.md`
- `docs/art_production/milestones/MILESTONE_01.md`
- `docs/art_production/ASSET_INVENTORY.md`

**Status:** open

## Elite Defender revival behavior

**Category:** gameplay | content | production

**Question**

Does the Elite Defender use Kagutsuchi Court's one-time revival mechanic, or remain a pure shield-and-spear positional defender?

**Affected files**

- `docs/content/area_3/enemies/ELITE_DEFENDER.md`
- `docs/content/area_3/ENEMIES.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** open

## Twin Maws transition implementation

**Category:** gameplay | boss | UI/UX

**Question**

How are transition invulnerability, survivor health and posture, inherited attacks, transition duration, and difficulty normalization handled after the first Twin Maw dies?

**Locked boundary**

Both twins begin active. The first defeated empowers the survivor, which remains recognizably itself.

**Affected files**

- `docs/content/area_2/BOSS.md`
- `docs/art_production/milestones/MILESTONE_05.md`
- `docs/ui_ux/HUD.md`
- future boss implementation documentation

**Status:** open

## Blood Lotus cycle tuning

**Category:** gameplay | boss | UI/UX

**Question**

What are the final Heart-cycle count, Stalk timer, punishment threshold, deathblow HP chunks, Stalk relocation rules, and posture reset behavior?

**Affected files**

- `docs/content/area_3/MINIBOSSES.md`
- `docs/ui_ux/HUD.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** open

## Blood Cavern trial rewards and upgrade caps

**Category:** gameplay | progression | UI/UX

**Question**

What are the final trial counts, unlock sequence, reward tables, mastery conditions, Technique-pool unlock rules, and numerical caps for permanent Blood Aspect reliability upgrades?

**Locked boundary**

Trials may grant Aspect access, small capped reliability improvements, Technique-pool access where deliberately designed, currency, cosmetics, lore reflections, or completion marks. They cannot add new Tiers, remove Embrace danger, or permanently pre-equip a run Technique.

**Affected files**

- `docs/gameplay/BLOOD_CAVERN_TRIALS.md`
- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/TECHNIQUES.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/ui_ux/BLOOD_MIRROR_TRIALS.md`
- `docs/art_production/milestones/MILESTONE_03.md`

**Status:** open

## Technique catalog and tuning

**Category:** gameplay | balance | production | UI/UX

**Question**

What are the final Technique count, individual effects, rarity weights, Aspect weighting, combat-verb tags, refinement pairs, unlock sequence, and unique VFX/icon requirements?

**Locked boundary**

- Four active slots and one reserve.
- Most Techniques are standalone.
- At most one slotless refinement per Technique.
- No exact multi-Technique dependency.
- Selected Aspect weights but does not fully restrict offers.
- Technique effects deepen sword, movement, execution, resource, or equipped-prosthetic play.

**Affected files**

- `docs/gameplay/TECHNIQUES.md`
- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/ITEMS_AND_REWARDS.md`
- `docs/ui_ux/TECHNIQUE_REWARDS.md`
- `docs/art_production/TECHNIQUE_VFX.md`
- `docs/art_production/ITEM_REWARD_ART.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_04.md`

**Status:** open

## Prosthetic tuning and Prosthetic Techniques

**Category:** gameplay | balance

**Question**

What are the final Spirit costs, cooldowns, durations, immunity rules, permanent Forge paths, eligible Prosthetic Techniques, one-step refinements, and balance caps for the eight prosthetics?

**Locked boundary**

The initial run structure uses one equipped prosthetic. Only that tool's Prosthetic Techniques enter the reward pool. A major Prosthetic Technique uses one active Technique slot; its refinement is slotless.

**Affected files**

- `docs/gameplay/PROSTHETICS.md`
- `docs/gameplay/TECHNIQUES.md`
- `docs/art_production/PROSTHETIC_VFX.md`
- `docs/art_production/TECHNIQUE_VFX.md`
- `docs/art_production/milestones/MILESTONE_04.md`

**Status:** open

## Reward cadence and room economy

**Category:** gameplay | balance | production | UI/UX

**Question**

What are the final room counts, branching structure, reward probabilities, anti-streak rules, Technique opportunities per area, fallback values, reroll economy, shop stock and prices, temporary capacity values, miniboss reward composition, and regional boss recovery values?

**Locked boundary**

- Reward categories are previewed before route commitment.
- Technique rewards do not follow every combat room.
- Provisional successful-run target is six to eight Technique-related decisions.
- Areas 1–2 form the build; Area 3 refines and replaces it.
- Shrines do not normally grant Techniques.
- Minibosses do not award only ordinary Gold or healing.

**Affected files**

- `docs/gameplay/ITEMS_AND_REWARDS.md`
- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/content/ROOM_TYPES.md`
- `docs/ui_ux/TECHNIQUE_REWARDS.md`
- `docs/art_production/ITEM_REWARD_ART.md`

**Status:** open

## Relic and consumable catalog

**Category:** gameplay | production | UI/UX

**Question**

What are the final Relic and consumable counts, effects, rarity weights, drop tables, and individual persistent/run-only ownership rules?

**Locked boundary**

The initial framework uses one separate run-scoped Relic slot. Relics are broader passive rules and do not use Technique slots or replace the Blood Aspect as the run identity.

**Affected files**

- `docs/gameplay/ITEMS_AND_REWARDS.md`
- `docs/art_production/ITEM_REWARD_ART.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_04.md`
- `docs/ui_ux/HUD.md`
- `docs/ui_ux/PAUSE_OVERVIEW.md`

**Status:** open

# Story-spine design lock questions

These questions must be answered in dependency order before the complete story spine, successful-clear count, ending, and final Milestone 6 scope can be locked.

## 1. Ancient source identity and agency

**Resolution**

The source of Beast Blood is the Heart: an ancient living godlike organ or supernatural core associated uniquely with the island.

- It is physically real but not an ordinary biological organ.
- It may be part of a forgotten godlike being, the core of the island, a divine vessel, or something else entirely.
- Its ultimate origin remains deliberately ambiguous and may be suggested through conflicting evidence.
- It exists somewhere between dormancy, injury, imprisonment, and awakening.
- It possesses primal agency centered on survival, regeneration, growth, continuation, resistance to restraint, and incorporation of other life.
- It does not require a human personality, ordinary speech, or a fully explained plan.
- Beast Blood is its living power and gradually rewrites bearers according to its nature.
- Some desperate Hushiro inhabitants may worship it as an ancient god or the only power that answered their suffering.
- The Eclipse Shogun remains the central character antagonist; the Heart is the deeper supernatural threat.

Akio is the only known bearer with genuine control over Beast Blood. Other bearers may retain humanity, intelligence, aspirations, and deliberate mutation use, but they remain unable to reject the Blood's rule.

**Deliberately unresolved**

- what larger being, if any, the Heart belonged to,
- whether the island grew around it or is part of it,
- whether it understands humanity,
- whether its awakening is deliberate or reactive,
- and its final anatomy or true-final manifestation.

**Affected files**

- `docs/lore/BEAST_BLOOD.md`
- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/RETURNING_BLOOD.md`
- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/characters/AKIO.md`
- `docs/overview/GAME_OVERVIEW.md`
- `docs/overview/DESIGN_PILLARS.md`
- `docs/_meta/TERMINOLOGY.md`

**Status:** resolved

## 2. Discovery or acquisition of the Heart

**Resolution**

The Heart was already buried beneath or within the island before the Shogun's civilization discovered it.

During the prosperous expansion of Kagutsuchi Court, royal engineers excavating foundations, cisterns, drainage channels, and protected storage exposed a sealed stairway after a collapse, possibly caused by an earthquake. The stairway descended into an ancient complex built around part of the Heart.

The first explorers encountered an immense living mass embedded in stone, with dark tissue, blackened vessels extending into the island, and a slow pulse perceptible through the chamber floor. The complex contained carved seals, ritual channels, restraints, damaged inscriptions, and chambers whose original purposes could not be determined.

The structure may have been a shrine, prison, research site, containment system, harvesting facility, or several of those things at different times. Altars could also be read as operating platforms, and devotional markings could also be read as restraints. Whether the collapse was natural, caused by failing ancient architecture, or subtly influenced by the Heart remains unresolved.

Royal engineers, guards, scholars, physicians, and ritual specialists made the discovery rather than the Shogun personally. The Shogun ordered the site sealed, prohibited direct human use, and restricted entry to a small trusted circle.

For years, the Court mapped and studied the ancient complex without reaching a definitive interpretation of its builders or purpose. The prohibition remained until the plague threatened the kingdom and the Shogun's daughter was expected to die. He then authorized the first controlled attempt to use power obtained from the Heart.

This decision establishes discovery and access to the chamber only. The exact method by which usable Beast Blood was drawn, prepared, stored, administered, and replenished remains Question 3.

`Wellspring` is not established by this decision as the name of the complex, an extraction site, or a Blood-access process.

**Deliberately unresolved**

- who built the ancient complex,
- whether its primary purpose was worship, imprisonment, study, containment, harvesting, or a changing combination,
- whether the island formed around the Heart,
- whether the Heart influenced its own discovery,
- whether the ancient builders also created the barrier,
- and the exact interval between discovery and the plague.

**Affected files**

- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/BEAST_BLOOD.md`
- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/lore/WORLD.md`
- `docs/_meta/TERMINOLOGY.md`

**Status:** resolved

## 3. Physical access to usable Beast Blood

**Question**

Where does usable Beast Blood physically come from, and how was it collected, stored, administered, and replenished?

Is it drawn directly from the Heart, collected in a ritual basin, produced through a vessel, extracted during an awakening, or obtained through another limited process?

**Locked boundary**

- Beast Blood is not airborne.
- It is not spread casually through bites or ordinary contact.
- It is rare and must be deliberately obtained and used.
- Discovery of the Heart and entry into its ancient complex do not by themselves define the usable-Blood process.

**Why it matters**

This defines the plague treatment, the Shogun's army, the barrier's containment purpose, the Heart chamber, and the threat of the Blood reaching the outside world.

**Status:** open; Question 2 prerequisite satisfied

## 4. Plague-era timeline and the Shogun's daughter

**Question**

What happened from the first plague cases through the kingdom's collapse, and what specifically happened to the Shogun's daughter after she received Beast Blood?

Establish:

- how quickly the plague spread,
- when the Shogun approved the cure,
- how long the apparent miracle lasted,
- why use expanded from the sick to soldiers and the wider population,
- when corruption became undeniable,
- and whether the daughter survived, transformed, died, disappeared, or remains relevant.

**Locked boundary**

The kingdom flourished before the plague. The Shogun was popular and initially restricted Beast Blood. His daughter's impending death helped drive the decision to use it.

**Status:** open

## 5. Shogun's present goal and relationship to the Heart

**Question**

What does the Shogun want during Akio's campaign, and how does the Heart's primal agency affect that desire?

Decide whether he seeks conquest, forced salvation, escape, renewed prosperity, protection of his kingdom, release, or another goal.

**Locked boundary**

The Shogun is not an innocent puppet. Beast Blood magnifies his qualities, but he remains responsible for continuing to use, defend, and expand its power.

He is the greatest false master of Beast Blood: intelligent and capable of deliberate transformation, but unable to reject the Heart or imagine salvation without its power.

**Status:** open

## 6. Corrupted inhabitants, loyalty, and Area 2 spirits

**Question**

How exactly does long-term Beast Blood produce the island's different physical and spiritual forms?

Clarify:

- the detailed limits of memory and humanity retained by corrupted inhabitants,
- why soldiers and subjects remain loyal or organized,
- how independent beasts and spirits relate to the Shogun's kingdom,
- and how Area 2 wraiths emerge from the same Beast Blood curse.

**Locked boundary**

There is no required hive mind or universal strength hierarchy. Corrupted beings may retain recognition, relationships, loyalty, training, ambitions, and territory.

Retained humanity or deliberate mutation use does not equal true control. Hushiro emphasizes rupture, Yomori emphasizes adaptation, and Kagutsuchi emphasizes false ascendancy. Akio alone has genuine sovereignty over Beast Blood.

**Status:** partially established; exact spirit rules remain open

## 7. Order knowledge, mission, and recurring threat

**Question**

What does the Order know about the plague, Shogun, Heart, Beast Blood, barrier, and consequences of destroying the Heart—and what exactly does it believe Akio must accomplish?

Also establish why a warrior must be sent every ten years. Is the Shogun preparing conquest, is the barrier deteriorating, are outsiders attempting to acquire the Blood, is the Heart awakening, or is another threat escalating?

**Locked boundary**

The Order opposes Beast Blood, uses anti-corruption warding, sends one warrior during the Blood Moon, and did not expect Returning Blood as a standard outcome.

**Status:** open

## 8. Barrier origin and Blood Moon deadline

**Question**

Who created the barrier, when was it created, what does it contain, and what happens when the active Blood Moon period ends?

Establish whether the barrier primarily prevents departure, access to the Heart, transport of Beast Blood, or all three; whether the Shogun can affect it; and how repeated Akio runs fit within one active period.

**Status:** open

## 9. Exact Returning Blood cause

**Question**

What event exposes Akio to Beast Blood, how do the Order's warding and his resolve alter it, and why did the same protection not produce Returning Blood in previous warriors?

**Current direction**

The ward protects Akio's identity; his resolve prevents surrender; Beast Blood's regeneration then reconstructs the identity the ward preserved and returns him to the Strand where the rite originated.

**Locked boundary**

Akio is not naturally immune, Returning Blood is not routine Order practice, and resolve alone is no longer a sufficient complete explanation.

Akio's genuine control is canon, but the exact event and mechanism that created it remain open.

**Status:** open; current direction promising but not canonized

## 10. Successful-run Heart layers and forced return

**Question**

What is Akio actually damaging after each Shogun victory, why does that damage persist, and why can he remove only one layer before his current body is destroyed or expelled?

Define whether the layers are biological defenses, seals, bindings, shells, vessels, wards, phases of awakening, or another structure derived from the Heart.

**Parked possibility — not approved**

The carved seals, ritual channels, restraints, and other structures in the ancient Heart complex may later connect to the persistent Heart-layer sequence. Akio might break, restore, sever, reactivate, or otherwise interact with parts of that system after successful runs.

This is preserved only so the possibility is not lost. It is not canon, does not establish what the layers are, and does not decide whether the ancient structures restrain the Heart, protect it, exploit it, or serve several purposes.

**Locked boundary**

A successful run defeats the Shogun, reaches the Heart, completes one persistent damage step, and returns Akio to the Strand.

**Status:** open; Question 2 satisfied, still depends on Question 3

## 11. Campaign clear count and changes after each clear

**Question**

How many successful Heart-layer completions are required before the Shogun can be permanently defeated and the true-final Heart encounter begins?

For each required clear, establish what changes in story, NPC dialogue, hub state, Heart state, Shogun behavior, encounters, unlocks, or presentation.

**Locked boundary**

No clear count is approved. Six remains only a prior candidate. The count must follow the completed story spine and Heart-layer design rather than determine them.

**Status:** open; depends on Questions 2–10

## 12. True-final Heart encounter, ending, and postgame

**Question**

What happens after the Shogun's permanent defeat, what form does the Heart confrontation take, what does Akio ultimately do with Beast Blood, and why can gameplay continue after the canonical ending?

Establish:

- Heart boss manifestation and phases,
- final vulnerability,
- fate of the Shogun, daughter, island inhabitants, and barrier,
- Akio's final condition,
- ending consequence,
- credits trigger,
- postgame explanation and scope.

**Locked boundary**

The Shogun remains the central character antagonist. The Heart is the deeper supernatural threat and intended true-final encounter.

The Heart's ultimate cosmic origin does not need to be explained in order to resolve the ending.

**Status:** open; final story-spine dependency

## 13. Eclipse Shogun final character and production identity

**Question**

What final body type, costume, weapon, movement language, and beast transformation distinguish the Shogun from the game's other samurai bosses?

**Current direction**

A regal, cunning, potentially slender or lightly armored ruler may fit better than another heavily armored warrior. The final form should use Beast Blood and reveal a beast transformation without becoming a mindless brute.

The transformation represents false ascendancy rather than genuine control: he becomes a more powerful and dangerous beast while believing that deliberate use proves mastery.

**Locked boundary**

The three-phase structure remains Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed. The existing armor, mask, polearm, and animation list are reopened working concepts.

**Status:** open before Milestone 6 quotation