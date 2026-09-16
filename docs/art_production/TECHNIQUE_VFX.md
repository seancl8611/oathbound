---
id: ART-TECHNIQUE-VFX
title: Technique VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - techniques
  - vfx
  - combat-readability
  - refinements
  - effect-families
  - vulnerable
  - backstabs
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - ART-CORE-VFX
  - ART-ASPECT-VFX
  - ART-ITEM-REWARD-ART
  - ART-MILESTONE-04
---

# Technique VFX

Techniques reshape existing combat actions through repeatable family effects. Their VFX should make run growth readable while preserving sword arcs, enemy tells, gameplay facing, hidden-Poise reactions, safe space, and Akio's final position.

The active roster is **40 Techniques + 6 refinements**. Technique labels are not equipment slots, and the current global catalog does not assume a universal Parry/Counter or Deathblow trigger.

## Production role

Technique presentation has two layers:

- **selection/build communication:** trigger identity where relevant, family, rarity, prerequisite/compatibility, refinement state, Supporting/Cross-family/Legendary relationships;
- **combat feedback:** readable effects for Echo, Rupture, Seal, Rift, Vulnerable/backstab payoff, or another approved individual Technique effect.

The former elemental stance families remain removed from scope. Prosthetic effects remain in their own visual system.

## Reuse hierarchy

Before commissioning a new Technique effect, prefer:

1. approved base sword trail, hit, guard/protected-contact, interruption, movement, or danger-telegraph language;
2. selected Blood Aspect VFX language where mechanically compatible;
3. established Returning Blood / Order / wound / ritual language;
4. small modular family overlays, marks, fractures, seals, wounds, arcs, delayed slashes, or pulses;
5. bespoke effects only when the mechanic cannot read correctly through reuse.

Do not preserve universal parry, enemy-Posture-break, or Deathblow presentation merely because an older Technique matrix referenced those events.

## Current family visual needs

### Echo — pale silver / twin slash

Echoes should read as delayed additional sword slashes, not as Akio literally replaying the full action.

The visual system must support:

- one delayed Echo from an originating action;
- repeated/weaker Echoes from Legendary support;
- Echo continuation/spread effects;
- Echo interaction with an existing Rift or Rupture source where the current catalog allows it;
- original authored attack direction/line remaining clear.

Echoes should be visually subordinate to the original hit so enemy telegraphs are still readable during layered builds.

### Rupture — gold / cracked crest

Rupture uses a visible family-specific buildup mark that culminates in one compact impact burst.

Needs:

- readable partial buildup without resembling a universal enemy resource bar;
- clear full-trigger/reset moment;
- direct Health impact plus strong guard/hidden-Poise pressure read on the primary target;
- bounded nearby impact distinct from broad unrelated AoE;
- support for partial spread, retained buildup, and chain interactions defined by the current catalog.

Rupture presentation must not look like an enemy's standard Posture meter or imply a mandatory finisher state.

### Seal — violet / binding knot

Seal must visibly progress from one mark, to two connected marks, to a completed three-mark pattern during Bind, then break/fade according to the current effect.

One, two, and three Seals must remain distinguishable without color alone.

Bind presentation should communicate movement restriction without implying Health invulnerability, stun immunity loss beyond the authored mechanic, or a new defeat resource.

### Rift — ivory / blade circle

Rift is one evolving visible fracture rather than a stack of separate projectiles.

The same mark should:

- appear on first application;
- spread/branch/intensify as later qualifying applications increase it;
- make fuse/opening timing legible without a giant countdown UI;
- open for direct Health damage;
- disappear/reset cleanly;
- support spread/scar/collapse variants without becoming visually confused with Echo or Rupture.

### Crimson — Vulnerable / backstab / direct Health damage

Crimson communicates exposed defense, genuine rear-position payoff, and direct Health damage.

