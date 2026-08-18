# 2026-08-18 — Hushiro implementation baseline locked

Hushiro is complete for planning at first-playtest depth.

Approved implementation package:

- **10 authored standard encounters** selected by the route generator rather than procedurally assembled,
- standard rooms use discrete **2-4 wave** scripts; the next wave begins only after the prior wave is fully defeated,
- normal encounters contain roughly **10-18 total enemies**, with a lightweight Hound-heavy encounter reaching 19,
- normal simultaneous-enemy ceiling is **6** to preserve precise posture/parry/perilous readability,
- five reusable standard Combat footprints support the encounter pool without unique art per chamber,
- dedicated Shrine, Rest, Shop, Treasure, Ogre, Collector, Keeper, and transition spaces complete the Hushiro gameplay-space inventory,
- Village Ogre and The Collector receive first-playtest durability, move/response classes, escalation, arena, and Deathblow contracts,
- Keeper receives a complete two-phase first-playtest combat contract linked by the first Deathblow.

The encounter-density target deliberately takes inspiration from Hades-style substantial combat chambers while using fewer simultaneous bodies because Oathbound combat is more precise and authored.

Final enemy damage, frame timing, exact wave delay, spawn positioning, and encounter-volume tuning belong to Godot playtesting rather than another paper-design pass.

The active development question now becomes the **Godot documentation-to-code delta audit** and the shortest implementation backlog to a complete 12-chamber Hushiro run.

**Authority:** `docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md`, with qualitative identity retained in the existing Area 1 enemy/miniboss/boss/environment authorities.
