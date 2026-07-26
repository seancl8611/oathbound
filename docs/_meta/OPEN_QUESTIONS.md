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
- all Aspects use the same control layout and participate in the attack, defense, movement, posture, deathblow, Technique, and prosthetic systems,
- identities are multidimensional rather than assigned to one core action,
- the weapon direction is one physical katana expressed through different Blood combat forms,
- and shared controls do not require an identical moveset.

Three is the current production baseline, not a permanent ceiling. A fourth or later Aspect should not be added during the current paper-design pass. Reconsider expansion only after playable testing demonstrates a meaningful missing combat identity that cannot be covered by the approved three or by Techniques and prosthetics.

## Resolved Aspect-Technique responsibility contract

Aspects and Techniques are both major run-build layers with different responsibilities.

- **Aspect:** the pre-run, always-present combat foundation and immediate Tier 0 identity.
- **Techniques:** four limited, replaceable in-run modifications plus one inactive reserve.
- The Aspect may broadly change chain structure, rhythm, range, coverage, commitment, recovery, attack movement, target handling, defensive profile, damage-versus-posture profile, and Blood-weapon expression.
- A Technique modifies a specific action, condition, transition, payoff, resource interaction, or tactical option within that foundation.
- An Aspect must function before any Technique is acquired.
- An ordinary Technique must function with every Aspect.
- Ordinary Techniques are not hard-locked to an Aspect or minimum Tier.
- Affinity represents amplification rather than eligibility.
- Most synergy should emerge through shared combat verbs instead of bespoke per-Aspect versions of every Technique.

A Technique loadout may intentionally reinforce an Aspect's strengths, broaden it into adjacent options, compensate for a weakness at the cost of a slot, or hybridize it into an unusual but coherent build.

Direct Aspect-, Blood-, or Tier-referencing Techniques remain possible only as limited explicit exceptions after the roster and shared structure are approved.

## Resolved expanded player-kit boundary

The original shared-moveset boundary is superseded. The approved rule is:

> Aspects share controls, neutral movement, enemy rules, and combat readability; they do not need to share one identical sword moveset.

### Universal across launch Aspects

- input layout and control scheme,
- basic attack, held attack, defense, parry-counter, dash-attack, deathblow, Technique, and prosthetic action slots,
- defense input and parry timing/success logic,
- enemy telegraphs, responses, and punish logic,
- posture, stagger, posture-break, and deathblow language,
- Spirit and prosthetic controls,
- Technique-system rules,
- ordinary locomotion speed,
- neutral dash distance and travel speed,
- neutral dash startup, invulnerability, recovery, steering, collision, and repeat availability,
- and standard access to actions after a neutral dash.

Aspect selection must not reduce dependable evasion or arena navigation through a shorter, slower, or less responsive neutral dash.

### Allowed to vary by Aspect at Tier 0

- basic attack sequence length, names, order, branches, restart behavior, and rhythm,
- reach and attack geometry,
- movement, tracking, commitment, recovery, and cancel opportunities attached to attacks,
- health-damage and posture-pressure profile,
- target handling,
- held-attack behavior,
- post-parry counterattack behavior,
- dash-attack behavior and follow-up sequence,
- offensive transitions after block, dodge, parry, deathblow, or another attack,
- player posture capacity and recovery direction,
- block efficiency and posture cost,
- and the Blood-formed expression of the katana.

`Quick Slash`, `Cross Cut`, `Heavy Cleave`, `Hold Thrust`, `Counter Cut`, and `Dash Slash` are no longer mandatory universal move names or roles. They may remain within an individual Aspect when appropriate.

All current launch candidates retain meaningful attack, block, parry, dodge, posture, deathblow, Technique, and prosthetic play. Removing sustained block entirely remains an unresolved possible exception requiring explicit roster-level approval and encounter compatibility review.

Universal Techniques retain one ruleset across all Aspects. They may feel or perform differently only because the underlying Aspect-specific action already differs.

Aspect statistics and properties are balanced as tradeoffs. No Aspect should simultaneously own the best attack speed, range, damage, safety, posture pressure, tracking, coverage, and flexibility. Neutral movement and dash are not automatic tradeoff levers.

## Resolved Wolf concept-level foundation — revised

Wolf's high-level role and qualitative Tier 0 combat foundation are approved for roster comparison under the expanded contract.

