---
id: DECISION-2026-09-10-COMBAT-V2-HUNTER-DIRECTION
title: Combat V2 Hunter Direction
category: decision
status: approved
authority: history
last_reviewed: 2026-09-10
---

# Combat V2 Hunter Direction

Oathbound keeps its Japanese supernatural setting and samurai-derived visual/cultural language, but the dominant player fantasy is shifting away from formal samurai dueling and toward **Akio as an aggressive supernatural hunter**.

The approved Combat V2 direction is:

- freer, more continuous player movement closer to a modern top-down action roguelite,
- attacks with authored movement/steering rather than broad state-wide movement shutdown,
- higher standard-enemy population where readable,
- weaker ordinary enemies that are easier to damage, stagger, interrupt, and kill,
- clearer fodder / standard / elite / boss roles,
- difficulty created more through enemy combinations, positioning, attack geometry, and overlapping intentions than through repeated one-on-one posture duels,
- parry retained as a valuable aggressive defensive option rather than the default answer to every enemy,
- sustained block deemphasized as the preferred universal play pattern,
- beast/spirit enemies allowed to move and attack more like predators rather than disciplined humanoid duelists,
- crowd coordination moving toward threat/impact scheduling rather than single-attacker turn ownership,
- bosses moving toward action-roguelite phase design where transformations, arena pressure, attack families, and spatial problems change between phases rather than merely escalating a Soulslike duel.

The Japanese identity remains. Samurai and disciplined martial enemies should become stronger points of contrast inside a broader population of corrupted warriors, spirits, monsters, and beasts.

## Aspect-dependent mechanic question

No current Aspect loses block, parry, dash, or another shared mechanic through this decision.

However, Combat V2 should not hard-code the assumption that every Aspect must expose every defensive mechanic identically. A later Aspect capability pass may decide that block, parry, defensive transitions, stagger/poise behavior, or equivalent actions differ materially by equipped Aspect.

Until that pass is explicitly approved and reconciled into the owning gameplay authorities, the current V1 universal defense contracts remain operative.

## Implementation consequence

Do not attempt to create this feel primarily through damage/Health tuning, higher spawn counts, shorter parry windows, or global speed increases on the current architecture.

The first V2 implementation work should establish the player motor and action/intent foundation, then migrate a reference enemy, then replace the single-turn pressure model, and only afterward retune encounter population and boss behavior.

**Direction authority:** `docs/overview/V2_COMBAT_DIRECTION.md`.

**Current operative mechanics until migrated:** `docs/gameplay/COMBAT.md`, `docs/gameplay/BLOOD_ASPECTS.md`, their implementation baselines, and the current Godot runtime.
