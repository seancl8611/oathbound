---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-23
topics:
  - techniques
  - run-builds
  - active-slots
  - reserve-slot
  - refinements
  - technique-categories
  - aspect-affinity
  - prosthetic-techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUE-CATALOG
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-ITEMS-REWARDS
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - META-OPEN-QUESTIONS
---

# Technique System

Techniques are temporary in-run upgrades that strengthen or reshape Akio's existing combat actions. They provide limited horizontal build construction around the selected Blood Aspect rather than replacing it or being replaced by it.

## System ownership

- **Blood Aspect:** selected pre-run combat foundation and immediate Tier 0 run identity; owner of any approved Aspect-specific vertical power and risk progression.
- **Techniques:** four limited, replaceable in-run modifications plus one inactive reserve.
- **Prosthetic:** equipped tactical tool with eligible temporary Techniques.
- **Relic:** separate passive rule using its own slot.

Aspect power must leave Technique choices meaningful. Technique combinations must deepen active combat without making the selected Aspect irrelevant.

## Approved Aspect-Technique division

### Aspects define the foundation

The Aspect determines the starting combat lens through which later rewards are interpreted. It may alter broad connected properties such as attack rhythm, range, coverage, commitment, recovery, movement flow, target handling, damage-versus-posture profile, and Blood-weapon expression.

An Aspect must function before the player owns any Technique.

### Techniques define the run's chosen development

A Technique modifies a specific action, condition, transition, payoff, resource interaction, or tactical option inside that foundation.

Techniques are the player's primary way to decide how this particular run develops after selecting an Aspect. A four-Technique loadout may:

1. **Reinforce** the Aspect's existing strengths.
2. **Broaden** it into adjacent combat options.
3. **Compensate** for a weakness at the cost of a slot.
4. **Hybridize** it into an unusual but coherent build.

The same Technique may create different value under different Aspects because the underlying action already has a different rhythm, reach, movement flow, commitment, or posture profile. Most synergy should emerge through these shared combat verbs rather than bespoke per-Aspect versions of every Technique.

### Compatibility guardrails

- Ordinary Techniques are usable by every Aspect.
- Ordinary Techniques do not require a minimum Aspect Tier.
- Affinity represents amplification, not permission.
- Soft affinity may later influence offer weighting, but alternate-affinity and neutral choices must remain available.
- No ordinary Technique is required to make an Aspect functional.
- No Aspect is required to make an ordinary Technique functional.
- A Technique may support an Aspect's emphasized behavior, but it cannot reproduce the Aspect's complete foundation, signature mechanic, or activatable Blood Art.
- An Aspect cannot globally make an entire Technique category the automatic correct choice.
- Every Aspect must support several distinct valid four-Technique builds.
- Direct Aspect-, Blood-, or Tier-referencing Techniques are limited explicit exceptions, not the normal catalog structure.

The responsibility contract above is approved. Exact affinity assignments, offer weights, direct exceptions, and individual Technique entries remain open.

## Starting state and capacity

Each run begins with:

- four empty active Technique slots,
- one empty inactive reserve slot.

Akio does not begin with placeholder Techniques. The base combat framework, selected Aspect, equipped prosthetic, and permanent progression provide the starting foundation.

Only active Techniques affect combat. The reserve is not a full inventory. Active slots are unrestricted by category, and initial scope does not include permanent slot-capacity increases.

## Acquiring Techniques

Technique opportunities normally present three cards.

- While an active slot is empty, the selected Technique fills it.
- After all active slots are full, a new Technique may replace an active Technique, enter the reserve, or be declined for the displayed smaller fallback reward.
- The player chooses which active Technique is replaced.

## Replacement and reserve

When a new Technique replaces an active Technique:

1. the new Technique becomes active,
2. the displaced Technique moves to reserve,
3. if reserve is occupied, its previous Technique is lost after explicit confirmation.

The reserve may be swapped with an active Technique only at Technique reward screens and rest rooms.

Reserve rules:

- inactive while stored,
- retains an existing refinement,
- cannot receive a new refinement while inactive,
- is lost if overwritten,
- and is not guaranteed to reappear after being lost or declined.

## Construction rules

Every Technique should:

1. provide immediate value on its own,
2. become stronger through compatible combat behavior,
3. remain functional without an exact combination.

Synergy should emerge through approved shared combat verbs such as attacks, parry, Counter Cut, posture, deathblow, dodge, movement, flank, pursuit, target state, prosthetic use, and Spirit.

Do not create:

- Techniques that do nothing without another exact Technique,
- exact multi-Technique dependency chains,
- deep prerequisite webs,
- or automatic effects that replace active combat execution.

## Refinements

A Technique may receive at most one refinement.

A refinement:

- does not consume another slot,
- may appear only while the base Technique is active,
- directly deepens the base effect,
- and remains attached if the Technique moves to reserve.

No refinement chain extends beyond one step.

A refinement should strengthen the reason the player selected the base Technique. It should not turn the entry into a different combat identity or unrelated reward family.

Possible refinement dimensions include:

- greater reliability,
- stronger payoff for the same skilled behavior,
- a bounded additional target or use case,
- deeper interaction with the same combat verb,
- a supporting resource interaction,
- or a risk adjustment that preserves the original decision.

The final refinement standard must still decide how transformative refinements may be, whether simple numerical improvements are acceptable, whether every launch Technique receives one, and which effects are too broad for a refinement.

## Categories

Categories organize communication and reward generation. They do not restrict slots.

