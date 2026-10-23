---
id: COMMISSION-AKIO-HAMMER-PROOF-A-FEEDBACK
title: Hammer — Akio Proof A Playtest Feedback Tracker
category: commission-feedback
status: draft
authority: supporting
last_reviewed: 2026-10-22
topics:
  - hammer
  - akio
  - proof-a
  - animation-review
  - quick-slash
  - sheathing
---

# Hammer — Akio Proof A Playtest Feedback Tracker

**Purpose:** Living internal working record of observed in-game animation problems, positives, questions to ask Hammer, and artist-dependent improvements. Use this to prepare *one* clear, prioritized feedback message. **This file has not been sent to Hammer; entries are not automatic change orders, approved extra scope, or final acceptance/rejection.**

**Status (2026-10-22):** Eight-direction Blender → 512px RGBA → Godot Proof A is functioning; Quick Slash at 30 FPS and the physics-camera fix are owner-tested. The former Run jitter was a **client camera-timing issue, not an artist defect**. The later Quick Slash sliding was a **client locomotion-policy issue** (code corrected and CI-tested; next field retest pending). **The priority artist conversation is weapon-state continuity between Quick Slash, Idle, and Run**. The full combo and its final attack speed cannot yet be judged; no new art scope has been approved.  
**Working game branch:** \`agent/akio-checkpoint-b-playtest\`.  
**Naming caution:** "Checkpoint B" is the current game/playtest asset and branch label. The repository's commission brief calls the first three **Proof A animations** the **Milestone 1 / Checkpoint C** animation deliverable, after Checkpoint B's 3D source handoff. Do not confuse the debug label with the contractual milestone name.

## Contract and ownership boundaries

- [Akio commission brief](AKIO_COMMISSION_BRIEF.md) is the repository's *commission technical authority*; the detailed external production spec and signed agreement govern actual scope, revision allowances, acceptance, payment and deliverable rights.
- Hammer authors editable model/rig/animation **Blender Actions**; the client owns eight-direction PNG generation, import, hitboxes, combat timing, collision, invulnerability, dashes and gameplay transitions. **Do not ask Hammer to fix Godot gameplay timing or deliver eight PNG sets unless the agreement is changed.**
- Proof A includes editable **Idle**, **Move / Combat Run**, and **Quick Slash**. Additional draw/sheath, drawn-sword Idle/Run variants, or a second slash Action might be new work: **ask feasibility, extent and price first**, and obtain written approval before scope expands.
- Reference: [current source-vs-gameplay testing](../../content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md) and [internal implementation tracker](../../art_production/AKIO_PROOF_A_INTEGRATION_TRACKER.md).

## Confirmed positives — preserve these

| ID | Observation | Status / implication |
|---|---|---|
| HP-01 | The **actual in-game** Quick Slash at Hammer's 30 FPS looks significantly better than the sped-up prototype. Full source is **41 frames (~1.37 s)**. | **Confirmed by owner during 2026-10-22 live combat playtest** and supported by 22 Hammer-mode attack traces. Preserve source pacing as a useful reference; **do not lock final combat speed** until the drawn-sword flow and other combo attacks exist. |
| HP-02 | The fast initial draw/unsheathe portion is acceptable; the complaint is **not** that the sword needs to be drawn more slowly. | **Observed by project owner.** Do not inadvertently slow or exaggerate the initial unsheathe. |
| HP-03 | Initial in-game integration confirms the source can be rendered/played in eight directions. | **Technically integrated, not a final art-quality approval.** Judge animation quality at real gameplay scale. |

## Artist-feedback queue — highest priority first

| ID | Priority | Finding / desired outcome | Status |
|---|---|---|---|
| HA-01 | **P0 — ready for owner-reviewed Hammer discussion** | **Repeated sheathing after every Quick Slash looks unnatural** during rapid attacks and would be especially conspicuous between hits of the future three-hit combo. Aim for a sword that stays out during active combat, with deliberate sheathing only when appropriate. | **Confirmed in playtest; solution pending artist discussion.** |
| HA-02 | P0 dependency | Current **Idle and Move/Run source poses also show the sword sheathed**. Trimming the tail of Quick Slash alone would cause the weapon to snap back into its sheath on movement/idle transitions. Any sword-out solution needs coherent resting/moving poses or an artist-supported transition approach. | **Confirmed by frame inspection; discuss minimal viable art package.** |
| HA-03 | P1 | Ask whether Hammer can **separate the existing draw/strike/sheath material** into editable Actions or variations using his existing Blender rig and keys. Preserve the source full-sequence Action. | **Proposal / feasibility question; not commissioned yet.** |
| HA-04 | P1 | Explore a **drawn-sword Quick Slash** ending in a ready posture instead of sheathing, plus **combat-ready Idle** and **combat-ready Move/Run**. A separate **sheath transition** can follow later after combat stops. | **Candidate design / new-scope discussion, not approved deliverables.** |
| HA-05 | **P1 — owner-confirmed gait/character-identity feedback, now source-frame reviewed** | **North and South running can read like an awkward waddle or high-knee march, unlike acceptable East/West.** The source poses alternate prominent raised knees/feet with moments where both legs appear bunched under the pelvis. At 30 FPS and high-angle gameplay scale this can look bouncy/goofy rather than controlled, grounded combat locomotion. Request Hammer's appraisal and targeted pose/weight-transfer refinement, with a subtle Akio-specific run identity that preserves the natural E/W feel. | **Owner playtest observation + independent visual review of all 16 N and all 16 S PNG frames (and E/W comparison) on 2026-10-22.** Precise Blender hip curves, foot contacts and camera-induced foreshortening remain hypotheses, not proven rig defects. Different issue from resolved camera jitter; discuss in first feedback. |
| HA-06 | P2 | Source blade extension/impact read differently by direction in earlier tests. Check all eight views at correct playback speed and actual game size before identifying a particular pose as defective. | **Requires comparative review; no artist revision request yet.** |
| HA-07 | Resolved — client-side | The East/West and diagonal Run jitter/blur persisted even with the Run pose frozen; Camera2D **physics callback with smoothing ON** removed it. Turning smoothing OFF also removed it; restoring old idle callback plus smoothing reproduced it. | **Verified by owner A/B and fixed in CameraFollow. Remove from artist change requests.** |
| HA-08 | P3 — watch only | Idle loop appears functional but **restrained breathing/pose motion is barely noticeable** at gameplay zoom. Owner reports no major Idle defects. | **Provisionally acceptable**; only ask Hammer to amplify if source and in-game review establish an actual readability need. |

### Source-frame gait inspection — North/South versus East/West (2026-10-22)

**Inspection method:** The GitHub connector's ordinary UTF-8 fetch cannot decode PNG binaries, but `fetch_file(..., encoding="base64")` exposed the actual 512×512 original RGBA files. The assistant visually inspected **all 16 frames** of `move_n_000.png`–`move_n_015.png` and `move_s_000.png`–`move_s_015.png`, plus `move_e_000/004/008/012.png` and `move_w_000/004/008/012.png`. These are original rendered source poses from the current branch, not reconstructed guesses or a new gameplay test. Source frame order was independently confirmed by earlier telemetry; no missing/interleaved frame defect was found.

**Observed North (`move_n_*.png`):** From behind, knees and lower legs repeatedly exchange the dominant silhouette across a narrow stance; boots alternately project slightly outward/behind while much of the forward-backward stride is concealed by the high-angle rear view. Frames around **000–004**, **006–010**, and **012–015** visibly change which leg is prominent, with relatively little readable forward reach. Cloth/hip silhouettes and the arms create additional alternating side-to-side visual emphasis. At native game size this can register as waddling rather than powerful running.

**Observed South (`move_s_*.png`):** From the front, a raised knee/boot becomes prominent beneath the torso at about **frames 000–002** and again for the opposite step at about **008–010**; around **004–006** and **012–014**, the limbs compress into a near-symmetric, bunched-under-body silhouette. The swing alternates left/right, but forward stride length and planted foot are difficult to read head-on. Puffed trousers exaggerate the two rounded leg masses. This creates a repeated high-knee / close-feet / high-knee cycle that may read as a waddle, march, or short hopping steps.

**Observed East/West comparison:** In `move_e_000/004/008/012.png` and `move_w_000/004/008/012.png`, forward upper-body inclination, trailing foot extension, arm counter-swing and the reach of the stride are clearly visible. The owner accepts these views as a base quality reference. **Do not broadly redesign the acceptable lateral gait.**

**Likely visual mechanism, not a proved rig fault:** Forward/backward running is heavily foreshortened in N/S; moderate knee lift, alternating hip/torso or clothing sway and limited clear foot contact/readability can dominate the tiny 2D silhouette. The `.blend` control curves, exact pelvis displacement, ankle trajectories, planted foot velocity and alternate render elevation were **not independently inspected**, so avoid claiming a measured hip wobble, foot sliding, or objectively incorrect biomechanics. The existing camera timing bug was a different, resolved client-side problem.

**Desired Hammer discussion / revision direction:** Preserve E/W's purposeful momentum. For N/S, consider reducing excessive frontal knee prominence, making planted/support foot transitions more legible, controlling lateral pelvis and shoulder displacement, refining torso forward intent and left/right arm balance, and distinguishing the forward-driving stride at the target high angle. Keep it natural, restrained and practical. An **Akio-specific combat-ready run** should read as deliberate, balanced, able to stop/turn/strike immediately; no caricature, Naruto-style lean, theatrical sprint, or blanket speed change. Ask Hammer whether targeted modifications to the existing Run Action and/or high-angle camera test would be most efficient before agreeing to any new animation scope.

**Frame references:** `game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames/move_{n,s,e,w}_###.png`; exact sample frames above. The 512×512 images include large transparent margins, so inspect the central character closely rather than interpreting raw canvas dimensions as character size. No client-created video or new local folder is required.

