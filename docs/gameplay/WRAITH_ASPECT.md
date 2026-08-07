---
id: GAMEPLAY-WRAITH-ASPECT
title: Wraith Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-06
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

Its qualitative Tier 0 weapon foundation and complete Tier I-IV progression are approved for current scoping. Exact numerical values, frame data, hitboxes, animation, detailed Blood presentation, Technique exceptions, and production counts remain implementation and playtesting work.

Wraith supersedes the earlier forced-reposition concept, the earlier spinning Blood Art, the former duration-state version of Wraith's Reach, the former Veiled Guard Tier III candidate, and the former Pale Procession Tier IV candidate. Its identity comes from extended reach, deliberate attack selection, player aim, recovery, spectral weapon expressions, corridor control, formation penetration, and final mastery of distant engagement and execution rather than mandatory lateral movement, target correction, special evasion, teleportation, generic armor, a generic moveset buff, or a replacement combat mode.

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
- a Tier II immediate Blood Art that controls one chosen frontal corridor and repeats it after a delay,
- Tier III formation penetration through ordinary-enemy lines,
- Tier IV distant engagement and deathblow initiation,
- and weakness when enemies collapse inside its preferred range or attack from outside its selected front.

Wraith gives up mobility, speed, close-range flexibility, and ordinary transition count in exchange for reach, attack selection, frontal control, delayed corridor pressure, formation penetration, and the ability to engage or execute from spectral distance at maximum investment.

Wraith does not use corrective tracking, hidden homing, automatic target selection, or an artificial point-blank damage dead zone. Close pressure is dangerous because its actions are frontal, deliberate, and comparatively limited—not because nearby enemies become immune to its attacks.

## Shared systems

Wraith retains universal locomotion, neutral dash, Defense input, ordinary parry timing, posture rules, deathblows, Technique inventory, and Prosthetic controls.

The player may stop the Basic sequence after either attack, defend, dash, reposition normally, use a Prosthetic, or disengage. Wraith does not gain additional neutral-dash distance or invulnerability, automatic movement behind targets, forced offsets, or a stronger ordinary dash.

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
| Enemy posture | Selected strong line, sweep, Held, counter, Blood Art, and formation pressure |
| Ordinary stagger | Below Ronin |
| Attack movement | Restrained and player-directed |
| Main failure state | Poor spacing, wrong attack selection, lateral collapse, or a missed commitment |

## Encounter role

- **Mixed groups:** pressure priority targets from useful range, use Passing Arc to interfere with grouped frontal threats, and at Tier III strike through ordinary front ranks.
- **Crowds:** control a broad front and layered ordinary formations but struggle when enemies surround, flank, or attack simultaneously.
- **Ranged pressure:** reach exposed targets through extended attacks, universal dash, and Prosthetics without becoming a projectile or room-crossing pursuit kit.
- **Elites and bosses:** punish from the edge of threat range, use Veil Cut during short openings, reserve Pale Lance for confirmed commitments, and place Wraith's Reach where the target is likely to remain or return. Spectral Passage does not create unrestricted single-target multiplication against them.

# Approved Tier I package

## Headline benefit — Pale Barrage

Pale Lance gains a continued held form.

After the initial Pale Lance thrust, continuing to hold the attack input causes Akio to unleash a rapid series of spectral jabs along the original Pale Lance direction. Releasing ends the barrage early; continuing to hold performs the current maximum sequence.

Approved boundaries:

- the original single Pale Lance remains available by releasing without continuing,
- each additional jab deals lower individual Health and enemy-posture damage than the initial thrust,
- a completed barrage delivers strong combined Health and posture pressure during a sufficiently long opening,
- Akio remains stationary once the barrage begins,
- aim adjustment is highly limited after commitment,
- the jabs do not track, rotate automatically, or select targets independently,
- longer continuation creates longer exposure to retaliation, flanking, and threats outside the selected line,
- and releasing early sacrifices remaining damage in exchange for ending the commitment sooner.

Pale Barrage is one authored multi-hit Held Attack rather than a separate status, meter, or stored reward. Blood generation, Technique triggers, healing, and other per-hit interactions must be weighted so its additional jabs do not receive unrestricted full-value independent procs.

The Tier I Held rhythm is:

> use a single Pale Lance for a confirmed medium opening → continue into Pale Barrage only when the opening supports sustained stationary commitment → release before the line becomes unsafe

