---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-26
---

# Current Design Questions

This file contains unresolved decisions that materially change release scope, production workload, interfaces, or authored presentation. Exact numerical tuning remains in implementation and playtesting.

## Priority order

1. Three-Aspect identity roster and Technique compatibility
2. Shared Aspect structure and selected Aspect packages
3. Launch run-build content catalog
4. Persistent progression, onboarding, and trial package
5. Narrative delivery and authored-content package
6. Postgame release package

## Resolved Blood Aspect foundation

The current launch-scoping direction is approved at this depth:

- the player selects one Blood Aspect as a major run foundation,
- the selected Aspect changes the run identity immediately at Tier 0,
- the launch scope currently assumes three Aspects,
- all Aspects use the complete attack, defense, movement, posture, deathblow, Technique, and prosthetic framework,
- identities are multidimensional rather than assigned to one core action,
- and the weapon direction is one physical katana expressed through different Blood combat forms over a shared defensive and execution framework.

Three is the current production baseline, not a permanent ceiling. A fourth or later Aspect should not be added during the current paper-design pass. Reconsider expansion only after playable testing demonstrates a meaningful missing combat identity that cannot be covered by the approved three or by Techniques and prosthetics.

## Resolved Aspect-Technique responsibility contract

Aspects and Techniques are both major run-build layers with different responsibilities.

- **Aspect:** the pre-run, always-present combat foundation and immediate Tier 0 identity.
- **Techniques:** four limited, replaceable in-run modifications plus one inactive reserve.
- The Aspect may broadly change rhythm, range, coverage, commitment, recovery, movement flow, target handling, damage-versus-posture profile, and Blood-weapon expression.
- A Technique modifies a specific action, condition, transition, payoff, resource interaction, or tactical option within that foundation.
- An Aspect must function before any Technique is acquired.
- An ordinary Technique must function with every Aspect.
- Ordinary Techniques are not hard-locked to an Aspect or minimum Tier.
- Affinity represents amplification rather than eligibility.
- Most synergy should emerge through shared combat verbs instead of bespoke per-Aspect versions of every Technique.

A Technique loadout may intentionally reinforce an Aspect's strengths, broaden it into adjacent options, compensate for a weakness at the cost of a slot, or hybridize it into an unusual but coherent build.

Direct Aspect-, Blood-, or Tier-referencing Techniques remain possible only as limited explicit exceptions after the roster and shared structure are approved.

## Resolved shared player-kit boundary

The shared-versus-Aspect-specific combat boundary is approved.

### Universal across all Aspects

- inputs and control scheme,
- block, parry, and base dodge rules,
- posture, stagger, posture-break, and deathblow rules,
- Spirit and prosthetic controls,
- Technique-system rules,
- enemy telegraphs, responses, and punish logic,
- and the existence and general purpose of Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, and Dash Slash.

Every Aspect retains the complete combat kit. No major action may be removed or made functionally irrelevant.

### Allowed to vary by Aspect at Tier 0

- attack-chain structure and rhythm,
- reach and arc coverage,
- forward movement, tracking, commitment, and recovery,
- movement-to-attack flow,
- health-damage and posture-pressure profile,
- target handling,
- offensive transitions after dodge, parry, block, or deathblow,
- and the Blood-formed expression of the katana.

These differences must combine into a recognizable offensive foundation rather than one passive bonus or one altered input.

Universal Techniques retain one ruleset across all Aspects. They may feel or perform differently only because the underlying Aspect-specific player action already differs.

Aspect statistics and properties are balanced as tradeoffs. No Aspect should simultaneously own the best speed, range, damage, safety, posture pressure, coverage, and flexibility. Exact values remain playtest work.

## Resolved Wolf concept-level foundation

Wolf's high-level role and qualitative Tier 0 attack foundation are approved for roster comparison.

- **Known as:** the close-range aggressive Aspect.
- **Rhythm:** fast, continuous, and forward-driving.
- **Range:** shortest or near-shortest normal attack reach.
- **Damage:** moderate per hit with strong sustained output while connected.
- **Posture:** consistent pressure through repeated contact.
- **Movement:** strong forward movement and nearby target correction.
- **Coverage:** narrow opener, broader follow-up and finisher.
- **Commitment:** responsive while attacks connect and more punishable after misses.
- **Encounter role:** priority-target pursuit with built-in mixed-wave, crowd, elite, and boss viability.
- **Risk:** short reach, overextension, missed attacks, target fixation, and surrounding pressure.

Wolf retains one universal defensive framework and one universal Technique catalog. Its approved attack expressions are owned by `gameplay/WOLF_ASPECT.md`.

Still unresolved for Wolf are exact values, exact animation and Blood-katana treatment, any later unique mechanic, Tier progression, drawback, Corruption behavior, Blood Art, production counts, and final roster inclusion after the three-candidate audit.

## 1. Three-Aspect identity roster and Technique compatibility

Wolf, Wraith, and Ronin remain the three working candidates for the three roster positions.

Wolf's concept-level identity and Tier 0 attack foundation are complete for the current pass. Wraith is the next active candidate. Ronin follows Wraith.

### Pass 1 — Candidate identity definitions

For Wraith and then Ronin, define:

- the clear player-facing playstyle label,
- relative range, rhythm, damage, posture, movement, coverage, tracking, commitment, and recovery,
- the qualitative Tier 0 attack foundation,
- how the candidate uses the shared core actions,
- how it remains fun and viable in mixed waves, crowds, elites, ranged pressure, hazards, and bosses,
- how universal Techniques can reinforce, broaden, compensate, and hybridize it,
- and its natural risk.

This pass does not lock exact numbers, frame data, production counts, Tiers, Blood Arts, or individual Techniques.

### Pass 2 — Roster overlap and gap audit

After Wraith and Ronin are defined, compare all three candidates together:

- identify mechanical or thematic overlap,
- identify any missing launch-critical combat territory,
- confirm that each candidate remains useful with the full combat kit,
- confirm several distinct four-Technique build shapes per candidate,
- confirm that Techniques and prosthetics retain meaningful build space,
- confirm the approved shared player-kit boundary remains intact,
- and determine whether the candidates are sufficiently distinct for repeated runs.

A detected gap should first be addressed by revising or replacing one of the three candidates. It does not automatically justify a fourth Aspect.

### Pass 3 — Roster revision

Retain, revise, rename, combine, or replace candidates as required by the audit.

### Pass 4 — Identity approval

Approve:

- a concise three-row roster table,
- the candidate-specific use of the approved shared player-kit boundary,
- and the expected Technique build directions for each identity.

Only after this pass should exact Tiers, Blood generation, Blood Arts, later candidate mechanics, detailed affinities, or candidate-specific production packages be treated as final.

## 2. Shared Aspect structure and selected Aspect packages

Only after the three identities are approved, decide the shared gameplay structure.

The current Tier 0-IV, Corruption, Embrace, Blood, Blood Art, and drawback-family model remains a working proposal. It may be preserved, revised, simplified, or replaced during this pass.

Decide:

- whether the Tier 0-IV structure remains appropriate,
- whether every selected Aspect uses the same Tier contract,
- whether Blood remains a Tier II run-only activation resource,
- whether every Aspect has one Blood Art,
- whether one evolving drawback family remains the correct risk model,
- how Resist, Embrace, and maximum-Tier Shrine behavior relate to the final system,
- Blood generation and activation behavior if Blood remains,
- the exact package for each approved Aspect,
- how every package continues to support the full combat kit,
- cross-Aspect distinction and overlap,
- relative attack, range, posture, speed, recovery, and coverage tradeoffs,
- detailed affinity and offer-weighting rules,
- whether any direct Aspect-, Blood-, or Tier-referencing Technique exceptions ship,
- and required input, HUD, animation, VFX, audio, trial, and progression states.

Exact damage, posture, speed, range, gain-rate, threshold, and duration values remain playtest work. The behavioral and relative tradeoff direction must be approved before production counts are locked.

Partial Blood Art activation is not part of the current working baseline. Reconsider it only if Blood Arts remain in the approved system and playable testing demonstrates a need.

This package must be completed before individual Technique coverage and launch counts are approved.

## 3. Launch run-build content catalog

What minimum catalog must exist at launch for a complete and replayable run-build system?

Decide:

- approximate base Technique count and broad combat-role distribution,
- how many Techniques support one refinement,
- how many entries may directly reference the approved Aspect system,
- temporary Prosthetic Technique count per equipped tool,
- initial Relic count and approximate rarity distribution,
- whether consumables are included at launch,
- and which entries require unique icons, VFX, animation, or audio.

Before approving counts, complete:

1. the approved three-Aspect identity roster,
2. the approved shared Aspect structure and individual packages,
3. detailed affinity, weighting, and direct-exception rules,
4. a cross-system overlap audit,
5. Technique category, tag, and rarity rules,
6. the refinement standard,
7. and the launch coverage matrix in `gameplay/TECHNIQUE_CATALOG.md`.

## 4. Persistent progression, onboarding, and trial package

What minimum persistent-progression and training package ships through the Bloodwell, Forge, Blood Mirror, and Blood Cavern?

Decide:

- available launch services,
- approximate permanent node, rank, or branch counts,
- required basic-combat and system trials,
- approved Aspect-system teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- and required interface states.

Exact costs and percentages remain balance work. Any persistent Aspect content depends on the final approved Aspect system.

## 5. Narrative delivery and authored-content package

What minimum authored package communicates the approved story clearly?

Decide:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression,
- Shogun reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

## 6. Postgame release package

What minimum postgame package ships after the canonical Heart victory?

Decide:

- continuation from the Shogun to the Heart,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless promoted later.

## Deferred gameplay and implementation decisions

- fourth or later Blood Aspects before playable roster testing demonstrates a missing identity,
- individual Technique concepts and final catalog counts before the Aspect roster and shared structure are approved,
- exact affinity weights and reward probabilities,
- exact room counts and route topology,
- miniboss placement,
- exact enemy and boss movesets,
- exact Corruption gain, Shrine frequency, and Tier thresholds,
- exact Blood gain, capacity, activation, duration, retention, and anti-farming values if Blood remains,
- exact Aspect damage, posture, speed, range, recovery, and coverage values,
- partial activation before approved system direction and playtest evidence,
- Spirit costs and prosthetic cooldowns,
- hitboxes, immunity tables, and status values,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- final animation frames and VFX timing.
