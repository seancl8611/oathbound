---
id: GAMEPLAY-WRAITH-ASPECT
title: Wraith Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-05
topics:
  - blood-aspects
  - wraith
  - tier-0
  - tier-progression
  - blood-arts
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Wraith Blood Aspect

## Status

Wraith is an approved member of the three-Aspect launch roster.

Its qualitative Tier 0 weapon foundation and Tier I package are now approved for current scoping. Tier II-IV remain provisional candidates under ordered revision and must not be treated as final production scope until each later Tier is reviewed.

Wraith supersedes the earlier forced-reposition concept and the earlier spinning Blood Art. Its spacing identity comes from extended reach, deliberate attack selection, player aim, recovery, and spectral weapon expressions rather than mandatory lateral movement, target correction, special evasion, teleportation, or a replacement combat mode.

Exact numerical values, frame data, hitboxes, animation, detailed Blood presentation, Technique exceptions, and production counts remain implementation and playtesting work.

## Weapon identity

**Wraith is the extended spectral reach and frontal-control kit.**

Wraith is defined by:

- the longest average melee reach in the launch roster,
- a short two-hit Basic Attack sequence,
- a slower and more deliberate cadence than Wolf,
- narrow long-reaching lines and broad frontal spectral arcs,
- restrained movement during attacks,
- moderate individual Health damage,
- selected strong enemy-posture and guard-pressure tools,
- fixed player-directed attack geometry after commitment,
- and weakness when enemies collapse inside its preferred range or attack from outside its selected front.

Wraith gives up mobility, speed, close-range flexibility, and ordinary transition count in exchange for reach, attack selection, and frontal control.

Wraith does not use corrective tracking, hidden homing, automatic target selection, or an artificial point-blank damage dead zone. Close pressure is dangerous because its actions are frontal, deliberate, and comparatively limited—not because nearby enemies become immune to its attacks.

## Shared systems

Wraith retains universal locomotion, neutral dash, Defense input, ordinary parry timing, posture rules, deathblows, Technique inventory, and Prosthetic controls.

The player may stop the Basic sequence after either attack, defend, dash, reposition normally, use a Prosthetic, or disengage. Wraith does not gain additional invulnerability, automatic movement behind targets, forced offsets, or a stronger neutral dash.

# Approved Tier 0 kit

## Basic Attack sequence

### 1. Veil Cut

A precise, low-commitment extended line attack.

- narrow medium-to-long frontal line,
- quickest Wraith Basic startup,
- moderate Health and enemy-posture damage,
- little attack-bound movement,
- shortest Basic recovery,
- and best suited to short openings, spacing checks, and single-target pressure.

Veil Cut is the reliable ordinary attack. Its advantage is accurate reach and controlled commitment rather than heavy impact or broad coverage.

### 2. Passing Arc

A broader and more committed frontal-control follow-up.

- broad spectral sweep across Wraith's front,
- slower startup and longer recovery than Veil Cut,
- moderate Health damage,
- stronger enemy-posture and guard pressure than Veil Cut,
- useful contact against grouped or laterally adjacent frontal enemies,
- restrained authored movement,
- and no tracking or corrective rotation after commitment.

Passing Arc does not need greater maximum reach than Veil Cut. Its purpose is wider frontal control and stronger pressure, not simply being a superior second attack.

The approved Basic rhythm is:

> test or punish with a precise extended line → stop safely or commit to a broader frontal sweep

The two-hit sequence is intentionally retained. A third Basic Attack should be reconsidered only if prototype play shows that the poke-to-sweep decision remains unsatisfying after these roles are implemented clearly.

## Held Attack — Pale Lance

A long, narrow Blood-formed thrust or blade extension connected to the physical katana.

- Wraith's longest focused melee reach,
- very narrow attack line,
- stronger Health damage than Veil Cut,
- strong focused enemy-posture pressure,
- minimal forward movement,
- fixed direction after release,
- meaningful preparation,
- and severe miss recovery relative to Wraith's ordinary attacks.

Pale Lance is a focused punish for a confirmed opening. It is not a projectile, pursuit tool, or Ronin-level heavy impact attack.

## Dash Attack — Ghostline Slash

A controlled extended cut after the universal neutral dash.

- reliable startup,
- medium-to-long spectral reach,
- modest Health and enemy-posture damage,
- limited additional movement beyond the dash,
- fixed authored geometry after release,
- and quick return to movement or defense.

Ghostline Slash is Wraith's responsive re-entry and repositioning attack. It does not add invulnerability or become a second pursuit system.

## Parry Counter — Veil Reversal

A precise extended counter slash after the universal parry.

- extended narrow-to-medium frontal geometry,
- moderate Health damage,
- Wraith's strongest ordinary parry-to-posture conversion,
- limited forward movement,
- and controlled recovery.

Veil Reversal does not teleport, move behind the enemy, rotate toward a target after release, or alter universal parry timing.

## Defensive profile

