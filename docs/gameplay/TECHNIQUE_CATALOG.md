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

This file owns the individual Technique catalog, catalog coverage, entry status, and refinement attached to each approved Technique.

[Technique System](TECHNIQUES.md) remains authoritative for shared rules such as slots, reserve behavior, categories, affinity, rarity, refinements, and offer eligibility. [Blood Aspect System](BLOOD_ASPECTS.md) remains authoritative for Aspect mechanics, gameplay form, power budget, and Tier behavior. This file must not redefine those systems.

The removed Storm, Frost, Ember, Hex, and Shadow stance catalog is historical implementation context only. It does not constrain the identities, effects, triggers, categories, or affinities of the new Technique catalog.

## Current status

No individual launch Technique, refinement, category count, rarity distribution, or final catalog total is approved yet.

Before catalog population begins, approve:

1. what equipping a Blood Aspect actually gives the player,
2. whether Aspects use passive modifiers, signature mechanics, contextual actions, activatable abilities, Technique interactions, or a bounded hybrid,
3. the shared Aspect power budget relative to Techniques and other run systems,
4. the shared Tier contract using the approved Tier II–III common / Tier IV occasional target,
5. the complete Tier 0–IV mechanical direction for Wolf, Wraith, and Ronin,
6. the Technique category, combat-verb tag, affinity, and rarity model,
7. the refinement design standard,
8. the Aspect–Tier–Technique interaction rules,
9. and the launch coverage matrix.

Catalog counts should follow the Aspect-system and coverage passes rather than precede them.

## Catalog design sequence

1. Define the Blood Aspect gameplay model, player-facing functionality, and power budget in `BLOOD_ASPECTS.md`.
2. Decide whether an activatable Aspect ability and direct Technique interaction exist.
3. Define the shared Tier contract and each Aspect's exact Tier direction.
4. Finalize Technique metadata and refinement rules in `TECHNIQUES.md`.
5. Build the coverage matrix below around combat territory not already owned by the Aspect system.
6. Draft individual Technique concepts.
7. Test every entry for standalone value and cross-Aspect usefulness.
8. Identify refinement, rarity, UI, VFX, animation, audio, and unlock treatment.
9. Approve launch counts and production tiers.

## Launch coverage matrix

Populate this matrix before approving the final catalog size. A row may be supported by several Techniques, and one Technique may cover several compatible rows. Coverage does not require one Technique per row.

The matrix must be revisited after the Blood Aspect gameplay model is approved. Techniques should complement Aspect functionality rather than duplicate signature abilities or make Aspect progression irrelevant.

| Coverage family | Required questions | Current status |
|---|---|---|
| Quick Slash and combo opening | What distinct run-build choices can deepen safe opening pressure without becoming generic attack speed? | Open |
| Cross Cut and crowd coverage | What choices support nearby or off-line target control while preserving readable sword combat? | Open |
| Heavy Cleave and commitment | What choices reward earned openings, posture pressure, or risk-managed commitment? | Open |
| Hold Thrust and spacing | What choices deepen narrow single-target punishment, spacing, or anti-commitment play? | Open |
| Counter Cut | What choices support parry-to-counter play without belonging only to Ronin? | Open |
| Dash Slash and re-entry | What choices deepen movement-to-offense transitions across Wraith, Wolf, and neutral builds? | Open |
| Block and parry | What choices reward defense, timing, posture control, or recovery without trivializing enemy response rules? | Open |
| Posture break and deathblow | What choices alter execution payoff, momentum, or target transition without automating combat? | Open |
| Wolf compatibility | After Wolf is fully defined, what Technique space remains for pursuit, Prey pressure, wounded targets, isolation, and execution momentum? | Open |
| Wraith compatibility | After Wraith is fully defined, what Technique space remains for clean avoidance, repositioning, flanking, re-entry, and punish timing? | Open |
| Ronin compatibility | After Ronin is fully defined, what Technique space remains for disciplined parry, Counter Cut, posture control, deathblow, and Focus? | Open |
| Cross-Aspect alternatives | Can every Aspect build outside its strongest affinity without receiving dead or misleading choices? | Open |
| Health, Spirit, and recovery | What limited General Techniques support survival or resources without becoming generic stat clutter? | Open |
| Boss viability | Which entries remain useful against single targets, immunity-bearing elites, and bosses? | Open |
| Mixed-encounter viability | Which entries help with groups, ranged pressure, hazards, or target prioritization? | Open |
| Early-run value | Which entries are immediately useful when the player owns no other Techniques? | Open |
| Late-run decisions | Which entries create meaningful replacement, reserve, refinement, or specialization decisions after all slots are full? | Open |

