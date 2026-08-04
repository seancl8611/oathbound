---
id: GAMEPLAY-RONIN-ASPECT
title: Ronin Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-03
topics:
  - blood-aspects
  - ronin
  - tier-0
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Ronin Blood Aspect

## Status

Ronin is an approved member of the three-Aspect launch roster. This document owns Ronin's qualitative Tier 0 weapon kit and its boundaries.

It replaces earlier directions based on maintaining a combo through defense, reaching a special finisher as the central goal, or selecting Basic Attacks through movement-direction input.

Exact numerical values, frame data, hitboxes, animation, Blood presentation, Tier I-IV package, Blood Art, justified exceptions to the shared Blood defaults, Technique exceptions, and production counts remain later design or implementation work.

## Weapon identity

**Ronin is the slow, precise, heavy-impact and stability kit.**

Ronin is defined by:

- a three-hit heavy Basic Attack sequence,
- conventional medium sword reach,
- the slowest cadence in the launch roster,
- the highest per-hit health damage,
- the highest or near-highest per-hit enemy-posture pressure,
- the strongest ordinary-enemy stagger,
- minimal player-directed attack movement,
- fixed attack lines after commitment,
- severe recovery after missed heavy attacks,
- and the strongest guard profile, balanced by slow posture recovery.

Ronin's limitations are inherent in its startup, movement, commitment, and recovery rather than expressed through a separate player-facing drawback category.

Ronin does not use corrective tracking, hidden homing, or post-input target rotation. The player judges both the attack direction and how much of an opening can be used safely. Ronin's attacks are individually valuable; the player never needs to complete the full sequence.

## Shared systems

Ronin retains universal locomotion, neutral dash, defense input, parry timing, posture-break rules, deathblows, Technique inventory, and prosthetic controls.

Its stability does not create parry immunity, automatic counters, free posture recovery while guarding, instant attack cancels, innate interruption resistance, super armor, damage reduction, or a unique defensive input.

A Tier 0 heavy attack must be protected by correct timing, spacing, enemy stagger, or a sufficiently large opening. A later fixed Tier benefit or Blood Art may protect one specific authored action only if that exception is explicitly approved.

## Tier 0 kit

### Basic Attack sequence

1. **Severing Cut** — the most reliable Basic Attack for short openings, using a comparatively compact line while still delivering meaningful single-hit damage and posture pressure.
2. **Crushing Cross** — the broadest frontal Basic Attack, with greater commitment, stronger impact, and the clearest role against closely grouped enemies in front of Akio.
3. **Bloodfall** — the most committed and directionally demanding Basic Attack, delivering the sequence's largest damage, posture, and stagger payoff with severe recovery.

The sequence cadence is:

> deliberate punish → broader heavy commitment → maximum committed impact

Severing Cut must provide strong value during short openings. Crushing Cross provides Ronin's primary ordinary frontal group coverage through authored sword geometry rather than a shockwave, tracking, or permanent extended reach. Bloodfall is an available heavy option, not a required finisher or combo reward.

Each attack remains useful when the sequence ends early.

### Held Attack — Stillness Draw

A defining high-damage draw attack that concentrates power around the katana and sheath.

Stillness Draw uses one fixed preparation threshold rather than multiple damage charge levels. Once prepared, the player may hold the readied stance and manually release the strike. Continuing to hold does not increase its power.

While the readied stance is held, Akio remains committed and does not regain ordinary defense access. Its risk comes from choosing when and where to prepare and release the attack, not from managing several charge tiers.

Stillness Draw provides:

- Ronin's clearest precise single-target punish,
- major single-hit health damage,
- major enemy-posture pressure,
- strong ordinary-enemy stagger,
- conventional or modestly extended melee reach rather than Wraith-like reach,
- a fixed attack line after commitment,
- and severe miss recovery.

Its advantage is power, not safe distance. It must remain distinct from Bloodfall: Bloodfall is the sequence's largest impact and stagger commitment, while Stillness Draw is Ronin's strongest prepared single-target punishment tool.

### Dash Attack — Breaching Slash

A quicker attack after the universal neutral dash.

- faster and more convenient than Ronin's normal heavy attacks,
- conventional sword reach,
- useful for short openings or re-entry,
- the most responsive recovery profile within Ronin's Tier 0 attacks,
- and lower damage, posture pressure, and stagger than the main sequence.

Breaching Slash must not replace Ronin's ordinary heavy strikes. Its role is access and re-entry, not pursuit dominance or maximum punishment.

### Parry Counter — Answering Steel

A forceful retaliatory strike after the universal parry.

- universal parry requirements,
- Ronin's strongest immediate conversion from a successful parry,
- high damage and enemy-posture payoff,
- strong ordinary-enemy recoil or stagger where enemy rules allow,
- restrained player-directed movement,
- and meaningful commitment after activation.

It does not change parry timing, turn toward a target after release, or make the counter automatically safe in crowds.

## Contact, commitment, and recovery

Ronin should feel deliberate and heavy rather than generally unresponsive.

