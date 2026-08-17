# Gameplay

Authoritative player-facing mechanics and system rules belong here.

## Core documents

- [Core Loop](CORE_LOOP.md)
- [Combat](COMBAT.md)
- [Run Structure](RUN_STRUCTURE.md)
- [Blood Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md)
- [Blood Aspects](BLOOD_ASPECTS.md)
- [Blood Aspect Identity Guidelines](ASPECT_IDENTITY_GUIDELINES.md)
- [Wolf Blood Aspect](WOLF_ASPECT.md)
- [Wraith Blood Aspect](WRAITH_ASPECT.md)
- [Ronin Blood Aspect](RONIN_ASPECT.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Relics](RELICS.md)
- [Progression](PROGRESSION.md)
- [Blood Cavern Trial System](BLOOD_CAVERN_TRIALS.md)
- [Prosthetic Tools](PROSTHETICS.md)
- [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md)

## Current status

The launch Blood Aspect roster and qualitative Tier 0-IV packages are locked for current paper-design scope:

- **Wolf:** four-hit fast close-range pressure and pursuit.
- **Wraith:** two-hit extended spectral reach and frontal control.
- **Ronin:** three-hit slow heavy impact and defensive stability.

No further Aspect or Tier audit is active unless prototyping exposes a concrete problem. Exact attack values, timings, hitboxes, growth percentages, and related balance remain implementation work.

The Technique architecture uses five direct combat slots—Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow—plus slotless Supporting, Cross-family, and Legendary Techniques. There is **no global Technique inventory cap**.

The current working Technique roster is complete at qualitative paper-design depth:

- **25 direct slotted Techniques**,
- **15 same-family Supporting Techniques**,
- **5 Cross-family Techniques**,
- **5 Legendary Techniques**,
- **10 refinements** that are not counted as separate Techniques.

This produces **50 actual Techniques plus 10 refinements**. Rarity and prerequisite / eligibility rules are approved in `TECHNIQUE_CATALOG.md` and `TECHNIQUES.md`.

The Relic system is also complete at current qualitative paper-design depth:

- **10 approved launch Relics**,
- one equipped Relic slot,
- persistent collection ownership,
- kill-earned mastery while equipped,
- run-active benefits,
- no Relic rarity tiers,
- Strand-side progression and management at the **Forge Bench** alongside Prosthetics.

Exact Relic acquisition allocation, mastery thresholds, Forge rank presentation, transition swap timing, and numerical values remain later design/playtest work.

The eight Prosthetic Forge paths are locked as shallow linear permanent progression.

Broad permanent-upgrade station ownership is also scoped:

- **Bloodwell:** Akio + Run Infrastructure,
- **Forge Bench:** Prosthetics + Relics,
- **Blood Mirror:** Blood Aspects, with the Mirror locked at the beginning and unlocked later.

Exact permanent-upgrade nodes, values, rank counts, costs, and unlock timing remain later detailed design rather than current full-game scope blockers.

The major-system production-scope audit and all three prototype regional chamber structures are complete. The active gameplay package is **full-run integration, rewards, encounters, and pacing**.

Current approved prototype regional structure:

- **Hushiro:** 12 counted chambers, Keeper at Chamber 12, approximately 14–16 active minutes.
- **Yomori:** 10 counted chambers, Twin Maws at Chamber 10, approximately 12–14 active minutes.
- **Kagutsuchi:** 11 counted chambers, Eclipse Shogun at Chamber 11, approximately 15–17 active minutes.

The full regional baseline is therefore **33 counted chambers**. All three regions use fixed chamber-index bands, weighted eligible contents, hard route-opportunity safeguards, optional miniboss routing, previewed exits, and fixed boss endpoints. Keeper and Twin Maws have separate non-counted post-boss transition spaces; the Shogun opens the specialized Heart route.

The next run-design layer is to evaluate those 33 chambers together and define provisional branching frequency, room/reward category weighting, Technique cadence, Shrine/Shop/Rest frequency, encounter pacing, economy pressure, and related route-generation values. Those numbers remain prototype/playtest targets rather than final balance law.

The successful-run duration target remains approximately **45–50 minutes** in [Run Structure](RUN_STRUCTURE.md).

## Authority rule

Gameplay files own mechanics. Lore explains fiction, content owns combatant/location identity, UI owns interaction behavior, art owns visual requirements, and milestones own production scope. Summary files must not redefine those authorities.