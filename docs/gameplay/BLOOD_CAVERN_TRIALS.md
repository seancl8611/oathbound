---
id: GAMEPLAY-BLOOD-CAVERN-TRIALS
title: Blood Cavern Trial System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - trials
  - training
  - blood-aspects
  - techniques
  - blood-mirror
  - mastery
related:
  - CONTENT-STRAND-BLOOD-CAVERN
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROGRESSION
---

# Blood Cavern Trial System

## Purpose

Provide repeatable, skill-focused activities in the Strand that teach combat, unlock Blood Aspects, demonstrate selected Technique interactions, and reward mastery without depending on run RNG.

## Trial families

### Basic Combat Trials

- parry,
- posture pressure and posture break,
- deathblow,
- dodge,
- perilous-attack response,
- Counter Cut,
- Dash Slash.

### Wolf Trials

- mark prey,
- maintain selected-target pressure,
- defeat marked targets before the mark expires,
- chain pressure across targets.

### Wraith Trials

- perfect dodge,
- reposition,
- mist-step,
- flank or backstrike punish,
- avoid pressure while countering.

### Ronin Trials

- perfect parry,
- Counter Cut,
- posture break,
- deathblow,
- stand-ground defense.

### Technique Demonstrations

Selected instructional trials may use fixed Techniques to teach:

- how one standalone Technique modifies an existing combat verb,
- how a refinement deepens its base Technique,
- how a Prosthetic Technique changes the equipped tool,
- how shared combat verbs create natural synergy without exact-combination dependence.

These demonstrations do not create a persistent equipped Technique loadout.

### Advanced and Mastery Trials

Later challenges may combine mechanics, impose fixed Aspect, Technique, prosthetic, or Relic loadouts, or test execution under stricter conditions. They should remain deterministic enough that failure teaches a clear lesson.

## Reward philosophy

Trials may award:

- Blood Aspect unlocks,
- approved Technique-pool unlocks,
- permanent currency,
- small permanent Aspect upgrades,
- cosmetics,
- lore reflections,
- challenge-completion marks.

Rewards must not replace the in-run Shrine Embrace Tier system or permanently pre-equip a run Technique.

Unlocking a Technique through a trial means adding it to future eligible reward pools, not granting it at the start of every run.

## Permanent Aspect upgrade rule

Permanent Aspect upgrades are small, capped, and reliability-focused. They may make an existing loop easier to execute, but they must not add a new Tier, remove the danger of Embrace, or introduce the Aspect's major run-changing mechanics.

Illustrative directions from the production bible:

| Aspect | Upgrade direction | Constraint |
|---|---|---|
| Wolf | Prey mark lasts slightly longer | No new Prey behavior |
| Wolf | Pressure bonus builds slightly faster | No new attack |
| Wraith | Perfect-dodge punish window lasts slightly longer | No new dodge type |
| Wraith | Mist-step recovery is slightly reduced | No additional invulnerability spike |
| Ronin | Perfect parries deal slightly more posture damage | Do not broadly widen the parry window |
| Ronin | Counter Cut recovery is slightly reduced | No new counter mechanic |
| General | Resist reward is slightly improved | Must not replace Embrace tension |

These are design examples rather than final numerical tuning.

## Technical requirements

- Trials must be repeatable.
- Fixed conditions and standardized Aspect, Technique, prosthetic, and Relic loadouts must be supported.
- Progress, unlocks, rewards, and permanent upgrade ranks must persist.
- Temporary trial Techniques clear when the trial ends.
- Trial rules should not require random room or reward generation.
- The framework should permit future challenge ladders, boss rematches, or score modes without becoming a required promise for current scope.
