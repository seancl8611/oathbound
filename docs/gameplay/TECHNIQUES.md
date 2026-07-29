---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-28
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

- **Blood Aspect:** selected pre-run weapon foundation, immediate Tier 0 identity, fixed vertical Tier progression, and Tier II Blood Art.
- **Techniques:** four limited replaceable in-run modifications plus one inactive reserve.
- **Prosthetic:** equipped tactical tool with eligible temporary Techniques.
- **Relic:** separate passive rule using its own slot.

Aspect power must leave Technique choices meaningful. Technique combinations must deepen active combat without making Wolf, Wraith, or Ronin irrelevant.

## Aspect-Technique division

### Aspects define the foundation

The selected Aspect determines attack sequence, rhythm, reach, coverage, commitment, recovery, player-directed attack movement, target handling through arcs and collision, damage and posture profile, defensive direction, fixed Tier benefits, and Blood-weapon expression.

Aspects do not use corrective tracking, hidden homing, or post-input target correction.

An Aspect must function before the player acquires any Technique.

### Techniques define chosen run development

A Technique modifies a specific action, condition, transition, payoff, resource interaction, or tactical option inside that foundation.

A four-Technique loadout may:

1. **Reinforce** the selected Aspect's strengths.
2. **Broaden** it into adjacent combat options.
3. **Compensate** for a weakness at the cost of a slot without erasing the tradeoff.
4. **Hybridize** it into an unusual but coherent build.

The same Technique may create different value under Wolf, Wraith, and Ronin because the underlying actions already differ. Most synergy should emerge through shared combat verbs rather than bespoke versions of every entry.

## Compatibility guardrails

- Ordinary Techniques are usable by every Aspect.
- Ordinary Techniques do not require a minimum Aspect Tier.
- Affinity represents amplification or weighting, not permission.
- Neutral and alternate-affinity choices remain valid.
- No Technique is required to make an Aspect functional.
- No Aspect is required to make an ordinary Technique functional.
- A Technique cannot reproduce an Aspect's complete weapon foundation or Blood Art.
- A Technique must not duplicate a fixed Tier behavior unless approved as a limited direct exception.
- No Aspect makes an entire Technique category automatically correct.
- Every Aspect supports several valid four-Technique builds.
- Direct Aspect-, Tier-, or Blood-referencing Techniques are limited explicit exceptions.
- Fixed Aspect Tier progression must not make Techniques secondary.

The responsibility contract is approved. Exact affinity assignments, offer weighting, direct exceptions, and catalog entries remain open.

Wolf's fixed package currently owns these behaviors and ordinary Techniques should not reproduce them directly:

- Blood Tempo's earlier next-Basic input after valid contact,
- Dire Hunt's guaranteed activation recovery and transformation,
- Blood Fang,
- Fanged Guard's one-hit frontal block while charging the Held Attack,
- Apex Feast's deathblow eruption and fully charged next Held Attack.

## Starting capacity

Each run begins with:

- four empty active Technique slots,
- one empty inactive reserve slot.

Only active Techniques affect combat. The reserve is not a full inventory. Active slots are unrestricted by category, and initial scope does not include permanent slot-capacity increases.

## Acquiring Techniques

Technique opportunities normally present three cards.

- While an active slot is empty, the selected Technique fills it.
- After all active slots are full, a new Technique may replace an active Technique, enter the reserve, or be declined for a displayed smaller fallback reward.
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
- is not guaranteed to reappear after loss or decline.

## Construction rules

Every Technique should:

1. provide immediate standalone value,
2. become stronger through compatible skilled behavior,
3. remain functional without an exact combination.

Synergy should use approved shared verbs such as Basic Attack, Held Attack, Dash Attack, Parry Counter, block, parry, posture, deathblow, dodge, movement, pursuit, spacing, positional conditions, prosthetic use, Health, and Spirit.

Do not create:

- entries that do nothing without another exact Technique,
- exact multi-Technique dependency chains,
- deep prerequisite webs,
- generic delayed bursts that duplicate no clear combat role,
- or automatic effects that replace active execution.

## Refinements

A Technique may receive at most one refinement.

A refinement:

- does not consume another slot,
- may appear only while the base Technique is active,
- directly deepens the base effect,
- remains attached if the Technique moves to reserve,
- does not extend into a second refinement.

A refinement should preserve the original reason for selecting the Technique. It may improve reliability, payoff, bounded coverage, interaction with the same combat verb, supporting resource behavior, or risk without becoming an unrelated ability.

The launch catalog must still define how transformative refinements may be, whether simple numerical improvements are acceptable, and which approved Techniques ship without one.

## Categories

Categories organize communication and reward generation. They do not restrict slots.

