---
id: CONTENT-AREA2-OVERVIEW
title: Yomori Grove
category: content
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - area-2
  - yomori-grove
  - forest
  - spirits
  - predators
  - adaptation
  - chamber-structure
related:
  - ART-DIRECTION
  - ART-MILESTONE-05
  - CONTENT-AREA2-ENEMIES
  - CONTENT-AREA2-MINIBOSSES
  - CONTENT-AREA2-BOSS
  - GAMEPLAY-RUN-STRUCTURE
  - CONTENT-ROOM-TYPES
---

# Yomori Grove

Yomori Grove is Area 2, where the long presence of Beast Blood bearers has devastated the forest and left enduring physical and spiritual remnants.

The region represents adaptation rather than immediate collapse. Suffering remains present, but the inhabitants are no longer reacting only as victims in the middle of a catastrophe. Predators, spirits, and other remnants have settled into more established patterns of existence shaped by the curse.

## Palette

- Rot-black bark
- Bone-white trunks
- Wet earth brown
- Corpse-gray stone
- Deep moss green-black
- Cold fog gray
- Crimson leaf mass
- Dark blood-red sap
- Pale spirit light
- Cyan-blue fungal glow

The region should feel dark and internally lit by corruption rather than by civilization or open sky.

## Material language

Root-knotted earth, swollen bark, red-veined trunks, slick stone, damp moss, fungal bloom, old shrine lanterns, trail markers, and blood-rich sap. Materials should feel overgrown, unstable, spiritually contaminated, and biologically pressurized.

These visual effects do not mean Beast Blood spreads through soil, roots, water, prey, or vegetation. The damaged ecology reflects the prolonged presence and actions of corrupted people and beasts rather than an environmental route of transmission.

## Enemy-family read

Enemies are long-term outcomes surrounding the same Beast Blood curse: corrupted beasts, hunting shades, spirits of past inhabitants, and territorial remnants emerging from brush, canopy, roots, mist, and shadow.

Predators should feel more hesitant, observant, intelligent, cunning, and dangerous than Area 1's unstable creatures. They stalk, test distance, retreat, isolate, and choose favorable moments rather than relying only on exposed aggression.

Area 2's spirits are truly the spirits of people who died after being shaped by Beast Blood. They persist less as complete ghosts than as incomplete memories or remnants of who they were. A spirit may retain an attachment, duty, emotion, ritual, path, or fighting instinct without preserving a full living personality.

Some spirits may appear calm, accepting, resigned, or bound into repeated patterns. Others remain hostile, but their hostility should feel deliberate or territorial rather than frantic. Their persistence belongs to the same curse and does not require a separate supernatural force.

Detailed family and unit definitions belong in [Area 2 Enemies](ENEMIES.md).

## Architecture and ambient pressure

Old hunting paths, shrine trails, torii, lantern markers, wayfinding stones, abandoned rest sites, and broken crossings are overtaken by roots, rolling mist, fungal pulse, pale spirit residue, red sap, leaf drift, slick mud, dense brush, and obscured sightlines.

## Movement philosophy

Beasts stalk, circle, observe, withdraw, and lunge. Spirit forms flicker, glide, partially manifest, and relocate with greater calm or purpose than Area 1's ruptured victims. Ambient uncertainty is encouraged, but every targetable state, attack startup, reappearance point, and control zone must remain fair.

## Standard enemy roster

- [Lingering Wraith](enemies/LINGERING_WRAITH.md)
- [Lantern Wraith](enemies/LANTERN_WRAITH.md)
- [Mist Shepherd](enemies/MIST_SHEPHERD.md)
- [Stalker Hound](enemies/STALKER_HOUND.md)

## Major encounters

1. [The Embered Pilgrim and Rotwood Host](MINIBOSSES.md)
2. [Twin Maws — Rootfang and Briarthorn](BOSS.md)

The Embered Pilgrim and Rotwood Host are the region's two minibosses. Rootfang and Briarthorn form the paired final boss. Whichever twin dies first transfers its half of the corrupted bond to the survivor, creating an empowered second half.

## Combat identity

- spirit manifestation and disappearance,
- disciplined spectral dueling,
- light-source-based ranged telegraphs,
- mist-linked support behavior,
- patient predator pressure and elite pounce timing,
- root and fungal area control,
- corrupted fire-rite escalation,
- shell-and-core state recognition,
- simultaneous melee and arena-control pressure,
- soul-transfer empowerment.

## Approved prototype run structure

Yomori uses **10 counted chambers** in the current prototype structure:

- **Chambers 1–2:** opening stretch
- **Chambers 3–7:** main stretch
- **Chambers 8–9:** pre-boss stretch
- **Chamber 10:** Twin Maws

Branching begins immediately, and Yomori Chamber 1 does not force a Technique reward because the player already arrives with an established run build. One optional miniboss opportunity is generated during Chambers 4–7, selecting either The Embered Pilgrim or Rotwood Host for that run. The player may route around it, so a normal Yomori run contains 0–1 fought minibosses.

The route network must contain at least one Shrine, one Shop, one Rest, one miniboss opportunity, and two Technique-reward opportunities. These are route opportunities rather than mandatory visits. Across Chambers 8–9, at least one available route should provide meaningful pre-boss preparation without making full recovery automatic.

Yomori is intentionally shorter than Hushiro because its normal encounters, minibosses, and Twin Maws are expected to be denser and mechanically more complex. The region currently targets approximately **12–14 minutes** of active run time.

Detailed generation rules, chamber eligibility, and transition behavior are owned by `docs/gameplay/RUN_STRUCTURE.md`; exact percentage weights and encounter compositions remain playtest tuning.

## Production dependencies

- Area 1 establishes shared scale, VFX hierarchy, room readability, and the longer opening-region route template.
- Area 2 requires its own environment kit before final room variants.
- The Yomori room kit must support the approved 10-chamber prototype route without requiring unique art for every chamber.
- Spirit effects must preserve attack direction, targetability, and safe-space readability.
- Audio is a functional readability layer for enemies such as the Mist Shepherd.
- Twin Maws arena effects must support two active roles and a clear survivor-empowerment transition.
