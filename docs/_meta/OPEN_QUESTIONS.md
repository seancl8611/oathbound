---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-13
---

# Current Design Questions

This file contains unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at qualitative paper-design depth.
- Five direct Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- One direct Technique may occupy each slot; ordinary direct Techniques do not stack within the same slot.
- The complete **25-Technique direct matrix is approved at qualitative paper-design depth**.
- There is no global cap on slotless Supporting Techniques.
- Filled direct slots normally remain committed; rare replacement offers may overwrite that same slot.
- A slotted Technique may receive at most one small refinement.
- Technique rarity uses **Common / Uncommon / Rare / Legendary**.
- Technique families are primarily recognized through symbol, color treatment, effect behavior, VFX, and audio rather than formal school names.
- All Technique rewards use the same underlying reward screen regardless of source.
- Prosthetic Techniques are removed; Prosthetic progression is persistent and belongs to the Forge.
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, or Legendary.
- Exact damage, timing, hitboxes, buildup rates, durations, rarity weights, and VFX timing remain prototype and implementation work.

## Approved Technique-family state

### Echo

Echoes are delayed additional sword slashes created by qualifying actions. Akio does not literally repeat the full action.

Approved direct row:

- Basic — **Lingering Cut**
- Held — **Second Draw**
- Dash — **Passing Shadow**
- Counter — **Remembered Reversal**
- Deathblow — **Final Memory**

### Rupture

Eligible effects build a visible Rupture meter. Filling it immediately triggers a major posture-damage proc, an allowed strong hit reaction, and smaller nearby posture pressure, then resets the meter.

Approved direct row:

- Basic — **Rupturing Edge**
- Held — **Mountain Breaker**
- Dash — **Breaching Step**
- Counter — **Breaking Reversal**
- Deathblow — **Shattered Ground**

### Seal

Seal uses three visible marks. One slows movement, two further restrict movement and qualifying movement abilities, and three briefly **Bind** the enemy in place without stunning it. Bind clears the stacks afterward.

Approved direct row:

- Basic — **Sealing Cuts**
- Held — **Binding Draw**
- Dash — **Warding Step**
- Counter — **Counterseal**
- Deathblow — **Passing Seal**

### Rift

Rift is one visible fracture mark that always opens after a short fuse for direct Health damage. Further qualifying applications intensify the same mark before it opens.

Approved direct row:

- Basic — **Rift Edge**
- Held — **Deep Rift**
- Dash — **Shearing Step**
- Counter — **Rift Reversal**
- Deathblow — **Parting Rift**

### Crimson / Vulnerable

**Vulnerable** is a short enemy status that substantially increases damage from genuine backstabs. It does not slow, stun, root, alter facing, suppress movement, or change awareness. Not every Crimson Technique needs to apply Vulnerable; the family also uses direct Health damage, bounded AoE, and standalone backstab payoff.

Approved direct row:

- Basic — **Open Wound**
- Held — **Deep Cut**
- Dash — **Blood Arc**
- Counter — **Exposed Guard**
- Deathblow — **Predator's Wake**

## Priority order

1. Finish the remaining Technique catalog layers
2. Finish Relic / consumable run-build scope
3. Scope permanent Prosthetic progression and the wider Forge package
4. Persistent progression, onboarding, and trial package
5. Narrative delivery and authored-content package
6. Postgame release package

# 1. Remaining Technique catalog layers

**This is the current active design area.**

The direct five-by-five matrix is no longer an open question.

Next establish:

1. **Legendary Techniques** for each family
2. same-family **Supporting Techniques**
3. worthwhile **Cross-family Techniques**
4. small **refinements** for eligible slotted Techniques
5. rare replacement candidates
6. rarity assignments, prerequisites, and reward-pool eligibility
7. final launch count and reward frequency after the catalog is coherent

Current Legendary candidate directions that may be revisited:

- Echo — **Unforgotten Steel:** a normal Echo creates one additional weaker Echo, with no recursion.
- Rupture — **Heavenbreaker:** a Rupture may trigger sufficiently developed nearby Rupture meters under a bounded non-recursive rule.
- Crimson — **Unseen:** brief invisibility or awareness suppression that allows Akio to reposition for a backstab. Trigger, duration, break conditions, boss behavior, and eligibility are not yet decided.
- Seal — open.
- Rift — open.

Later-layer design should be audited for:

- compatibility with Wolf, Wraith, and Ronin,
- boss and isolated-target usefulness,
- group power and AoE limits,
- high-frequency / multi-hit normalization,
- genuine backstab access and Vulnerable usefulness across important enemies,
- mixed-family compatibility,
- control limits on protected enemies,
- visual readability when several family effects coexist,
- and whether every pickup remains useful without requiring an exact multi-Technique combination.

The approved 25 direct Techniques should remain stable unless testing exposes a concrete issue.

# 2. Remaining run-build catalog

After the Technique catalog is coherent, define:

- initial Relic count and final rarity structure,
- whether consumables ship,
- final Technique reward frequency and offer weighting,
- and entries requiring unique icons, VFX, animation, or audio.

# 3. Permanent Prosthetic / Forge scope

Define individual permanent upgrade paths for the eight Prosthetics through the Forge.

Scrolls are currently the persistent Forge currency. Exact branch counts, ranks, costs, and tool-specific upgrade depth remain open.

# 4. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern.

# 5. Narrative delivery and authored-content package

Define first-death presentation, bloodline confirmation, Shogun dialogue progression, codex / NPC updates, ending / credits requirements, voice scope, and delivery ownership.

# 6. Postgame release package

Define repeat Heart-route access, repeat-clear rewards, launch completion goals, and required postgame UI states.

## Deferred implementation and balance work

Keep exact values in their owning files, including damage, posture, Rupture buildup/decay, Seal slow/duration/expiry, protected-enemy control resistance, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage/width, Predator's Wake radius, guard pressure, stagger, reach, movement, recovery, Blood values, room probabilities, prices, rarity weights, replacement rates, permanent-upgrade percentages, and final VFX/animation timing.
