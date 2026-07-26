---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-07-26
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
  - GAMEPLAY-COMBAT
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - CONTENT-STRAND-INTERACTIBLES
---

# Blood Aspect System

## Approved foundation at the current scoping depth

The following direction is approved:

- the player selects one Blood Aspect as a major run foundation,
- the selected Aspect creates an immediate run identity at Tier 0,
- the current launch scope contains three Aspects,
- every Aspect uses the same control layout and participates in Oathbound's attack, defense, movement, posture, deathblow, Technique, and prosthetic systems,
- every Aspect uses one physical katana expressed through an Aspect-specific Returning Blood combat form,
- each Aspect may substantially reinterpret the sword actions produced by the shared inputs,
- no universal combo length, attack names, held attack, counterattack, or dash attack is required across the roster,
- neutral locomotion and dash functionality remain universal so Aspect selection does not weaken dependable evasion or arena navigation,
- the selected Aspect remains functional before any Technique is acquired,
- ordinary Techniques retain one universal ruleset,
- and identities must remain readable as different forms of Akio rather than unrelated playable characters.

Three is the current production and design baseline, not a permanent ceiling.

The expanded contract leaves room for a possible fourth and fifth Aspect in future development. Neither is part of current launch paper-design or production scope. Expansion should be reconsidered only after the three launch candidates are playable and testing demonstrates a meaningful missing combat identity that cannot be handled by revising the approved roster, Techniques, or prosthetics.

## Current unresolved status

This file remains a draft because the repository does not yet approve:

- Wolf, Wraith, and Ronin as the final three identities,
- Ronin's complete Tier 0 combat foundation,
- the final roster-level balance between attack, defense, movement, posture, range, and production cost,
- exact numerical values, frame data, animation counts, or hit geometry,
- whether any future Aspect should remove sustained block rather than merely alter its efficiency,
- the Tier 0-IV structure,
- Blood unlocking at Tier II,
- one Blood Art per Aspect,
- the drawback-family model,
- detailed Aspect-affinity and offer-weighting rules,
- rare direct Aspect-, Blood-, or Tier-referencing Technique exceptions,
- or the exact relationship between Aspects, Corruption, Shrines, trials, and persistent progression.

Wolf, Wraith, and Ronin remain the three working launch candidates. Wolf and Wraith are approved at qualitative Tier 0 depth for roster comparison. Their final inclusion remains unapproved until Ronin is defined and the three-candidate audit is complete.

## System purpose

Blood Aspects are the central pre-run choice through which Akio shapes Returning Blood into a distinct combat foundation.

The selected Aspect should:

- remain noticeable from the first combat room,
- matter even when the player does not heavily pursue later Aspect upgrades,
- preserve Oathbound's readable posture, parry, block, dodge, deathblow, and prosthetic language,
- alter Akio's sword behavior enough to create a different run identity,
- support several valid Technique builds,
- function against standard enemies, mixed groups, ranged pressure, hazards, elites, and bosses,
- express increasing supernatural power and risk,
- and remain achievable within gameplay, UI, animation, VFX, audio, trial, and progression scope.

## Approved Aspect-Technique layer contract

Aspects and Techniques are both major run-build layers, but they have different responsibilities.

### Aspects own the foundation

The selected Aspect is:

- chosen before the run,
- active from Tier 0,
- always present during combat,
- responsible for the run's starting combat identity,
- allowed to change chain structure, attack rhythm, reach, coverage, commitment, recovery, movement flow, target handling, damage-versus-posture profile, defensive profile, and Blood-weapon expression,
- and the owner of any later Aspect-specific vertical power and risk progression that remains in the final system.

An Aspect must be complete without finding a particular Technique. Techniques may deepen or redirect it, but they cannot repair an incomplete foundation.

### Techniques own modular build construction

Techniques are:

- temporary rewards acquired during the run,
- limited to four active slots plus one inactive reserve,
- individually replaceable,
- focused modifications to existing attacks, defenses, movement, posture, deathblows, resources, or the equipped prosthetic,
- and the primary way the player develops the selected foundation during that run.

A Technique should provide standalone value and should not become the player's entire foundation by itself.

