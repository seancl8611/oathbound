# Gameplay

Authoritative player-facing mechanics and system rules belong here.

## Core documents

- [Core Loop](CORE_LOOP.md)
- [Combat](COMBAT.md)
- [Run Structure](RUN_STRUCTURE.md)
- [Blood Aspects](BLOOD_ASPECTS.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Technique System](TECHNIQUES.md)
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Prosthetic Tools](PROSTHETICS.md)
- [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md)

## Current design work

Production-level gameplay questions are tracked in [`../_meta/OPEN_QUESTIONS.md`](../_meta/OPEN_QUESTIONS.md):

- run length and route structure,
- launch build-content catalog,
- persistent progression and trial scope,
- postgame route and repeat-clear rewards.

Exact attack timings, cooldowns, probabilities, prices, hitboxes, numerical balance, and other playtest values remain in the owning gameplay or encounter file and do not belong in the top-level question tracker.

## Authority rule

Gameplay files own mechanics. Lore explains fiction, content owns combatant and location identity, UI owns interaction behavior, art owns visual requirements, and milestones own production scope. Those files may summarize gameplay but must not redefine it.