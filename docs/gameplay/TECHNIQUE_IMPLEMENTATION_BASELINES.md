---
id: GAMEPLAY-TECHNIQUE-IMPLEMENTATION-BASELINES
title: Technique Implementation Baselines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - techniques
  - implementation
  - first-playtest
  - echo
  - rupture
  - seal
  - rift
  - crimson
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
  - GAMEPLAY-ASPECT-IMPLEMENTATION-BASELINES
---

# Technique Implementation Baselines

This file owns the shared first-playtest numerical constants and normalization rules used to implement the already-approved Technique catalog.

`TECHNIQUES.md` owns system-wide Technique rules. `TECHNIQUE_CATALOG.md` owns the 50-Technique + 10-refinement roster, names, rarities, prerequisites, and qualitative behavior. This file does **not** redesign that roster.

All values below are approved prototype implementation targets. They are expected to be tuned after Godot playtesting without reopening Technique-family architecture.

# Shared proc and normalization rules

- One normal authored sword hit has a **1.0 proc coefficient**.
- A secondary/AoE target normally receives a **0.5 proc coefficient** unless an effect explicitly defines a different value.
- Repeated subhits such as Pale Barrage use **0.25 coefficient per subhit**, with a maximum **1.5 total proc contribution per originating action**.
- Technique-created secondary damage normally has **0 proc coefficient** and cannot recursively trigger the same or another ordinary proc.
- Explicit Cross-family Techniques may create approved exceptions to the previous rule.
- One continuous Basic sequence may contribute at most **2 full family applications to the same target** unless a Technique explicitly defines a lower cap.
- Rarity does not apply a universal numerical multiplier. Common / Uncommon / Rare / Legendary primarily describe specialization, prerequisites, transformation, and reward restriction.

These rules exist so Wolf's hit frequency, Wraith's multi-target reach, and Ronin's large single hits can all use one Technique roster without accidental proc dominance.

# Echo

Echo is delayed additional sword damage attached to a qualifying action.

## Normal Echo

- delay: **0.55 seconds**,
- Health damage: **35% of the originating sword hit's direct Health damage**,
- posture damage: **35% of the originating hit's posture damage**,
- uses the originating attack's authored direction/contact orientation,
- cannot trigger another ordinary Echo.

## Heavy Echo

Used by effects such as `Second Draw` where the catalog calls for a heavier delayed Echo:

- Health damage: **50% of source Health damage**,
- posture damage: **45% of source posture damage**.

## Shared Echo support constants

- `Passing Memory` propagated Echo: **60% of the triggering Echo's package**.
- `Pale Wake` secondary-target result: **60% of the Echo's normal damage/posture package**.
- `Gathering Memory`: later pending Echoes created against the same enemy before earlier Echoes resolve gain **+20% power each**, capped at **+40%**.
- `Unforgotten Steel`: the additional weaker Echo is **55% of the normal Echo** and resolves approximately **0.35 seconds** after that Echo.
- `Lingering Cut`: the same target may receive at most **2 Echoes from one continuous Basic sequence**.

Echo-created damage does not recursively create ordinary Echoes or unrestricted Technique procs.

# Rupture

Rupture is a visible posture-oriented buildup system.

## Shared meter

- meter maximum: **100 buildup**,
- no passive buildup decay during the encounter in the first prototype.

When the meter reaches 100 it immediately Ruptures:

- primary target: **45 posture damage**,
- nearby enemies: **20 posture damage** within approximately **90 px**,
- eligible ordinary enemies receive the approved strong hit reaction,
- bosses/elites receive posture pressure while preserving authored encounter protections,
- no direct Health damage is added by the base Rupture event,
- meter resets to 0 unless an owned Technique explicitly changes the reset state.

## Shared Rupture application targets

- `Rupturing Edge`: maximum **60 buildup per complete continuous Basic sequence** against one target.
- `Breaching Step`: **25 buildup** to its primary target.
- `Breaking Reversal`: **45 buildup**.
- `Shattered Ground`: surviving affected enemies receive **30 buildup**.