### Intentional overlap

Overlap is expected at the combat-verb level. Both systems may affect attacks, parries, dodges, posture, deathblows, movement, and prosthetics, but they affect them at different scales.

- The Aspect establishes how the overall combat foundation behaves.
- A Technique modifies a specific action, condition, payoff, transition, or tactical option within that foundation.

A Technique may intentionally:

1. **Reinforce** an Aspect's existing strengths.
2. **Broaden** the Aspect into an adjacent play pattern.
3. **Compensate** for a weakness at the cost of a Technique slot.
4. **Hybridize** the foundation into an unusual but coherent build.

Ordinary Techniques have one universal ruleset. They do not contain separate Wolf, Wraith, and Ronin versions. A Technique may feel or perform differently because the action it modifies already behaves differently under the selected Aspect.

### Compatibility rules

- Ordinary Techniques are not hard-locked to one Aspect.
- Ordinary Techniques do not require a minimum Aspect Tier.
- Affinity describes natural synergy and may later influence offer weighting; it does not determine eligibility.
- Every Aspect must support several distinct valid four-Technique builds.
- Neutral and alternate-affinity Techniques must remain meaningful options.
- An Aspect cannot automatically make an entire Technique category the correct choice.
- A Technique cannot duplicate the Aspect's complete foundation, signature mechanic, or activatable Blood Art.
- Direct Aspect-, Blood-, or Tier-referencing Techniques may exist only as limited, explicit exceptions after the shared structure and roster are approved.
- Aspect progression must not make Technique selection secondary.
- Technique combinations must not make Aspect identity irrelevant.

## Approved shared player-kit boundary

Blood Aspects create distinct Tier 0 combat foundations without turning Akio into unrelated characters.

The shared boundary is defined by **common controls, common encounter rules, common neutral movement, and common readability**, not by one identical moveset.

### Universal control and combat framework

The following remain consistent across all launch Aspects:

- input layout and control scheme,
- the existence of the basic attack, held attack, defense, parry counter, dash attack, dodge, deathblow, Technique, and prosthetic action slots,
- defense input and parry timing/success logic,
- enemy telegraphs, hit reactions, defensive responses, and punish windows,
- posture, stagger, posture-break, and deathblow language,
- Spirit and prosthetic controls,
- Technique slots, acquisition, replacement, reserve, and refinement rules,
- and the interface and feedback language required to read combat.

The player should not need to relearn the controller layout, enemy logic, parry timing, deathblow rules, or interface behavior after changing Aspects.

### Universal neutral movement and dash

All launch Aspects share the same functional neutral:

- running and ordinary locomotion speed,
- dash distance,
- dash travel speed,
- dash startup,
- dash invulnerability timing,
- neutral dash recovery,
- repeat-dash availability,
- directional and steering rules,
- collision and hazard behavior,
- and standard access to movement, defense, and offense after the dash.

Exact values remain implementation work, but the functional values are common. A shorter, slower, or less responsive neutral dash must not be used as an automatic Aspect weakness.

Aspect-specific movement is expressed primarily through attacks, counters, attack transitions, and the selected dash attack. A dash attack may travel differently, end in a different position, or carry different risk because the player voluntarily enters an offensive commitment after the universal dash.

### Shared action slots, not shared moves

Every Aspect retains meaningful access to:

- a basic attack input and an Aspect-specific sequence,
- a held attack,
- a post-parry counterattack,
- a dash-to-attack action,
- block,
- parry,
- dodge and repositioning,
- posture pressure,
- deathblows,
- Techniques,
- and the equipped prosthetic.

The previous universal list of `Quick Slash`, `Cross Cut`, `Heavy Cleave`, `Hold Thrust`, `Counter Cut`, and `Dash Slash` is superseded.

Those names and exact roles may belong to an individual Aspect, but the roster is not required to share:

- a three-hit chain,
- the same chain length,
- the same attack names,
- the same attack geometry,
- the same held attack behavior,
- the same parry follow-up,
- or the same dash attack.

An Aspect may use a two-hit sequence, a longer sequence, contextual branches, or another finite and readable attack structure when that structure directly teaches its playstyle.