- **Vulnerable:** compact crimson wound/split-mark/exposed-guard symbol for the short status duration.
- The Vulnerable mark must not imply slow, root, stun, forced facing, awareness loss, or fake backstab geometry.
- Genuine backstabs against Vulnerable enemies receive a strong brief crimson hit accent.
- **Deep Cut:** concentrated rear-hit treatment with no extra persistent status required.
- **Blood Arc:** wide but bounded sword-shaped crimson arc tied to the actual Dash Attack origin/path.
- **Blood Trail:** clear transfer/application feedback when a Vulnerable enemy dies and a nearby survivor becomes Vulnerable.
- **Severed Line:** compact through-target cleave readable as a positional follow-through, not a new projectile.
- **Unseen:** brief player-state treatment that communicates suppressed awareness without making Akio literally invisible or obscuring player position.

Vulnerable must never obscure enemy facing because the player still has to earn the target's rear.

## Current trigger treatment

Current shared Action Technique triggers are:

- **Basic Attack**
- **Held Attack**
- **Dash / Dash Attack**

These are trigger classifications, not Technique slots. Multiple owned Techniques may respond to the same action and their effects must layer cleanly.

- **Basic Attack:** frequent effects stay visually light.
- **Held Attack:** may support heavier fixed geometry, concentrated impact, Rift application, or other committed payoff.
- **Dash / Dash Attack:** effects stay tied to the actual dash path/contact and must not imply hidden movement, homing, or automatic rear positioning.

Other Techniques may respond to current supported events such as landed damage, kills, genuine backstabs, family events, or explicitly compatible kit-specific hooks. Presentation should only be authored for those events when the current Technique entry actually uses them.

## Kit-specific compatibility

A global Technique must not visually promise an event that the active kit cannot produce.

If a future/current Technique uses a Ronin-specific Reprisal or another Aspect-owned hook, the card and VFX should communicate that compatibility explicitly rather than pretending the event is universal.

## Supporting / Cross-family / Legendary effects

The active catalog contains:

- 15 Action Techniques;
- 15 same-family Supporting Techniques;
- 5 Cross-family Techniques;
- 5 Legendary Techniques;
- 6 refinements.

Supporting effects should normally modify established family cues. Cross-family effects should make both contributing mechanics legible without creating a third unrelated visual school. Legendary effects may justify more dramatic presentation when genuinely run-shaping, but enemy telegraphs and combat-space readability remain higher priority.

Do not use an obsolete 25-Action-Technique matrix as the production-count baseline.

## Refinement treatment

A refinement should look like a small improvement to the same Technique, not a second ability.

Current refinement presentation can usually reuse the parent family cue with a modest footprint/intensity/duration/readability change. A refinement does not need a new rarity treatment.

## Directional-body boundary

Technique VFX remain separate from the eight-direction actor body art wherever practical.

This allows:

- the same Technique effect to work with clean-prerender or pixel/downsample Akio;
- character frames to be rerendered without baking Technique states into every action/direction;
- CombatActionRunner timing to remain authoritative;
- effect density to be tuned independently from animation assets.

If a Technique changes the apparent sword path, the VFX must still match the real gameplay geometry and may not imply extra reach that the hitbox does not have.

## Readability constraints

- Technique feedback cannot hide enemy telegraphs, safe zones, projectiles, Akio's position, or meaningful facing.
- Multiple Technique effects must layer cleanly, including several Techniques responding to the same action.
- Seal marks must remain readable on moving enemies.
- Rift marks must not be mistaken for Echo slashes.
- Rupture buildup must not be mistaken for universal enemy Posture.
- Vulnerable must not obscure rear-position judgment.
- Crimson AoE must remain distinct from Rupture's compact impact family.
- Exact timing, footprint, trigger, values, and compatibility remain owned by gameplay/catalog documentation.

## Delivery planning

Do not lock the final unique-icon or bespoke-effect count from historical roster sizes.

Every production-ready Technique should specify:

- catalog name and family;
- current trigger/event;
- eligibility/compatibility requirements;
- target/footprint;
- existing VFX reuse;
- added family cue;
- whether it can stack visually with other effects on the same action;
- mixed-build readability risk;
- runtime treatment at the accepted high-angle camera.

Nothing in the art specification should imply exclusive Technique slots or a global Technique inventory cap.
