---
id: CONTENT-AREA1-COMBAT-PLAYTEST-TARGET
title: Hushiro Player-Paced Combat Playtest Target
category: content
status: approved
authority: primary
last_reviewed: 2026-09-12
topics:
  - area-1
  - hushiro
  - combat-v2
  - encounter-pacing
  - waves
  - durability
related:
  - CONTENT-AREA1-IMPLEMENTATION-BASELINE
  - GAMEPLAY-COMBAT-V2-DIRECTION
---

# Hushiro Player-Paced Combat Playtest Target

This file owns the next manual-playtest readiness target for **normal Area 1 / Hushiro combat rooms**. It refines the earlier first-playtest tuning in `HUSHIRO_IMPLEMENTATION_BASELINE.md` where the two conflict. The older encounter identities, eligibility windows, room roles, enemy identities, and overall authored encounter pool remain valid; this file changes the intended **combat speed, standard-enemy kill time, guard frequency framing, and intra/inter-wave pacing**.

The goal is to move ordinary Hushiro combat decisively toward a **player-paced supernatural hack-and-slash / action-roguelite rhythm** while preserving Oathbound's Posture, parry, commitment, enemy-specific guard, and Deathblow layers.

A normal weak enemy is **not supposed to be a major threat as a lone target**. Area 1 difficulty should primarily emerge from enemy combinations, overlapping intentions, movement, wave pressure, target priority, geometry, and occasional authored defense. Individual Health pools should not force ordinary encounters into repeated duels.

# Playtest readiness gate

Do not present a new Combat V2 manual-playtest branch as the intended Area 1 feel until the Godot runtime supports all of the following:

1. A skilled player can dash into a normal engagement and kill an Area 1 standard Swordsman in about **5 clean base-katana hits** if none are guarded. Most ordinary Area 1 bodies should fall within roughly **4-5 clean hits**, not require the full six-hit pressure string.
2. A meaningful Swordsman guard can deny that otherwise lethal five-hit line. The player may then continue into hit six, keep pressure, or disengage/reposition; one block should create variation without turning a standard soldier into a long solo fight.
3. Corrupted Archers are distinctly fragile once reached; the initial target is roughly **4 clean base-katana hits**.
4. The Warden remains the deliberate durable standard-enemy extreme; the initial target remains roughly **10-11 clean base-katana hits**, before considering successful full-Health blocks.
5. Lightweight Hollow/Hound bodies remain faster to remove than the standard Swordsman and derive danger from numbers, movement, and pressure rather than individual durability. Hollows may die in roughly **3 clean hits** and Hounds in roughly **4**.
6. Clearing the current active wave launches the next authored wave **immediately**. There is no intentional 0.9-second dead-air pause between normal wave clears.
7. A long **120-second Area 1 anti-stall timer** may launch the next authored wave while survivors remain. This is a fail-safe/escalation rule, not the normal expected route through an encounter.
8. Waves can author different arrival styles. A wave is a scripted set of enemy arrivals, **not a promise that all members appear on the same frame**.
9. Encounters are balanced at the **whole-encounter level for their point in the run**, not by forcing every wave to have equal population, equal duration, or equal difficulty.

# Player-paced kill-time calibration

The initial calibration anchor is the approved pre-awakening base-katana basic sequence in `AspectCatalog.gd`:

- Quick Slash: **9 Health damage**
- Cross Cut: **12 Health damage**
- Heavy Cleave: **21 Health damage**
- first 3 hits: **42 Health damage**
- first 4 hits: **51 Health damage**
- first 5 hits: **63 Health damage**
- full 6-hit pressure string: **84 Health damage**

The six-hit string is a **player pressure capability**, not the default Health requirement for a normal Area 1 enemy. Standard enemies should usually die before Akio reaches the endpoint if the attacks land cleanly.

This produces the revised Area 1 targets:

| Enemy | Initial Health target | Clean base-katana expectation | Defensive interpretation |
|---|---:|---|---|
| Hollow | 40 | about 3 hits | fragile fodder; danger comes from swarm pressure |
| Blighted Hound | 50 | about 4 hits | predator pressure and mobility are the defense |
| Corrupted Archer | 45 | about 4 hits | weak/occasional reactive guard can sometimes extend the kill |
| Corrupted Swordsman | 60 | 5 hits | one meaningful guard should deny the clean 5-hit kill, usually extending it rather than creating a long duel |
| Cellar Bilemass | 60 | about 5 hits | no guard; hazard pressure and committed spit Poise are the defense |
| Warden | 140 | about 11 hits | durable exception; short full-Health guard can extend the fight |

These are **manual-playtest starting values**, not universal game-wide ratios. Later regions, enemy tiers, variants, difficulty layers, Techniques, Aspects, and run scaling may change kill-time expectations.

## Why Swordsman 60 is intentional

The clean first five hits deal **63 Health damage**, so a 60-Health Swordsman dies if the player lands the pressure cleanly. Its current authored guard passes only 35% of Health damage. Even if it guards the lightest 9-damage hit, the five-hit total falls to about **57 Health damage**, which lets it survive.

That produces the intended Area 1 interaction:

**clean offense -> standard soldier dies in about five hits**  
**one successful defense -> five-hit kill is denied, but the player can extend pressure instead of entering a long duel**

The sixth Heavy remains valuable as a pressure extension after a guarded hit. This keeps blocking meaningful while preserving the hack-and-slash expectation that an ordinary soldier is still disposable once Akio successfully gets on top of it.

