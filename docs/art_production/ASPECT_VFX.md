---
id: ART-ASPECT-VFX
title: Blood Aspect VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-07
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
  - ART-MILESTONE-04
---

# Blood Aspect VFX

Blood Aspect effects communicate weapon geometry, commitment, state, and impact before spectacle. All three qualitative Tier 0-IV packages are approved for high-level production planning; exact counts and timings still require implementation briefs and playable validation.

## Shared rules

- The physical katana remains visible or clearly connected to the Blood-formed expression.
- Direction, reach, collision, and final player position must remain readable.
- Neutral dash and universal defense keep shared presentation across Aspects.
- VFX cannot imply tracking, homing, teleportation, invulnerability, armor, projectiles, or target selection that gameplay does not provide.
- Tier escalation should extend the same visual family rather than replace it.
- Wolf, Wraith, and Ronin must not become color swaps.
- Reuse base animation, HUD, and effect families whenever a Tier changes geometry or values rather than creating a new action.

## Wolf — pressure and pursuit

### Tier 0

- dense close-range Blood edge,
- compact predatory trails,
- strong connected-contact emphasis,
- readable forward travel on Predator's Passage and Hunting Slash,
- broad committed Blood Cleave impact,
- clear severe-miss recovery.

### Tier I — Blood Tempo / Feral Momentum

- brief continuation-ready cue only after valid contact,
- escalating impact treatment on later connected Basic positions,
- no combo meter, random critical flash, or persistent attack-speed aura.

### Tier II — Blood Hunt

- full-meter activation surge,
- limited-healing feedback,
- short Blood howl and nearby disruption radius,
- one fixed pursuit line,
- readable ordinary-enemy pass-through and stronger-enemy/geometry stopping,
- Blood Fang endpoint,
- severe ending recovery.

The wolf jaw is an attack effect, not a summoned companion or transformation.

### Tier III — Fanged Guard

Use one frontal fang-guard language for Predator's Passage charge and eligible connected Raking Fang/Blood Cleave startup. Show availability, one-hit consumption, normal posture cost, and posture break without implying general armor.

### Tier IV — Apex Mauling

Show one consolidated rapid Blood-claw package at valid contact, with dominant primary impact, compact reduced-power outer coverage, posture/guard recoil, and a restrained movement-only slow cue.

## Wraith — reach and frontal control

### Tier 0

- elongated spectral Blood edge connected to the katana,
- precise Veil Cut line,
- broad Passing Arc sweep,
- longest narrow Pale Lance expression,
- compact extended Ghostline Slash,
- posture-focused Veil Reversal,
- restrained body effects and clear miss dissipation.

### Tier I — Pale Barrage / Spectral Edge

Pale Barrage needs clear continuation from Pale Lance, repeated lower-impact thrusts along the same direction, stationary commitment, early release, and recovery.

Spectral Edge must distinguish physical-range contact from currently eligible spectral-only contact. Its Tier escalation emphasizes posture/guard pressure rather than Health-damage spectacle. Pale Lance and Ghostline Slash gain the cue only at Tier IV.

### Tier II — Wraith's Reach

- full-meter activation,
- short directional preparation,
- compact broad frontal sweep,
- very long connected corridor strike,
- one weaker delayed repetition along the exact same corridor,
- clear ending recovery and Blood-consumed state.

The delayed Wraith is a brief authored repetition, not an autonomous companion.

### Tier III — Spectral Passage

Existing spectral geometry remains visibly continuous through eligible ordinary-enemy bodies. Show dominant primary impact, reduced secondary impacts, and obvious termination against elites, bosses, protected heavies, solid geometry, and authored blockers.

Do not imply added reach, chaining, bouncing, same-target multiplication, or a detached projectile.

### Tier IV — Beyond the Veil

- longer Pale Lance and Ghostline Slash attack geometry without neutral-dash changes,
- Tier IV Spectral Edge eligibility on those attacks,
- greater-distance deathblow prompt only for valid clear paths,
- one straight visible spectral approach into the shared execution,
- brief movement-only Veilstride after a killing deathblow.

No teleportation, persistent transformation, Pale Procession shades, or generic mobility state.

## Ronin — impact and stability

### Tier 0

- dense compressed Blood edge,
- restrained buildup around blade and sheath,
- strongest hit-frame and recoil emphasis,
- heavier audio than Wolf or Wraith,
- clear guard stability and slow posture-recovery readability,
- minimal visual noise between major impacts.

### Repeated posture growth

Ronin's Tier I-IV maximum-posture growth should use the existing player-posture HUD/capacity language. It requires **no separate buff icon, aura, stack effect, or new VFX state**.

### Tier I — Steadfast Reprisal

- short opportunity cue after a qualifying block,
- planted startup distinct from Answering Steel,
- strong standalone impact,
- no movement-to-target, armor, or posture-recovery implication.

### Tier II — Falling Mountain

- full-meter activation and partial posture-relief cue,
- planted channel with narrow interruption-resistance readability,
- monumental direct slam,
- compact reduced-power impact burst,
- marked original impact point,
- powerful delayed Deep Rupture at that same point,
- severe recovery.

Deep Rupture must read as ground-bound force rather than Wraith-like delayed weapon geometry.

### Tier III — Unbroken Resolve / Weight

Use distinct compact reads for:

- the late commitment-preservation window,
- temporary Measured Weight readiness,
- Perfect Weight consumption emphasizing posture, guard recoil, and stagger rather than extra Health damage.

The timer/readiness cue should not become a dominant maintenance UI.

### Tier IV — Shattering Wake

A qualifying heavy contact produces one forward force wake beginning at the primary contact point and continuing behind the target. Show reduced Health payoff, strong posture/recoil, no wake on a miss, no double-hit on the primary target, and stronger posture treatment when Perfect Weight amplifies it.

## Tier escalation and production boundary

All three launch Aspect families now support high-level Tier 0-IV scoping.

Final production still requires exact animation reuse, VFX/audio counts, HUD states, collision, timing, and implementation briefs. Superseded Prey Mark, Dire Hunt transformation, Apex Feast, Wraith duration-state reach buff, Veiled Guard, Pale Procession, perfect-dodge/Mist-Step/spinning Art, Ronin Counter Cut/Focus, and formal drawback-badge assets remain excluded.