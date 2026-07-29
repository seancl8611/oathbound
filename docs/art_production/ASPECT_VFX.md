---
id: ART-ASPECT-VFX
title: Blood Aspect VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-28
topics:
  - blood-aspects
  - wolf
  - wraith
  - ronin
  - vfx
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-TECHNIQUES
  - CHAR-AKIO
  - ART-TECHNIQUE-VFX
  - ART-MILESTONE-04
---

# Blood Aspect VFX

Blood Aspect effects communicate the selected katana weapon kit. They are information cues first and spectacle second. All three families layer onto Akio's base character presentation and must preserve attack direction, enemy telegraphs, hit geometry, hazards, and the player's final position.

Techniques may reuse or lightly extend an Aspect family when they amplify the same combat verb, but the selected Aspect remains the stronger visual identity.

Wolf's current Tier I-IV and Blood Art package is approved as a working draft. Wraith and Ronin escalation remains dependent on their future fixed progression packages.

## Shared presentation rules

- The physical katana remains visible or clearly connected to the Blood-formed weapon expression.
- Attack reach, direction, and geometry must be readable before spectacle.
- Neutral dash and universal defensive actions keep shared presentation across Aspects.
- Aspect VFX cannot imply invulnerability, teleportation, independent projectiles, automatic target marks, corrective tracking, or homing that gameplay does not provide.
- Tier escalation should deepen the same visual family rather than replace it with unrelated effects.
- Wolf, Wraith, and Ronin must not become simple color swaps.
- Effects use modular overlays and VFX where practical rather than requiring three unrelated complete player sheets.

## Wolf — pressure and pursuit

### Gameplay purpose

Communicate fast close-range attacks, player-directed forward pursuit, sustained contact, and the danger of committed misses.

### Tier 0 visual direction

- dense Blood edge close to the physical katana,
- compact predatory trails that follow the real attack arc,
- stronger contact emphasis across connected attacks,
- clear forward travel on Predator's Passage and Hunting Slash,
- broad but controlled impact on Blood Cleave,
- visible recovery or Blood dissipation after a severe miss.

Wolf effects should feel forceful, close-ranged, and committed to direct contact.

### Tier I — Blood Tempo

Successful Fang Slash, Rending Cross, or Raking Fang contact needs a brief Blood-link cue showing that the next Basic Attack input is available earlier.

The cue must:

- occur only after valid contact,
- remain subordinate to hit, parry, posture-break, and deathblow feedback,
- and avoid implying a stored combo state or permanent attack-speed buff.

### Tier II — Dire Hunt and Blood Fang

Dire Hunt requires:

- a clear activation surge and short-range Blood howl,
- visible player-posture clearing and limited healing feedback,
- a readable active transformation state,
- stronger Blood treatment on the existing Wolf attack library,
- an ending or consumed-state transition,
- and no effect that suggests automatic targeting or attack invulnerability.

Blood Fang is the transformation's main bespoke attack and visual centerpiece:

- a Blood-formed wolf jaw manifests around Akio's committed lunge,
- the jaw bites at the real point of contact,
- the movement line and final position remain readable,
- successful healing receives clear but restrained feedback,
- and a miss must communicate severe recovery.

The jaw is an attack effect, not a summoned animal or independent entity.

### Tier III — Fanged Guard

Charging Predator's Passage or Blood Fang forms a frontal Blood jaw or fang guard.

Presentation must distinguish:

- charge active,
- the single frontal block being consumed,
- immediate completion of the Held Attack charge,
- and the remaining player choice to release or hold the attack.

The effect must not imply side, rear, grab, hazard, or unblockable protection.

### Tier IV — Apex Feast

A deathblow triggers:

- a compact Returning Blood eruption around Akio and the executed enemy,
- readable stagger or posture-pressure impact on nearby enemies,
- limited healing feedback,
- and a clear state showing that the next Held Attack is fully charged.

The primed-Held cue must disappear when consumed or when the encounter ends. Apex Feast must not imply automatic target selection or automatic attack release.

### Wolf boundaries