### Aspect-specific foundation

At Tier 0, each Aspect may change connected dimensions of Akio's combat foundation:

- basic attack sequence length, order, names, branching, restart behavior, and rhythm,
- attack startup, recovery, cancel opportunities, and commitment,
- effective reach, attack arcs, and coverage,
- forward, lateral, or backward movement attached to attacks,
- tracking and target correction,
- health-damage and enemy-posture balance,
- target handling and transfer between enemies,
- held attack purpose and target interaction,
- post-parry counterattack behavior,
- dash attack behavior and its follow-up sequence,
- offensive transitions after block, dodge, parry, deathblow, or another attack,
- player-posture capacity and recovery direction,
- block efficiency and posture cost,
- and the visual form of the katana through Returning Blood.

These changes should work together to create a recognizable combat identity. An Aspect should not be defined by changing only one number, one attack, or one input.

### Defense and posture boundary

The current baseline retains block, parry, dodge, player posture, and deathblows under every launch Aspect.

Aspects may have different relative:

- player-posture capacity,
- player-posture recovery behavior,
- posture damage received while blocking,
- incentives to hold block versus parry precisely,
- and offensive continuation after successful defense.

Removing sustained block entirely remains a possible future exception, not an approved baseline. Such a change would require explicit roster-level approval after enemy, boss, onboarding, accessibility, and encounter compatibility review.

### Contextual differences

Universal actions may have different offensive consequences under each Aspect.

- A parry follows the same timing and success rules, but the counterattack and sequence entered afterward may differ.
- A neutral dash follows the same movement and defensive rules, but the optional dash attack may differ.
- A deathblow requires the same eligible enemy state, but its effect on positioning or offensive momentum may differ.
- A prosthetic retains its tactical function, but its value may change naturally because of the selected Aspect's range, rhythm, defensive profile, or target handling.

These differences belong to the Aspect foundation rather than separate versions of Techniques or prosthetics.

### Balance boundary

Aspects may have different relative:

- attack speeds,
- chain lengths,
- damage profiles,
- player- and enemy-posture interactions,
- weapon ranges,
- attack recovery times,
- attack movement and tracking,
- block efficiency,
- and crowd coverage.

These must function as tradeoffs rather than direct upgrades. No Aspect should have the best speed, range, damage, safety, posture pressure, tracking, coverage, and flexibility simultaneously.

Neutral movement and dash are excluded from these automatic tradeoffs. Exact numerical values remain implementation and gameplay-testing work.

## Three-Aspect identity process

### Pass 1 — Candidate definitions

Evaluate Wolf, Wraith, and Ronin individually using the identity template below. Bring each candidate to the same qualitative depth before finalizing progression, Blood Arts, or production counts.

Wolf and Wraith are complete at this depth. Ronin is the active candidate.

### Pass 2 — Overlap and gap audit

After Ronin is defined, compare all three candidates together:

- identify mechanical and thematic overlap,
- identify missing launch-critical territory,
- confirm meaningful full-system use,
- confirm distinct run identities,
- confirm multiple Technique build shapes,
- preserve Technique and prosthetic build space,
- test mixed-wave, ranged, elite, hazard, and boss viability,
- and verify that the common controls and neutral dash remain readable.

A gap should first be addressed by revising or replacing one of the three candidates. It does not automatically justify adding a fourth.

### Pass 3 — Roster revision and approval

Retain, revise, rename, combine, or replace candidates as required by the audit. Then approve:

- one concise identity row for each of the three Aspects,
- the candidate-specific moveset and defensive profile,
- the expected Technique build shapes,
- and the production distinction required for each identity.

Exact Tiers, Blood generation, Blood Arts, and later candidate mechanics follow after roster approval.

## Identity evaluation template

Each proposed Aspect should answer:

