# OATHBOUND_AGENT_CONTROL_PLANE

Repository state is authority. Conversation/project memory is cache only.

## Boot
1. Read `main:AGENTS.md` in a fresh session.
2. If an active PR/branch is recorded below, inspect that exact head before editing.
3. Read only the authorities and runtime files needed for the task.
4. Do not ask Sean to restate recoverable repository context.

## Current state
```yaml
schema: 11
updated_utc: 2026-09-16T18:45:00Z
repo: seancl8611/oathbound
active_branch: agent/isometric-2d-main-integration
active_pr: 197
current_head: bb92b37333bd236a366f838292b820f51215177d
objective: >-
  Finish the clean main integration: remove stale live-3D and retired combat references,
  keep current Combat V2/runtime documentation aligned, validate the accepted isometric
  2D presentation and rig-rendered character pipeline, then merge PR #197 when relevant
  exact-head checks are green.
```

## Current authorities
- Game identity: `docs/overview/GAME_OVERVIEW.md`
- Combat: `docs/overview/V2_COMBAT_DIRECTION.md` + `docs/gameplay/COMBAT.md`
- Presentation: `docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md`
- Art direction: `docs/art_production/ART_DIRECTION.md`
- Character production: `docs/art_production/RIG_RENDERED_2D_PIPELINE.md`
- Akio artist brief: `docs/commissions/akio/AKIO_COMMISSION_BRIEF.md`
- Technique rules/catalog: `docs/gameplay/TECHNIQUES.md` + `docs/gameplay/TECHNIQUE_CATALOG.md`
- Aspect rules: `docs/gameplay/BLOOD_ASPECTS.md` + individual Aspect files.

## Locked presentation direction
- Runtime is authoritative planar 2D.
- Fixed high-angle/isometric-style `Camera2D`.
- Accepted proving profile: zoom `0.50`, ground compression `0.72`, framing offset `(0, -12)`.
- Characters use eight directional 2D presentations: `e,se,s,sw,w,nw,n,ne`.
- Actor world position is the feet/contact anchor; Y depth follows the ground contact point.
- Environments are layered illustrated 2D.
- Combat VFX/telegraphs remain independent 2D presentation layers.
- Offline 3D rigs are valid art-production sources only: model -> rig -> animate -> directional render -> 2D frames.
- Do not restore live Planar3D actors or Camera3D gameplay presentation without a new explicit direction decision.

## Current combat contract
- Health is the normal defeat resource for player and standard enemies.
- Standard enemies use hidden Poise/interruption resistance for flinch/stagger/action interruption.
- There is **no universal player Posture bar, enemy Posture bar, posture-break kill loop, Deathblow prompt, or mandatory execution layer**.
- `posture_damage`/similar fields may remain temporarily as internal compatibility pressure channels; they are not permission to restore visible Posture gameplay.
- Defense is kit-specific where identity requires it. Ronin retains Guard/Reprisal identity.
- Do not assume a universal parry/counter event across all Aspects.
- Bosses/minibosses may own bespoke stagger, armor, vulnerability, phase, or recovery rules.
- Pressure/AI difficulty comes from readable multi-enemy intentions, geometry, role combinations, movement, and authored commitments rather than HP sponges.

## Character production contract
- `DirectionalActorPresentation` is presentation-only; combat/movement remain authoritative elsewhere.
- Animation naming is `<state>_<direction>` and `attack_<action_id>_<direction>`.
- Runtime source frames use stable canvas/feet registration and no gameplay root motion.
- Current proof derivative is 128x128 with foot anchor `(64,112)` and 12 fps baseline where applicable.
- Paid character source should preserve high-resolution transparent masters; 128x128 is a derivative, not the paid master.
- Akio is the first production candidate. One concise artist-facing source exists: `docs/commissions/akio/AKIO_COMMISSION_BRIEF.md`.
- Do not proliferate artist documents unless a separate deliverable genuinely needs its own brief.

## Akio commission gate
Stage 1 animation set:
- Idle
- Move / combat run
- Dash / step-dodge
- Defend
- Hurt
- Death
- Quick Slash
- Cross Cut
- Heavy Cleave

Qualitative combo language: fast opener -> distinct continuation -> heavy finisher. Do not dictate exact impact milliseconds to the animator; tune Godot around accepted animation while keeping gameplay authority in Godot.

Blood Aspects are later dedicated animation/presentation libraries. Wolf is fast/aggressive, Wraith is longer-range/spacing-focused, Ronin is slower/heavier with Guard/Reprisal identity. The base Akio rig should remain reusable for later weapon, silhouette, material, stance, and animation variation.

## Engineering guards
- Presentation never owns movement, hitboxes, damage, invulnerability, target selection, AI, Pressure Director admission, encounter flow, rewards, or progression.
- Replacement body art is exclusive; do not render old bodies under new directional sprites.
- Keep gameplay facing authoritative even when the visible sprite snaps to one of eight directions.
- Do not reintroduce retired Posture/Deathblow UI or rewards through compatibility code/tests/docs.
- Do not remove hidden Poise/interruption simply because visible Posture is retired.
- Do not invent Heart combat.
- Deterministic CI must fail on missing PASS markers and GDScript runtime errors.

## PR policy
- Routine coherent PR merge approval is not required.
- Fix failing relevant CI instead of asking Sean to diagnose it.
- Delete or retire CI that validates an explicitly abandoned architecture rather than making current code satisfy obsolete checks.
- Merge a coherent, mergeable PR autonomously only after relevant exact-head validation is green.
- After merge, branch subsequent work from updated `main`; do not continue an obsolete feature branch.

## Current cleanup priorities
1. Remove obsolete Planar3D/three-quarter validation that conflicts with the accepted 2D production direction.
2. Reconcile stale Posture/Deathblow/universal-counter references in current docs, tests, settings, catalogs, and runtime seams.
3. Keep the active Technique catalog/runtime aligned with the current documented 40 Techniques + 6 refinements instead of restoring retired trigger families merely to preserve an old count.
4. Keep Akio commissioning/rig-rendered pipeline documents concise and production-useful.
5. Validate PR #197 and merge it into `main` once current checks are clean.

## Work loop
`AGENTS.md -> exact active head -> owning authority/runtime -> smallest coherent patch -> targeted CI -> merge when appropriate -> updated main -> refresh AGENTS checkpoint`