## Shared Rupture support constants

- `Guardbreaker`: **+50% Rupture buildup** when the qualifying hit is made against a guarding enemy.
- `Chain Break`: nearby valid enemies receive **25 buildup** when the primary target Ruptures.
- `Faultline`: after Rupture, reset that target to **25 buildup instead of 0**.
- `Heavenbreaker`: nearby enemies already at **70+ buildup** immediately Rupture; these secondary Ruptures cannot recursively trigger another Heavenbreaker chain.

# Seal

Seal is a discrete three-mark control pattern. It does not use a hidden continuous buildup meter.

## Shared pattern

- target stores **0 to 3 visible Seals**,
- normal Seal lifetime: **4.0 seconds**,
- applying another Seal refreshes the active pattern to 4.0 seconds,
- one continuous Basic sequence may apply at most **2 Seals to the same target**.

Movement effects:

- **1 Seal:** approximately **-10% movement speed**,
- **2 Seals:** approximately **-20% movement speed** and **-25% eligible ordinary reposition movement**,
- **3 Seals:** immediately triggers **Bind**, then clears the normal Seal pattern unless an owned effect changes the reset state.

## Bind duration

- ordinary enemy: **1.25 seconds**,
- elite: **0.8 seconds**,
- boss: **0.5 seconds**.

Boss/elite Bind never cancels or suppresses protected authored actions. It may restrict ordinary locomotion, but does not interrupt attacks, leaps, charges, scripted movement, phase transitions, grabs, or other protected encounter mechanics.

## Shared Seal application targets

- `Binding Draw`: **2 Seals**.
- `Counterseal`: **2 Seals**.
- ordinary spread/transfer effects normally apply **1 Seal**.
- `Residual Knot`: target retains **1 Seal** after Bind ends.
- `Closed Circle`: eligible nearby targets receive **2 Seals**; the application cannot recursively trigger itself.

# Rift

Rift is one evolving visible ivory fracture. It must never be presented as an exposed generic stack counter.

## Shared fuse and intensity

- normal fuse: **1.5 seconds**,
- maximum intensity: **III**.

| Intensity | Health damage when Rift opens |
|---|---:|
| I | **16** |
| II | **24** |
| III | **34** |

Rules:

- first valid application creates Intensity I unless the Technique explicitly starts higher,
- later valid applications before opening increase the same Rift's intensity,
- a continuous Basic sequence may increase the same Rift by at most **2 intensity steps**,
- the fuse does not create additional Rifts,
- opening damage is direct Health damage and is not Rupture/posture damage by default.

## Shared Rift Technique constants

- `Deep Rift`: creates Intensity II on an unmarked target or adds **+2 intensity steps** to an existing Rift, capped at III.
- `Shearing Step`: fresh Rift uses a **0.9-second fuse**; against an existing Rift it adds +1 intensity and removes approximately **0.4 seconds** from the remaining fuse.
- `Rift Reversal`: creates Intensity II on an unmarked target; against an existing Rift it drives the Rift to maximum intensity and **forces it open**.
- `Lingering Scar`: the next Rift created on that enemy begins at **Intensity II**.
- `Overpressure`: reaching Intensity III immediately opens the Rift.
- `Fracture Spread`: transferred Rift begins at **Intensity I** and cannot recursively spread again.

## Ivory Collapse

When a maximum-intensity Rift opens with `Ivory Collapse`:

- primary maximum-intensity burst gains approximately **+20% Health damage**,
- nearby valid enemies receive approximately **18 direct Health damage**,
- compact secondary radius: approximately **100 px**.

# Crimson

Crimson is the direct-Health and genuine-backstab specialist family. It uses the universal backstab classification in `COMBAT_IMPLEMENTATION_BASELINE.md`; it does not manufacture rear hits.