- meaningful startup and active commitment cannot be cancelled into block or dash,
- a full miss receives severe authored recovery,
- successful or guarded contact receives strong hit-stop, audiovisual weight, and its authored contact recovery,
- and ordinary defensive access returns after that authored recovery rather than through a special hit-confirm cancellation rule.

Tier 0 does not include a formal mechanic that reduces recovery whenever an attack connects. The distinction between a successful impact and a complete miss should initially come from authored animation, hit-stop, feedback, and recovery tuning.

## Defensive profile

Ronin has the strongest ordinary guard profile in the launch roster through:

- meaningfully higher player-posture capacity as its primary defensive advantage,
- modestly better block posture efficiency as a secondary advantage,
- and greater stability during direct exchanges.

These strengths are balanced by:

- the slowest player-posture recovery in the launch roster,
- committed attacks that delay access to defense,
- no instant block or dash cancel during meaningful attack startup or active frames,
- and no free posture recovery while actively guarding.

Ronin can withstand a direct exchange longer, but accumulated posture remains a serious concern during the next exchange. Its guard supports deliberate exchanges; it does not erase the consequences of bad commitments or permit indefinite blocking.

## Combat profile

| Property | Approved direction |
|---|---|
| Preferred range | Medium |
| Basic sequence | Three attacks |
| Cadence | Slowest and most deliberate |
| Per-hit damage | Highest |
| Sustained output | Opening-dependent and lower than Wolf |
| Enemy posture | Largest chunks per clean strike |
| Ordinary-enemy stagger | Strongest |
| Attack movement | Minimal, grounded, and player-directed |
| Held identity | Prepared single-target power |
| Main failure state | Missed heavy commitment and accumulated posture that recovers slowly |

## Strengths

- highest per-hit health damage,
- highest or near-highest per-hit posture pressure,
- strong ordinary-enemy stagger,
- excellent punishment of short and large openings,
- powerful elite and boss damage,
- strong Parry Counter payoff,
- clear frontal group coverage through Crushing Cross,
- and stable blocking during direct exchanges.

## Firm tradeoffs

- slow attack startup,
- severe whiff recovery,
- fixed attack lines after commitment,
- minimal attack-bound movement,
- no innate interruption resistance or damage reduction during attacks,
- low sustained output when openings are scarce,
- mobile or ranged enemies,
- pressure from several directions,
- and slow recovery of accumulated player posture.

Ronin must not become the generally optimal kit by combining the strongest guard with unrestricted damage, posture, and stagger. Its commitments and recovery remain fundamental costs.

## Encounter role

- **Mixed groups:** remove or stagger priority enemies while using Crushing Cross, frontal arcs, and defense to stabilize direct pressure.
- **Crowds:** threaten grouped frontal targets but struggle when fast enemies attack from several directions.
- **Ranged pressure:** rely on universal dash, Breaching Slash, projectile defense where supported, prosthetics, and target priority rather than pursuit or extended reach.
- **Elites and bosses:** convert correctly read openings into the largest individual health and posture gains, with Stillness Draw serving as the clearest prepared single-target punish.

## Tier progression direction

Ronin's future Tiers must provide clearly net-positive benefits that deepen heavy impact, posture pressure, stability, or deliberate punishment. The benefits may be strong because Ronin already gives up speed, movement, and recovery through its ordinary kit.

Future Tiers should preserve those inherent limitations through the actions they strengthen rather than adding separate named drawbacks or unrelated penalty attributes. A strong Ronin Technique build at Tier 0-I must remain capable of completing a run without requiring the Blood Art.

## Technique space

Universal Techniques may:

- **reinforce** heavy Basic Attacks, Stillness Draw, direct damage, posture chunks, and stagger,
- **broaden** attack speed, pursuit, crowd handling, ranged access, or sequence flexibility,
- **compensate** for whiff recovery, fixed attack lines, posture recovery, mobile enemies, or surrounding pressure,
- **hybridize** through Breaching Slash, Answering Steel, deathblows, blocking, posture, or prosthetics.

Ronin does not own every damage, posture, parry, block, Held Attack, or heavy-attack Technique.

## Blood-katana presentation

Ronin's Blood-formed katana should feel dense, compressed, disciplined, and heavy at impact.

Presentation may use a dense Blood edge, a spectral sheath during Stillness Draw, restrained trails before contact, strong hit-frame emphasis, and heavy audio. It must not gain Wraith-like permanent reach.

## Remaining Ronin design work

Define one Tier at a time:

- the fixed Tier I benefit,
- Tier II and Ronin's Blood Art after Tier I is approved,
- Tier III after Tier II is approved,
- Tier IV after Tier III is approved,
- how each Tier preserves Ronin's inherent speed, movement, commitment, and recovery limits,
- any justified exception required by the approved Blood Art,
- limited direct Technique interactions if approved,
- final animation, VFX, audio, HUD, Shrine, selection, and trial requirements.

Exact timing, range, geometry, player-directed movement, damage, posture, stagger, block efficiency, player-posture values, armor interactions, Stillness Draw preparation and readied-state durations, Blood values, and presentation values remain implementation and playtesting work.
