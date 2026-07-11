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

The Embered Pilgrim and Rotwood Host are Area 2's two minibosses. Rootfang and Briarthorn form the paired Twin Maws boss encounter. Both twins begin active, and the first defeated transfers its half of the corrupted bond to the survivor, creating an empowered second half.

**Affected files**

- `docs/content/area_2/OVERVIEW.md`
- `docs/content/area_2/MINIBOSSES.md`
- `docs/content/area_2/BOSS.md`
- `docs/art_production/milestones/MILESTONE_05.md`

**Status:** resolved

### Area 3 encounter classification

**Resolution**

Blood Lotus is Area 3 Miniboss #1, Eternal Swordsman is Area 3 Miniboss #2, and Eclipse Shogun is the principal Area 3 boss. The Eclipse Shogun encounter uses the Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed phases.

**Affected files**

- `docs/content/area_3/OVERVIEW.md`
- `docs/content/area_3/MINIBOSSES.md`
- `docs/content/area_3/BOSS.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** resolved

## Open questions

### Elite Defender revival behavior

**Category:** gameplay | content | production

**Question**

Does the Elite Defender use Kagutsuchi Court's one-time revival mechanic, or should it remain a pure shield-and-spear positional defender?

**Why it matters**

Adding revival may reinforce the regional preservation language, but it may also overload a unit whose primary read already depends on shield orientation, guard coverage, and committed spear punishments.

**Affected files**

- `docs/content/area_3/enemies/ELITE_DEFENDER.md`
- `docs/content/area_3/ENEMIES.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`

**Status:** open

### Twin Maws transition implementation

**Category:** gameplay | boss | UI/UX

**Question**

When the first Twin Maw dies, how are transition invulnerability, survivor health and posture, inherited attacks, transition duration, and difficulty normalization handled?

**Current locked boundary**

Both twins begin active. The first defeated transfers its half of the shared corrupted bond to the survivor. The survivor remains recognizably itself while gaining visible traces and selected capabilities from the fallen twin.

**Affected files**

- `docs/content/area_2/BOSS.md`
- `docs/art_production/milestones/MILESTONE_05.md`
- future boss UI and implementation documentation

**Status:** open

### Blood Lotus cycle tuning

**Category:** gameplay | boss | UI/UX

**Question**

What are the final number of Heart cycles, Stalk-destruction timer, punishment threshold, deathblow HP-chunk values, Stalk relocation rules, and posture-reset behavior?

**Current locked boundary**

The Heart is invulnerable while active Stalks remain. Destroying the Stalks opens a short Heart window. The player builds posture and lands repeated deathblows to remove major HP chunks. Leaving Stalks active too long triggers a punishment phase and resets the encounter into another limb cycle.

**Affected files**

- `docs/content/area_3/MINIBOSSES.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/art_production/milestones/MILESTONE_06.md`
- future miniboss UI and implementation documentation

**Status:** open

### Blood Cavern trial rewards and upgrade caps

**Category:** gameplay | progression | UI/UX

**Question**

What are the final trial counts, unlock sequence, reward tables, mastery conditions, and numerical caps for permanent Blood Aspect reliability upgrades?

**Current locked boundary**

Trials may unlock Aspects and grant small, capped reliability improvements, currency, cosmetics, lore reflections, or completion marks. They must not add new Tiers, remove Embrace danger, or permanently grant the major mechanics owned by in-run Aspect Tiers.

**Affected files**

- `docs/gameplay/BLOOD_CAVERN_TRIALS.md`
- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/ui_ux/BLOOD_MIRROR_TRIALS.md`
- `docs/art_production/milestones/MILESTONE_03.md`

**Status:** open

### Currency family names and ownership

**Category:** gameplay | production | UI/UX

**Question**

How should Mist, Mist Shards, Scrolls, Gold, and Boss Emblems be finalized as currency names and families, and which Strand service owns each one?

**Why it matters**

The source bible uses overlapping currency language across Forge and Bloodwell interfaces. Persistence is broadly defined, but final names, icons, costs, and item-family counts require one consistent currency pass.

**Affected files**

- `docs/gameplay/PROGRESSION.md`
- `docs/content/strand/interactibles/FORGE_BENCH.md`
- `docs/content/strand/interactibles/BLOODWELL.md`
- `docs/art_production/ASSET_INVENTORY.md`
- `docs/ui_ux/HUB_INTERFACES.md`

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

### Stance and prosthetic mechanics

**Category:** gameplay

**Question**

What are the final mechanics, costs, and upgrade paths for the five stances and eight prosthetic tools?

**Affected files**

- `docs/gameplay/STANCES.md`
- `docs/gameplay/PROSTHETICS.md`
- `docs/art_production/milestones/MILESTONE_04.md`

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
