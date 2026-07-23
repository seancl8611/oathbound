---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-23
topics:
  - blood-aspects
  - blood-arts
  - blood-resource
  - wolf
  - wraith
  - ronin
  - corruption
  - run-progression
  - techniques
related:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - CONTENT-STRAND-INTERACTIBLES
---

# Blood Aspect System

Blood Aspects are controlled specializations of Akio's Returning Blood. They are not independent spirits or unrelated magic schools; each is a behavioral expression of the same altered Blood within him.

## System role

Blood Aspects are an overarching run-power system. The player equips one Aspect before a run and may increase its Tier at designated Shrine rooms through Embrace choices.

The selected Aspect should influence how the player approaches combat and build decisions throughout the run, but it must not replace the base sword system, Techniques, prosthetics, Relics, route choices, or player execution.

Every post-unlock run confirms one Aspect. The selected identity remains present throughout the run even when the player does not pursue maximum Tier.

## Approved gameplay model

Each Blood Aspect uses the same shared structural framework while providing different exact mechanics.

- **Tier 0:** equips one persistent Aspect-specific signature mechanic.
- **Tier I:** strengthens, broadens, or stabilizes that signature mechanic.
- **Tier II:** unlocks the run-only **Blood** resource and the Aspect's activatable **Blood Art**.
- **Tier III:** deepens the Aspect's established mechanic, Blood Art, or the relationship between them.
- **Tier IV:** provides a difficult, rewarding capstone expression of the same established identity.

The shared framework does not require every Blood Art to have the same type of effect. Blood Arts may be temporary empowered states, contextual combat actions, defensive responses, mobility or control tools, focused attacks, or another bounded form that preserves sword combat. They should generally not be designed as one large automatic damage attack, and they are not all required to be activatable buffs.

The exact signature mechanic, Blood-generation rules, Blood Art function, and Tier effects remain specific design work for Wolf, Wraith, and Ronin.

## Blood resource

**Blood** is a run-only combat resource used only to activate the selected Aspect's Blood Art.

Approved rules:

- Blood does not exist as an active combat resource before Tier II.
- Reaching Tier II unlocks Blood generation and the Blood Art.
- Combat generates Blood after Tier II.
- The exact qualifying actions and gain rules may differ by Aspect and remain unresolved.
- The baseline system requires the approved activation amount before the Blood Art can be used.
- Activating the Blood Art consumes the required Blood.
- Blood has no shop price, route-preview category, Strand wallet, or account-level persistence.
- Blood resets after death or successful run completion.
- Blood may be modified during a run by later Tiers, Techniques, refinements, Relics, or other approved run effects.
- Those modifiers must not turn Blood into a meta currency or make near-permanent Blood Art uptime the default.

The exact capacity, activation amount, generation rate, carry behavior between encounters, boss behavior, and any retained Blood after activation remain later system and playtest decisions.

### Full and partial activation

The initial implementation target is one clear activation threshold rather than multiple partial-spend levels.

Partial activation may be reconsidered only after:

1. the Aspect and Blood Art production milestones are complete enough to test the full system,
2. the three Blood Arts are playable,
3. the HUD and activation feedback are readable,
4. and gameplay testing demonstrates that partial spending creates meaningful decisions without unnecessary complexity.

Partial activation is therefore a deferred possibility, not part of the currently approved launch baseline.

## Approved run-power target

The following direction is committed:

- Blood Aspect growth must reward both skill and strategic decision-making.
- A knowledgeable or highly skilled player is not expected to reach Tier IV in every run.
- A successful run played well should commonly finish around Tier II or Tier III.
- Tier IV should be difficult enough to feel notable and rewarding when reached.
- Some runs may deliberately prioritize Techniques, economy, survival, prosthetic development, or another route over maximum Aspect growth.
- A player performing well should still commonly gain meaningful Aspect power even when the Aspect is not the run's primary build priority.
- Tier IV must provide a satisfying capstone without becoming so transformative that it takes over the run or makes Techniques and other systems secondary.
- Lower-Tier and mid-Tier runs must remain complete, viable, and strategically interesting.

Exact Shrine frequency, Corruption gain, Blood gain, thresholds, and numerical power remain later balance and playtest work. The design target is variable run outcomes rather than automatic maximum progression.

## Build hierarchy

The intended hierarchy is:

1. **Base combat and player skill:** the reliable foundation of every run.
2. **Blood Aspect:** overarching run identity and optional vertical power pursuit.
3. **Aspect Tier:** escalating run-only expression of the selected Aspect.
4. **Techniques:** four active temporary upgrades plus one reserve that shape specific combat verbs and build priorities.
5. **Prosthetic and Prosthetic Techniques:** tactical tool and optional run specialization.
6. **Relic and resource rewards:** secondary passive, survival, and economy layers.

A late-run build should feel like a specialized expression of Ronin, Wolf, or Wraith, but the Aspect must share the run with the player's Technique choices and other build investments.

## Unlock and selection flow

- Aspects are introduced after the player learns basic combat.
- Ronin is the likely first/default unlock through Blood Cavern or Blood Mirror trials.
- Wolf and Wraith unlock later through Aspect trials or progression milestones.
- The Blood Mirror teaches, unlocks, previews, tests, and lightly improves Aspects.
- The Boat equips or confirms one unlocked Aspect before the run.
- The active Aspect remains selected as a loadout option between runs unless the player changes it.

## Run loop

1. Choose or confirm an unlocked Aspect at the Boat.
2. Begin the run at Tier 0 with empty Technique slots.
3. Use the Aspect's Tier 0 signature mechanic while building through Techniques and other rewards.
4. Fill Corruption through combat accomplishments and major encounter progress.
5. Reach a Shrine-ready state.
6. Choose Resist or Embrace.
7. Resist keeps the current Tier; Embrace advances the active Aspect by one Tier, up to Tier IV.
8. At Tier II, combat begins generating Blood and the Blood Art becomes available when its activation requirement is met.
9. Continue developing the run according to current needs rather than assuming maximum Aspect Tier is always the correct priority.
10. On death or successful run completion, Aspect Tier, Blood, and all other run-only Aspect state reset.

## Tier structure

- **Tier 0:** the selected Aspect's signature mechanic is active, but no in-run mutation Tier has been accepted.
- **Tier I–IV:** fixed run-only progression steps gained through Embrace.
- Tier progression is fixed for each Aspect rather than branching into multiple choices at every Tier.
- Tiers reset after death or successful completion.
- Tier II or III should be a common successful-run endpoint.
- Tier IV is a difficult, rewarding, non-mandatory capstone rather than the automatic expected endpoint of every successful run.
- Tier II must provide a complete and usable Blood Art baseline.
- Tier III and Tier IV should deepen established functionality rather than continually adding unrelated abilities or resources.

The exact benefit, drawback, transformation, and complexity rules for each Tier remain part of the shared Tier-contract decision.

## Technique relationship

Techniques provide horizontal run-build customization. The Aspect and Blood Art may create combat states that naturally increase the usefulness of certain Techniques, but Techniques remain independently selected run upgrades.

Approved guardrails:

- Techniques must remain valuable choices rather than automatic extensions of the selected Aspect.
- Ordinary Techniques should remain functional without a specific Aspect or Tier unless an explicitly rare authored exception is approved.
- Two runs using the same Aspect should be able to form meaningfully different Technique builds.
- An Aspect must remain functional before the player acquires any Technique.
- Aspect power must not make Technique acquisition or refinement feel secondary.
- Selecting an Aspect does not automatically buff every Technique assigned to that Aspect's affinity.
- A limited number of run upgrades may modify Blood generation, Blood Art behavior, duration, activation payoff, or another approved property.
- Blood-related upgrades should remain optional build directions rather than mandatory repairs to an incomplete Blood Art.

The final Technique relationship must still determine offer weighting, affinity, rare Aspect-specific interactions, and how many Blood-related Technique or refinement entries are appropriate.

## Permanent Aspect upgrades

Blood Mirror trials may award small permanent upgrades that improve reliability, tuning, or comfort. They must not:

- add new Tiers,
- guarantee maximum Tier progression,
- remove the danger or opportunity cost of Embrace,
- transform an Aspect into a different combat identity,
- create a broad invulnerability or timing advantage that trivializes core combat,
- permanently pre-equip Techniques,
- provide a permanent Blood wallet,
- or turn run-only Tier and Blood growth into automatic persistent power.

Any permanent change to starting Blood, Blood capacity, generation, or Blood Art availability requires explicit approval during the persistent-progression design pass.

## Wolf Aspect

**Role:** aggression, pursuit, and selected-target pressure.

