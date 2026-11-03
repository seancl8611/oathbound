# Akio — Proposed Milestone 2 Commission Plan (Planning Only)

**Status:** planning / **not quoted, contracted, paid or authorized** (2026-11-03). This file supplements, but does not change, the signed Hammer Milestone 1 agreement or the baseline [Akio commission brief](AKIO_COMMISSION_BRIEF.md). Obtain Hammer's feasibility input, a separate quote/contract or written amendment, and explicit owner approval before assigning work.

**Artist-facing working draft:** [Milestone 2 — Draft Scope and Quote Request](AKIO_MILESTONE_02_SCOPE_QUOTE_DRAFT.md). This is the editable scope to review, not a quotation from Hammer or a signed authorization. The matching Google Doc is filed in the existing Oathbound - Akio Character Commission Drive folder for iterative owner review.

## What "second commission" currently means

The planned second commission to **Hammer for Akio** is the six **remaining** base animation Actions, not a new character or the whole Art Production Milestone 2 Hushiro region:

1. Dash / Step-Dodge
2. Defend
3. Hurt
4. Death
5. Cross Cut (basic combo hit 2)
6. Heavy Cleave (basic combo hit 3)

Milestone 1 / Proof A already covers Akio's **Idle**, **Move / Combat Run**, **Quick Slash** plus source model/rig, subject to the signed agreement and outstanding review/acceptance. The intended combined baseline remains **nine** named source animations. The second commission has **no agreed price or schedule** in current repository planning; do not extend Milestone 1's $2,080 quote or its 50/50 checkpoint payment terms automatically to new work.

## Gating before quotation or kickoff

- Finish outstanding Milestone 1 checkpoint review, receive/approve final editable source and resolve or explicitly defer material Proof A art feedback. A functioning technical playtest does **not** imply artistic approval.
- Confirm which version of the delivered Akio model, rig, materials, camera and Actions will be the starting source for Milestone 2. Preserve the original artist source and its SHA-256; avoid inaccessible proprietary rig/plugins.
- Validate the current 8-direction Blender-to-PNG-to-Godot route with the [required exporter workflow](../../tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md); keep gameplay timing, dash travel and hitboxes Godot-owned.
- Agree on a **combat weapon-state policy** with Hammer before animating combo hits 2 and 3. The current Quick Slash returns the sword to the sheath, while current Idle/Run show a sheathed sword; merely cutting the last frames would snap transitions.
- Agree the target source 3D Action handoff and the client-side eight-view test. Hammer is **not** being commissioned to produce 8 separate PNG sequences or modify Godot gameplay unless separately scoped.

## Lessons from the first commission that change the plan

| Finding | Consequence for Milestone 2 scope and review |
|---|---|
| A real Blender Action can contain meaningful frames past its saved manual/NLA range (Run 16 vs verified 18; Quick Slash 41 vs 44-frame **candidate**). | Require per-Action key/slot/NLA inspection, intended start/end/loop closure and source-evaluated export before acceptance. The 44-frame Quick Slash must still be owner-playtested; do not declare it final. |
| Idle has a duplicated closing pose at Blender frame 40; validated loop uses frames 0–39. Non-looping attacks instead keep meaningful terminal frames. | Require **different explicit endpoint rules** for looped and non-looped Actions, with no dropped keys or repeated loop-closing frames. |
| The original complete draw–strike–sheathe Quick Slash read better at ~1.37 seconds, but resetting the sword between combo hits is visually wrong. | Do not speed up all poses or lock each combo strike to the current full Quick Slash length. Preserve anticipation/impact quality but establish drawn-sword continuations and legal interruption handoffs. |
| Source Run North/South gait can appear waddle-like; East/West is stronger. Separately, camera jitter and source-timed skating had client-side causes. | Review real high-angle N/S (plus diagonals) before sign-off; separate actual authored gait feedback from camera, scaling/filtering and locomotion defects. Do not charge artist for client problems. |
| 512x512, 30 FPS, eight independent views worked as an **experimental client integration**; retained masters and source Actions must outlive one export size. | Make tests reproducible across all eight directions, preserve consistent feet/weapon orientation and source-to-frame traceability. Do not confuse test values with final global style or contractual render deliverables. |
| Missing frames and incorrect timing can pass simple filename-count checks. | Enforce the **source audit -> deterministic render -> validation/contact sheets -> synchronized manifest/Godot promotion -> playtest** sequence for each delivered Action. |