## Vulnerable

- base duration: **3.0 seconds**,
- reapplication refreshes duration rather than stacking magnitude,
- universal normal backstab remains **1.25x direct Health damage**,
- a genuine backstab against a Vulnerable target deals **1.75x total direct Health damage**,
- the 1.75x treatment replaces the ordinary 1.25x backstab multiplier for that hit rather than multiplying 1.25 x 1.75,
- no posture multiplier,
- no movement slow,
- no stun/root,
- no facing manipulation,
- no awareness manipulation.

## Shared Crimson Technique constants

- `Blood Arc`: adds approximately **12 direct Health damage** through its bounded wide sword arc.
- `Deep Cut`: a genuine Held backstab gains approximately **+40% direct Health damage** and ignores **30% of applicable defensive damage mitigation**.
- `Predator's Wake`: Vulnerable application radius approximately **120 px** around the completed Deathblow.
- `Fresh Wound`: a genuine backstab against a Vulnerable enemy refreshes Vulnerable to the full **3.0 seconds**.
- `Blood Trail`: transfer range approximately **120 px** to one valid surviving enemy.
- `Severed Line`: rear cleave deals approximately **45% of the triggering backstab's direct Health damage** to valid enemies immediately behind the primary target.

## Unseen

`Unseen` first-playtest rules:

- duration: **2.5 seconds**,
- attacking ends Unseen,
- taking Health damage ends Unseen,
- no invulnerability,
- does not create fake backstabs or force enemy facing,
- first successful genuine backstab while Unseen gains approximately **+50% direct Health damage**, then Unseen ends.

# Cross-family implementation constants

The existing five Cross-family Techniques use these first-playtest values:

- `Resonant Break` — Echoes contribute **10 Rupture buildup**, capped at **20 buildup from one originating action**.
- `Fractured Memory` — an Echo may add **+1 Rift intensity**, maximum once per originating action; Echoes cannot create a fresh Rift.
- `Shattered Scar` — triggering Rupture adds **+2 Rift intensity** to an existing Rift, capped at III.
- `Exposed Break` — triggering Rupture applies the normal **3.0-second Vulnerable** status.
- `Bound Wound` — Vulnerable remains active throughout Bind and for **1.0 additional second** afterward.

Cross-family interactions may not recursively create unrestricted chains.

# Family identity summary

Use these as the first-playtest mathematical identities:

- **Echo:** approximately 35–50% delayed replication of qualifying sword impact.
- **Rupture:** 100-point buildup into a 45-posture primary event plus bounded nearby posture pressure.
- **Seal:** three discrete marks into short movement restriction / Bind.
- **Rift:** one 1.5-second fracture progressing through 16 → 24 → 34 direct-Health burst values.
- **Crimson:** 3-second Vulnerable with a 1.75x genuine-backstab payoff plus separate direct-Health/AoE tools.

# Planning status — COMPLETE

The current Technique package is complete for implementation planning when read together with `TECHNIQUE_CATALOG.md`, `TECHNIQUES.md`, and the Aspect/combat implementation baselines.

Do **not** create another open planning pass merely to assign one-off values already implied by these family constants and the catalog's qualitative entries. When wiring an individual Technique into Godot, ordinary host-specific geometry, animation synchronization, exact hitbox width, proc polish, and similar low-level values are implementation/playtest work.

A Technique design question should reopen only if implementation exposes a genuinely missing behavior, contradiction, unusable interaction, or balance problem that cannot be solved by tuning an existing field.

# Deferred to playtesting

The following remain tunable after implementation:

- final proc coefficients,
- final family damage/buildup numbers,
- final status durations,
- final Bind boss/elite scaling,
- final secondary radii,
- final multi-hit caps,
- final Crimson/backstab magnitude,
- final Rift fuse timing,
- final Rupture trigger cadence.

These are balance variables, not reasons to reopen the approved Technique roster or family structure before implementation.