**Fantasy:** a predatory mutation that turns Beast Blood aggression into prey pressure and relentless offense.

**Current directional loop:** mark or identify prey, stay aggressive, build pressure, finish the target, and chain momentum.

**Candidate Tier direction:**

- early progression: prey identification and target-pressure foundation,
- middle progression: consecutive pressure, wounded-target payoff, and Blood Art access,
- high progression: execution momentum and risky chain pressure.

**Potential Technique affinity:** prey, pursuit, consecutive pressure, wounded targets, Dash Slash re-entry, execution momentum, and target-isolating tools.

**Visual direction:** red eyes, sharper stance, blood trail on marked prey, and a controlled feral aura. Akio must remain recognizably samurai-shaped rather than becoming a full beast.

**Constraint:** Wolf is target pressure and pursuit—not generic attack speed.

The exact Prey mechanic, Blood-generation rules, Blood Art type and effect, Tier placement, benefit structure, and drawbacks remain open.

## Wraith Aspect

**Role:** evasion, repositioning, and punishment after clean avoidance.

**Fantasy:** a spectral mutation that lets Akio approach bodily dissolution without losing his physical form.

**Current directional loop:** bait an attack, avoid it cleanly, reposition, and punish from a favorable angle.

**Candidate Tier direction:**

- early progression: clean-avoidance and punish foundation,
- middle progression: afterimage, repositioning, flank payoff, and Blood Art access,
- high progression: enhanced ghost movement or mist-step behavior.

**Potential Technique affinity:** perfect dodge, repositioning, flanking, Dash Slash, recovery manipulation, clean-avoidance rewards, and tactical movement tools.

**Visual direction:** mist trails, pale-red afterimages, smoky blade trails, and partial wraith silhouette at high Tiers.

**Constraint:** Wraith is avoidance into punishment. It must remain distinct from Wolf's aggression and from the Mist Raven prosthetic.

The exact perfect-dodge vocabulary, Blood-generation rules, Blood Art type and effect, Mist-Step ownership, Tier placement, benefit structure, and drawbacks remain open.

## Ronin Aspect

**Role:** sword discipline, parries, posture, Counter Cuts, and deathblows.

**Fantasy:** a disciplined mutation that reinforces the fundamentals of Akio's sword game.

**Current directional loop:** control the exchange, parry or defend precisely, pressure posture, Counter Cut or deathblow, then reset with control.

**Candidate Tier direction:**

- early progression: parry and posture foundation,
- middle progression: Counter Cut, execution payoff, and Blood Art access,
- high progression: disciplined chain momentum or Focus behavior.

**Potential Technique affinity:** parry, Counter Cut, posture control, Focus, deathblow, guard timing, and defensive tool mastery.

**Visual direction:** blood-lit blade edge, sharper parry spark, calm red aura after deathblow, and a controlled human silhouette.

**Constraint:** Ronin is likely the first/default Aspect. It should be reliable and fundamentals-focused rather than intentionally weak.

The exact Focus mechanic, Blood-generation rules, Blood Art type and effect, Tier placement, benefit structure, and drawbacks remain open.

## Detailed design package

The shared system form, Blood resource, Tier II Blood Art unlock, and variable Tier-progression target are approved. Resolve the following decisions in dependency order before individual Tier tables or the Technique catalog are approved.

### 1. Shared Tier contract

Decide:

- the exact baseline value and complexity allowed at Tier 0,
- what kinds of functionality Tier I may add or improve,
- the guaranteed baseline supplied by the Tier II Blood Art unlock,
- whether Tier benefits accumulate, transform, or may do either under a consistent rule,
- whether drawbacks accumulate, transform, or use another clearly communicated structure,
- whether every Tier must add a benefit and drawback or may deepen an existing pair,
- how much complexity one Tier may add,
- what Shrine behavior remains available after Tier IV,
- and how Resist remains meaningful for players who deliberately remain at Tier II or III.

The run target is already approved: Tier II–III should be common on successful runs, while Tier IV should be difficult, rewarding, occasional, and non-mandatory.

### 2. Blood generation and activation rules

Decide:

- which combat events generate Blood for each Aspect,
- whether all combat produces baseline Blood with Aspect-specific bonus sources or each Aspect uses wholly distinct rules,
- how health damage, posture damage, parries, dodges, deathblows, elites, bosses, summons, hazards, and multi-target attacks contribute,
- what anti-farming and multi-hit safeguards are required,
- Blood capacity and the activation amount,
- whether Blood carries unchanged between combat rooms,
- whether Blood decays, is retained, or is adjusted during transitions,
- what happens when Tier II is first acquired,
- what happens at boss entrances and phase changes,
- and whether any Blood remains after activation.

Exact numerical rates should remain playtest values even after the behavioral rules are approved.

### 3. Blood Art form and function

For each Aspect, decide:

- the Blood Art's exact effect and tactical purpose,
- whether it is a temporary state, contextual action, defensive response, mobility or control tool, focused attack, or another bounded type,
- activation timing and interruption rules,
- whether it has a duration, immediate resolution, or mixed behavior,
- how it functions against standard enemies, groups, elites, and bosses,
- how Tier III and Tier IV deepen it,
- which Techniques or refinements may modify it,
- and what unique input, HUD, animation, VFX, and audio states it requires.

Blood Arts should generally preserve sword execution and should not default to one large automatic attack. They do not all need to use the same effect type.

### 4. Wolf mechanic definition

Define Wolf's exact signature functionality, including Prey ownership, selection, pressure, transfer, boss behavior, Blood-generation rules, Blood Art function, and Tier placement.

### 5. Wraith mechanic definition

Define Wraith's exact signature functionality, including perfect-dodge vocabulary, punish windows, positional rules, Mist-Step ownership, Blood-generation rules, Blood Art function, and Tier placement.

### 6. Ronin mechanic definition

Define Ronin's exact signature functionality, including Focus ownership, parry and posture interaction, deathblow behavior, Blood-generation rules, Blood Art function, and Tier placement.

### 7. Deferred partial activation test

Do not design partial activation as part of the initial baseline. Revisit it only after playable Arts, integrated UI, and representative encounter testing exist. The later evaluation should ask whether partial activation adds tactical choice, whether it harms readability, and whether it makes full activation feel less meaningful.

### 8. Aspect approval tests

Each completed Aspect design must satisfy all of the following:

- selecting the Aspect has a clear gameplay effect at Tier 0,
- the Aspect remains useful and complete at Tier II or III,
- Tier II supplies a functional Blood Art rather than an incomplete placeholder,
- Tier IV is meaningfully rewarding without taking over the run,
- a skilled player is not expected or required to reach Tier IV every run,
- every Tier reinforces the same tactical identity rather than adding unrelated powers,
- choosing Aspect growth competes meaningfully with other run priorities,
- Blood generation rewards participation without forcing one repetitive action regardless of the Technique build,
- the Blood Art creates a tactical decision rather than an automatic damage rotation,
- the Aspect does not make block, parry, dodge, posture, deathblow, sword positioning, Techniques, prosthetics, or Relics broadly irrelevant,
- the Aspect supports several distinct four-Technique build shapes,
- ordinary Techniques remain useful outside their strongest affinity,
- and the three Aspects remain mechanically and visually distinct in common rooms, bosses, and mixed encounters.

## Current design order

Resolve this package in the following order:

1. shared Tier contract around the approved Tier 0 signature and Tier II Blood Art framework,
2. shared Blood generation and activation rules,
3. Wolf exact functionality, Blood Art, and Tier direction,
4. Wraith exact functionality, Blood Art, and Tier direction,
5. Ronin exact functionality, Blood Art, and Tier direction,
6. cross-Aspect distinction and overlap audit,
7. Technique metadata, Blood interactions, and refinement rules,
8. Technique coverage and individual catalog design,
9. launch content counts and production treatment,
10. partial-activation evaluation only after playable milestone and test requirements are met.

## Visual production rule

Do not create twelve complete replacement Akio animation libraries. Use:

- one approved base Akio animation set,
- modular eyes, veins, markings, weapon treatments, auras, mist, trails, and limited silhouette accents,
- Aspect-specific VFX layered over the base animation,
- composable Tier escalation overlays.

The shared Blood activation framework should reuse input, readiness, activation, and unavailable-state logic where practical. Different Blood Art types may still require distinct animation, VFX, audio, target, duration, or state presentation.

## Related documents

- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Combat](COMBAT.md)
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Shrine interface](../ui_ux/SHRINE_INTERFACE.md)
- [Blood Mirror interface](../ui_ux/BLOOD_MIRROR_TRIALS.md)