Wraith retains functional blocking and universal parry timing.

Its defensive weakness is not an artificially weak guard. Its weakness is preserving useful spacing while using a small set of deliberate frontal actions. Close, lateral, and simultaneous pressure can force Wraith out of its preferred attack selection.

## Combat profile

| Property | Approved direction |
|---|---|
| Preferred range | Medium-to-long |
| Basic sequence | Two attacks |
| Cadence | Deliberate; faster than Ronin and slower than Wolf |
| Per-hit Health damage | Moderate |
| Sustained output | Below connected Wolf pressure |
| Enemy posture | Selected strong line, sweep, Held, and counter pressure |
| Ordinary stagger | Below Ronin |
| Attack movement | Restrained and player-directed |
| Main failure state | Poor spacing, wrong attack selection, lateral collapse, or a missed commitment |

## Encounter role

- **Mixed groups:** pressure priority targets from useful range and use Passing Arc to interfere with grouped frontal threats.
- **Crowds:** control a broad front but struggle when enemies surround, flank, or attack simultaneously.
- **Ranged pressure:** reach exposed targets through extended attacks, universal dash, and Prosthetics without becoming a projectile or room-crossing pursuit kit.
- **Elites and bosses:** punish from the edge of threat range, use Veil Cut during short openings, and reserve Pale Lance for confirmed commitments.

# Approved Tier I package

## Headline benefit — Pale Barrage

Pale Lance gains a continued held form.

After the initial Pale Lance thrust, continuing to hold the attack input causes Akio to unleash a rapid series of spectral jabs along the original Pale Lance direction. Releasing ends the barrage early; continuing to hold performs the current maximum sequence.

Approved boundaries:

- the original single Pale Lance remains available by releasing without continuing,
- each additional jab deals lower individual Health and enemy-posture damage than the initial thrust,
- a completed barrage delivers strong combined Health and posture pressure during a sufficiently long opening,
- Akio remains stationary once the barrage begins,
- aim adjustment is highly limited after commitment unless a later approved Tier explicitly changes it,
- the jabs do not track, rotate automatically, or select targets independently,
- longer continuation creates longer exposure to retaliation, flanking, and threats outside the selected line,
- and releasing early sacrifices remaining damage in exchange for ending the commitment sooner.

Pale Barrage is one authored multi-hit Held Attack rather than a separate status, meter, or stored reward. Blood generation, Technique triggers, healing, and other per-hit interactions must be weighted so its additional jabs do not receive unrestricted full-value independent procs.

The Tier I Held rhythm is:

> use a single Pale Lance for a confirmed medium opening → continue into Pale Barrage only when the opening supports sustained stationary commitment → release before the line becomes unsafe

## Supporting growth rule — Spectral Edge

Beginning at Tier I, Wraith attacks that connect through the spectral extension beyond the physical katana's ordinary reach gain a modest enemy-posture and guard-pressure bonus.

Each Embrace from Tier I through Tier IV modestly increases this bonus.

Qualifying primary attacks are:

- Veil Cut,
- Passing Arc,
- Pale Lance's initial thrust,
- Ghostline Slash,
- and Veil Reversal.

Approved boundaries:

- the bonus requires contact through the spectral-only portion of the authored attack geometry,
- physical-blade-range contact receives no Spectral Edge bonus,
- the bonus improves enemy-posture and guard pressure rather than Health damage,
- it adds no reach, width, movement, tracking, correction, interruption resistance, or recovery reduction,
- it does not create automatic stagger against elites or bosses,
- Pale Barrage's additional jabs do not each receive a full independent Spectral Edge bonus,
- delayed, secondary, shade, or repeated hits do not independently receive Spectral Edge unless a later Tier explicitly defines a restricted interaction,
- and the rule uses no meter, stack counter, timer, random chance, or stored reward.

Spectral Edge rewards the player for maintaining Wraith's intended spacing rather than simply granting generic stat growth. A close-range hit remains fully functional; a correctly spaced spectral hit creates stronger posture and guard pressure.

The complete Tier I rhythm is:

> preserve useful distance → choose the correct line or arc → gain modest Spectral Edge pressure through spectral-only contact → use Pale Barrage only when the opening is large enough

# Provisional later-Tier candidates

The following sections preserve the current working candidates for discussion. They are not approved production scope.

## Tier II candidate — Wraith's Reach

The current candidate unlocks Wraith's Blood meter and a temporary empowered state.

Provisional behavior:

- a full meter activates manually and is consumed,
- Blood does not generate while the duration state is active,
- Veil Cut, Passing Arc, and Pale Lance gain additional spectral reach,
- qualifying primary attacks create one delayed spectral afterimage along the original player-selected line or arc,
- afterimages do not track, home, rotate, or independently select targets,
- an afterimage may hit an enemy that remains in or enters its geometry and misses if the enemy leaves,
- Akio retains ordinary movement, dash, block, parry, attacks, deathblows, and Prosthetics,
- and ordinary startup, recovery, commitment, and restrained attack movement remain unchanged.

