---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-09
---

# Current Design Questions

This file contains only unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

- The launch Blood Aspect roster is **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at current qualitative paper-design depth.
- Five core Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- One direct Technique may occupy each slot; ordinary direct Techniques do not stack within the same slot.
- There is no global cap on slotless supporting Technique upgrades.
- Filled slots normally remain committed; rare replacement offers may overwrite that slot.
- A slotted Technique may receive at most one refinement, and that refinement must be a small buff rather than a separate Technique.
- Technique rarity uses **Common / Uncommon / Rare / Legendary**.
- Technique families are primarily recognized through symbol, color treatment, effect behavior, VFX, and audio rather than requiring formal player-facing school names.
- All Technique rewards use the same underlying reward screen regardless of whether the source is a combat room, shop, treasure, miniboss, regional boss, or another approved source.
- Prosthetic Techniques are removed. Prosthetic progression is persistent and belongs to the Forge.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, or Legendary.
- Exact damage, timing, hitboxes, buildup rates, decay rates, rarity weights, and VFX timing remain prototype and implementation work.

## Current family-design state

The earlier broad Technique draft is no longer treated as the current launch roster. The core slotted families must be stabilized before supporting, cross-family, Legendary, or refinement content is rebuilt.

Current state:

- **Pale silver / twin slash:** Echo mechanic is a strong direction. Echoes are delayed additional slashes; some core-slot concepts still need rewriting so the scalable mechanic is the echo itself rather than simply repeating Akio's action.
- **Gold / cracked crest:** Rupture mechanic has a working qualitative rule.
- **Violet / binding knot:** Seal family is promising, but the buildup / completion model is unresolved.
- **Ivory / blade circle:** redesign required; precision triggers alone are not a scalable parent-family mechanic.
- **Crimson / split blood drop:** redesign required; Health loss / sacrifice / recovery triggers alone are not a scalable parent-family mechanic.

### Rupture rule now established at working-design depth

- Gold effects may add **Rupture buildup** to a visible enemy meter.
- The old **Fracture** terminology is removed.
- Partial Rupture buildup has no separate effect.
- Filling the meter immediately triggers **Rupture** and resets the meter.
- Rupture deals a large burst of posture damage, creates a strong hit reaction where allowed, and sends a smaller posture shockwave into nearby enemies.
- Not every Gold Technique must add Rupture buildup; direct posture, guard-breaking, impact, and bounded AoE effects can still belong to the family.
- Exact buildup amounts, decay timing, AoE radius, and boss reaction strength remain tuning work.

## Priority order

1. Finish the five core Technique-family mechanics and slotted matrix
2. Rebuild supporting Techniques, cross-family Techniques, Legendaries, and refinements
3. Finish Relic / consumable run-build scope
4. Scope permanent Prosthetic progression and the wider Forge package
5. Persistent progression, onboarding, and trial package
6. Narrative delivery and authored-content package
7. Postgame release package

# 1. Core Technique-family mechanics

**This is the current active design area.**

The immediate next question is the **Violet Seal model**:

- Does Seal use discrete stacks, a continuous meter, or another buildup representation?
- Does partial buildup already produce a minor effect?
- What happens when Seal reaches completion?
- How does completed Seal behave on normal enemies, elites, and bosses?
- How can Basic, Held, Dash, Parry / Counter, and Deathblow interact with Seal without becoming five copies of the same mechanic?

After Seal is coherent:

1. define a scalable recurring mechanic for the ivory family,
2. define a scalable recurring mechanic for the crimson family,
3. revisit weak pale-silver and gold core-slot concepts,
4. approve the full five-by-five slotted Technique matrix.

Do not rebuild cross-family Techniques or refinements before this core pass is complete.

# 2. Later Technique layers

After the core matrix is stable, rebuild only the ideas that remain strong:

- slotless same-family supporting Techniques,
- cross-family Techniques,
- Legendary / capstone Techniques,
- small refinements for eligible slotted Techniques,
- rare replacement candidates,
- rarity assignments and eligibility rules.

The final Technique count should emerge from quality rather than a predetermined quota.

# 3. Remaining run-build catalog

After the Technique roster is coherent, define:

- initial Relic count and final rarity structure,
- whether consumables ship,
- final Technique reward frequency and offer weighting,
- and entries requiring unique icons, VFX, animation, or audio.

# 4. Permanent Prosthetic / Forge scope

Define individual permanent upgrade paths for the eight Prosthetics through the Forge.

Scrolls are currently the persistent Forge currency. Exact branch counts, ranks, costs, and tool-specific upgrade depth remain open.

# 5. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern.

# 6. Narrative delivery and authored-content package

Define first-death presentation, bloodline confirmation, Shogun dialogue progression, codex / NPC updates, ending / credits requirements, voice scope, and delivery ownership.

# 7. Postgame release package

Define repeat Heart-route access, repeat-clear rewards, launch completion goals, and required postgame UI states.

## Deferred implementation and balance work

Keep exact values in their owning files, including damage, posture, Rupture buildup, Seal buildup, guard pressure, stagger, reach, movement, recovery, Blood values, room probabilities, prices, rarity weights, replacement rates, permanent-upgrade percentages, and final VFX / animation timing.
