---
id: META-OPEN-QUESTIONS
title: Open Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-11
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

Blood Lotus is Area 3 Miniboss #1, Eternal Swordsman is Area 3 Miniboss #2, and Eclipse Shogun is the principal boss with Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed phases.

**Affected files**

- `docs/content/area_3/OVERVIEW.md`
- `docs/content/area_3/MINIBOSSES.md`
- `docs/content/area_3/BOSS.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** resolved

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

Standard combat routes preview a primary payout. Selected combat and milestone rewards offer Techniques. Shrines own Resist/Embrace or support; rest rooms own recovery and reserve swapping; shops use Gold; treasure/miniboss rewards are high value; regional bosses grant persistent and current-run power; the Eclipse Shogun resolves through Wellspring completion.

**Status:** resolved at structural level

## Open questions

### Milestone 1 Posture Break Cue assignment

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

### Elite Defender revival behavior

**Category:** gameplay | content | production

**Question**

Does the Elite Defender use Kagutsuchi Court's one-time revival mechanic, or remain a pure shield-and-spear positional defender?

**Affected files**

- `docs/content/area_3/enemies/ELITE_DEFENDER.md`
- `docs/content/area_3/ENEMIES.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** open

### Twin Maws transition implementation

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

### Blood Lotus cycle tuning

**Category:** gameplay | boss | UI/UX

**Question**

What are the final Heart-cycle count, Stalk timer, punishment threshold, deathblow HP chunks, Stalk relocation rules, and posture reset behavior?

**Affected files**

- `docs/content/area_3/MINIBOSSES.md`
- `docs/ui_ux/HUD.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** open

### Blood Cavern trial rewards and upgrade caps

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

### Technique catalog and tuning

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

### Prosthetic tuning and Prosthetic Techniques

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

### Reward cadence and room economy

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

### Relic and consumable catalog

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

### Order knowledge and intent

**Category:** lore

**Question**

How much does the Order know about the Shogun, Wellspring, Returning Blood, and Akio's chance of returning?

**Affected files**

- `docs/lore/THE_ORDER.md`
- `docs/lore/STORY_OVERVIEW.md`
- `docs/characters/AKIO.md`

**Status:** open

### Barrier origin

**Category:** lore

**Question**

Who created the barrier, and what is its exact relationship to the Shogun and Wellspring?

**Affected files**

- `docs/lore/THE_BARRIER_AND_BLOOD_MOON.md`
- `docs/lore/ECLIPSE_SHOGUN.md`

**Status:** open

### The Shogun's ancient enemy

**Category:** lore

**Question**

Who or what was the ancient enemy the Eclipse Shogun defeated using Beast Blood, and how did that conflict lead to the army's preservation and the island's current state?

**Affected files**

- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/TIMELINE.md`

**Status:** open

### Ending structure

**Category:** lore

**Question**

What final decision or consequence follows the Shogun's defeat at the Wellspring?

**Affected files**

- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/art_production/milestones/MILESTONE_07.md`

**Status:** open
