---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-07-23
topics:
  - blood-aspects
  - blood-arts
  - blood-resource
  - wolf
  - wraith
  - ronin
  - corruption
  - run-progression
  - techniques
related:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - CONTENT-STRAND-INTERACTIBLES
---

# Blood Aspect System

## Design status

The Blood Aspect system is under reevaluation.

The repository does not currently approve:

- a fixed launch count,
- Wolf, Wraith, and Ronin as the final roster,
- the exact identity of any candidate Aspect,
- the Tier 0-IV structure,
- Blood unlocking at Tier II,
- one Blood Art per Aspect,
- the drawback-family model,
- or the exact relationship between Aspects, Corruption, Shrines, Techniques, trials, and persistent progression.

Wolf, Wraith, and Ronin remain useful working candidates. Their existing descriptions may be retained, revised, renamed, combined, replaced, or cut.

The amount of detail in a draft does not make it approved.

## Current design objective

Determine whether Blood Aspects should remain the central run specialization through which Akio deliberately shapes Returning Blood.

A successful system should:

- deepen the base katana combat rather than replace it,
- create meaningfully different run identities,
- support several valid Technique builds per identity,
- remain readable during standard, group, elite, and boss encounters,
- express increasing supernatural power and risk,
- and fit the available gameplay, UI, animation, VFX, audio, trial, and progression scope.

## First approval package: purpose, count, and identities

Before designing exact mechanics, approve:

1. the system's role in the run build,
2. whether the player selects one Aspect per run,
3. the intended launch count,
4. the final or provisional launch roster,
5. the player fantasy of each selected identity,
6. the combat behavior each identity rewards,
7. the risk each identity introduces,
8. the combat territory reserved for Techniques and prosthetics,
9. and the production distinction required for each identity.

Three is not currently a locked count.

## Identity evaluation template

Each proposed Aspect should answer:

- **Fantasy:** What form of controlled Returning Blood is Akio expressing?
- **Combat identity:** What decisions does it change during ordinary sword combat?
- **Skill expression:** What player behavior does it reward?
- **Risk:** What danger or limitation belongs naturally to that identity?
- **Encounter coverage:** How does it function against groups, elites, and bosses?
- **Build space:** What related mechanics remain available for Techniques and prosthetics?
- **Visual identity:** How is it readable without requiring a separate full Akio animation set?
- **Production cost:** What unique UI, animation, VFX, and audio does it require?

An Aspect should not be approved only because its theme is appealing. It must own a distinct and sustainable gameplay loop.

## Working structural candidate — not approved

The previous design used this shared structure:

- **Tier 0:** one persistent signature mechanic with no meaningful drawback.
- **Tier I:** strengthens the signature and introduces one coherent drawback family.
- **Tier II:** unlocks run-only Blood and one activatable Blood Art.
- **Tier III:** deepens the established specialization.
- **Tier IV:** provides an optional capstone with the strongest form of the same risk.

Additional working rules were:

- one headline improvement and at most one minor supporting rule per Tier,
- no new Aspect resource, input, or second Blood Art after Tier II,
- evolving rather than unrelated stacked drawbacks,
- Tier II or III as a common successful-run endpoint,
- Tier IV as occasional rather than mandatory,
- Resist as stabilization rather than an alternate power path,
- and no Tier V.

These remain candidates for evaluation. They should not constrain the identity pass if a simpler or stronger structure emerges.

## Working Blood candidate — not approved

The previous design treated Blood as:

- a run-only combat resource,
- inactive before Tier II,
- generated through combat,
- used only to activate the selected Aspect's Blood Art,
- reset after death or successful completion,
- and unavailable as a shop, route, Strand, or persistent currency.

Capacity, activation amount, gain rules, room carry, boss behavior, retention, and individual Blood Arts were unresolved.

Partial activation was deferred until representative playable testing. This remains a reasonable safeguard only if Blood Arts remain in the final system.

## Working candidate identities

### Wolf — candidate

- **Current role direction:** aggression, pursuit, and selected-target pressure.
- **Current fantasy direction:** predatory Returning Blood.
- **Current loop direction:** identify prey, maintain pressure, finish the target, and transfer momentum.
- **Current constraint:** should not collapse into generic attack speed or claim all aggressive Technique space.
- **Status:** identity and inclusion are unapproved.

### Wraith — candidate

- **Current role direction:** evasion, repositioning, and punishment after clean avoidance.
- **Current fantasy direction:** controlled spectral dissolution.
- **Current loop direction:** bait, avoid, reposition, and punish from a favorable angle.
- **Current constraint:** must remain distinct from Wolf, ordinary movement Techniques, and the Mist Raven prosthetic.
- **Status:** identity and inclusion are unapproved.

### Ronin — candidate

- **Current role direction:** sword discipline, parries, posture, Counter Cuts, and deathblows.
- **Current fantasy direction:** Returning Blood reinforcing trained martial control.
- **Current loop direction:** control the exchange, defend precisely, counter or execute, and reset.
- **Current constraint:** must feel like a complete specialization rather than a basic or intentionally weaker default.
- **Status:** identity and inclusion are unapproved.

## Technique relationship boundary

Until the Aspect roster and identities are approved:

- do not populate the Technique catalog around Wolf, Wraith, or Ronin as fixed launch identities,
- do not reserve major Technique categories for candidate mechanics,
- do not hard-lock ordinary Techniques to a candidate Aspect,
- and do not use candidate affinities to approve production counts.

The final Aspect system should preserve independently useful Techniques and several valid builds for each selected identity.

## Permanent progression boundary

Blood Mirror, Blood Cavern, Bloodwell, and unlock plans may reference a future Aspect system, but exact unlocks, mastery trials, permanent upgrades, and interface counts remain blocked by the final system and roster.

No persistent upgrade should make a run-only Aspect mechanic automatic or remove its intended risk.

## Design order

1. Approve the system purpose.
2. Approve the launch count.
3. Approve the identity roster at fantasy and combat-loop depth.
4. Audit identity overlap and production cost.
5. Approve or revise the shared progression structure.
6. Design each selected Aspect's exact mechanics.
7. Approve shared resource, activation, Shrine, and HUD rules.
8. Finalize Aspect-Technique interaction rules.
9. Populate Technique coverage and launch counts.
10. Evaluate optional complexity through playable testing.

## Approval tests

The roster is not ready unless:

- every selected Aspect owns a distinct player fantasy and combat decision pattern,
- the launch count supports replayability without exceeding production scope,
- no identity is merely a stronger or weaker version of another,
- base katana combat remains primary,
- Techniques and prosthetics retain meaningful territory,
- each identity can function against groups, elites, and bosses,
- and the roster can be communicated clearly through gameplay and presentation.

An individual Aspect is not ready for exact Tier or Blood Art approval until its identity passes the roster-level audit.

## Visual production direction

The preferred production direction remains one base Akio animation set with modular eyes, markings, weapon treatments, auras, trails, and composable overlays where possible.

This is a cost-control direction, not proof that three specific Aspect families are approved.

## Related documents

- [Current Design Questions](../_meta/OPEN_QUESTIONS.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Combat](COMBAT.md)
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Shrine interface](../ui_ux/SHRINE_INTERFACE.md)
- [Blood Mirror interface](../ui_ux/BLOOD_MIRROR_TRIALS.md)