- **Blade:** modifies katana or Blood-weapon actions.
- **Deflection:** modifies parry, block, player posture, or Parry Counter.
- **Execution:** modifies posture break, deathblow, or execution payoff.
- **Movement:** modifies dodge, repositioning, spacing, pursuit, or re-entry.
- **Prosthetic:** temporarily modifies the equipped tool.
- **General:** supports Health, Spirit, recovery, or broad combat rules without generic stat clutter.

A Technique normally has one primary category.

## Technique metadata

Every catalog entry states:

- stable ID and status,
- player-facing name,
- primary category,
- rarity,
- combat-verb tags,
- soft Aspect affinity or neutral status,
- build direction,
- trigger or condition,
- standalone effect,
- failure and reset behavior,
- boss, elite, and crowd behavior,
- cross-Aspect usefulness,
- overlap safeguards,
- refinement when present,
- UI, VFX, animation, audio, and unlock treatment.

### Aspect affinity

Affinity explains which Aspect naturally amplifies or is amplified by an entry.

Affinity may influence offer weighting and communicate natural synergy. It does not make a Technique unusable elsewhere, replace category or tags, or justify a dead option under another Aspect.

An entry may be neutral or have more than one justified affinity.

### Rarity

Rarity represents unusualness, transformation, complexity, or reward restriction rather than only a larger number.

The catalog must define rarity tiers, offer timing, reward-source eligibility, readability, and which effects belong to Relics or other systems instead.

## Prosthetic Techniques

Prosthetic Techniques use the normal Technique system.

- Only the equipped prosthetic contributes eligible entries.
- A major temporary prosthetic modification occupies one active slot.
- Its one refinement is slotless.
- The Forge owns permanent tool development.
- The run owns temporary specialization.
- Prosthetic Techniques deepen the tool's existing tactical role rather than replacing it with an unrelated ability.

## Aspect relationship still to define

The roster, fixed Tier structure, and Wolf working package are approved. Still resolve:

- Wraith and Ronin Tier packages and their power budgets,
- cross-roster overlap after all three packages exist,
- soft offer-weighting strength,
- neutral and alternate-affinity representation,
- whether any direct Wolf-, Wraith-, Ronin-, Tier-, or Blood-referencing Technique ships at launch,
- rarity and production treatment for those exceptions,
- whether fixed Tier benefits may alter already-owned Techniques,
- and how the catalog prevents repetitive same-Aspect builds.

These decisions do not affect Technique eligibility under the ordinary universal rules.

## Reward-generation principles

Before all active slots are filled, offers should favor useful standalone entries, approved compatibility weighting, occasional eligible Prosthetic Techniques, and occasional higher-rarity options.

After the loadout is full, offers should usually mix:

- a compatible replacement,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

The generator should avoid three unusable or excessively narrow choices. Limited rerolls and decline rewards may reduce extreme bad luck without guaranteeing a perfect build.

## Expected late-run state

A successful late run should commonly reach:

- Tier II or III, with Tier IV occasional rather than expected,
- four active Techniques,
- one optional reserve,
- one to three refined Techniques,
- zero or more Prosthetic Techniques within active slots,
- one run-scoped Relic when obtained,
- and additional survival or resource growth.

The late-run fantasy comes from coherent systems reinforcing skilled play rather than one layer dominating the build.

## Catalog ownership

Individual entries, refinements, coverage, production treatment, and launch population belong in [Technique Catalog](TECHNIQUE_CATALOG.md).

The removed Storm, Frost, Ember, Hex, and Shadow stance catalog is historical context only.

## Catalog approval tests

Before launch counts are approved, demonstrate that:

- the approved Wolf, Wraith, and Ronin foundations remain distinct,
- every core action has meaningful but non-mandatory support,
- each Aspect supports reinforce, broaden, compensate, and hybridize builds,
- early choices provide standalone value,
- late choices create replacement, reserve, and refinement decisions,
- neutral and alternate-affinity choices prevent repetitive runs,
- no category is mandatory for a viable build,
- boss and mixed-encounter usefulness are documented,
- Techniques do not make Aspect progression irrelevant,
- fixed Aspect progression does not make Technique selection secondary,
- fixed Tier behaviors are not accidentally duplicated as generic cards,
- and the reward generator can avoid presenting three invalid choices.

## Reset rule

Active Techniques, reserve, and refinements reset after death, successful Heart Binding completion, or story completion.

Permanent progression may unlock additional entries into future reward pools. It does not preserve an assembled build between runs.

## Current design package

Before approving the launch catalog, resolve:

1. Wraith and Ronin Tier packages and cross-roster power budget,
2. primary-category boundaries,
3. combat-verb tag taxonomy,
4. affinity and offer-weighting rules,
5. Technique rarity model,
6. final refinement standard,
7. rare direct Aspect-, Tier-, or Blood-specific exceptions,
8. launch coverage matrix.

Then approve total count, category and rarity distribution, refinement count, Prosthetic Technique count per tool, icon needs, bespoke production requirements, and unlock ownership.

Individual values, rarity weights, reroll rates, and refinement frequency remain implementation and playtesting work.