## Supporting growth rule — Spectral Edge

Beginning at Tier I, qualifying Wraith attacks that connect through the spectral extension beyond the physical katana's ordinary reach gain a modest enemy-posture and guard-pressure bonus.

Each Embrace from Tier I through Tier IV modestly increases this bonus.

From Tier I through Tier III, qualifying primary attacks are:

- Veil Cut,
- Passing Arc,
- and Veil Reversal.

Pale Lance's initial thrust and Ghostline Slash do not qualify for Spectral Edge before Tier IV. Their Tier IV eligibility is an explicit part of Beyond the Veil rather than an implicit Tier I property.

Approved boundaries:

- the bonus requires contact through the spectral-only portion of the authored attack geometry,
- physical-blade-range contact receives no Spectral Edge bonus,
- the bonus improves enemy-posture and guard pressure rather than Health damage,
- it adds no reach, width, movement, tracking, correction, interruption resistance, or recovery reduction,
- it does not create automatic stagger against elites or bosses,
- Pale Barrage's additional jabs do not receive full independent Spectral Edge bonuses,
- delayed, secondary, repeated, and Blood Art hits do not independently receive Spectral Edge unless an approved Tier explicitly defines a restricted interaction,
- and the rule uses no meter, stack counter, timer, random chance, or stored reward.

Spectral Edge rewards the player for maintaining Wraith's intended spacing rather than simply granting generic stat growth. A close-range hit remains fully functional; a correctly spaced qualifying spectral hit creates stronger posture and guard pressure.

The complete Tier I rhythm is:

> preserve useful distance → choose the correct line or arc → gain modest Spectral Edge pressure through qualifying spectral-only contact → use Pale Barrage only when the opening is large enough

# Approved Tier II package

## Blood Art — Wraith's Reach

Tier II unlocks Wraith's Blood meter and **Wraith's Reach**, an immediate two-stage frontal Blood Art followed by one delayed spectral repetition.

Wraith's Reach follows the shared Blood defaults:

- it requires a full meter,
- activates manually,
- consumes the stored Blood when the Art commits,
- generates no Blood while its authored action and delayed echo are resolving,
- and Blood generation resumes after the complete Art finishes.

The player selects one direction during a brief readable Blood manifestation. Once committed, the Art uses that fixed player-selected direction and cannot track, turn, home, retarget, or correct itself.

### Stage 1 — opening sweep

Akio releases a compact but broad spectral sweep across his immediate front.

- modest Health damage,
- strong enemy-posture and guard pressure,
- brief stagger against eligible ordinary enemies,
- modest enemy-posture pressure without automatic stagger against elites and bosses,
- frontal coverage only,
- and no protection against side, rear, perilous, grabbing, launching, or simultaneous threats.

The opening sweep is Wraith's Reach's guaranteed activation value. It is not a full-circle panic effect, posture clear, heal, automatic parry, or invulnerability window.

### Stage 2 — corridor strike

Immediately after the sweep, Akio drives the spectral katana through a very long narrow-to-medium frontal corridor.

- moderate Health damage,
- strong enemy-posture and guard pressure,
- longer reach than Wraith's ordinary attacks,
- little or no forward pursuit,
- fixed authored corridor after commitment,
- no corrective rotation,
- and normal vulnerability and interruption behavior.

### Delayed spectral echo

A short beat later, a spectral Wraith repeats the corridor strike along the exact same authored geometry and player-selected direction.

- lower Health damage than the primary corridor strike,
- meaningful enemy-posture and guard pressure,
- no Blood generation,
- no tracking, turning, homing, retargeting, or independent target selection,
- and no persistence outside the authored delay and strike timing.

An enemy that leaves the corridor before the echo resolves avoids it. An enemy that remains in or enters the corridor may be struck.

### Interruption and failure rules

Wraith's Reach grants no healing, player-posture clearing, damage reduction, interruption resistance, super armor, automatic defense, Blood refund, movement correction, or guaranteed corridor hit.

The directional preparation, corridor commitment, and ending recovery remain vulnerable through ordinary combat rules. A poor line may miss the priority target, allow mobile enemies to leave before the echo, or leave Akio exposed to pressure outside the selected front.

### Spectral Edge and system interactions

Tier II advances Spectral Edge by its normal second Tier step for currently qualifying ordinary primary attacks.