- **Fantasy:** What form of controlled Returning Blood is Akio expressing?
- **Known as:** What simple playstyle label would a player understand?
- **Basic sequence:** What does repeated basic attack input produce, and why does that structure teach the identity?
- **Held attack:** What committed option does hold/release provide?
- **Counterattack:** How does successful parry convert back into this Aspect's offense?
- **Dash attack:** How does the universal dash flow into Aspect-specific offense?
- **Foundation change:** How does it alter rhythm, reach, coverage, commitment, recovery, attack movement, damage, posture, target handling, or weapon form?
- **Defense profile:** How do shared parry, block, dodge, and player posture support the identity?
- **Full-system use:** How does it use deathblows, Techniques, and prosthetics without depending on one of them?
- **Technique build space:** How can Techniques reinforce, broaden, compensate, or hybridize the identity?
- **Risk:** What danger or limitation belongs naturally to the identity?
- **Encounter coverage:** How does it function against groups, ranged enemies, elites, hazards, and bosses?
- **Visual identity:** How is it readable without unnecessary production duplication?
- **Production cost:** What unique UI, animation, VFX, and audio does it require?

An Aspect should not be approved only because its theme is appealing or because it strongly modifies one input. It must create a sustainable combat pattern using the complete game and support more than one obvious Technique build.

## Cross-behavior requirement

All current launch candidates must meaningfully support:

- their complete Aspect-specific attack foundation,
- parry and block,
- the universal neutral dash and repositioning,
- posture pressure and deathblows,
- Techniques,
- and the equipped prosthetic.

An Aspect may favor certain combinations, timings, ranges, risks, or tactical situations. It must not make one core behavior its only meaningful route or reserve an entire action family for itself.

## Working structural candidate — not approved

The previous design used:

- **Tier 0:** one persistent signature mechanic with no meaningful drawback,
- **Tier I:** strengthens the signature and introduces one coherent drawback family,
- **Tier II:** unlocks run-only Blood and one activatable Blood Art,
- **Tier III:** deepens the established specialization,
- **Tier IV:** provides an optional capstone with the strongest form of the same risk.

Additional working rules included:

- one headline improvement and at most one minor supporting rule per Tier,
- no new Aspect resource, input, or second Blood Art after Tier II,
- evolving rather than unrelated stacked drawbacks,
- Tier II or III as a common successful-run endpoint,
- Tier IV as occasional rather than mandatory,
- Resist as stabilization rather than an alternate power path,
- and no Tier V.

These remain candidates. They should not constrain the identity pass if a stronger or simpler structure emerges.

## Working Blood candidate — not approved

The previous design treated Blood as:

- a run-only combat resource,
- inactive before Tier II,
- generated through combat,
- used only to activate the selected Aspect's Blood Art,
- reset after death or successful completion,
- and unavailable as a shop, route, Strand, or persistent currency.

Capacity, activation amount, gain rules, room carry, boss behavior, retention, and individual Blood Arts remain unresolved.

Partial activation remains deferred unless the final system retains Blood Arts and playable testing demonstrates a need.

## Working candidate identities

### Wolf — approved for roster comparison

- **Known as:** the close-range aggressive Aspect.
- **Fantasy:** predatory Returning Blood.
- **Basic sequence:** Fang Slash → Rending Cross → Blood Cleave.
- **Held attack:** Predator's Passage, committed piercing pursuit with conditional pass-through.
- **Counterattack:** Fang Reversal, advancing return to pressure after a universal parry.
- **Dash attack:** Hunting Slash, aggressive re-entry after the universal neutral dash.
- **Defense:** functional block and parry with a durable but not dominant player-posture profile.
- **Risk:** short reach, overextension, missed attacks, target fixation, and surrounding pressure.
- **Status:** qualitative Tier 0 foundation approved; final roster inclusion unapproved.

The authoritative Wolf package is [Wolf Blood Aspect](WOLF_ASPECT.md).

### Wraith — approved for roster comparison

- **Known as:** the mid-range spectral skirmisher.
- **Fantasy:** controlled spectral dissolution expressed through extended blade forms and visible attack-bound repositioning.
- **Basic sequence:** Veil Cut → Passing Arc.
- **Held attack:** Pale Lance, a long narrow punish with severe miss recovery.
- **Counterattack:** Veil Reversal, a terminal off-axis response after a universal parry.
- **Dash attack:** Ghostline Slash, a terminal positional cut after the universal neutral dash.
- **Defense:** sustained block retained but less efficient than Wolf's; lower player-posture capacity with stronger recovery after escaping pressure.
- **Risk:** point-blank pressure, constrained spaces, missed committed attacks, and dangerous finishing positions.
- **Constraint:** must remain distinct from Mist Raven and must not claim all movement, range, dash, or avoidance Techniques.
- **Status:** qualitative Tier 0 foundation approved; final roster inclusion unapproved.

