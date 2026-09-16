# Art Production

Authoritative art direction, technical standards, asset inventory, outsourcing workflow, visual-system briefs, and milestone scope belong here.

## Current production authority

Oathbound's production runtime is **authoritative planar 2D with fixed high-angle/isometric-style presentation**.

- characters use eight-direction 2D presentation;
- environments use layered illustrated 2D construction;
- feet/contact points own actor placement and Y-depth;
- combat VFX/telegraphs remain independent 2D layers;
- offline 3D rigs may be used to generate directional 2D character frames;
- live real-time 3D actors/environments are retired research, not the production default.

Read these first for current art/presentation work:

- [Art Direction](ART_DIRECTION.md)
- [Technical Standards](TECHNICAL_STANDARDS.md)
- [Rig-Rendered 2D Character Pipeline](RIG_RENDERED_2D_PIPELINE.md)
- [Isometric 2D Runtime Presentation Direction](../overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md)
- [Asset Inventory](ASSET_INVENTORY.md)
- [Character and Enemy Brief Standard](CHARACTER_BRIEF_STANDARD.md)
- [Outsourcing Workflow](OUTSOURCING_WORKFLOW.md)
- [Art Milestones](milestones/README.md)

System-specific presentation authorities:

- [Core Combat and Corruption VFX](CORE_VFX.md)
- [Blood Aspect VFX](ASPECT_VFX.md)
- [Prosthetic Tool VFX](PROSTHETIC_VFX.md)
- [Technique VFX](TECHNIQUE_VFX.md)
- [Item, Pickup, and Reward Art](ITEM_REWARD_ART.md)

## Current character-production gate

Do not scale actor production across the roster yet.

Current order:

1. custom Akio source model/rig;
2. Akio Proof A — Idle + Move + Quick Slash, eight directions, high-resolution masters and runtime derivatives;
3. in-game clean-prerender vs pixel/downsample comparison at the accepted Hushiro camera;
4. finish Akio's current Stage 1 set after the minimum proof passes;
5. one Corrupted Swordsman on the same pipeline;
6. only then approve or reject roster-wide rig-rendered production.

The artist-facing Akio brief is `docs/commissions/akio/AKIO_COMMISSION_BRIEF.md`.

## Current gameplay dependencies

Art-production files translate current gameplay authorities; they do not preserve superseded combat models for historical convenience.

### Combat

Current shared combat assumptions:

- Health is the normal player/enemy defeat resource;
- standard enemies use hidden Poise/interruption rather than a universal visible Posture/deathblow loop;
- player-facing Posture is retired;
- defense is kit-specific where identity demands it;
- Ronin retains the authored guard/Reprisal identity;
- bosses/minibosses may own bespoke stagger/vulnerability states;
- combat presentation must remain readable at the accepted small screen-space scale.

Use `docs/gameplay/COMBAT.md` and `docs/overview/V2_COMBAT_DIRECTION.md` as the owning authorities.

### Blood Aspects

Wolf, Wraith, and Ronin remain the fixed launch Aspect families. Art should communicate their distinct weapon/commitment identities without assuming every Aspect shares the same timed defensive action.

Detailed Tier/Blood-Art presentation requirements belong to the current Aspect gameplay docs plus `ASPECT_VFX.md` after reconciliation with those authorities.

### Techniques

Techniques have **no inventory slots and no global inventory cap**.

The active catalog currently contains **40 Techniques + 6 refinements** after reconciliation with Combat V2's supported shared triggers. The five families remain Echo, Rupture, Seal, Rift, and Crimson.

Art/UI must not imply the retired four-active-plus-reserve model, exclusive per-action equipment slots, a temporary Prosthetic-Technique layer, universal Deathblow requirements, or universal Parry/Counter eligibility.

Use `docs/gameplay/TECHNIQUES.md` and `docs/gameplay/TECHNIQUE_CATALOG.md` for current counts/eligibility rather than duplicating a historical roster here.

### Prosthetics and Relics

- eight launch Prosthetic tools remain in scope;
- one Prosthetic is equipped at a time;
- the Forge owns 19 permanent Prosthetic upgrades;
- 10 persistent Relics remain in scope;
- one Relic is equipped;
- Relics use Base -> Mastery I -> Mastery II progression;
- no separate Relic Reliquary or rarity-badge production family is required.

### Permanent progression

Permanent station scope remains:

- **Bloodwell:** Akio + Run Infrastructure;
- **Forge Bench:** Prosthetics + Relics;
- **Blood Mirror:** Blood Aspect progression after unlock.

The old alternate-weapon/socket Forge system and old fixed three-branch Bloodwell presentation are not production targets.

## Environment production dependency

Production supports the approved regional route shape:

- Hushiro — 12 counted chambers;
- Yomori — 10 counted chambers;
- Kagutsuchi — 11 counted chambers.

These are not 33 unique illustrated rooms. Production should build reusable layered environment foundations, prop/occluder families, regional skins, landmarks, functional-room treatments, miniboss/boss arenas, and authored composition variants.

Use ground-contact depth logic and split tall props into base/upper layers when needed for readable actor overlap.

## Authority rule

Art-production documents translate approved design into asset requirements. They do not invent mechanics, lore, values, catalog entries, route algorithms, or encounter behavior when the owning design file remains unresolved.

When an art-production file conflicts with a current gameplay/overview authority, reconcile the art file rather than preserving the stale mechanic as a second design path.

The asset inventory records high-level groups. Individual briefs own detailed visual requirements. Milestones own production grouping, dependencies, and quotation boundaries.
