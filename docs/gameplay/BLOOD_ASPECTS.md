---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-22
topics:
  - blood-aspects
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

Blood Aspects are the central run identity. They define the broad tactical behavior Akio is becoming during an attempt and control the run's vertical risk-and-power escalation through Corruption and Embrace.

Every post-unlock run confirms one Aspect. The player is not required to advance it to Tier IV, but the selected identity remains present throughout the run.

Techniques provide horizontal customization around the selected Aspect. They do not replace the Aspect, and the Aspect does not consume Technique slots.

## Build hierarchy

The intended hierarchy is:

1. **Blood Aspect:** broad run identity.
2. **Aspect Tier:** escalating benefit, drawback, and visual mutation.
3. **Techniques:** four active temporary upgrades plus one reserve that shape specific combat verbs.
4. **Prosthetic and Prosthetic Techniques:** tactical tool and optional run specialization.
5. **Relic and resource rewards:** secondary passive and economy layers.

A late-run build should feel like a specialized expression of Ronin, Wolf, or Wraith rather than a collection of unrelated upgrade schools.

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
3. Acquire Techniques that modify Akio's combat around the selected identity.
4. Fill Corruption through combat accomplishments and major encounter progress.
5. Reach a Shrine-ready state.
6. Choose Resist or Embrace.
7. Resist keeps the current Tier; Embrace advances the active Aspect by one Tier, up to Tier IV.
8. Continue refining, replacing, and reorganizing the Technique build as the Aspect escalates.
9. On death or successful run completion, the Aspect Tier and all Techniques reset for the next run.

## Tier structure

- **Tier 0:** selected Aspect is equipped but no in-run mutation Tier has been accepted.
- **Tier I–IV:** each Embrace adds a stronger Aspect-specific benefit and a stronger drawback or visible consequence.
- Tier progression is fixed for each Aspect rather than branching into multiple choices at every Tier.
- Tiers are run-only and reset after the run ends.
- Final numbers, exact effects, and drawbacks remain tuning work, but the four-Tier escalation structure is committed.

Fixed Tier direction keeps the Aspect readable and balanceable. Run-to-run variety comes from Technique choices, prosthetic specialization, Relics, route rewards, and Resist/Embrace timing rather than branching Tier trees.

## Technique relationship

Technique generation may weight choices toward the selected Aspect without fully restricting the pool.

- Aspect-weighted Techniques should be useful immediately and naturally amplified by the Aspect's combat verbs.
- Neutral, prosthetic, recovery, and alternate-style Techniques remain available.
- Ordinary Techniques do not require exact Aspect Tiers.
- Rare authored Aspect interactions may use a clear Tier condition when necessary, but no Technique should require a multi-card prerequisite web.
- Two runs using the same Aspect should be able to develop into different valid builds.

Examples of natural amplification:

- Ronin strengthens a Counter Cut Technique because both reward the parry-to-counter sequence.
- Wolf strengthens a wounded-target or pursuit Technique because both reward maintained prey pressure.
- Wraith strengthens a Dash Slash or flank Technique because both create punish opportunities after clean avoidance.

## Permanent Aspect upgrades

Blood Mirror trials may award small permanent upgrades that improve reliability, tuning, or comfort. They must not:

- add new Tiers,
- remove the danger of Embrace,
- unlock major run-changing mechanics that belong to in-run Tier growth,
- transform an Aspect into a different combat identity,
- create a broad invulnerability or timing advantage that trivializes core combat,
- permanently pre-equip Techniques.

Illustrative directions from the production bible:

| Aspect | Example direction | Guardrail |
|---|---|---|
| Wolf | Prey mark lasts slightly longer | No new Prey behavior |
| Wolf | Pressure bonus builds slightly faster | No additional attack |
| Wraith | Perfect-dodge punish window lasts slightly longer | No new dodge type |
| Wraith | Mist-step recovery is slightly reduced | No added invulnerability spike |
| Ronin | Perfect parries deal slightly more posture damage | Avoid broad parry-window expansion |
| Ronin | Counter Cut recovery is slightly reduced | No new counter mechanic |
| General | Resist reward is slightly improved | Must not replace Embrace tension |

These examples are design direction, not locked numerical tuning. Detailed trial structure belongs in [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md).

## Wolf Aspect

**Role:** aggression, pursuit, and selected-target pressure.

**Fantasy:** a predatory mutation that turns Beast Blood aggression into prey pressure and relentless offense.

**Core loop:** mark prey, stay aggressive, build pressure, finish the target, and chain momentum.

**Tier direction:**

- Tier I: prey mark and target-pressure foundation
- Tier II: consecutive hits build additional posture/damage pressure
- Tier III: bonuses against wounded prey
- Tier IV: high-risk chain-pressure state

**Technique weighting:** prey, pursuit, consecutive pressure, wounded targets, Dash Slash re-entry, execution momentum, and prosthetic options that isolate or control prey.

**Visual transformation:** red eyes, sharper stance, blood trail on marked prey, and a controlled feral aura. Akio must remain recognizably samurai-shaped rather than becoming a full beast.

**Drawback direction:** tunnel-vision risk, weaker defense while pursuing, penalties from unmarked enemies, or reduced blocking efficiency at higher Tiers.

**Animation/VFX needs:** prey mark, pressure streaks, blood trail, and a brief aggression aura.

**Constraint:** Wolf is target pressure and pursuit—not generic attack speed.

## Wraith Aspect

**Role:** evasion, repositioning, and punishment after clean avoidance.

**Fantasy:** a spectral mutation that lets Akio approach bodily dissolution without losing his physical form.

**Core loop:** bait an attack, dodge cleanly, reposition, and punish from the flank or rear.

