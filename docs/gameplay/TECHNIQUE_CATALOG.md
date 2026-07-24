---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-07-23
topics:
  - techniques
  - technique-catalog
  - refinements
  - combat-verbs
  - aspect-affinity
  - run-builds
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - META-OPEN-QUESTIONS
---

# Technique Catalog

## Purpose and ownership

This file owns individual Technique entries, catalog coverage, entry status, refinements, and production treatment.

[Technique System](TECHNIQUES.md) owns shared rules such as slots, reserve behavior, categories, affinity, rarity, refinements, eligibility, and the approved Aspect-Technique responsibility contract. [Blood Aspect System](BLOOD_ASPECTS.md) owns Aspect identity, foundation, progression, and power budget. This file must not redefine either system.

The removed Storm, Frost, Ember, Hex, and Shadow stance catalog is historical implementation context only.

## Current status

No individual launch Technique, refinement, category count, rarity distribution, or final catalog total is approved.

The general layer contract is approved:

- Aspects define the pre-run combat foundation.
- Techniques are four limited, replaceable in-run modifications plus one reserve.
- Ordinary Techniques are usable by every Aspect.
- Affinity represents amplification rather than eligibility.
- Technique builds may reinforce, broaden, compensate, or hybridize an Aspect.
- Most synergy should emerge through shared combat verbs rather than bespoke per-Aspect versions.

Before catalog population begins, approve:

1. the final three-Aspect identity roster and combat-foundation boundary,
2. the shared Aspect progression and power budget,
3. Technique category, combat-verb tag, affinity, and rarity models,
4. the refinement design standard,
5. affinity and offer-weighting rules,
6. rare direct Aspect-, Blood-, or Tier-referencing exception rules,
7. and the launch coverage matrix.

Catalog counts follow those passes rather than preceding them.

## Catalog design sequence

1. Approve the three-Aspect roster and shared Aspect structure.
2. Finalize Technique metadata, affinity, refinement, and exception rules.
3. Build the coverage matrix around combat territory not already owned by the Aspect foundation.
4. Draft individual Technique concepts.
5. Test every entry for standalone value and cross-Aspect usefulness.
6. Verify reinforce, broaden, compensate, and hybridize build coverage for every Aspect.
7. Identify rarity, UI, VFX, animation, audio, and unlock treatment.
8. Approve launch counts and production tiers.

## Launch coverage matrix

Populate this matrix before approving the final catalog size. One Technique may cover several compatible rows, and one row may be supported by several Techniques.

| Coverage family | Required question | Status |
|---|---|---|
| Attack opening and chains | What choices alter opening pressure, chain behavior, or commitment without becoming generic attack speed? | Open |
| Range and crowd coverage | What choices affect reach, arcs, nearby targets, or line control across all Aspects? | Open |
| Heavy commitment | What choices reward earned openings, posture pressure, or risk-managed commitment? | Open |
| Spacing and precision | What choices deepen narrow punishment, spacing, or anti-commitment play? | Open |
| Defense-to-offense | What choices connect parry, block, dodge, or recovery into offense without belonging to one Aspect? | Open |
| Movement and re-entry | What choices deepen repositioning, pursuit, flanking, or movement-to-attack transitions? | Open |
| Posture and execution | What choices alter posture pressure, break payoff, deathblow momentum, or target transition? | Open |
| Prosthetic development | What temporary choices deepen each equipped tool's existing tactical purpose? | Open |
| Reinforce builds | Does every Aspect have several Techniques that naturally deepen its strengths? | Open |
| Broaden builds | Can every Aspect develop adjacent combat options without losing its identity? | Open |
| Compensate builds | Can a player spend slots to cover an Aspect weakness without erasing the tradeoff entirely? | Open |
| Hybrid builds | Can each Aspect support surprising cross-category combinations that remain coherent? | Open |
| Alternate affinity | Are neutral and alternate-affinity choices useful rather than misleading or dead? | Open |
| Health, Spirit, and recovery | What limited General Techniques support survival or resources without generic stat clutter? | Open |
| Boss viability | Which entries remain useful against single targets, elites, and bosses? | Open |
| Mixed encounters | Which entries address groups, ranged pressure, hazards, or target prioritization? | Open |
| Early-run value | Which entries provide immediate value without another exact Technique? | Open |
| Late-run decisions | Which entries create meaningful replacement, reserve, refinement, or specialization choices? | Open |

## Technique entry schema

### Identity

- **Stable ID:** `TECH-###`
- **Name:** player-facing Technique name
- **Status:** concept, approved, deferred, cut, or implemented
- **Primary category:** one approved category
- **Rarity:** approved rarity tier
- **Combat-verb tags:** all directly affected verbs
- **Aspect affinity:** one or more justified soft affinities, or neutral
- **Build direction:** reinforce, broaden, compensate, hybridize, or a justified combination
- **Prosthetic requirement:** none unless this is a Prosthetic Technique

### Gameplay definition

- **Trigger or condition:** player action, enemy state, resource state, or positional condition
- **Base effect:** complete standalone behavior without numerical tuning
- **Intended decision:** why the player selects it over another valid option
- **Intended pattern:** what skilled behavior it encourages
- **Failure and reset behavior:** what breaks, expires, or resets it
- **Boss and elite behavior:** restrictions and reliability
- **Crowd behavior:** multiple-enemy behavior
- **Cross-Aspect usefulness:** why it remains valid outside its strongest affinity
- **Aspect overlap check:** why it modifies rather than duplicates the Aspect foundation
- **Invalid combinations or safeguards:** only where required

### Refinement

- **Refinement name**
- **Refinement effect**
- **Why it preserves the base Technique's identity**

Use `None at launch` when an approved Technique intentionally ships without a refinement.

### Production and progression

- **UI treatment**
- **VFX treatment:** reused, extended, or bespoke
- **Animation treatment:** existing library or explicit scope increase
- **Audio requirement**
- **Unlock ownership**
- **Dependencies**

## Quality checks

An individual Technique is not ready unless:

- it provides value without another exact Technique,
- its effect is understandable before selection,
- it deepens active combat rather than replacing execution,
- its category, tags, affinity, rarity, and build direction describe different properties,
- it remains useful in common and major encounter contexts,
- it does not become invalid under another Aspect,
- it modifies rather than reproduces an Aspect foundation or activatable ability,
- its refinement preserves the original reason for selection,
- and its production treatment is explicit enough to estimate.

## Catalog-level checks

Approve the launch catalog only when:

- the Aspect roster and shared structure are approved,
- every core combat action has meaningful but non-mandatory support,
- each Aspect supports several reinforce, broaden, compensate, and hybridize build shapes,
- neutral and alternate-affinity choices prevent repetitive same-Aspect runs,
- early offers provide standalone value,
- late offers create replacement, reserve, and refinement decisions,
- the pool avoids exact prerequisite chains,
- the reward generator can avoid three invalid choices,
- Techniques do not make Aspect progression irrelevant,
- Aspects do not make Technique selection secondary,
- and unique production requirements are counted.

## Deferred values

The catalog may define behavior without locking:

- damage and posture values,
- durations and cooldowns,
- exact thresholds,
- offer weights and rarity probabilities,
- reroll formulas,
- final unlock costs,
- or frame-level implementation values.

Those remain implementation and playtest work.