- **Known as:** the close-range aggressive Aspect.
- **Rhythm:** fast, continuous, and forward-driving.
- **Range:** shortest or near-shortest normal attack reach.
- **Damage:** moderate per hit with strong sustained output while connected.
- **Posture:** consistent enemy-posture pressure through repeated contact.
- **Movement:** strong movement within attacks and offensive transitions; universal neutral movement and dash remain unchanged.
- **Coverage:** narrow opener with broader later attacks for nearby threats.
- **Commitment:** responsive while attacks connect and more punishable after misses.
- **Encounter role:** priority-target pursuit with built-in mixed-wave, crowd, ranged, elite, hazard, and boss viability.
- **Risk:** short reach, overextension, missed attacks, target fixation, and surrounding pressure.

Wolf's approved Aspect-specific controls are:

- **Basic sequence:** Fang Slash → Rending Cross → Blood Cleave.
- **Sequence rule:** successful completion may flow back to Fang Slash; misses receive full recovery.
- **Held attack:** Predator's Passage, a committed piercing pursuit that may pass through valid ordinary enemies and stops at heavy targets or invalid destinations.
- **Dash attack:** Hunting Slash after the universal neutral dash, entering the sequence at Rending Cross.
- **Parry counter:** Fang Reversal after a universal parry, entering the sequence at Rending Cross.
- **Defense:** functional sustained block, universal parry timing, moderate-to-high player posture capacity, and no automatic attack-based posture recovery at Tier 0.

Wolf's authoritative package is owned by `gameplay/WOLF_ASPECT.md`.

Still unresolved for Wolf are exact values, hitboxes, chain windows, passage eligibility, player-posture values, exact animation and Blood-katana treatment, any later unique mechanic, Tier progression, drawback, Corruption behavior, Blood Art, production counts, and final roster inclusion after the three-candidate audit.

## 1. Three-Aspect identity roster and Technique compatibility

Wolf, Wraith, and Ronin remain the three working candidates for the three roster positions.

Wolf's revised concept-level Tier 0 combat foundation is complete for the current comparison pass. Wraith is the next active candidate. Ronin follows Wraith.

### Pass 1 — Candidate identity definitions

For Wraith and then Ronin, define:

- the clear player-facing playstyle label and fantasy,
- the Aspect-specific basic attack sequence and why its length or structure teaches the identity,
- the held attack,
- the post-parry counterattack,
- the dash attack following the universal neutral dash,
- relative range, rhythm, damage, enemy-posture pressure, player-posture profile, movement, coverage, tracking, commitment, and recovery,
- how block, parry, and the universal neutral dash support the playstyle,
- how the candidate remains fun and viable in mixed waves, crowds, ranged pressure, elites, hazards, and bosses,
- how universal Techniques can reinforce, broaden, compensate, and hybridize it,
- its natural risk,
- and how it remains one version of Akio rather than a separate character.

This pass does not lock exact numbers, frame data, hitboxes, production counts, Tiers, Blood Arts, or individual Techniques.

Wraith must remain distinct from Wolf and from Mist Raven. It must not become only the dash Aspect, teleport Aspect, or invulnerability Aspect.

### Pass 2 — Roster overlap and gap audit

After Wraith and Ronin are defined, compare all three candidates together:

- identify mechanical or thematic overlap,
- identify any missing launch-critical combat territory,
- confirm that each candidate remains useful with the complete combat framework,
- confirm several distinct four-Technique build shapes per candidate,
- confirm that Techniques and prosthetics retain meaningful build space,
- confirm that neutral movement and dash remain universal,
- confirm that enemy and boss rules do not need separate compatibility layers,
- and determine whether the candidates are sufficiently distinct for repeated runs.

A detected gap should first be addressed by revising or replacing one of the three candidates. It does not automatically justify a fourth Aspect.

### Pass 3 — Roster revision

Retain, revise, rename, combine, or replace candidates as required by the audit.

### Pass 4 — Identity approval

Approve:

- a concise three-row roster table,
- the candidate-specific moveset and defensive profile,
- the expected Technique build directions for each identity,
- and the production distinction required for each identity.

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
- how every package continues to support the complete combat framework,
- cross-Aspect distinction and overlap,
- relative attack, player-posture, enemy-posture, range, recovery, block-efficiency, and coverage tradeoffs,
- detailed affinity and offer-weighting rules,
- whether any direct Aspect-, Blood-, or Tier-referencing Technique exceptions ship,
- and required input, HUD, animation, VFX, audio, trial, and progression states.

Exact damage, posture, attack speed, range, gain-rate, threshold, and duration values remain playtest work. Neutral locomotion and dash remain universal unless a later exceptional system change receives explicit approval.

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
- exact Aspect attack damage, posture, range, tracking, recovery, block efficiency, and coverage values,
- exact neutral movement and dash values while preserving their universal contract,
- whether any future Aspect removes sustained block,
- partial activation before approved system direction and playtest evidence,
- Spirit costs and prosthetic cooldowns,
- hitboxes, immunity tables, and status values,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- final animation frames and VFX timing.