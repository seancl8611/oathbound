---
id: GAMEPLAY-TECHNIQUES
title: Technique System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
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
  - ART-MILESTONE-04
---

# Technique System

Techniques are temporary in-run upgrades that strengthen or reshape Akio's existing combat actions. They replace the former five-stance system and broad generic boon layer.

## System role

The selected Blood Aspect is the central identity of a run. Techniques provide horizontal customization around that identity by modifying sword actions, defensive responses, movement, executions, resources, and the equipped prosthetic.

The systems remain distinct:

- **Blood Aspect and Corruption:** vertical risk-and-power escalation through Tier 0–IV.
- **Techniques:** limited horizontal build construction during the current run.
- **Prosthetic:** equipped tactical tool with eligible temporary Prosthetic Techniques.
- **Relic:** separate rare passive rule using its own slot.

Technique builds must deepen the sword-combat loop rather than automate or replace it.

## Starting state

- Technique slots begin empty.
- Akio does not begin with weak placeholder or default Techniques.
- The base katana kit, selected Blood Aspect at Tier 0, equipped prosthetic, and permanent progression provide the starting combat foundation.
- New Techniques should feel like meaningful power gained during the run.

## Loadout limit

Akio has:

- **four active Technique slots,**
- **one inactive reserve slot.**

Only active Techniques affect combat. The reserve holds one dormant Technique and is not a full inventory.

The four active slots are unrestricted. They are not permanently assigned to Blade, Deflection, Movement, Execution, or Prosthetic categories. A player may build any combination that remains valid under the general rules.

The initial scope does not include permanent increases to the four active slots or the single reserve slot.

## Acquiring Techniques

Technique opportunities normally present three cards.

While an active slot is empty:

1. the player chooses one Technique,
2. it fills an empty active slot,
3. the Technique remains active for the current run.

After all four active slots are full, a selected new Technique may:

- replace any active Technique,
- enter the reserve slot,
- be declined in favor of the displayed smaller fallback reward.

The new Technique does not dictate which active Technique it replaces. The player chooses.

## Replacement and reserve behavior

When a new Technique replaces an active Technique:

1. the new Technique becomes active,
2. the displaced active Technique moves to reserve,
3. if reserve is already occupied, its previous Technique is permanently lost for the current run after an explicit confirmation.

The player may exchange the reserve Technique with any active Technique only at:

- Technique reward screens,
- rest rooms.

General swapping is not available during combat or from the ordinary pause screen.

Reserve rules:

- the reserve Technique is inactive,
- it retains any refinement already earned,
- it cannot receive a new refinement while inactive,
- overwriting it loses it for the current run,
- a lost or declined Technique is not guaranteed to return, although normal reward generation may offer the same Technique again.

This structure preserves forward-moving decisions while allowing one controlled experiment, contingency, or later reorganization.

## Technique construction rules

Every Technique must be:

1. useful immediately on its own,
2. stronger when paired with compatible combat verbs or the selected Aspect,
3. functional without requiring an exact combination.

Most Techniques are standalone. Synergy should emerge primarily through shared player behavior rather than dependency webs.

Examples of shared combat verbs include:

- `PARRY`
- `COUNTER CUT`
- `POSTURE`
- `DEATHBLOW`
- `DASH`
- `FLANK`
- `PREY`
- `PURSUIT`
- `PROSTHETIC`
- `SPIRIT`

A Ronin build may naturally connect perfect parry, Counter Cut, posture break, and deathblow Techniques without those Techniques explicitly requiring one another.

## Refinements and conditional upgrades

A Technique may have at most one refinement:

> Base Technique → one refinement

Refinements:

- do not consume another Technique slot,
- may appear only after the base Technique is active,
- directly deepen the base effect,
- retain their state if the Technique moves into reserve.

Do not create:

- chains deeper than one refinement,
- Techniques requiring multiple other Techniques,
- exact multi-Technique combination requirements,
- unusable investment pieces that have no current effect,
- large Hades-style duo or legendary prerequisite webs.