Provisional interaction boundaries:

- Pale Lance creates at most one full delayed afterimage whether or not it continues into Pale Barrage,
- additional Pale Barrage jabs may receive the reach extension but do not each create full afterimages,
- echoes deal lower Health damage than the corresponding primary strike and emphasize meaningful posture pressure,
- echoes generate no Blood,
- echoes receive restricted Technique, healing, and proc weighting,
- and echoes do not independently receive Spectral Edge.

The Tier II review must determine whether this duration state is the correct Blood Art form, whether it provides enough immediate activation value, and whether an immediate or shorter frontal-control action would fit Wraith better.

## Tier III candidate — Veiled Guard

The current candidate permits one manually timed spectral parry during each Pale Lance use, including when that use continues into Pale Barrage.

Provisional boundaries:

- normal parry timing and attack eligibility apply,
- the spectral manifestation may intercept an eligible attack from any direction without rotating Akio,
- success preserves the current Pale Lance charge or Pale Barrage channel,
- entering Pale Barrage does not refresh the use,
- a mistime provides no fallback block or protection,
- and the effect adds no healing, Blood refund, automatic counter, easier timing, or passive defense.

This candidate remains dependent on the final Tier II and broader Tier distribution.

## Tier IV candidate — Pale Procession

The current candidate adds two reduced-power adjacent spectral barrage lanes while Akio channels Pale Barrage.

Provisional boundaries:

- Akio remains the central and strongest stream,
- left and right shades create adjacent frontal lanes,
- the formation may rotate slowly through direct player input within a limited frontal arc,
- the formation does not track or snap to enemies,
- Akio remains stationary,
- releasing or being interrupted ends all streams,
- only one stream may damage an enemy during each authored barrage beat,
- central-stream contact takes priority,
- and shade hits generate no Blood, no delayed echoes, and restricted proc value.

This candidate is intended as a frontal-coverage and reliability upgrade rather than a single-target damage multiplier. Its final role remains dependent on the Tier II and Tier III reviews.

# Technique space

Universal Techniques may reinforce or broaden Wraith's:

- reach and spectral-only spacing,
- line and arc coverage,
- Pale Lance and Pale Barrage,
- dash attacks and parry counters,
- posture continuity,
- close-range handling,
- re-entry,
- or whiff recovery.

Techniques must not simply duplicate Spectral Edge's deterministic spacing reward or turn Wraith into a tracking, projectile, teleportation, or autonomous-companion kit.

A strong Wraith Technique build at Tier 0-I must remain capable of completing a run without a Blood Art or later Tier.

# Presentation requirements

Wraith's Blood-formed katana should feel elongated, spectral, precise, and light in visual motion while remaining visibly connected to the physical katana.

Tier 0 must communicate:

- Veil Cut as the precise low-commitment line,
- Passing Arc as the broader committed sweep,
- Pale Lance as the longest focused punish,
- Ghostline Slash as controlled dash re-entry,
- and Veil Reversal as the posture-focused counter.

Spectral Edge requires readable but restrained feedback distinguishing:

- physical-blade contact,
- spectral-only contact,
- and the modestly increasing Tier I-IV posture and guard-pressure reward.

The feedback must not imply a critical hit, separate meter, or large Health-damage multiplier.

Pale Barrage requires clear continuation, early-release, stationary commitment, and diminishing per-jab impact communication without hiding enemy telegraphs.

# Production requirements

The approved Tier 0-I package establishes requirements for:

- distinct Veil Cut and Passing Arc timing, geometry, recovery, and hit response,
- clear physical and spectral hit-region ownership,
- deterministic Spectral Edge qualification and scaling,
- Spectral Edge posture and guard-pressure feedback,
- Pale Lance charge, release, miss, and recovery presentation,
- Pale Barrage continuation, early release, maximum sequence, and interruption behavior,
- restricted multi-hit Blood, Technique, healing, and proc weighting,
- Shrine summaries for Pale Barrage and Spectral Edge,
- and Tier 0-I teaching and mastery-trial coverage.

Tier II-IV production requirements remain provisional until those Tiers are individually approved.

# Remaining Wraith work

The current active design question is Tier II and Wraith's Blood Art form.

Remaining ordered work is:

1. compare Wraith's Reach against immediate or concise non-duration Blood Art alternatives,
2. select the Tier II Blood Art and guaranteed activation value,
3. redistribute Tier III-IV around that decision,
4. audit Spectral Edge interactions with the selected later package,
5. complete cross-roster comparison against Wolf and Ronin,
6. finalize animation, VFX, audio, HUD, Shrine, selection, and trial requirements,
7. and validate the package through prototypes and playtesting.

Exact timing, damage, posture, guard pressure, spectral hit-region size, Pale Barrage jab count and duration, recovery, Blood values, proc weighting, later-Tier behavior, and presentation values remain implementation and playtesting work.