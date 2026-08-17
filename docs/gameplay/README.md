# Gameplay

Authoritative player-facing mechanics and system rules belong here.

## Core documents

- [Core Loop](CORE_LOOP.md)
- [Combat](COMBAT.md)
- [Run Structure](RUN_STRUCTURE.md)
- [Blood Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md)
- [Blood Aspects](BLOOD_ASPECTS.md)
- [Blood Aspect Identity Guidelines](ASPECT_IDENTITY_GUIDELINES.md)
- [Wolf Blood Aspect](WOLF_ASPECT.md)
- [Wraith Blood Aspect](WRAITH_ASPECT.md)
- [Ronin Blood Aspect](RONIN_ASPECT.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Relics](RELICS.md)
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Prosthetic Tools](PROSTHETICS.md)
- [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md)

## Current status

Major gameplay architecture is complete at first-pass paper/prototype depth:

- **3 Blood Aspects:** Wolf, Wraith, Ronin.
- **Technique system:** five direct slots + slotless Supporting / Cross-family / Legendary Techniques; 50 Techniques + 10 refinements; three-choice reward generation and source weighting approved for prototype.
- **Relics:** 10-item launch roster, one equipped slot, persistent collection/mastery/progression, no rarity tiers.
- **Prosthetics:** 8 tools, 19 shallow linear Forge upgrades.
- **Permanent stations:** Bloodwell → Akio + Run Infrastructure; Forge → Prosthetics + Relics; later-unlocked Blood Mirror → Blood Aspects.
- **Run structure:** 12 Hushiro + 10 Yomori + 11 Kagutsuchi = 33 counted chambers; ~45–50 minute normal successful Binding-run target.
- **Reward model:** first route/room weights, Technique cadence, Gold/Shop economy, recovery/capacity values, and persistent-resource payouts are approved prototype targets.

Persistent economy is intentionally small:

- **Mist** — broad permanent progression,
- **Scrolls** — primarily Prosthetic Forge progression,
- **three regional boss materials** — one unique low-count material per Keeper / Twin Maws / Eclipse Shogun kill, used sparingly as secondary requirements on selected major permanent upgrades,
- **Gold** — run-only.

There is **no generic Boss Emblem currency**.

The active gameplay package remains **full-run integration, rewards, encounters, and pacing**. The next design dependency is regional-boss current-run reward composition, followed by Relic acquisition / limited swap placement, consumables include/cut, encounter composition, and playable pacing validation.

See `docs/_meta/OPEN_QUESTIONS.md` for unresolved priorities rather than using this index as a parallel tracker.

## Authority rule

Gameplay files own mechanics. Lore owns fiction, content owns combatant/location identity, UI owns interaction behavior, art owns visual requirements, and milestones own production scope. Summary files should link to these authorities rather than duplicate their full rules.
