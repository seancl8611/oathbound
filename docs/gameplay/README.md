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

The successful-run duration target is approved in [Run Structure](RUN_STRUCTURE.md). Exact room counts, route topology, branch frequency, miniboss frequency, and authored layout counts remain later prototype and playtest decisions rather than top-level scope questions.

The Blood Aspect system remains a draft at the progression and production-package level, but the following qualitative Tier 0 weapon kits are approved for roster comparison:

- **Wolf:** four-hit fast close-range pressure,
- **Wraith:** two-hit extended spectral poking and reach control,
- **Ronin:** three-hit slow heavy direct damage.

The current launch baseline remains three Aspects. A fourth or fifth Aspect is possible future expansion but is not part of current launch scope.

The next active gameplay task is the three-kit overlap, gap, encounter, Technique-space, and production audit before final combined roster approval.

Current production-level gameplay dependencies tracked in [`../_meta/OPEN_QUESTIONS.md`](../_meta/OPEN_QUESTIONS.md) are:

- final three-Aspect roster audit and approval,
- shared Aspect progression structure and selected packages,
- launch run-build content catalog,
- persistent progression, onboarding, and trial package,
- and postgame release package.

The narrative-delivery package is also tracked there because it affects authored content and production, but it does not reopen gameplay or lore canon.

Exact attacks values, timings, cooldowns, probabilities, prices, hitboxes, numerical balance, route generation, and other playtest values remain in the owning gameplay or encounter file.

## Authority rule

Gameplay files own mechanics. Lore explains fiction, content owns combatant and location identity, UI owns interaction behavior, art owns visual requirements, and milestones own production scope. Those files may summarize gameplay but must not redefine it.