### Evidence for the P0 sheathing issue

- In \`game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames/attack_quick_slash_e_020.png\` through ~\`_026.png\`, the sword is visibly drawn/extended.
- By \`attack_quick_slash_e_029.png\` through \`_040.png\`, the sword is being returned to the sheath / reaches its sheathed pose.
- \`idle_e_000.png\` and \`move_e_000.png\` also show the default sheathed state.
- These are **client-rendered directional frames** used as evidence of the Blender Action; if Hammer is reviewing, send a short in-engine video and relevant Action/key-pose references, **not** a request that he edit the PNG derivatives.

## Preferred direction to discuss, NOT an authorized scope change

**Combat-readiness model:** Start sheathed outside combat; draw for initial combat engagement; perform consecutive strikes and defensive movement while sword stays drawn; return to sheathed state only after combat ends / a deliberate quiet interval. This retains Akio's restrained swordsman identity without visibly re-sheathing after every tap.

**Possible staged artist conversation:**

1. **Minimum first ask:** Confirm Hammer agrees the repeated sheath will look awkward in a chained combat context, and ask the least disruptive way to prevent it **in the editable Blender source**.
2. **Likely option:** Split/derive a first draw/attack, a repeatable sword-already-drawn Quick Slash, a matching drawn Idle and Move, and eventually a separate sheath Action. Determine which changes are revisions versus additions before committing to all of them.
3. **After feasibility/quote:** Approve only what is needed for a clean Proof A test. The full core combo (Cross Cut / Heavy Cleave) remains future work under the original milestone structure.

**Important alternative to ask about:** If Hammer can reuse a convincing partial drawn-sword segment plus a ready pose with little added work, compare that solution against commissioning full new loops. **Do not assume a frame-range cut alone is production-ready**, since movement transitions also have to agree.

## Additional Run / Idle feedback to verify (2026-10-22)

The owner confirms Run loops cleanly but **North/South looks awkwardly waddling or bouncy**, whereas **East/West looks acceptable**. The concern is **not that the run is too anime-like**; it is ordinary motion that fails to convey Akio's controlled, recognizable combat movement from the frontal/rear high-angle views. A subtle signature run is a desired art-direction improvement, **not** an exaggerated or anime-styled run. Earlier lateral blur/jitter was resolved through the Godot camera correction; do not blend those symptoms into the gait discussion. Idle remains acceptable but subtle. Do not equate the gait concern with a bad character model or an automatically defective rig.

The client currently uses `AkioCheckpointBProfile.tres` with `visual_scale_multiplier=0.5`, `pixel_art=false`, `snap_actor_to_pixel_grid=false`, plus scene camera zoom `0.5`; `DirectionalActorPresentation` consequently uses `TEXTURE_FILTER_LINEAR`. The original 512×512 sprite canvases contain a relatively small character. Downscaling/filtering and high-angle leg foreshortening are plausible **engineering/visual-presentation hypotheses**, not proven causes of blur or waddling.

**Review basis:** In addition to owner gameplay impressions, the assistant has now directly inspected all 16 North and all 16 South original source-rendered PNGs and representative E/W frames retrieved from GitHub with base64 encoding, without asking for a new game playtest. Existing camera/filter tests are complete and should not be repeated to assess authored gait. Hammer can inspect the cited frames in his own Blender source. A new owner gameplay recording is **not required** to include the gait item in first-round feedback; a direct Blender Action review could later settle rig-level causes.

## Run frame-integrity follow-up (2026-10-22)

The owner supplied `combat_1792706336.jsonl`, `godot(20261022-220034).log` and indexed Run contact sheets for E, W, N and S. The 12-second test observed 1,350 presenter samples, all 16 source indices per cardinal animation at 30 FPS, and **no skipped frame indices**. The PNG contact sheets exhibit a complete stride cycle and no obvious missing tile. The user's earlier observations (lateral twitch/softness, N/S waddling) remain valid, but **the evidence does not demonstrate a defective Blender Action or missing exported frames**.

At the actual 640×360 viewport, the art is reduced approximately 4× from 512 source frames via the combined 0.5 character/profile and 0.5 camera zoom. Akio's visible side-view figure can occupy only about 18–25 native pixels in width/height measurements. Source readability when displayed much larger in Blender therefore does not automatically predict sharp motion in-game. Before requesting any Run redo, **test a deliberately mipmapped or high-quality prefiltered client-render path and, if necessary, physics/camera synchronization**. Neither is Hammer's responsibility. Sheathing continuity remains the leading confirmed issue to raise with him; North/South waddling remains separately reviewable.

## Run rendering A/B follow-up (2026-10-22)

The owner has now tested all five **live game** presets (Baseline, Nearest, Linear+world snap, Nearest+world snap, Linear+125% size). **None meaningfully reduced movement twitchiness or apparent blur**; the larger character made it more noticeable. East/West and diagonal running are the most visibly shaky/soft. North/South is smoother but has the previously reported waddling-like gait. The 16-frame Run loop is clean. The Idle movement remains a low-priority subtlety, not a new artist defect.

The `godot(20261022-202153).log` and `combat_1792700224.jsonl` confirm all four preset switches, all 776 source frames loaded, and generally stable sampled runtime performance. **These text logs do not show rendered frame-to-frame body/foot motion** and cannot prove that Hammer's Action is responsible. Camera/presentation timing, sprite registration and reduction to gameplay screen size remain credible alternatives. User also reports the Run looked sharp when viewed in Blender at a larger size, making a fair matched-screen-size comparison important.

**Hold artist blame on former blur:** the Camera2D IDLE+ON jitter has been diagnosed and resolved in our game. **Run gait remains valid artist-facing first-round feedback** based on the owner's repeated observation and direct source-frame inspection. Invite Hammer's judgment on knee lift, foot placement, hip/torso stability, and the high-angle projection before prescribing specific rig curves or commissioning a complete new Run. No new game playtest is a precondition to discussing gait.

## October 20 Hammer source handoff — integration and response notes

**Artist's message (as supplied by the owner):** Hammer supplied a Blender 5.2.2 LTS blockout scene with editable Idle, Run and `quick_slack` Actions for testing and review. The `quick_slack` spelling is in his message; our Godot action identifier is `quick_slash`. He describes a reusable render camera controlled by `CameraPivot` Z rotation, adjustable orthographic scale, ample fixed empty frame margins to keep a stable pivot, optional later texture packing that preserves pivot metadata, rendering frames from 0 to final keyframe minus one, and using negative source keyframes as unrendered setup/reference poses. He explicitly asks whether Oathbound prefers a specific perspective, angle and sprite scale.

**Established client test settings:** The current Checkpoint B manifest uses eight directions at 45° intervals, 512×512 transparent RGBA canvases, an untrimmed fixed central anchor at (256,256), 30 FPS source and 40 Idle / 16 Run / 41 Quick Slash frames per direction (776 frames), with clean prerendering. Godot's visual_scale_multiplier is 0.5 and current camera zoom is 0.5. These are working proof values, **not** final artist-locked Blender orthographic scale/pitch or a universal roster-wide packing policy. Retain clean full-canvas masters for reproducibility; test texture packing later only if trimmed regions restore exactly the same pivot. Do not request eight finished PNG sheets from Hammer; directional rendering belongs to the client.

**Coordinate/convention question for next iteration:** The artist rotates `CameraPivot` on Z; our generic client-side Blender template rotates `Akio_Root` with a fixed camera. Both are potential ways of generating eight views, but applying both would double-rotate the result. Confirm that one controlled transform maps all eight directions consistently, preserves scabbard handedness and stable registration, and does not unintentionally introduce camera motion or mirrored asymmetry. Confirm his actual source Action start/end frame ranges and whether final-keyframe-minus-one intentionally omits duplicated closing loop frames; don't demand extra frames absent a demonstrated loss. Test ordinary opening/re-rendering in Blender 5.2.2 before declaring final source-handoff acceptance.

**What to answer Hammer now:** The eight-direction fixed high-angle, orthographic/three-quarter character treatment is currently acceptable for Proof A, provided the foot anchor and weapon silhouette remain stable at real gameplay size; propose a gameplay screenshot and the client's current render settings as a concrete visual target rather than guessing a final camera pitch or source orthographic scale. The main desired artistic change is coherent sword-out combat readiness: current Quick Slash ends resheathed and Idle/Run are sheathed, whereas the future strike chain should generally keep the katana out. Ask about minimally reusing/splitting current editable Actions; distinguish included revision work from separately priced additions before approval. Former camera shimmer and Quick Slash skating are engineering issues and **not artist defects**.

## New client-side outcomes (not Hammer revision requests)

- **Run**: owner confirmed frozen source pose still jittered under old camera; physics Camera2D callback with smoothing ON fixed it. Do not request Run texture quality/frame smoothing revisions on that basis.
- **Quick Slash while moving**: source-timed combat was using high locomotion weights and an inherited lunge, causing apparent skating in the 41-frame draw–slash–sheath. Client isolated and zeroed those movement permissions only for the current debug Hammer-timed Quick Slash; implementation passes focused regression tests, owner retest pending. A later tiny authored *gameplay* attack step is optional and distinct from adding artist root motion.
- **Recovery dash**: existing engine logs show successful dash cancellations but not all unsuccessful presses. Client added input accepted/buffered/expired telemetry; tuning is a gameplay responsibility. No reason to ask Hammer to fix dash responsiveness.
- **Artist acceptance**: not yet final. Review source and post-correction artistic readability at actual screen size; do not conflate successful data import with visual or contract sign-off.

## Latest live-playtest interpretation (2026-10-22)

The 30 FPS source is now playing correctly in real combat, not just the paused preview. **Do not ask Hammer to shorten Quick Slash based on one isolated repeatable attack.** Because the current isolation blocks Cross Cut / Heavy Cleave, full-combo flow and final attack commitment have **not** been evaluated. Seven uninterrupted attacks displayed all 41 source frames; eight were successfully dash-canceled during recovery. What remains artist-facing is the embedded **sheathing after each Quick Slash** and the need for compatible sword-drawn states across future combo art.

**Feedback order:** (1) discuss weapon-state continuity and a minimal coherent sword-out setup for combos, (2) discuss the **North/South Run waddle** separately, showing the specific source frames and explaining the desired controlled/recognizable gait while preserving acceptable E/W, (3) confirm which Action edits are within existing revisions versus new scope, and (4) plan Cross Cut / Heavy Cleave only after the above direction is agreed. No further owner gameplay capture or extensive telemetry is required before this first artistic discussion. Avoid presenting the current ~1.37-second action commitment as a final gameplay requirement.

## Questions to send Hammer

- Would you agree that repeating the complete draw → cut → sheath cycle for every basic attack will feel unnatural once Akio chains strikes?
- Can the existing Blender rig/Actions be adapted so an opening Quick Slash draws the blade but subsequent cuts **start and end sword-drawn**?
- Which of the following can be derived from the current work, and which would require new animation effort: sword-out Idle, sword-out Run, first draw, stand-alone sheath transition, and sword-out Quick Slash?
- What is the **smallest coherent set** that will let us demonstrate seamless back-to-back strikes and return to Idle/Run at the target high-angle camera?
- Can the modified source remain in-place, directionally readable and editable as separate Blender Actions without needing alternate proprietary tools?
- Would these be within any existing revision allowance, or should we treat them as a **separately priced addition**? What delivery/iteration cost or schedule change would you estimate?
- Could you look at the **North/South Run Action from our elevated gameplay angle**? Compared with the convincing East/West profile, the front/back high-knee and close-feet phases look a little waddling/goofy in game. Would refining leg/knee spacing, planted-foot readability, weight transfer or subtle pelvis/torso sway help while keeping a natural, compact, recognizable swordsman gait?
- Are there intentional posing differences among the eight views that we should account for when syncing hit frames? The **client** will tune collision/hitboxes, not Hammer.

## Ready-to-send feedback outline — DRAFT ONLY

> The original Quick Slash animation looks noticeably better at its intended 30 FPS, so I want to preserve that quality. One issue became clear during in-game testing: Akio visibly sheaths his sword at the end of each Quick Slash, which would repeat between rapid attacks and the hits of a longer combo. Ideally he would keep the sword drawn during active combat and only sheath it after combat has stopped. Since the current Idle and Run poses also show the sword sheathed, I want to understand the simplest way to make the transitions consistent using the existing Blender rig. Do you think we could adapt or split the current Action into a draw/opening cut and a sword-drawn follow-up, and potentially add matching sword-out Idle/Run and a separate sheath transition? Please let me know what could be handled as a revision and what would require additional scope and cost. I can share a short gameplay clip and the frame ranges that prompted the feedback.

**Run addendum for the eventual email:** "The side-view Run looks good. In the North/South views, though, the alternating raised knees and close-together foot positions make the gait read a little like a waddle at our high camera angle. I'd like Akio's movement to feel more deliberate and characteristic of a controlled, combat-ready swordsman rather than asking for anything exaggerated. Could you review the front/back poses and let me know whether a relatively small pass on leg/weight-transfer readability would help? I can point you to the specific source frames." **This is a separate, real artistic feedback item from the already-fixed Godot camera jitter.**

**Do not send directly from this file without owner review.** Keep the tone collaborative; don't imply that all proposed extra Actions are already purchased.

## Follow-up and acceptance log

| Date | Item | Outcome / next step |
|---|---|---|
| 2026-10-22 | **Actual gameplay** 30 FPS versus accelerated prototype | Owner confirms 30 FPS Quick Slash is visually much better. Of 22 instrumented Quick Slashes, 7 ran to full 41-frame completion; 8 were dash-canceled during recovery and 7 were interrupted by enemy damage. Full combo pacing **cannot yet be judged**. |
| 2026-10-22 | Repeated sheathing between attacks | **Reconfirmed during full-speed live combat:** full draw–slash–sheath as a repeatable basic attack feels unnecessarily committed. **Prioritize discussion with Hammer** about keeping the blade drawn through combinations and aligning future Idle/Run. Owner must approve the message before sending. |
| 2026-10-22 | Scope, exact Action split, additions and revisions | **Pending discussion with Hammer**, no quote or change order recorded. |
| 2026-10-22 | Live 30 FPS gameplay checked against logs and actual animation | **Verified on updated branch** in local Godot log `godot(20261022-173048).log` and combat telemetry `combat_1792689985.jsonl`; no gameplay timing bug reproduced. |
| 2026-10-22 | Run rendering A/B results | Initial texture/filter/mipmap experiments did not fix jitter (mipmaps worsened it); frozen pose still jittered, while physics Camera2D callback with smoothing fixed it. **Client-side camera cause found; no Run re-render requested.** |
| 2026-10-20 | Hammer Blender source email and rendering conventions | Owner shared artist's notes: Blender 5.2.2 LTS, CameraPivot Z rotation, orthographic scale, fixed consistent canvas/pivot, optionally trimmed atlas with retained pivot metadata, export 0 through final keyframe−1. Match the client's 8-way fixed high-angle configuration before next render iteration. |
| 2026-10-22 | Quick Slash movement / dash field follow-up | Owner saw skating when holding movement during slash/re-sheath; client authored a source-timed movement lock and input telemetry. Focused CI passed; owner retest pending. This is not an artist defect. |
| 2026-10-22 | Direct source-frame Run gait review | All 16 North, all 16 South, and eight E/W reference frames inspected directly from repository PNGs. Front/back knee/foot occlusion and repeated compressed leg pose are plausible contributors to the owner's persistent waddling impression; art direction revised to restrained signature run. **No new gameplay work required from owner.** |
| — | Message sent / Hammer response | **Not yet recorded.** |
| — | Revision approved / assets delivered / accepted | **Not yet recorded.** |

## Maintenance rule for later reviews

Append new findings with IDs (\`HA-07\`, etc.), mark **observed / suspected / proposed / approved / sent / resolved**, and link the supporting gameplay clip, rendered frame or Hammer reply. Do not erase an issue just because we changed the Godot timing. Promote an item into the commission brief or a change order **only after actual agreement**, and update [the integration tracker](../../art_production/AKIO_PROOF_A_INTEGRATION_TRACKER.md) if the deliverable changes.