Wraith's Reach uses its own authored Health, posture, guard-pressure, and stagger values:

- the opening sweep does not independently trigger Spectral Edge,
- the primary corridor strike does not independently trigger Spectral Edge,
- the delayed echo does not independently trigger Spectral Edge,
- the echo receives restricted Technique, healing, and other proc weighting,
- the echo cannot recursively create another echo,
- and none of the Art's stages generate Blood.

The approved Tier II rhythm is:

> fill Blood through ordinary combat → identify a valuable frontal line → commit Wraith's Reach and stabilize the immediate front with the opening sweep → drive one extended corridor strike → reposition or defend while the delayed echo punishes enemies that remain in or enter the chosen geometry

The launch-roster Blood Art distinction is:

> Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point

# Approved Tier III package

## Headline benefit — Spectral Passage

At Tier III, the spectral portion of Wraith's qualifying ordinary attacks is no longer occluded by the first ordinary enemy it contacts. It continues through the remaining authored line or arc and may strike additional ordinary enemies layered behind or across the same selected frontal geometry.

Qualifying attacks are:

- Veil Cut,
- Passing Arc,
- Pale Lance's initial thrust,
- Ghostline Slash,
- and Veil Reversal.

Spectral Passage eligibility is independent of Spectral Edge eligibility. At Tier III, Pale Lance and Ghostline Slash may pass through ordinary enemies but do not yet receive Spectral Edge.

The first or primary contacted enemy receives the attack's normal authored Health, posture, guard, and stagger result. Additional ordinary enemies reached through Spectral Passage receive:

- reduced Health damage,
- meaningful enemy-posture and guard pressure,
- reduced ordinary-enemy stagger where appropriate,
- and no additional hit against an enemy already struck by that action.

Spectral Passage is built into the existing attacks. It adds no new input, mode, stored state, follow-up command, or separate meter.

## Collision and stopping rules

Spectral Passage preserves Wraith's authored geometry:

- the attack gains no extra reach or width,
- it follows the original player-selected line or arc,
- it cannot turn, track, home, retarget, bounce, or seek another enemy,
- the physical katana and solid world geometry retain ordinary collision behavior,
- elites, bosses, protected heavy enemies, and other authored stopping bodies stop further passage after receiving their valid contact,
- and one qualifying action may strike each eligible enemy at most once.

An elite or boss may still be struck normally as the first target or after ordinary enemies, but Tier III does not allow the same attack to pass through that stopping target and return extra damage to it.

## Pale Barrage and Blood Art boundaries

Pale Barrage's additional jabs do not each receive unrestricted full Spectral Passage behavior. The initial Pale Lance thrust qualifies; the repeated jabs remain one separately weighted stationary multi-hit sequence.

Wraith's Reach remains a complete self-contained Blood Art. Its opening sweep, corridor strike, and delayed echo do not gain extra Tier III hits, create new passage chains, or trigger another echo.

## Spectral Edge and system interactions

Tier III advances Spectral Edge by its normal third Tier step.

For enemies reached after the primary contact:

- contact through the spectral-only region may receive a restricted Spectral Edge posture and guard-pressure contribution only when the originating attack is Spectral Edge-eligible at the current Tier,
- secondary passage contacts do not receive unrestricted full-value Spectral Edge multiplication,
- secondary contacts generate no Blood,
- Technique, healing, status, and other per-hit effects use restricted or separately authored weighting,
- and Spectral Passage cannot recursively trigger itself or another secondary attack.

The approved Tier III rhythm is:

> identify a layered frontal formation → choose the correct line or arc → strike through the ordinary front rank → pressure additional enemies occupying the same authored geometry → reposition before enemies collapse around the selected front

Spectral Passage does not improve Wraith's defense, point-blank speed, lateral coverage, startup, recovery, or movement. Its value depends on enemy alignment and correct geometry rather than another operational command.

# Approved Tier IV package

## Headline benefit — Beyond the Veil

Tier IV completes Wraith's mastery of engagement and execution from spectral distance.

Beyond the Veil provides three linked improvements:

1. Pale Lance gains increased maximum spectral reach.
2. Ghostline Slash gains increased spectral attack reach after the unchanged universal dash.
3. Valid deathblows may be initiated from farther away through a clear frontal path.

The package does not grant a stronger neutral dash, generic movement speed during ordinary combat, tracking, teleportation, or a universal range increase to every Wraith attack.

