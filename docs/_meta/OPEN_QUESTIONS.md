---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-23
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

A Technique loadout may intentionally:

1. reinforce an Aspect's strengths,
2. broaden it into adjacent options,
3. compensate for a weakness at the cost of a slot,
4. or hybridize it into an unusual but coherent build.

Direct Aspect-, Blood-, or Tier-referencing Techniques remain possible only as limited explicit exceptions after the roster and shared structure are approved.

## 1. Three-Aspect identity roster and Technique compatibility

Wolf, Wraith, and Ronin are the current working candidates for the three available roster positions. Their inclusion, names, fantasies, combat patterns, risks, and exact foundation changes remain unapproved.

The roster decision is a sequence of focused passes rather than one oversized question.

### Pass 1 — Roster coverage

Define what the complete three-Aspect roster must cover across:

- player fantasy,
- attack rhythm, reach, coverage, commitment, recovery, and movement flow,
- health-damage and posture-pressure profiles,
- target handling and encounter approach,
- natural risk-and-reward patterns,
- full-kit use,
- visual distinction,
- production cost,
- and Technique build space.

For Technique compatibility, each identity must support multiple valid ways to:

- reinforce its strengths,
- broaden its options,
- compensate for a weakness,
- and hybridize its foundation.

This pass defines comparison criteria. It does not invent exact mechanics or Technique entries.

### Pass 2 — Candidate identity definitions

Evaluate Wolf, Wraith, and Ronin one at a time. For each candidate, define:

- the controlled Returning Blood fantasy,
- the combined combat pattern created at Tier 0,
- the offensive-foundation changes that make it immediately recognizable,
- how it uses attacks, defense, movement, posture, deathblows, Techniques, and prosthetics,
- the situations and combinations it emphasizes without monopolizing one action,
- how Techniques can reinforce, broaden, compensate, and hybridize it,
- its natural risk,
- and its group, elite, and boss viability.

This pass includes how each candidate expresses the multidimensional foundation and interacts with the general Technique concept. Those are not separate later questions.

### Pass 3 — Roster overlap and gap audit

Compare the three candidates together:

- identify mechanical or thematic overlap,
- identify any missing launch-critical combat territory,
- confirm that each candidate remains useful with the full combat kit,
- confirm several distinct four-Technique build shapes per candidate,
- confirm that Techniques and prosthetics retain meaningful build space,
- and determine whether the candidates are sufficiently distinct for repeated runs.

A detected gap should first be addressed by revising or replacing one of the three candidates. It does not automatically justify a fourth Aspect.

### Pass 4 — Roster revision

Retain, revise, rename, combine, or replace candidates as required by the audit.

### Pass 5 — Identity approval

Approve:

- a concise three-row roster table,
- the shared-versus-Aspect-specific combat-foundation boundary,
- and the expected Technique build directions for each identity.

Only after this pass should exact Tiers, Blood generation, Blood Arts, candidate mechanics, detailed affinities, or candidate-specific production packages be treated as final.

## 2. Shared Aspect structure and selected Aspect packages

Only after the three identities and combat-foundation boundary are approved, decide the shared gameplay structure.

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

1. the approved three-Aspect identity roster and combat-foundation boundary,
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
