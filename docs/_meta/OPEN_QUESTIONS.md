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

**Status:** resolved

### Corruption and Resist rules

**Resolution**

Corruption is gained through combat accomplishments and major encounter progress. Taking damage is not a universal source in v1. Resist keeps the current Tier, reduces Corruption to approximately 75%, and grants a short-term support reward such as healing. Exact values remain tuning variables.

**Status:** resolved

## Resolved in production bible pages 71–105

### Area 2 encounter structure

**Resolution**

The Embered Pilgrim and Rotwood Host are Area 2's two minibosses. Rootfang and Briarthorn form the Twin Maws boss. Both twins begin active, and the first defeated transfers its half of the corrupted bond to the survivor.

**Status:** resolved

### Area 3 encounter classification

**Resolution**

Blood Lotus is Area 3 Miniboss #1, Eternal Swordsman is Area 3 Miniboss #2, and Eclipse Shogun is the principal boss with Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed phases.

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

### Stance and prosthetic roster identities

**Resolution**

The five stance identities are Storm, Frost, Ember, Hex, and Shadow. The eight prosthetic tools are Beast-Bane Whistle, Thunder Rod, Smoke Gourd, Fang Harpoon, Mirror Umbrella, Flame Vent, Mist Raven, and Bloodletting Gourd. Their tactical roles and visual footprints are now defined.

Final costs, cooldowns, upgrade paths, stack values, durations, and balance caps remain open.

**Status:** resolved at roster/identity level

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

**Status:** open

### Twin Maws transition implementation

**Category:** gameplay | boss | UI/UX

**Question**

How are transition invulnerability, survivor health and posture, inherited attacks, transition duration, and difficulty normalization handled after the first Twin Maw dies?

**Locked boundary**

Both twins begin active. The first defeated empowers the survivor, which remains recognizably itself.

**Status:** open

### Blood Lotus cycle tuning

**Category:** gameplay | boss | UI/UX

**Question**

What are the final Heart-cycle count, Stalk timer, punishment threshold, deathblow HP chunks, Stalk relocation rules, and posture reset behavior?

**Status:** open

### Blood Cavern trial rewards and upgrade caps

**Category:** gameplay | progression | UI/UX

**Question**

What are the final trial counts, unlock sequence, reward tables, mastery conditions, and numerical caps for permanent Blood Aspect reliability upgrades?

**Locked boundary**

Trials may grant Aspect access, small capped reliability improvements, currency, cosmetics, lore reflections, or completion marks. They cannot add new Tiers or remove Embrace danger.

**Status:** open

### Stance and prosthetic tuning

**Category:** gameplay | balance

**Question**

What are the final activation rules, Spirit costs, cooldowns, durations, stack thresholds, immunity rules, switching behavior, upgrade paths, and balance caps for the five stances and eight prosthetics?

**Affected files**

- `docs/gameplay/STANCES.md`
- `docs/gameplay/PROSTHETICS.md`
- `docs/art_production/milestones/MILESTONE_04.md`

**Status:** open

### Boon, relic, and item catalog

**Category:** gameplay | production | UI/UX

**Question**

What are the final boon, relic, consumable, breakable, and reward-object counts, effect catalogs, rarity weights, drop tables, and persistent/run-only ownership rules for individual entries?

**Locked boundary**

The shared categories, card templates, world/HUD relationships, and Common–Legendary rarity presentation are approved.

**Status:** open

### Order knowledge and intent

**Category:** lore

**Question**

How much does the Order know about the Shogun, Wellspring, Returning Blood, and Akio's chance of returning?

**Status:** open

### Barrier origin

**Category:** lore

**Question**

Who created the barrier, and what is its exact relationship to the Shogun and Wellspring?

**Status:** open

### The Shogun's ancient enemy

**Category:** lore

**Question**

Who or what was the ancient enemy the Eclipse Shogun defeated using Beast Blood, and how did that conflict lead to the army's preservation and the island's current state?

**Status:** open

### Ending structure

**Category:** lore

**Question**

What final decision or consequence follows the Shogun's defeat at the Wellspring?

**Status:** open