# Guard frequency, not per-hit universal RNG

"Block chance" in design discussion means **effective lifetime guard frequency**, not a mandatory universal random roll on every incoming sword hit.

Area 1 should initially read as:

- **Hollow:** no traditional guard.
- **Hound:** no traditional guard.
- **Bilemass:** no guard.
- **Archer:** low-frequency weak reactive guard; closing distance should still make it vulnerable.
- **Swordsman:** moderate tactical guard frequency. It should sometimes interrupt a clean five-hit kill line, but not make every approach become a blocking duel.
- **Warden:** the highest defensive resistance among standard Area 1 enemies, but through short authored guard windows, restraint/control identity, Health, and committed Poise rather than permanent blocking.

Future enemy tiers / later areas / higher difficulty may raise effective guard frequency by changing guard intent bias, guard readiness, cooldowns, or authored behavior. Prefer those decision-boundary tools over per-frame randomness.

# Area 1 wave flow

## Primary progression rule: clear -> immediate next wave

The normal loop is:

**spawn authored wave -> fight -> all active enemies defeated -> next authored wave begins immediately**

The next wave's first arrival should begin without an intentional downtime pause. Spawn tells and authored stagger intervals provide readability; dead air should not.

## Anti-stall escalation

If the player has not cleared the active pressure for **120 seconds** after a wave becomes engaged, the encounter may begin the next authored wave even while survivors remain.

Rules:

- this timer is deliberately long and should almost never affect a normal successful Area 1 clear,
- the timer resets when the next authored wave begins,
- the timeout is an escalation / anti-idle mechanism, not the primary cadence,
- normal Area 1 spawning remains tuned around a six-body readability cap,
- a timeout may temporarily permit a small overflow beyond that normal cap so the escalation is real rather than merely queued invisibly,
- deeper regions/difficulties may later use shorter timers or more deliberate wave overlap, but that is **not** assumed for this Area 1 target.

# A wave is an arrival script, not a simultaneous packet

Each wave may use one of several authored arrival styles:

- **Burst:** enemies enter nearly together. Use for readable spikes, compact packs, and final-wave pressure.
- **Staggered:** the wave's enemies enter over a short sequence. Use to create a rolling fight without turning the wave into disconnected one-on-one duels.
- **Sequence:** enemies arrive one after another with clearly perceptible spacing. Use selectively for reinforcement feel, target-priority changes, or a wave intended to build over several seconds.

A wave can therefore contain four enemies while only one or two are initially visible, with the rest entering as authored reinforcements. The wave is still one wave because all of those arrivals belong to the same scripted encounter beat.

Spawn order can matter. Examples:

- an Archer may appear first, followed by Hollows that complicate the player's route to it,
- a Warden may establish restraint pressure before supporting Swordsmen arrive,
- a Hollow sequence may feed fragile bodies rapidly enough that an experienced player cuts through them almost continuously,
- a Hound pack can remain a fast burst rather than being artificially serialized just because sequence spawning exists.

Do **not** make every wave use the same arrival style.

# Encounter-level balance

Balance the **complete encounter at its eligible point in the run**. Do not normalize every wave.

Valid encounter shapes include:

- several very fast/easy waves followed by one difficult spike,
- a difficult opening followed by shorter cleanup/reinforcement waves,
- a mostly even encounter with no dramatic spike,
- a short two-wave encounter whose waves are individually substantial,
- a four-wave encounter where several waves clear in seconds but the total room still has appropriate substance.

Some waves may take only a few seconds for a skilled player. A demanding mixed wave may take up to roughly a minute. That variance is desirable when the total encounter remains appropriate for its chamber eligibility and role.

The existing Hushiro pool already supports **2-, 3-, and 4-wave encounters** and different total enemy counts. Preserve that variability rather than forcing one template.

# Area 1 implementation constraints retained from Combat V2

- `PressureDirectorV2` controls dangerous impact timing; it does not turn waves back into single-enemy turns.
- Several enemies may approach, reposition, aim, wind up, or occupy space simultaneously.
- Health, Posture, and Poise remain separate axes.
- Enemy PostureBar remains visible and canonical until an explicitly approved replacement exists.
- Taking Health damage does not automatically cancel a committed action; Poise owns immediate interruption.
- Deathblow remains a useful tactical reward, not a requirement for defeating every standard enemy.
- Standard enemy difficulty should increasingly come from composition, timing, geometry, priority, and overlapping intentions rather than oversized individual Health bars.
- Weak standard enemies should feel dangerous **together**, not because each one individually survives a long combo.

# What the next manual playtest should answer

Once this target exists in Godot, the next manual playtest should primarily answer:

- Does a clean five-hit Swordsman kill feel fast and satisfying without making mixed encounters effortless?
- Does a defended Swordsman usually require only a small pressure extension rather than becoming a duel?
- Do Archers/Hounds disappear quickly enough when Akio successfully reaches them?
- Do Hollows feel appropriately disposable as individual fodder?
- Does the Warden feel meaningfully durable at roughly 10-11 clean hits without feeling like an HP sponge once its control tools are understood?
- Does immediate wave chaining keep momentum after a clear?
- Do burst/staggered/sequence arrivals make encounters less repetitive?
- Do whole encounters feel appropriately substantial even when individual enemies die quickly?
- Does the 120-second anti-stall rule remain effectively invisible during normal skilled play?
