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
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Prosthetic Tools](PROSTHETICS.md)
- [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md)

## Current status

The launch Blood Aspect roster and qualitative Tier 0-IV packages are locked for current paper-design scope:

- **Wolf:** four-hit fast close-range pressure and pursuit.
- **Wraith:** two-hit extended spectral reach and frontal control.
- **Ronin:** three-hit slow heavy impact and defensive stability.

No further Aspect or Tier audit is active unless prototyping exposes a concrete problem. Exact attack values, timings, hitboxes, growth percentages, and related balance remain implementation work.

The Technique architecture uses five direct combat slots—Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow—plus slotless supporting upgrades. The old four-active-plus-reserve model is retired.

All five core Technique-family mechanics are defined at qualitative core-rule depth: **Echo, Rupture, Seal, Rift, and Burst**. The active Technique task is to finish and approve the direct five-by-five combat-slot matrix before rebuilding supporting, cross-family, Legendary, and refinement layers.

Current production-level dependencies in [`../_meta/OPEN_QUESTIONS.md`](../_meta/OPEN_QUESTIONS.md) begin with:

1. direct five-by-five Technique matrix,
2. remaining Technique layers and run-build content,
3. persistent Prosthetic / Forge scope and broader persistent progression,
4. narrative delivery and authored-content scope,
5. postgame release scope.

The successful-run duration target is approved in [Run Structure](RUN_STRUCTURE.md). Exact route topology, room counts, probabilities, prices, and other playtest variables remain in their owning files.

## Authority rule

Gameplay files own mechanics. Lore explains fiction, content owns combatant/location identity, UI owns interaction behavior, art owns visual requirements, and milestones own production scope. Summary files must not redefine those authorities.