- **Blade:** modifies approved katana or Blood-weapon actions.
- **Deflection:** modifies parry, block, posture, Counter Cut, or defensive mastery.
- **Execution:** modifies posture break, deathblow, or execution momentum.
- **Movement:** modifies dodge, repositioning, flanking, pursuit, or re-entry.
- **Prosthetic:** temporarily modifies the equipped tool.
- **General:** supports health, Spirit, recovery, or broad combat rules without generic stat clutter.

A Technique should normally have one primary category. Category describes the principal part of combat changed, not every trigger, tag, affinity, or synergy.

## Technique metadata model

### Primary category

Answers: **what part of combat does this Technique principally modify?**

### Combat-verb tags

Answer: **which player actions, enemy states, resources, or positional rules does this Technique directly use?**

A Technique may use several tags. Tags support communication, offer validation, build comparison, trials, analytics, and later balance work. They do not create prerequisites by themselves.

### Aspect affinity

Answers: **which Aspect naturally amplifies or is naturally amplified by this Technique?**

Affinity is soft:

- it may influence offer weighting,
- it may explain natural synergy,
- it does not make the Technique unusable elsewhere,
- and it does not replace category or tags.

A Technique may be neutral or have more than one justified affinity. The catalog should not label every broadly useful entry as universally affiliated.

### Rarity

Answers: **how unusual, transformative, complex, or restricted is this Technique within the reward ecosystem?**

Rarity should not mean only a larger number. The final rarity model must define tiers, offer timing, reward-source eligibility, readability requirements, and which effects belong to Relics or other systems instead.

## Prosthetic Techniques

Prosthetic Techniques use the normal Technique system.

- Only the equipped prosthetic contributes eligible Techniques.
- A major prosthetic modification occupies one active slot.
- Its single refinement is slotless.
- The Forge owns permanent tool development.
- The run owns temporary specialization.
- Prosthetic Techniques strengthen the tool's existing tactical role rather than replacing it with an unrelated ability.

## Detailed Blood Aspect relationship still open

The general responsibility contract is approved, but detailed interaction rules follow the identity roster and shared Aspect structure.

Still decide:

- soft offer-weighting strength,
- how much neutral and alternate-affinity representation each offer needs,
- whether any direct Aspect-, Blood-, or Tier-referencing Technique ships at launch,
- what rarity and production treatment justify such exceptions,
- whether Aspect progression may alter already-owned Techniques,
- and how the catalog prevents repetitive same-Aspect builds.

The current Wolf, Wraith, and Ronin affinities are only candidate directions and do not establish Technique eligibility.

## Reward-generation principles

Before all active slots are filled, offers should favor:

- useful new Techniques,
- selected-Aspect compatibility after weighting rules are approved,
- occasional eligible Prosthetic Techniques,
- occasional higher-rarity options.

After the loadout is full, offers should usually mix:

- a compatible replacement,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

The generator should avoid three unusable or excessively narrow choices. Limited rerolls and decline rewards may reduce extreme bad luck without guaranteeing a perfect build.

## Expected late-run state

A successful late run should commonly reach:

- the approved common Aspect progression endpoint once that structure is finalized,
- four active Techniques,
- one optional reserve Technique,
- one to three refined Techniques,
- zero or more Prosthetic Techniques within the active slots,
- one run-scoped Relic when obtained,
- and additional survival or resource growth.

Even experienced players should not be assumed to maximize the Aspect every run. The late-run fantasy should come from coherent layers reinforcing skilled play and meaningful priorities rather than one system dominating the build.

## Individual catalog ownership

Individual Technique entries, refinements, catalog status, coverage matrix, production treatment, and launch population belong in [Technique Catalog](TECHNIQUE_CATALOG.md).

Every catalog entry should state:

- stable ID and status,
- primary category,
- rarity,
- combat-verb tags,
- Aspect affinity,
- trigger and standalone effect,
- intended play pattern,
- boss, elite, and crowd behavior,
- cross-Aspect usefulness,
- Aspect-overlap check,
- refinement when present,
- UI, VFX, animation, audio, and unlock treatment.

The old stance upgrade catalog is historical implementation context only.

## Catalog approval tests

Before launch counts are approved, the Technique system and catalog must demonstrate that:

- the three-Aspect identity roster and shared structure are approved,
- each core combat action has meaningful but non-mandatory support,
- each Aspect supports reinforce, broaden, compensate, and hybridize build directions,
- early choices provide standalone value,
- late choices create replacement, reserve, and refinement decisions,
- alternate-affinity and neutral options prevent repetitive same-Aspect runs,
- no category becomes mandatory for a viable build,
- boss and mixed-encounter usefulness are documented,
- Techniques do not make Aspect growth irrelevant,
- Aspects do not make Technique choices secondary,
- and the reward generator can avoid presenting three invalid choices.

## Reset rule

Active Techniques, reserve, and refinements reset after death, successful Heart Binding completion, or story completion.

Permanent progression may unlock additional Techniques into future reward pools. It does not preserve an assembled build between runs.

## Current design package

Before approving the minimum launch catalog, resolve:

1. the final three-Aspect identity roster and combat-foundation boundary,
2. the shared Aspect progression and power-budget structure,
3. primary-category boundaries,
4. the combat-verb tag taxonomy,
5. affinity and offer-weighting rules,
6. the Technique rarity model,
7. the final refinement standard,
8. rare direct Aspect-, Blood-, or Tier-specific exception rules,
9. and the launch coverage matrix in `TECHNIQUE_CATALOG.md`.

After that groundwork, approve:

- total base Technique count,
- category and rarity distribution,
- refinement count,
- Prosthetic Technique count per tool,
- unique icon requirements,
- bespoke VFX or animation requirements,
- and unlock ownership.

Individual numerical values, exact rarity weights, reroll rates, and expected refinement frequency remain implementation and playtest work.