## Pale Lance mastery

Pale Lance's initial thrust gains a meaningful but controlled increase to its maximum spectral reach.

- The added reach remains a narrow fixed line.
- Preparation, direction commitment, interruption behavior, and severe miss recovery remain unchanged.
- The Pale Barrage continuation uses the approved Tier IV maximum line, but its repeated jabs remain separately weighted and do not each receive full independent Spectral Edge triggers.
- The attack gains no tracking, turning, homing, pursuit, correction, armor, or recovery reduction.

At Tier IV, Pale Lance's initial thrust becomes eligible for Spectral Edge. Contact must still occur through the spectral-only portion of the authored geometry.

## Ghostline Slash mastery

Ghostline Slash gains increased spectral attack reach after the normal neutral dash.

- Neutral-dash distance, startup, invulnerability, recovery, collision, and steering remain unchanged.
- The added attack reach follows the player's selected direction and does not track or snap toward an enemy.
- Ghostline Slash gains no extra attack-bound movement, protection, recovery cancel, automatic follow-up, or damage merely for being used after a dash.

At Tier IV, Ghostline Slash becomes eligible for Spectral Edge. Contact must still occur through the spectral-only portion of the slash.

## Extended deathblow initiation

When an enemy is already in a valid deathblow-ready state, Wraith may initiate that deathblow from a greater distance than the shared ordinary initiation range.

Approved boundaries:

- the enemy must satisfy all normal deathblow conditions,
- the target must be within a limited frontal acquisition angle,
- the path between Akio and the target must be clear,
- solid geometry, impassable hazards, intervening enemies, and other authored blockers prevent the extended initiation,
- Akio travels rapidly along one authored straight spectral approach,
- the approach does not curve, track a moving target after commitment, or retarget,
- the approach is not a free attack, neutral dash, teleport, or general-purpose traversal action,
- and the deathblow retains the shared deathblow's authored damage, success, camera, vulnerability, and encounter rules unless separately standardized for all Aspects.

Extended initiation changes where a valid deathblow may begin; it does not create deathblow readiness, increase deathblow damage, or bypass encounter-specific execution restrictions.

## Supporting benefit — Veilstride

After a deathblow kills its target, Akio gains a brief modest movement-speed increase.

Veilstride exists to help Wraith leave the execution position, restore medium-to-long spacing, or establish the next useful attack line.

Approved boundaries:

- the deathblow must kill the target,
- the benefit is movement speed only,
- it does not increase attack speed, animation speed, dash distance, dash invulnerability, recovery speed, tracking, or attack-bound movement,
- it does not stack with itself,
- a new valid trigger refreshes rather than multiplies the duration,
- and exact magnitude and duration remain tuning work.

Veilstride is not triggered by ordinary Spectral Edge contact. Spectral Edge remains a posture-and-guard spacing reward rather than a general mobility engine.

## Spectral Edge and Tier IV interactions

Tier IV advances Spectral Edge by its normal fourth and final Tier step.

At Tier IV, qualifying primary attacks are:

- Veil Cut,
- Passing Arc,
- Pale Lance's initial thrust,
- Ghostline Slash,
- and Veil Reversal.

Pale Barrage's repeated jabs, Wraith's Reach, extended deathblow travel, the deathblow itself, and Veilstride do not independently trigger Spectral Edge.

Spectral Passage continues to function normally across the remaining authored geometry of Pale Lance and Ghostline Slash. Additional passage contacts use the approved reduced and restricted rules and do not turn the Tier IV reach increase into unrestricted Blood, healing, Technique, status, or proc multiplication.

## Intended Tier IV rhythm

> punish a confirmed opening from greater Pale Lance distance → re-enter from farther away through Ghostline Slash when appropriate → convert accumulated posture pressure into an extended-range valid deathblow → use Veilstride to reclaim spacing or choose the next front

Beyond the Veil improves Wraith's distant opportunity and post-execution repositioning without removing the danger of wrong attack selection, lateral collapse, point-blank pressure, fixed direction, interruption, or a missed commitment.

# Technique space

Universal Techniques may reinforce or broaden Wraith's:

- reach and spectral-only spacing,
- line and arc coverage,
- Pale Lance and Pale Barrage,
- dash attacks and parry counters,
- formation penetration,
- posture continuity,
- close-range handling,
- re-entry,
- whiff recovery,
- deathblows,
- movement after execution,
- or delayed line pressure.

