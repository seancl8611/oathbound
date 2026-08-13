---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-12
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
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind; Crimson does not create fake backstab windows by altering enemy facing or widening the rear arc.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, or Legendary.
- Exact damage, timing, hitboxes, buildup rates, durations, rarity weights, and VFX timing remain prototype and implementation work.

## Current family-design state

The earlier broad Technique draft is no longer treated as the current launch roster. The five core family mechanics are defined at qualitative core-rule depth, but the complete direct five-by-five Technique matrix still needs to be approved.

Current state:

- **Pale silver / twin slash:** Echo mechanic defined. Echoes are delayed additional slashes; some core-slot concepts still need rewriting so the scalable mechanic is the echo itself rather than simply repeating Akio's action.
- **Gold / cracked crest:** Rupture mechanic defined at qualitative gameplay depth.
- **Violet / binding knot:** Seal mechanic defined at qualitative gameplay depth.
- **Ivory / blade circle:** Rift mechanic defined. A single evolving fracture mark automatically opens after a short delay for Health damage; further qualifying applications intensify the same mark and strengthen the burst.
- **Crimson / split blood drop:** Crimson has been redesigned around **Vulnerable, backstab payoff, and direct Health damage**. The family core and its five direct slot concepts are approved at qualitative depth.

The families are not required to use the same buildup model or scale identically. Every direct Technique should still provide worthwhile standalone value when it is the player's only pickup from that family.

### Rupture rule

- Gold effects may add **Rupture buildup** to a visible enemy meter.
- The old **Fracture** terminology is removed.
- Partial Rupture buildup has no separate effect.
- Filling the meter immediately triggers **Rupture** and resets the meter.
- Rupture deals a large burst of posture damage, creates a strong hit reaction where allowed, and sends a smaller posture shockwave into nearby enemies.
- Not every Gold Technique must add Rupture buildup; direct posture, guard-breaking, impact, and bounded AoE effects can still belong to the family.

### Seal rule

- Violet uses discrete visible **Seal stacks**, not a buildup meter.
- One Seal causes a minor movement-speed reduction.
- Two Seals cause a stronger movement reduction and restrict qualifying movement abilities such as lunges, leaps, teleports, or retreats where applicable.
- Three Seals complete the pattern and briefly **Bind** the enemy in place.
- Bind is not a stun: the enemy may still perform attacks that are valid from its current position.
- When Bind ends, the Seal stacks clear and must be built again.
- Seal does not inherently damage posture, stop posture recovery, or trigger a posture burst.
- Exact slow values, durations, stack expiry, and boss / protected-enemy resistance remain tuning and enemy-integration work.

### Rift rule

- Rift is represented by one visible ivory fracture-line on the enemy, not a meter or exposed stack counter.
- The first qualifying application starts a short fuse.
- A Rift always opens at the end of that fuse, even if it was never intensified further.
- Further qualifying Rift applications before opening intensify the same mark, making it visibly spread / worsen and increasing the eventual direct Health-damage burst.
- When the Rift opens, the fracture violently splits / flashes through the target and then disappears.
- Exact fuse, maximum intensity, application strength, damage, and boss scaling remain tuning work.

### Crimson / Vulnerable rule

- **Vulnerable** is a short enemy status effect.
- While Vulnerable, genuine backstabs against that enemy deal substantially increased direct Health damage.
- Vulnerable does not make frontal attacks count as backstabs and does not slow, stun, root, change enemy facing, suppress movement abilities, or change awareness.
- Not every Crimson Technique applies or references Vulnerable. Crimson may also use direct Health damage, bounded AoE, and standalone backstab payoffs.
- Every Crimson direct Technique must remain worthwhile when it is the player's only Crimson pickup.
- Exact Vulnerable duration, refresh rule, and backstab multiplier remain tuning work.

Approved Crimson direct row:

- **Basic Attack — Open Wound:** qualifying Basic hits apply Vulnerable for a short duration.
- **Held Attack — Deep Cut:** a Held Attack backstab deals extremely high direct Health damage and partially bypasses defensive mitigation; it does not need to apply Vulnerable.
- **Dash — Blood Arc:** Dash Attack releases a wide bounded crimson sword arc that deals direct Health damage to the struck target and nearby enemies; no Vulnerable requirement.
- **Parry / Counter — Exposed Guard:** a successful Counter applies Vulnerable to the struck enemy.
- **Deathblow — Predator's Wake:** after the Deathblow resolves, nearby surviving enemies become Vulnerable for a short duration.

A brief invisibility / enemy-awareness-suppression effect is reserved for a future **Crimson Legendary**, not an ordinary core Technique. Exact Legendary implementation remains deferred.

## Priority order

1. Finish and approve the five-by-five direct Technique matrix
2. Rebuild supporting Techniques, cross-family Techniques, Legendaries, and refinements
3. Finish Relic / consumable run-build scope
4. Scope permanent Prosthetic progression and the wider Forge package
5. Persistent progression, onboarding, and trial package
6. Narrative delivery and authored-content package
7. Postgame release package

# 1. Core Technique-slot matrix

**This is the current active design area.**

The immediate next task is to finish the unresolved direct Techniques:

- rewrite the weak Pale Silver / Echo slot concepts, especially Dash,
- revisit weak Gold / Rupture slot concepts, especially Counter and exact Deathblow behavior,
- revisit the working Violet / Seal slot concepts and approve the final five,
- define and approve how the five Rift slots apply, intensify, accelerate, or potentially force open the same Rift mechanic,
- keep the approved Crimson row stable unless the full-matrix audit exposes a concrete overlap, balance, readability, or implementation problem.

Then audit the complete matrix for:

- compatibility with Wolf, Wraith, and Ronin,
- boss and isolated-target usefulness,
- group power and AoE limits,
- high-frequency / multi-hit trigger normalization,
- genuine backstab access and Vulnerable usefulness across important enemies,
- mixed-family compatibility,
- visual readability when multiple family effects coexist,
- and whether each family feels like a coherent scalable path without being mechanically identical to the others.

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

Keep exact values in their owning files, including damage, posture, Rupture buildup, Rupture decay, Seal slow values, Seal duration / expiry, protected-enemy Seal resistance, Rift fuse / intensity / damage, Vulnerable duration / refresh / backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage / width, Predator's Wake radius, guard pressure, stagger, reach, movement, recovery, Blood values, room probabilities, prices, rarity weights, replacement rates, permanent-upgrade percentages, and final VFX / animation timing.