## Proposed internal ordering (not extra contractual scope)

### Prep — approve the weapon-state design

Ask Hammer to assess the least expensive reliable approach. Preferred gameplay behavior to prototype: sheathed outside combat -> initial draw/attack -> **sword remains drawn** through consecutive strikes, guarded movement/dashes and brief idle -> deliberate sheath when safe. Allow a simpler alternative if tests demonstrate natural continuity.

Obtain a **separate, itemized option quote** for any assets *beyond the six baseline Actions*: drawn-sword Idle/Run variations, new drawn-sword Quick Slash variant, draw/sheath transitions, changes to existing source keys, or extra defend/dash pose variants. Some content may be derivable cheaply from existing Actions, but that must be confirmed with the artist; these are **not assumed included** as ordinary revisions.

### First paid sub-batch — make the basic combo real

- Prioritize **Cross Cut and Heavy Cleave**, with the agreed transition/weapon-state solution needed to connect them to Quick Slash.
- Require key poses/start and end weapon locations for Quick Slash -> Cross Cut -> Heavy Cleave, complete readable startup/active/recovery phases and clear attack identities. Avoid returning to sheathed pose between hits.
- Validate in Godot at the accepted high-angle camera with attack queuing/cancels. **Do not** bake hit windows, enemy damage, root travel or cooldowns into the Blender animations.
- Price/approve this as a distinct internal gate before authorizing all remaining Actions where commercially practical. The six baseline Actions still define the intended Milestone 2 scope.

### Second paid sub-batch — movement and reactions

- **Dash**, **Defend**, **Hurt**, **Death**, sharing the accepted rig and same combat stance/weapon continuity policy.
- Provide distinct interrupted/guarded/death poses and clean returns to appropriate Idle/Move state. Where supported by the chosen policy, test sheathed and drawn states without assuming unquoted variants exist.
- Test Dash -> Idle/Move/Attack, Defend -> response, Hurt -> recovery, and Death -> state reset/revival, including enemy overlaps.

### In-engine acceptance after each batch

- Artist delivers **editable Blender Actions**, all relevant model/rig/texture dependencies, Action/slot names, intended frame range, loop/non-loop and endpoint details, key pose/timing notes, and any necessary neutral/transition poses.
- Client renders **E, SE, S, SW, W, NW, N, NE** and validates exact source-vs-PNG counts, no missing/extra/stale frames, fixed registered feet, canvas margins, handedness and consistent scale; preview at the game's actual camera.
- Check the 3-hit combo, eight-direction moves, visible sword state, dash/cancel timing, and transition regressions in real Hushiro combat. Camera and gameplay tuning remain client work.
- Keep all acceptance issues and approvals documented; revised asset exports must update manifest, SpriteFrames and regression smoke tests together.

## Artist communication and commercial boundaries

- First send Hammer a consolidated factual feedback/feasibility discussion, not a blanket instruction to create new animations. Use [Hammer Proof A feedback tracker](HAMMER_PROOF_A_FEEDBACK_TRACKER.md) and [internal integration tracker](../../art_production/AKIO_PROOF_A_INTEGRATION_TRACKER.md).
- Request quote(s) with the **six baseline Actions separated from any sword-state optional variations**, milestones, delivery dates, source requirements and revision/in-engine test allowances.
- Respect the signed Milestone 1 acceptance and revision rights; label added variants, new Actions and fundamental redesign separately. Signed scope/terms control, not this planning document.
- Keep formal scope/pricing/acceptance decisions in writing (email or executed document). This file is an internal planning aid and not evidence that Hammer agreed to the revised scope.

## Relationship to the wider art roadmap

Milestone 2 here completes **Akio's animation library**. It **does not** hire an environment artist, fund VFX/HUD, or make the full Hushiro region. After Akio and the first Corrupted Swordsman proof, the [visual roadmap](../../art_production/VISUAL_ASSET_ROADMAP.md) calls for a tiny Hushiro benchmark room and essential effects before bulk enemy/boss commissions.
