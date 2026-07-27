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
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Prosthetic Tools](PROSTHETICS.md)
- [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md)

## Current status

The successful-run duration target is approved in [Run Structure](RUN_STRUCTURE.md). Exact room counts, route topology, branch frequency, miniboss frequency, and authored layout counts remain prototype and playtest decisions rather than top-level scope questions.

The launch Blood Aspect roster is approved:

- **Wolf:** four-hit fast close-range pressure and pursuit,
- **Wraith:** two-hit extended spectral reach and frontal control,
- **Ronin:** three-hit slow heavy impact and defensive stability.

These three identities complete the current launch space. Mobility, evasion, ranged utility, and broader crowd-control options remain supported by universal systems, Techniques, prosthetics, and encounter design. Additional Aspects are outside current launch scope unless playable evidence later demonstrates a missing identity.

Aspect progression is fixed from Tier 0 through Tier IV. At a full Corruption threshold, the player chooses Resist or Embrace; Embrace advances the selected Aspect by one fixed Tier. Tier IV uses Stabilize rather than Tier V. Blood is run-only and unavailable before Tier II.

Current production-level gameplay dependencies tracked in [`../_meta/OPEN_QUESTIONS.md`](../_meta/OPEN_QUESTIONS.md) are:

- fixed Tier I-IV packages, evolving drawbacks, Blood rules, and Blood Arts for Wolf, Wraith, and Ronin,
- launch run-build content catalog,
- persistent progression, onboarding, and trial package,
- and postgame release package.

The narrative-delivery package is also tracked there because it affects authored content and production, but it does not reopen gameplay or lore canon.

Exact attack values, timings, cooldowns, probabilities, prices, hitboxes, resource values, route generation, and other playtest variables remain in their owning gameplay or encounter files.

## Authority rule

Gameplay files own mechanics. Lore explains fiction, content owns combatant and location identity, UI owns interaction behavior, art owns visual requirements, and milestones own production scope. Those files may summarize gameplay but must not redefine it.