- no automatic Prey Mark,
- no persistent marked-target UI requirement,
- no pressure meter or combo-state effect,
- no corrective tracking or homing cue,
- no spectral companion or mirrored attacker,
- no permanently extended blade that removes Wolf's reach weakness,
- no full-body effect that implies attack invulnerability.

## Wraith — reach and frontal control

### Gameplay purpose

Communicate long connected melee reach, narrow pokes, broad spectral arcs, restrained movement, fixed attack lines, and quick return to neutral.

### Approved visual direction

- elongated pale or spectral Blood edge visibly connected to the katana,
- clean narrow lines for Veil Cut and Pale Lance,
- broad translucent frontal arcs for Passing Arc,
- compact extended slash language for Ghostline Slash,
- restrained body effects so Akio's actual position remains obvious,
- clear endpoint and dissipation on missed extended attacks.

Wraith should feel precise and light in visual motion without becoming intangible.

### Boundaries

- no perfect-dodge identity,
- no vanish or reappearance states,
- no Mist-Step,
- no forced afterimage path between special positions,
- no teleportation or additional invulnerability,
- no corrective tracking or homing,
- no independent projectile detached from the katana,
- no confusion with the Mist Raven prosthetic.

## Ronin — impact and stability

### Gameplay purpose

Communicate deliberate heavy attacks, concentrated power, large health and posture impact, strong ordinary-enemy stagger, stable guarding, fixed attack lines, and meaningful recovery after commitment.

### Approved visual direction

- dense compressed Blood edge,
- restrained accumulation around the blade and sheath before heavy actions,
- controlled trails before contact,
- strong hit-frame emphasis and recoil readability,
- heavier audio and impact treatment than Wolf or Wraith,
- clear guard stability and slow posture-recovery states where the HUD or animation requires them.

Ronin is the least visually noisy family outside major impact moments.

### Boundaries

- no generic Focus aura after deathblows,
- no Counter Cut terminology or effect requirement,
- no combo-preservation state,
- no corrective tracking or homing,
- no permanently enlarged reach,
- no effect that suggests heavy attacks can cancel instantly into defense.

## Tier escalation

Every Aspect follows a fixed Tier path from Tier 0 through Tier IV.

Wolf's working escalation is defined in `WOLF_ASPECT.md`. Production may use it for high-level dependency planning, but final counts still require animation and implementation briefs.

Wraith and Ronin production must not invent unrelated visual mechanics before their Tier packages are approved.

Across all three:

- Tier escalation should intensify or extend the existing family,
- one evolving drawback family should remain readable without covering enemy telegraphs,
- Embrace should clearly communicate advancement and danger,
- Resist should stabilize the current state without implying advancement,
- Stabilize at Tier IV should not look like Tier V,
- any mutation overlay should be modular and justified by gameplay or narrative presentation.

## Blood and Blood Arts

Blood is unavailable before Tier II. The shared UI and VFX framework must support unavailable, building, ready, activated, active or resolving, consumed, and rebuilding states.

Each Blood Art may require limited Aspect-specific treatment, but common readiness and activation language should remain recognizable across all three.

A Blood Art must communicate its guaranteed activation payoff and its usable combat state. Do not rely only on generic damage, range, or color intensity to make the transformation desirable.

## Technique relationship

- Neutral Techniques remain compatible with every Aspect family.
- Technique effects reuse base sword, Aspect, posture, deathblow, and prosthetic language before new VFX are authorized.
- A Technique cannot create a separate Wolf, Wraith, and Ronin effect set unless its approved rule genuinely requires different geometry or presentation.
- Technique VFX must not duplicate Blood Tempo, Blood Fang, Fanged Guard, or Apex Feast without explicit approval.
- Aspect identity remains more prominent than any single temporary Technique.

## Delivery requirements

Final production briefs must define:

- required attack trails and impact states,
- Tier I-IV changes,
- drawback presentation,
- Blood buildup and readiness states,
- Blood Art startup, active, resolve, and recovery states,
- animation dependencies,
- audio requirements,
- HUD and Shrine relationships,
- regional palette tests,
- and boss readability tests.

Exact sprite frames, particle counts, blend behavior, screen effects, color values, and timing are production and implementation decisions after each gameplay package is approved.