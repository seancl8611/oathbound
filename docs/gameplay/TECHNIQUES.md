---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-21
topics:
  - techniques
  - run-builds
  - active-slots
  - reserve-slot
  - refinements
  - prosthetic-techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-ITEMS-REWARDS
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - META-OPEN-QUESTIONS
---

# Technique System

Techniques are temporary in-run upgrades that strengthen or reshape Akio's existing combat actions. They provide horizontal customization around the selected Blood Aspect rather than replacing it as the run's central identity.

## System ownership

- **Blood Aspect and Corruption:** vertical risk-and-power progression.
- **Techniques:** limited horizontal run-build construction.
- **Prosthetic:** equipped tactical tool with eligible temporary Techniques.
- **Relic:** separate passive rule using its own slot.

Technique builds must deepen sword combat rather than automate or replace it.

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

## Categories

Categories organize communication and reward generation. They do not restrict slots.

- **Blade:** modifies approved katana actions.
- **Deflection:** modifies parry, block, posture, Counter Cut, or defensive mastery.
- **Execution:** modifies posture break, deathblow, or execution momentum.
- **Movement:** modifies dash, repositioning, flanking, pursuit, or re-entry.
- **Prosthetic:** temporarily modifies the equipped tool.
- **General:** supports health, Spirit, recovery, or broad combat rules without generic stat clutter.

## Prosthetic Techniques

Prosthetic Techniques use the normal Technique system.

- Only the equipped prosthetic contributes eligible Techniques.
- A major prosthetic modification occupies one active slot.
- Its single refinement is slotless.
- The Forge owns permanent tool development.
- The run owns temporary specialization.
- Prosthetic Techniques should strengthen the tool's existing tactical role rather than replace it with an unrelated ability.

## Blood Aspect relationship

The selected Aspect weights Technique offers without fully restricting them.

- **Ronin:** parry, posture, Counter Cut, deathblow, controlled defense.
- **Wolf:** Prey, pursuit, consecutive pressure, wounded targets, execution momentum.
- **Wraith:** clean avoidance, repositioning, flanking, Dash Slash, punish-after-dodge.

Neutral, recovery, prosthetic, and alternate-style Techniques remain available so runs using the same Aspect can develop differently.

Ordinary Techniques should not require a specific Aspect Tier unless a rare authored interaction explicitly needs that boundary.

## Reward-generation principles

Before all active slots are filled, offers should favor:

- useful new Techniques,
- selected-Aspect compatibility,
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

- Blood Aspect Tier II–IV depending on Shrine choices,
- four active Techniques,
- one optional reserve Technique,
- one to three refined Techniques,
- zero or more Prosthetic Techniques within the active slots,
- one run-scoped Relic when obtained,
- additional survival and resource growth.

The late-run fantasy should come from several coherent layers reinforcing skilled play rather than collecting every catalog entry.

## Reset rule

Active Techniques, reserve, and refinements reset after death, successful Heart Binding completion, or story completion.

Permanent progression may unlock additional Techniques into future reward pools. It does not preserve an assembled build between runs.

## Current scope dependency

The structural system is resolved. The remaining production-level question is the minimum launch catalog:

- total base Technique count,
- category distribution,
- refinement count,
- Prosthetic Technique count per tool,
- unique icon requirements,
- bespoke VFX or animation requirements.

Individual effects, values, rarity weights, Aspect weighting, reroll rates, and expected refinement frequency remain later design and playtest work.