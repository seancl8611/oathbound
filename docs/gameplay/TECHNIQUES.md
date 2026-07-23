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

Techniques are temporary in-run upgrades that strengthen or reshape Akio's existing combat actions. They provide horizontal customization alongside the selected Blood Aspect rather than replacing it or being replaced by it.

## System ownership

- **Blood Aspect and Corruption:** overarching run identity and optional vertical power pursuit; exact gameplay form remains to be approved in `BLOOD_ASPECTS.md`.
- **Techniques:** limited horizontal run-build construction.
- **Prosthetic:** equipped tactical tool with eligible temporary Techniques.
- **Relic:** separate passive rule using its own slot.

Technique builds must deepen sword combat rather than automate or replace it. Blood Aspect power must likewise leave Technique choices meaningful.

## Starting state and capacity

Each run begins with:

- four empty active Technique slots,
- one empty inactive reserve slot.

Akio does not begin with placeholder Techniques. The base katana kit, selected Blood Aspect, equipped prosthetic, and permanent progression provide the starting foundation.

Only active Techniques affect combat. The reserve is not a full inventory.

The four active slots are unrestricted by category. The initial scope does not include permanent slot-capacity increases.

## Acquiring Techniques

Technique opportunities normally present three cards.

While an active slot is empty, the selected Technique fills that slot.

After all active slots are full, a selected new Technique may:

- replace any active Technique,
- enter the reserve,
- or be declined for the displayed smaller fallback reward.

The player chooses which active Technique is replaced.

## Replacement and reserve

When a new Technique replaces an active Technique:

1. the new Technique becomes active,
2. the displaced Technique moves to reserve,
3. if reserve is occupied, its previous Technique is lost for the run after explicit confirmation.

The reserve may be swapped with an active Technique only at:

- Technique reward screens,
- rest rooms.

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

Synergy should emerge through shared combat verbs such as:

- parry,
- Counter Cut,
- posture,
- deathblow,
- dash,
- flank,
- Prey,
- pursuit,
- prosthetic,
- Spirit.

Do not create:

- Techniques that do nothing without another Technique,
- exact multi-Technique dependency chains,
- deep prerequisite webs,
- or automatic effects that replace active combat execution.

## Refinements

A Technique may receive at most one refinement.

A refinement:

- does not consume another slot,
- may appear only while the base Technique is active,
- directly deepens the base effect,
- remains attached if the Technique moves to reserve.

No refinement chain extends beyond one step.

### Refinement design direction

A refinement should strengthen the reason the player selected the base Technique. It should not turn that Technique into a different combat identity or unrelated reward family.

Possible refinement dimensions include:

- greater reliability or consistency,
- a stronger payoff for the same skilled behavior,
- a carefully bounded additional target or use case,
- a deeper interaction with the same combat verb,
- a resource interaction that supports the same loop,
- or a risk adjustment that preserves the original decision.

The final refinement standard must decide:

- how transformative a refinement may be,
- whether simple numerical improvements are acceptable and under what conditions,
- whether every launch Technique should support a refinement,
- which effects are too broad and should become separate Techniques or Relics,
- and how refinements are distributed across categories, affinities, and rarities.

## Categories

Categories organize communication and reward generation. They do not restrict slots.

- **Blade:** modifies approved katana actions.
- **Deflection:** modifies parry, block, posture, Counter Cut, or defensive mastery.
- **Execution:** modifies posture break, deathblow, or execution momentum.
- **Movement:** modifies dash, repositioning, flanking, pursuit, or re-entry.
- **Prosthetic:** temporarily modifies the equipped tool.
- **General:** supports health, Spirit, recovery, or broad combat rules without generic stat clutter.

A Technique should normally have one primary category. Category describes the principal part of combat changed by the entry; it does not describe every trigger, synergy, rarity, or Aspect relationship.

## Technique metadata model

The player-facing card and internal catalog use several separate dimensions. They must not collapse into interchangeable labels.

### Primary category

Category answers: **what part of the combat system does this Technique principally modify?**

A Technique normally has one primary category even when it uses several combat verbs.

### Combat-verb tags

Tags answer: **which approved player actions, enemy states, resources, or positional rules does this Technique directly use?**

A Technique may use several tags. The final taxonomy should be drawn from approved combat vocabulary such as Quick Slash, Heavy Cleave, thrust, parry, Counter Cut, posture, deathblow, dash, Dash Slash, flank, Prey, perfect dodge, Focus, Spirit, or an approved prosthetic.

Tags support communication, offer validation, build comparison, trials, analytics, and later balance work. They do not create prerequisites by themselves.

### Aspect affinity

Affinity answers: **which Aspect naturally amplifies or is naturally amplified by this Technique?**

Affinity is normally soft:

- it may influence offer weighting,
- it may explain a natural synergy,
- it does not make the Technique unusable with another Aspect,
- and it does not replace the Technique's category or tags.

A Technique may be neutral or may have more than one justified affinity, but the catalog should avoid labeling every broadly useful entry as universally affiliated.

### Rarity

Rarity answers: **how unusual, transformative, complex, or restricted is this Technique within the run reward ecosystem?**

Rarity should not mean only a larger numerical bonus. The final rarity model must define:

- approved Technique rarity tiers,
- what gameplay and production properties justify each tier,
- whether rarity affects offer timing or reward-source eligibility,
- how rare entries remain understandable and independently useful,
- and which effects are too broad for Techniques and belong to Relics or other systems.