The authoritative Wraith package is [Wraith Blood Aspect](WRAITH_ASPECT.md).

### Ronin — active candidate

- **Current role direction:** adaptable sword mastery, exchange control, posture management, counters, and deliberate offense.
- **Current fantasy direction:** Returning Blood reinforcing trained martial control.
- **Current constraint:** must not collapse into the parry build, feel like a generic default, or become a slower and stronger Wolf.
- **Current design requirement:** define a Ronin-specific sequence, held attack, counterattack, dash attack, defensive profile, encounter pattern, Technique space, and natural risk.
- **Status:** identity and inclusion are unapproved.

## Permanent progression boundary

Blood Mirror, Blood Cavern, Bloodwell, and unlock plans may reference the three-Aspect launch scope, but exact unlocks, mastery trials, permanent upgrades, and interface counts remain blocked by the final identities and shared system.

No persistent upgrade should make a run-only Aspect mechanic automatic or remove its intended risk.

## Design order

1. Use the approved Aspect-Technique contract and expanded shared player-kit boundary as roster constraints.
2. Treat Wolf and Wraith as approved qualitative comparison candidates.
3. Define Ronin at the same depth.
4. Audit overlap, gaps, full-system use, Technique space, encounter coverage, and production cost.
5. Revise, replace, combine, or rename candidates as needed.
6. Approve the three-row launch identity roster.
7. Approve or revise the shared progression structure.
8. Design each selected Aspect's later mechanics and Tier package.
9. Approve shared resource, activation, Shrine, and HUD rules.
10. Finalize affinity, offer weighting, and rare direct-interaction exceptions.
11. Populate Technique coverage and launch counts.
12. Reconsider a fourth or fifth Aspect only after playable testing demonstrates a missing identity.

## Approval tests

The roster is not ready unless:

- all three identities own distinct fantasies and combined combat patterns,
- no identity is merely a stronger or weaker version of another,
- no difference depends on nerfing universal neutral movement,
- no identity is reducible to one core action,
- all identities preserve meaningful attack, defense, movement, posture, deathblow, Technique, and prosthetic play,
- Tier 0 creates a noticeable run identity,
- the expanded shared player-kit boundary remains readable and teachable,
- each identity supports reinforce, broaden, compensate, and hybridize Technique builds,
- Techniques and prosthetics retain meaningful territory,
- each identity functions against groups, ranged pressure, elites, hazards, and bosses,
- and the roster can be communicated clearly through gameplay and presentation.

An individual Aspect is not ready for exact Tier or Blood Art approval until its identity passes the roster-level audit.

## Visual and weapon-production direction

The approved launch-scoping direction uses one physical katana expressed through three Aspect-specific Blood combat forms over a shared defensive, movement, execution, and enemy-response framework.

Exact attack variants, chain lengths, ranges, rhythms, effects, animation reuse, overlays, and production counts remain open until the identities are approved.

Reuse Akio's movement, input, defensive, execution, and enemy-response language where practical. Add Aspect-specific offensive animation, VFX, audio, and weapon treatment where required to create a genuinely distinct run identity.

Future fourth or fifth Aspects would require separate production approval after launch-roster testing. They are not included in current animation, VFX, UI, trial, or milestone counts.

## Related documents

- [Current Design Questions](../_meta/OPEN_QUESTIONS.md)
- [Wolf Blood Aspect](WOLF_ASPECT.md)
- [Wraith Blood Aspect](WRAITH_ASPECT.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Combat](COMBAT.md)
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Shrine interface](../ui_ux/SHRINE_INTERFACE.md)
- [Blood Mirror interface](../ui_ux/BLOOD_MIRROR_TRIALS.md)