## Technique entry schema

Every drafted Technique should use the following fields.

### Identity

- **Stable ID:** `TECH-###`
- **Name:** player-facing Technique name
- **Status:** concept, approved, deferred, cut, or implemented
- **Primary category:** one approved Technique category
- **Rarity:** approved Technique rarity tier
- **Combat-verb tags:** all directly affected approved verbs
- **Aspect affinity:** Wolf, Wraith, Ronin, neutral, or a justified combination
- **Prosthetic requirement:** none unless the entry is a Prosthetic Technique

### Gameplay definition

- **Trigger or condition:** what player action, enemy state, or resource condition activates the Technique
- **Base effect:** the complete standalone behavior without numerical tuning
- **Intended decision:** why a player selects it over another valid option
- **Intended play pattern:** what skilled behavior it encourages
- **Failure and reset behavior:** what breaks, expires, or resets the effect
- **Boss and elite behavior:** immunity, single-target, and encounter restrictions
- **Crowd behavior:** how the entry behaves with multiple enemies
- **Cross-Aspect usefulness:** why it remains valid outside its strongest affinity
- **Aspect overlap check:** why it complements rather than duplicates the selected Aspect's signature functionality
- **Invalid combinations or safeguards:** only when required to preserve combat rules

### Refinement

- **Refinement name:** player-facing name
- **Refinement effect:** one direct deepening of the base Technique
- **Why it preserves identity:** how it strengthens the original choice rather than replacing it

Use `None at launch` when an approved Technique intentionally ships without a refinement.

### Production and progression

- **UI treatment:** icon, tags, comparisons, counters, or HUD state
- **VFX treatment:** reused, lightly extended, or bespoke
- **Animation treatment:** existing animation library or explicit scope increase
- **Audio requirement:** reused cue, layered cue, or bespoke
- **Unlock ownership:** starting pool, Blood Cavern, Blood Mirror, campaign milestone, or another approved source
- **Dependencies:** mechanics or data required before implementation

## Quality checks

An individual Technique is not ready for approval unless:

- it provides value without another exact Technique,
- its effect can be understood before selection,
- it deepens approved combat rather than replacing sword execution,
- its category, tags, affinity, and rarity describe different properties,
- it remains useful in at least one common enemy encounter and one major encounter context,
- it does not become invalid merely because the player selected a different Aspect,
- it complements rather than reproduces an Aspect's signature mechanic or active ability,
- its refinement, when present, strengthens the original reason for selection,
- it states any boss, elite, crowd, or immunity behavior that affects reliability,
- and its production treatment is explicit enough to estimate after the catalog is approved.

## Catalog-level checks

The launch catalog should be approved only when:

- the Blood Aspect system's functionality and power budget are already approved,
- every core sword action has meaningful but non-mandatory support,
- each Aspect supports several distinct valid four-Technique build shapes,
- neutral and alternate-affinity choices prevent repetitive same-Aspect runs,
- early offers can produce immediate value,
- late offers can produce replacement, reserve, and refinement decisions,
- the pool does not rely on exact prerequisite chains,
- the reward generator can avoid three invalid choices,
- Techniques do not make Aspect Tier pursuit irrelevant,
- Aspects do not make Technique selection secondary,
- and unique icon, VFX, animation, audio, and unlock requirements are counted.

## Deferred values

The catalog may define behavior without locking:

- damage and posture numbers,
- durations and cooldowns,
- exact thresholds,
- offer weights and rarity probabilities,
- reroll formulas,
- final unlock costs,
- or frame-level implementation values.

Those remain implementation and playtest work in the appropriate owning files or data.