Techniques must not simply duplicate Spectral Edge's deterministic spacing reward, Wraith's Reach's sweep-corridor-echo package, Spectral Passage's ordinary-enemy formation penetration, Beyond the Veil's extended engagement and execution range, or Veilstride's post-kill repositioning.

A strong Wraith Technique build at Tier 0-I must remain capable of completing a run without Wraith's Reach, Spectral Passage, or Beyond the Veil.

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
- attacks that are currently eligible,
- and the modestly increasing Tier I-IV posture and guard-pressure reward.

Pale Lance and Ghostline Slash should not imply Spectral Edge eligibility before Tier IV. Their Tier IV Shrine summary and presentation must make the newly unlocked eligibility clear without requiring a separate HUD meter.

Pale Barrage requires clear continuation, early-release, stationary commitment, and diminishing per-jab impact communication without hiding enemy telegraphs.

Wraith's Reach requires:

- a short readable directional preparation,
- a compact broad opening sweep,
- a visibly connected very long corridor strike,
- a restrained delayed repetition along exactly the same geometry,
- clear differentiation between the primary strike and weaker echo,
- and no presentation suggesting homing, a projectile field, an autonomous companion, or a duration transformation.

Spectral Passage requires:

- the existing spectral line or arc to remain visually continuous through ordinary-enemy bodies,
- clear reduced secondary impacts,
- readable stopping against elites, bosses, heavy enemies, solid geometry, and authored blockers,
- and no effect suggesting new reach, tracking, bouncing, repeated hits on one enemy, or an autonomous chain attack.

Beyond the Veil requires:

- a clearly longer but still narrow Pale Lance line,
- a clearly longer Ghostline Slash spectral region without implying a longer neutral dash,
- a readable extended deathblow prompt or targeting state that appears only for valid clear-path targets,
- one rapid straight spectral approach rather than a teleport or curved pursuit,
- restrained Veilstride movement feedback after a killing deathblow,
- and no clone, shade, persistent zone, extra lane, tracking ribbon, or large secondary attack effect.

# Production requirements

The approved Tier 0-IV package establishes requirements for:

- distinct Veil Cut and Passing Arc timing, geometry, recovery, and hit response,
- clear physical and spectral hit-region ownership,
- deterministic Spectral Edge qualification, Tier gating, and scaling,
- Pale Lance and Ghostline Slash becoming Spectral Edge-eligible only at Tier IV,
- Pale Lance charge, release, miss, recovery, Tier IV reach, and Pale Barrage continuation behavior,
- restricted multi-hit Blood, Technique, healing, and proc weighting,
- Wraith's Reach preparation, sweep, corridor, echo, interruption, and fixed-geometry rules,
- Spectral Passage penetration, stopping-body classification, secondary ownership, and restricted interactions,
- Tier IV Ghostline Slash reach without neutral-dash modification,
- extended deathblow target validation, clear-path testing, approach travel, blocker handling, and encounter exceptions,
- Veilstride trigger, duration, refresh, movement-only behavior, and feedback,
- Shrine summaries for Pale Barrage, Spectral Edge, Wraith's Reach, Spectral Passage, Beyond the Veil, and Veilstride,
- and Tier 0-IV teaching and mastery-trial coverage.

# Remaining Wraith work

The qualitative Wraith Tier 0-IV package is approved for current scope.

Remaining work is implementation and validation:

1. prototype the Tier 0 attack roles and physical-versus-spectral hit regions,
2. validate Pale Barrage commitment and release behavior,
3. validate Wraith's Reach sweep, corridor, and echo readability,
4. validate Spectral Passage stopping rules and secondary weighting,
5. validate Tier IV reach increases and extended deathblow pathing,
6. tune Veilstride so it restores positioning without becoming a persistent mobility engine,
7. finalize animation, VFX, audio, HUD, Shrine, selection, and trial requirements,
8. and compare the implemented package against Wolf and Ronin.

Exact timing, damage, posture, guard pressure, spectral hit-region size, Pale Barrage jab count and duration, Wraith's Reach preparation, sweep size, corridor dimensions, echo delay, Spectral Passage stopping classifications, secondary-target weighting, Tier IV reach increases, extended deathblow range and angle, Veilstride magnitude and duration, interruption timing, recovery, Blood values, proc weighting, and presentation values remain implementation and playtesting work.