**Tier direction:**

- Tier I: dodge-punish bonus
- Tier II: afterimage support
- Tier III: flank/backstrike payoff
- Tier IV: enhanced ghost dodge or mist-step

**Technique weighting:** perfect dodge, repositioning, flanking, Dash Slash, recovery manipulation, clean-avoidance rewards, and tactical movement prosthetics.

**Visual transformation:** mist trails, pale-red afterimages, smoky blade trails, and partial wraith silhouette at high Tiers.

**Drawback direction:** increased fragility if struck directly, weaker blocking, or higher posture damage when caught outside the intended dodge window.

**Animation/VFX needs:** perfect-dodge cue, afterimage, mist-step, backstrike cue, and ghost-dodge effect.

**Constraint:** Wraith is avoidance into punishment. It must remain distinct from Wolf's aggression and from Mist Raven's tool-based fixed blink.

## Ronin Aspect

**Role:** sword discipline, parries, posture, Counter Cuts, and deathblows.

**Fantasy:** a disciplined mutation that reinforces the fundamentals of Akio's sword game.

**Core loop:** stand ground, perfect parry, pressure posture, Counter Cut or deathblow, then reset with control.

**Tier direction:**

- Tier I: perfect parries deal more posture pressure
- Tier II: stronger Counter Cut
- Tier III: deathblows restore health/posture or grant Focus
- Tier IV: parry/counter/deathblow chain momentum

**Technique weighting:** parry, Counter Cut, posture control, Focus, deathblow, guard timing, and defensive prosthetic mastery.

**Visual transformation:** blood-lit blade edge, sharper parry spark, calm red aura after deathblow, and a controlled human silhouette.

**Drawback direction:** less efficient blocking, more dangerous missed parries, and reduced benefit from evasive or chase-heavy play.

**Animation/VFX needs:** enhanced parry spark, Counter Cut trail, deathblow Focus cue, and posture-break emphasis.

**Constraint:** Ronin is likely the first/default Aspect. It should be reliable and fundamentals-focused rather than intentionally weak.

## Detailed design package

The high-level identities and Tier directions above are approved. The following decisions must be resolved here before the launch Technique coverage and catalog count can be approved.

### Shared Tier contract

Decide:

- whether Tier 0 grants each Aspect's core active mechanic immediately or only establishes selection, affinity, and presentation,
- whether Tier benefits accumulate, replace earlier behavior, or may do either under a consistent rule,
- whether drawbacks accumulate, transform, or use another clearly communicated structure,
- whether every Tier must add one benefit and one drawback or may deepen an existing pair,
- how much mechanical complexity one Tier may add,
- what Shrine behavior and reward remain available after Tier IV,
- how repeated Resist choices remain strategically meaningful,
- what Tier a typical successful run should commonly reach,
- and whether Tier IV is an expected endpoint, an optional high-risk capstone, or dependent on route and play quality.

The answer should define the structural contract, not final percentages, durations, Corruption rates, or Shrine frequency.

### Wolf mechanic definition

Before locking Wolf's Tier table, define:

- how Prey is selected,
- whether only one target may be Prey,
- whether selection is automatic, manual, or action-driven,
- what begins, maintains, breaks, and resets target pressure,
- how Prey transfers after a kill or invalid target,
- how Wolf functions in single-target boss encounters,
- what qualifies as wounded or finishable,
- and which parts of the loop belong to Tier 0, Tier I, or later Tiers.

### Wraith mechanic definition

Before locking Wraith's Tier table, define:

- what qualifies as a perfect dodge,
- whether perfect dodge is universal combat vocabulary or enabled primarily through Wraith,
- how the punish window begins and ends,
- how flank and rear position are detected,
- what backstrike means within the base combat system,
- what Mist-Step changes relative to the ordinary dash,
- how repeated avoidance builds or resets momentum,
- and how Wraith remains mechanically distinct from the Mist Raven prosthetic.

### Ronin mechanic definition

Before locking Ronin's Tier table, define:

- what Focus is,
- when Focus first becomes available,
- how it is gained, stored, refreshed, consumed, or lost,
- which actions benefit from Focus,
- whether deathblow recovery and Focus are separate or alternate directions,
- how missed-parry risk is expressed without making the fundamentals-focused Aspect excessively punitive,
- how Ronin remains useful against enemies with unusual posture or deathblow behavior,
- and which parts of the loop belong to Tier 0, Tier I, or later Tiers.

### Aspect approval tests

Each completed Aspect design must satisfy all of the following:

- it is functional before any Technique is acquired,
- every Tier strengthens the same tactical identity rather than adding unrelated powers,
- Embrace creates a meaningful benefit-and-drawback decision,
- Resist remains a valid situational choice,
- the Aspect does not make block, parry, dodge, posture, deathblow, or sword positioning broadly irrelevant,
- the Aspect supports several distinct four-Technique build shapes,
- ordinary Techniques remain useful outside their strongest affinity,
- and the three Aspects remain mechanically and visually distinct in common rooms, bosses, and mixed encounters.

## Current design order

Resolve this package in the following order:

1. shared Tier contract,
2. Wolf core mechanic and Tier 0–IV direction,
3. Wraith core mechanic and Tier 0–IV direction,
4. Ronin core mechanic and Tier 0–IV direction,
5. cross-Aspect distinction and overlap audit,
6. then Technique metadata, coverage, and catalog design.

## Visual production rule

Do not create twelve complete replacement Akio animation libraries. Use:

- one approved base Akio animation set,
- modular eyes, veins, markings, weapon treatments, auras, mist, trails, and limited silhouette accents,
- Aspect-specific VFX layered over the base animation,
- composable Tier escalation overlays.

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