Rare authored interactions may exist, but they must remain understandable, independently functional, and limited in number.

## Technique categories

Categories organize reward pools and communication; they are not slot restrictions.

### Blade Techniques

Modify the approved katana actions, such as Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, or Dash Slash.

### Deflection Techniques

Modify parries, blocking, posture control, Counter Cut follow-ups, or mastery-based defensive rewards.

### Execution Techniques

Modify posture breaks, deathblows, kill momentum, or execution-linked recovery.

### Movement Techniques

Modify dashes, clean avoidance, repositioning, flanking, pursuit, or re-entry attacks.

### Prosthetic Techniques

Temporarily modify the equipped prosthetic. They use the same four active slots as other Techniques.

### General Techniques

Support health, posture, Spirit, recovery, or other broadly useful run behaviors without becoming generic percentage-stat clutter.

## Prosthetic Techniques

Prosthetic Techniques are part of the normal Technique system, not a separate in-run tree or interface.

Rules:

- only Techniques for the currently equipped prosthetic are eligible,
- a major prosthetic modification occupies one active Technique slot,
- its one-step refinement is slotless,
- the Forge owns permanent unlocks and baseline tool development,
- the run owns temporary specialization and synergy.

Example structure:

- **Scorching Wake:** Flame Vent leaves a small scorched zone.
- **Fed Embers — refinement:** the scorched zone lasts longer and applies greater pressure.

The second option may appear only after Scorching Wake is active. No deeper Flame Vent chain follows it in the initial system.

## Blood Aspect relationship

Every post-unlock run confirms one Blood Aspect at the Boat. The Aspect defines the broad tactical identity; Techniques shape the player's expression of it.

Technique generation may weight options toward the selected Aspect without fully restricting the pool:

- **Ronin:** parry, posture, Counter Cut, deathblow, and controlled defense.
- **Wolf:** prey, pursuit, consecutive pressure, wounded targets, and execution momentum.
- **Wraith:** clean avoidance, repositioning, flanking, Dash Slash, and punish-after-dodge play.

Neutral, prosthetic, recovery, and alternate-style Techniques remain available so two runs using the same Aspect can develop differently.

Techniques should connect to Aspect Tiers through shared verbs and natural amplification. Ordinary Techniques should not require a particular Tier unless a rare, clearly authored interaction explicitly needs that boundary.

## Reward-generation principles

Before four active slots are filled, Technique offers should favor:

- immediately useful new Techniques,
- selected-Aspect compatibility,
- occasional eligible Prosthetic Techniques,
- occasional higher-rarity options.

After four slots are filled, offers should usually mix:

- a compatible new Technique,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

Reward generation should avoid three unusable or overly narrow choices. Limited rerolls and smaller decline rewards may reduce extreme bad luck without guaranteeing a perfect build.

Detailed room ownership and reward cadence belong in [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md). Screen behavior belongs in [Technique Rewards and Build Management](../ui_ux/TECHNIQUE_REWARDS.md).

## Expected late-run state

A successful late run should commonly reach:

- Blood Aspect Tier II–IV depending on Resist/Embrace decisions,
- four active Techniques,
- one optional reserve Technique,
- one to three refined Techniques,
- zero or more Prosthetic Techniques within the four active slots,
- one run-scoped Relic when obtained,
- additional resource and survival growth from other reward categories.

The late-game power fantasy should come from several coherent layers reinforcing skilled combat, not from collecting every mechanic in the catalog.

## Run reset

Active Techniques, the reserve Technique, and all refinements are run-only. They are burned away after failed death-return or successful Wellspring completion.

Permanent progression may unlock additional Techniques into future reward pools or improve baseline reliability, but it does not preserve an assembled Technique build between runs.

## Open balance work

Still subject to implementation and playtesting:

- final Technique catalog size,
- individual effects and values,
- rarity weights,
- exact reward cadence,
- reroll availability and cost,
- decline-reward values,
- final Aspect weighting,
- final Relic interactions,
- exact number of refinements expected per successful run.