Individual rarity assignments belong in [Technique Catalog](TECHNIQUE_CATALOG.md) after the model is approved.

## Prosthetic Techniques

Prosthetic Techniques use the normal Technique system.

- Only the equipped prosthetic contributes eligible Techniques.
- A major prosthetic modification occupies one active slot.
- Its single refinement is slotless.
- The Forge owns permanent tool development.
- The run owns temporary specialization.
- Prosthetic Techniques should strengthen the tool's existing tactical role rather than replace it with an unrelated ability.

## Blood Aspect relationship

The exact Blood Aspect–Technique relationship is not yet approved. It must follow the gameplay-model decision in `BLOOD_ASPECTS.md` rather than assume that offer weighting is the only interaction.

Possible bounded relationships include:

- soft offer weighting and affinity only,
- direct run-long buffs to approved Technique tags or categories,
- higher-Tier interactions with already-owned Techniques,
- rare Aspect-linked Technique behavior,
- or another structure that preserves both systems' independence.

The final relationship must determine:

- whether any Technique may be hard-locked to an Aspect,
- whether any Technique may require a minimum Tier,
- whether Aspect progression may modify owned Techniques during the run,
- whether those modifications affect categories, tags, individual entries, or only offer generation,
- what qualifies as a justified rare Aspect-specific interaction,
- how offer weighting distinguishes affinity from eligibility,
- and how much neutral or alternate-affinity representation every run should retain.

Until those decisions are approved, retain these guardrails:

- no ordinary Technique is required to make an Aspect functional,
- no Aspect Tier is required to make an ordinary Technique functional,
- affinity creates amplification rather than permission,
- the same Technique may produce different value under different Aspects,
- every Aspect should support several distinct valid four-Technique builds,
- Techniques must not duplicate an Aspect's signature mechanic or activatable ability,
- Aspect power must not make Technique selection or refinement secondary,
- and rare Tier-referencing interactions remain explicit exceptions rather than the normal catalog structure.

The current directional affinities remain:

- **Ronin:** parry, posture, Counter Cut, deathblow, controlled defense.
- **Wolf:** Prey, pursuit, consecutive pressure, wounded targets, execution momentum.
- **Wraith:** clean avoidance, repositioning, flanking, Dash Slash, punish-after-dodge.

These are design directions, not locked Technique eligibility rules.

## Reward-generation principles

Before all active slots are filled, offers should favor:

- useful new Techniques,
- selected-Aspect compatibility after the relationship model is approved,
- occasional eligible Prosthetic Techniques,
- occasional higher-rarity options.

After the loadout is full, offers should usually mix:

- a compatible replacement,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

The generator should avoid three unusable or excessively narrow options. Limited rerolls and decline rewards may reduce extreme bad luck without guaranteeing a perfect build.

Detailed cadence and room ownership belong in `ITEMS_AND_REWARDS.md`.

## Expected late-run state

A successful late run should commonly reach:

- Blood Aspect Tier II or Tier III,
- occasional Tier IV when the player performs well and invests in Aspect growth,
- four active Techniques,
- one optional reserve Technique,
- one to three refined Techniques,
- zero or more Prosthetic Techniques within the active slots,
- one run-scoped Relic when obtained,
- additional survival and resource growth.

Even experienced players should not be assumed to maximize the Aspect every run. The late-run fantasy should come from several coherent layers reinforcing skilled play and meaningful priorities rather than one system automatically dominating the build.

## Individual catalog ownership

Individual Technique entries, their attached refinements, catalog status, coverage matrix, production treatment, and launch population belong in [Technique Catalog](TECHNIQUE_CATALOG.md).

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

The old stance upgrade catalog does not constrain the new Technique effects. It is historical implementation context only.

## Catalog approval tests

Before launch counts are approved, the Technique system and catalog together must demonstrate that:

- the Blood Aspect gameplay model and power budget are already approved,
- each core sword action has meaningful but non-mandatory support,
- each Aspect supports several distinct valid build shapes,
- early choices provide immediate standalone value,
- late choices create replacement, reserve, and refinement decisions,
- alternate-affinity and neutral options prevent repetitive same-Aspect runs,
- no category becomes an automatic requirement for a viable build,
- boss and mixed-encounter usefulness are documented,
- Techniques do not make Aspect growth irrelevant,
- Aspects do not make Technique choices secondary,
- and the reward generator can avoid presenting three invalid choices.

## Reset rule

Active Techniques, reserve, and refinements reset after death, successful Heart Binding completion, or story completion.

Permanent progression may unlock additional Techniques into future reward pools. It does not preserve an assembled build between runs.

## Current design package

Before approving the minimum launch catalog, resolve:

1. the Blood Aspect gameplay model and power budget in `BLOOD_ASPECTS.md`,
2. the activatable-ability and direct Technique-interaction decisions,
3. the shared Tier contract and exact Aspect functionality,
4. primary-category boundaries,
5. the combat-verb tag taxonomy,
6. affinity assignment and offer-weighting rules,
7. the Technique rarity model,
8. the final refinement standard,
9. rare Aspect- or Tier-specific exception rules,
10. and the launch coverage matrix in `TECHNIQUE_CATALOG.md`.

After that groundwork, approve:

- total base Technique count,
- category and rarity distribution,
- refinement count,
- Prosthetic Technique count per tool,
- unique icon requirements,
- bespoke VFX or animation requirements,
- and unlock ownership.

Individual numerical values, exact rarity weights, reroll rates, and expected refinement frequency remain implementation and playtest work.
