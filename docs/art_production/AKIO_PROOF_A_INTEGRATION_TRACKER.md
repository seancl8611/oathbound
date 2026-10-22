---
id: ART-AKIO-PROOF-A-INTEGRATION-TRACKER
title: Akio Proof A — Internal Animation Integration Tracker
category: art-production
status: draft
authority: supporting
last_reviewed: 2026-10-22
topics:
  - akio
  - checkpoint-b-playtest
  - combat-v2
  - godot
  - sprite-animation
  - input-buffering
  - weapon-readiness
---

# Akio Proof A — Internal Animation Integration Tracker

**Purpose:** Living engineering backlog for the work Oathbound must do to playtest and integrate Hammer's editable Blender animations, independent of any artist revisions. **This is a tracker, not a new combat-design authority or permission to expand the commission.** Start here in future GitHub sessions instead of reconstructing decisions from chat history.

**Working branch:** \`agent/akio-checkpoint-b-playtest\` as of 2026-10-22.  
**Artist feedback counterpart:** [Hammer's feedback tracker](../commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md).  
**Current test instructions:** [Checkpoint B focused playtest](../content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md).  
**Other authorities:** [Akio commission brief](../commissions/akio/AKIO_COMMISSION_BRIEF.md), [Rig-rendered 2D pipeline](RIG_RENDERED_2D_PIPELINE.md), [Combat](../gameplay/COMBAT.md), [Akio character](../characters/AKIO.md), [Source of Truth](../_meta/SOURCE_OF_TRUTH.md).

**Naming caution:** Current branch and test assets say "Checkpoint B"; the commission brief calls the first three Proof A animations "Milestone 1 / Checkpoint C." Do not treat these labels as a contract or acceptance decision.

## Playtest conclusions and non-negotiable separation of concerns

- **Owner-observed:** All-Quick-Slash isolation did work in an earlier playtest and made the excessive speed easy to judge.
- **Owner-verified in live combat on 2026-10-22:** Hammer's 41-frame, 30 FPS Quick Slash looks significantly better than the compressed prototype playback (~0.32 s sampling); runtime cadence is now verified by telemetry as well as human playtest. **Its final combat commitment is not settled**, because this test intentionally blocks follow-up Cross Cut / Heavy Cleave and still includes embedded sheathing.
- **Owner-observed:** Repeated final re-sheathing looks awkward during fast attack repetition and would be inappropriate between multiple future combo hits.
- **Confirmed source-art constraint:** At least east-facing \`attack_quick_slash\` frames ~29–40 show the return-to-sheath and the current \`idle\`/\`move\` source poses are sheathed. A cropped slash clip **alone** cannot supply a complete drawn-sword combat-ready state.
- **Engineering ownership:** Godot remains authoritative for movement, damage, actual hitbox windows, dash/parry permissions, action phase, combo queue, recovery, hitstop, and presentation sampling. Hammer owns source models/rig/animation Actions, not collision or eight-direction PNG export.
- **Do not lock prototype combat numbers:** Source timing is a valid baseline for testing, not an immutable 1.3667-second animation commitment for all future attacks.
- **Do not globally rewrite the combo yet:** Subsequent Cross Cut / Heavy Cleave assets have not yet been commissioned/accepted in this integration pass. Preserve their current fallback until separately reauthored and reviewed.

## Current code / assets map

| Area | Current implementation / notes |
|---|---|
| Source animation assets | \`game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames/\`, delivered subset rendered client-side. |
| Profile | \`game/oathbound/Presentation/Profiles/AkioCheckpointBProfile.tres\`; \`default_fps = 30\`, required Idle/Move/Quick Slash; Cross Cut/Heavy Cleave currently alias Quick Slash *visually*. |
| Playtest Lab | \`game/oathbound/Core/Regions/OathboundRegionPlaytestLab.gd\` — Focused Tests tab, Quick Slash-only scenario, independent prototype/Hammer timing dropdown, 30 FPS paused source viewer. |
| Source timing | \`game/oathbound/Core/Combat/AkioCheckpointBTiming.gd\` — provisional 41 frames: 15 windup, 8 active, 18 recovery at 30 FPS (~1.3667 s total). |
| Attack authority | \`game/oathbound/Player/OathboundCombatPlayer.gd\`, \`LegacyPlayerController.gd\`, \`OathboundPlayerMotion.gd\`, \`OathboundAspectPlayerRuntime.gd\`, \`CombatActionRunner.gd\`. |
| Directional presentation | \`game/oathbound/Utility/DirectionalActorPresentation.gd\` — resolves actions and samples PNG frames from Combat V2 progress. |
| Logs | Existing \`combat_*.jsonl\`, including \`akio_checkpoint_b_live_timing\`, \`akio_focus_attack_started\`, \`akio_focus_visual_frame\`, \`akio_focus_hitbox_edge\`. |
| Validation | \`game/oathbound/Core/Combat/Validation/AkioFocusedPlaytestSmoke.gd\` in the Hushiro Isometric 2D Presentation CI workflow. |

## Engineering backlog

Use **Done / Code implemented, needs field retest / Blocked on art / Planned / Investigation**. An implementation passing headless smoke tests is **not** equivalent to successful human playtesting.

| ID | Priority | Work item | Status | Dependency / acceptance |
|---|---|---|---|---|
| AI-01 | P0 | **Verify live 30 FPS reaches Akio.** Previous coupling to Quick Slash isolation was removed. | **Verified in focused gameplay 2026-10-22; Normal scenario separately not exercised in this log.** | 22 Quick Slashes have `source_30fps=true`, `presentation_duration=1.3667`. Owner visually confirms slower cadence. Retain Normal-scenario verification as a separate regression target. |
| AI-02 | P0 | **Verify presentation and action clock stay synchronized through separate recovery.** | **Verified on seven uninterrupted attacks; monitor future revisions.** | Each completed Quick Slash displayed all 41 distinct indices 0–40 over ~1.34–1.38 seconds. Frame sampling and Combat V2 completion both reflect Hammer's source cadence. |
| AI-03 | P0 | **Architect weapon-readiness presentation:** sheathed outside combat, sword-out inside combat, and coherent transitions. Avoid sheath/unsheathe per attack. | **Blocked on art feasibility; design not yet approved** | Artist responds to [HA-01–HA-04](../commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md). Do not implement synthetic frame cropping that leaves sheathed Idle/Run. |
| AI-04 | P1 | Introduce explicit \`SHEATHED\` / \`DRAWN\` presentation stance (plus \`DRAWING\`/\`SHEATHING\` transitions if accepted) without changing 2D authoritative combat. Route Idle, Move, Quick Slash, dash and interruption using stance and current action. | **Planned; contingent on art** | A player never snaps from a sword-out strike to a sheathed movement frame during sustained combat. Preserve 8-direction orientation, foot anchor, sprite priorities. |
| AI-05 | P1 | **Separate opening unsheathe and repeatable sword-out attack.** Preserve Hammer's full source Action; if revised art provided, map first draw attack and sword-already-drawn Quick Slash to distinct animation bases. | **Blocked on artist delivery** | Repeat strikes never play an embedded sheath tail; source remains editable and Godot chooses the proper clip. |
| AI-06 | P1 | **Combat disengage / auto-sheath policy.** Prototype a 3–5 s inactivity window only when safe/out of combat. Trigger a dedicated sheath transition and allow interruption by new combat actions. | **Proposal; not approved** | Stable enter/exit behavior with nearby enemies, attacks, dash, parry and scene changes. Do not bind weapon readiness to arbitrary one-shot clip completion. |
| AI-07 | P1 | **Hitbox alignment:** current Hammer test divides 41 frames as **15/8/18**, which was a hypothesis, not a precise artist-confirmed impact frame range. Compare E/SE/S/SW/W/NW/N/NE impact poses with actual hitbox edges. | **Investigation** | Blade strikes land when visually plausible. Use direction-aware data only if necessary; avoid changing damage based on sprite-frame polling. |
| AI-08 | P1 | **Defensive cancel policy:** test permits dash/parry during source recovery; early buffer 0.15 s. | **Eight recovery dash cancels verified; parry and detailed input-buffer edge cases pending.** | `dash_cancel` occurs at 0.82–1.30 seconds into the attack (recovery). All observed activated focused Quick Slash hitboxes subsequently deactivated. One separate `dash_slash` action occurred during isolation and warrants test-scenario purity review. |
| AI-09 | P1 | **Combo continuation after accepted art:** define legal Cross Cut / Heavy Cleave starts, visual poses, queue windows and movement restrictions against drawn-sword Quick Slash; keep fallback profiles in the meantime. | **Future; blocked on later animation deliveries** | No unnecessary intermediate sheathing; no global lock to 1.37 s per hit; timing is tuned by playtest. |
| AI-10 | **P1** | **North/South Run still looks like waddling**, although its loop is clean and the sprite looks smoother than lateral Run. Four alternative filter/snap/size settings did not resolve it. | **Reproduced by owner during A/B; cause not identified.** | Distinguish source stride/upper-body motion, high-angle foreshortening and 16-frame 30 FPS cadence from client-side camera/presentation. Compare actual recorded gameplay against source at matched on-screen size before requesting a Hammer revision. |
| AI-11 | P2 | Keep debugging/scenario infrastructure reusable for future enemies/checkpoints; avoid permanent one-off gameplay mechanics leaking into production. | **Foundation implemented** | Debug-only controls, default normal scenario, specific event-gated logs, no shared AspectCatalog profile mutation. |
| AI-12 | P1 | **End-to-end directional transition regression:** after new Action deliveries, verify each compass direction across Attack→Idle, Attack→Move, Attack→Dash, Dash→Idle, Draw→Attack, sheath interruption and scene reload. | **Planned; contingent on art** | Sprite selection and continuity remain correct; no loop-phase/one-shot restarts or sudden sword teleport. |
| AI-13 | **P1** | **Directional Run still appears jittery in gameplay despite correct frame order.** Full 12-second live trace shows 1,350 presentation callbacks, 1,270 move samples, all 16 numbered frames in each E/W/N/S direction, 30 FPS animation metadata and **zero detected frame-index jumps**. | **Frame-order verification complete; root cause open.** | Do not change source frames or force 60 FPS without comparison. Evaluate severe runtime downsampling (~0.5 profile scale × 0.5 camera zoom = 0.25 world-image scale), missing mipmap/prefiltering, screen-space camera/physics synchronization and real-size pose legibility as distinct factors. |
| AI-14 | P3 | **Idle visibility at true gameplay scale.** Owner sees restrained Idle motion with no major complaint. | **Provisionally acceptable / monitor** | Check one full 40-frame 30 FPS Idle loop at source and native gameplay zoom; accept if natural and stable. Do not enlarge gestures simply to make motion conspicuous. |

## Practical architecture proposed for AI-03–AI-06 (not yet implemented)

A small **visual equipment-state machine** is preferable to hacking attack playback speed or introducing collision authority into the SpriteFrames layer:

\`\`\`text
SHEATHED  -- combat begins / first attack --> DRAWING or DRAW-ATTACK
DRAWING   -- complete --> DRAWN
DRAWN     -- Quick Slash / Cross Cut / Heavy Cleave / Dash / Parry --> DRAWN
DRAWN     -- safe + idle timeout --> SHEATHING
SHEATHING -- complete --> SHEATHED
SHEATHING -- interrupted by attack/dash --> DRAWN or a valid DRAW-ATTACK transition
\`\`\`

Only introduce transitions that have matching art and have been approved. \`Idle\`/\`Move\` need alternative presentation bases while sword-drawn; authoritative movement remains planar Godot. Do not couple collision lifetime to visual animation completion. Reset or preserve stance intentionally on death/respawn/scene changes; determine the correct policy when real assets arrive.

**Potential minimal Prototype:** Reuse one short drawing Action and one sword-out idle stance to test viability, but do not ship full directional run by looping/cropping a slash or silently mirroring all directions unless the visual checks support it.

## Timing and state-of-the-world record (updated 2026-10-22)

- **Initial state:** prototype Quick Slash visual sampling around 0.32 s while source has 41 frames at 30 FPS; tests reported numerous skipped intermediate poses. This is an integration/design mismatch, not an indictment of Hammer's source.
- **First full-source test:** authored Quick Slash profile copied to 0.50 s startup, ~0.267 s active, 0.60 s recovery; Combat V2 presentation advanced through recovery for this specific test. **Still reported too fast** in one live playtest.
- **Discovered configuration bug:** Hammer timing originally required **Quick Slash-only scenario AND Hammer selection**. That dependency was removed on \`agent/akio-checkpoint-b-playtest\`; Hammer timing now also applies in **Normal combat** for debug base-katana Quick Slash.
- **Current diagnostic contract:** Godot console prints \`[AkioCheckpointB] live Quick Slash timing=hammer_source_30fps source_30fps=true action_total=1.3667s isolated=<true/false>\`. JSONL emits \`akio_checkpoint_b_live_timing\` for each live Quick Slash.
- **Verification:** Owner visually confirmed Hammer's slower cadence in live focused gameplay, independently supported by 22 Hammer-timed starts, 7 full 41-frame completions, and 8 dash cancellations in `combat_1792689985.jsonl`. **Do not generalize this to Normal combo gameplay or final animation feel.** Check actual GitHub Actions for latest CI status before saying it passed.
- **Artist issue:** the full Quick Slash ends with the sword resheathed, and existing Idle/Run returns to sheathed. Do not "fix" this by simply cutting frames in the renderer. See artist tracker.

## Next action order

1. **Next checkpoint — targeted rendering-quality fix, not another frame-count trace.** Evaluate a **mipmapped or high-quality downsampled Run-only texture** against Baseline at identical camera zoom and frame cadence. Then isolate camera/physics scheduling in a controlled experiment only if Run remains jittery. Prior tests already proved consecutive 16-frame playback, and nearest/filter/snap/size are not fixes.
2. **Review Hammer's feedback with the owner**, prioritizing verified re-sheathing and any Run/source-art concern that remains after the technical A/B. Ask about keeping the blade drawn, matching Idle/Run poses and minimal editable Blender Action changes. Obtain approval before sending.
3. **Plan later Cross Cut / Heavy Cleave animations** with consistent sword-drawn handoff poses; additions are not already authorized in Proof A. Once revised source and further combo actions are delivered, render all eight directions and integrate attack-to-attack flow before separately testing defensive cancels.
4. **Only then decide final Quick Slash speed and combo-lockout durations.** The verified 1.3667-second draw–strike–sheath cycle is a visual reference, not a final mandatory commitment per hit.
5. Keep additional tests for Normal-scenario timing, parry, input-buffer edge cases and atlas preparation performance on the engineering backlog without making them a reason to force provisional speed changes.

## Run frame trace and source contact-sheet analysis — 2026-10-22

**Uploaded evidence:** `combat_1792706336.jsonl`, `godot(20261022-220034).log`, plus four source-frame contact sheets for E/W/N/S, exported from build `f0d8a945ef3794dc3af6c0ab936660cd9dc5fa46`.

- **Diagnostic was armed and completed successfully**: 12,000 ms; 1,350 `akio_run_frame_sample` callbacks (the draw frame number advances exactly one each sample), 1,270 motion samples, 80 idle samples.
- **Per-direction motion samples:** E 284, W 239, N 363, S 384. All four directions visited source-frame indices **0–15 in order** with **zero `frame_jumped` flags**, and `sprite_fps=30.0` throughout. One 16-frame loop takes ~0.533 s by contract.
- **Displayed frame-change median spacing during traced movement:** E ~35.8 ms, W ~36.1 ms, N ~30.9 ms, S ~32.0 ms. Nonuniformity includes directional/idle transitions and discrete high-FPS rendering; it is *not* a proven broken animation clock.
- **PNG source contact sheets:** each has 16 distinct ordered-looking poses and intact continuity with no obvious garbage frame or duplicated exact tile. Source images exhibit stride-dependent variations in the visible bounds of Akio's silhouette; this observation alone is not a diagnosis of an incorrect export root anchor.
- **Camera/presenter:** actor and presenter positions match throughout sampled movement. The camera's smoothed screen center lags the target by roughly 24–26 **world** units during steady movement and changes with direction, which is a valid follow-camera design but must not be conflated with sprite-pose jitter. Current trace does *not* include screenshots of actual GPU-rendered frames, so it cannot prove perceived blur or source-pose smoothness.
- **Effective display size:** exported PNG canvases are 512×512, but Akio's visible person spans only approximately 70–100 source pixels in side view. Live Akio uses visual multiplier 0.5 and camera zoom 0.5, net ~0.25 horizontal reduction, so body features can occupy **roughly 18–25 internal viewport pixels** (Godot virtual viewport 640×360, stretched to 1280×720). These values are approximate image-bound measures, not an art acceptance specification.
- **Leading *new hypothesis*, not proven root:** default sprite texture sampling is `TEXTURE_FILTER_LINEAR` without mipmaps; heavy minification can alias and shimmer fine edges even though nearest/linear switching did not help. Godot 4.7 docs recommend imported/generated mipmaps plus a mipmap-aware filter for minified nonpixel-art textures, at memory cost. Test a controlled mipmapped/pre-filtered Run variant before changing Hammer Action or all global renderer settings.
- **Second targeted hypothesis:** gameplay actor transforms update on physics ticks while camera smoothing and the `DirectionalActorPresentation` render on different cadence; investigate a debug-only smooth-camera/physics-interpolation comparison only if mipmap/prefilter variant fails. Physics interpolation may add latency and needs owner evaluation, particularly in action combat.
- **Decision:** Source indexing and animated sprite playback order are **validated**; visual polish remains **unresolved**. No reason yet to ask Hammer to redo Run, and no reason to repeat the already unsuccessful nearest/pixel-snap/125% presets. Preserve original master 512×512 and combat timing.

## Run frame integrity and synchronization diagnostic (2026-10-22)

The user's prior Blender preview was smooth. Our earlier advice to submit gameplay video was not a usable diagnostic in this workflow. The pipeline already has a Python frame validator, and the Checkpoint B manifest explicitly declares 16 Run frames per direction (128 total), 40 Idle and 41 Quick Slash (776 total). **Counts validate declared coverage but do not establish that Blender's original frame range/frame rate was sampled correctly.**

Implemented on `agent/akio-checkpoint-b-playtest`:
- Extended the Hushiro presentation GitHub Action to validate all Checkpoint B PNGs, including contiguous 0–15 Run indices and correct 512×512 RGBA canvases, before treating the asset set as valid.
- Added **Arm 12-second Run trace** to the existing debug Playtest Lab. During the interval the live presenter records `akio_run_frame_sample` every render callback, including run animation, frame index/progress, source FPS/count, missed forward indices, sample intervals, physics/render frame counters, player velocity/world position, sprite position, screen-space position, camera target and actual camera center.
- Added a **four-PNG Run contact-sheet export** using the imported source frames at one constant crop and 4×4 fixed cell layout in `game/oathbound/playtest_logs`. This lets the user upload individual still images showing *all sixteen authored render frames* per cardinal direction, in index order. It is not a video file and cannot diagnose dynamic screen motion alone; combine it with telemetry.
- No changes to source textures, attack timing, Run FPS, movement, filtering defaults or camera behavior. **Do not prematurely mark the Godot rendering pipeline or Hammer asset as broken; use the diagnostic evidence to select one actual corrective edit.**
- Test procedure is [Focused Playtest Mode A4](../content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md).

## Run sharpness A/B results — user playtest (2026-10-22)

**Uploaded evidence:** `godot(20261022-202153).log` and `combat_1792700224.jsonl`; build SHA `98721461de459cd01faa399ef446e2c04269efd7`. This evidence was analyzed in conversation and is **not copied into the repository**.

- **Result:** Baseline already looked somewhat soft/twitchy; Nearest looked much the same or slightly worse; Linear+world snap and Nearest+world snap had no clear improvement; Linear+125% made softness/twitchiness more visible. **No preset fixed the issue.**
- **Direction distinction:** E/W and diagonals are particularly shaky/soft; N/S appears smoother but retains the waddling-like gait. Run loops cleanly.
- **Controls confirmed:** `akio_render_test_preset` events at t=68.943 s (nearest), 113.868 s (linear_snap), 135.500 s (nearest_snap), 147.861 s (linear_125), in that order. The default Baseline precedes them, with no explicit change event because it is already selected.
- **Measured runtime:** 3.006-minute capture, 669 world samples, 177 one-second performance windows. Median sampled frame rates by preset approximately 108, 106, 119, 120, and 108 FPS respectively. Aside from a startup hitch, the performance windows show no 33 ms+ frames during any non-baseline preset. In >95% of all moving world samples, player speed was approximately 200 world units/s. **This supports no major game-speed fluctuation or stall, but does not measure visual pose jitter.**
- **Source ready:** All 776 original frames prepared successfully in 1.433 s. The scene printed no GDScript/runtime errors; existing encounter fallback warnings are unrelated.
- **Remaining hypotheses, not diagnoses:** Per-frame changes in feet/torso silhouette, pose registration or directional transition, in-place authored stride at high-angle perspective, 30 FPS sprite pacing versus faster render/physics refresh, renderer/camera follow discrepancies, downsampled high-frequency costume detail. Neither the absence of A/B improvement nor high FPS proves Hammer's Blender Action is defective.
- **Conclusion:** Rule out the simple filter/snap/scale switches as easy fixes; **do not declare the complete game rendering pipeline ruled out**. Do not ship a changed rendering preset. Keep Idle provisionally acceptable and Quick Slash/source-cadence decisions unchanged.

## Run sharpness diagnostic implementation (2026-10-22)

- Added an **independent, debug-only Live Akio Run sharpness dropdown** to `Core/Regions/OathboundRegionPlaytestLab.gd` (existing Focused Tests tab).
- `Utility/DirectionalActorPresentation.gd` applies the selected linear/nearest texture filtering, optional world-coordinate rounding, or +25% Akio visual scale only when showing `akio_checkpoint_b` player profile.
- Baseline preserves the original pixel placement, linear texture filtering and 0.5 profile visual multiplier. **Do not touch Hammer's PNGs, source frame cadence, hitboxes, controller, camera zoom or non-Akio presenters.** Baseline is default and session-only.
- Added regression assertions to `Core/Combat/Validation/AkioFocusedPlaytestSmoke.gd` verifying preset propagation, pixel placement, scale and exact restoration. CI status must be verified separately.
- **Next manual evidence:** comparable N/S and E/W running video under presets 1, 2, 3 and 5, noting clarity and possible jaggedness/stutter. Distinguish **world-pixel rounding** from full screen-space pixel-perfect camera snapping.
- See [Focused Playtest guide](../content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md) Mode A3 for exact test steps. **No conclusion about Hammer source quality yet.**

## Evidence from focused live playtest — 2026-10-22

**Files reviewed:** `godot(20261022-173048).log` and `combat_1792689985.jsonl` (user-uploaded test artifacts; not committed to GitHub). Recorded build `ddf266a0fffdab77a889979636f7ea4ef1a33726`.

- **Timing:** 22 Quick Slash starts, all combo index 0 and `hammer_source_30fps`; attack-state duration 0.7667 s, recovery 0.6000 s, full presentation duration 1.3667 s.
- **Attack outcomes:** 7 completed and displayed all 41 unique frames 0–40; 8 ended with explicit `dash_cancel` in recovery; 7 ended with `player_state_exit` coincident with enemy damage. These show real commitment in isolation, **not** a final judgment on full combo pacing.
- **Hitbox trace:** 16 active and 16 inactive edges. Activation near 0.5167 s and normal deactivation near 0.7667 s; actual blade contact alignment across directions is not yet artist-verified.
- **Other actions:** One separate `dash_slash` occurred while Quick Slash-only mode was active; investigate optional stricter action isolation only if needed for future measurements.
- **Source load:** The 776-frame atlas completed preparation in 26.273 seconds, shortly after the first swing started; review independently from animation artist feedback if repeatable.
- **Godot:** No GDScript or runtime errors. Two chamber encounter-selection warnings used a documented Firing Line fallback.
- **Conclusion:** The source timing integration now works and looks better. **Do not lock Quick Slash speed or commit further Hades-like cancel redesign until sheathing continuity and Cross Cut/Heavy Cleave combo art are available.** Current recovery dash cancellation already works in this test.

## Update log

| Date | Change |
|---|---|
| 2026-10-22 | Initialized engineering tracker; separated confirmed runtime fixes, subjective feedback, unapproved proposed architecture and artist dependencies. |
| 2026-10-22 | Verified 22 live Hammer-mode Quick Slashes: 7 full 41-frame completions, 8 recovery dash cancels, 7 damage interruptions. Deferred final timing until sword-drawn and combo art exist. |
| 2026-10-22 | Owner reports N/S Run looks somewhat waddling though loop is clean, moving Akio appears blurry/soft, and Idle is subtle but acceptable. Checked client-side 0.5 visual scale, 0.5 zoom, linear filtering and disabled pixel snap; reserved one bounded diagnostic A/B before asking Hammer for any Run/Idle art revision. |
| 2026-10-22 | Implemented independent in-game rendering A/B presets with a smoke regression and instructions; awaiting user comparison of nearest, snap and slightly larger display. |
| 2026-10-22 | Owner completed all five visual presets: none improved twitch/blur; East/West/diagonals shakier, North/South smoother but waddles. Logs confirm preset order and stable game timing. Investigate frame continuity/camera or matched-size source before artist attribution. |
| 2026-10-22 | Verified 12-second Run trace (1,350 samples, no skipped indices, 16/16 frames at 30 FPS in E/W/N/S); contact sheets appear complete. Next quality target: stronger minification/prefiltering and camera/physics synchronization, not art redo. |

## Maintenance rule

On each Checkpoint/Proof A playtest, update the **status**, **observed evidence**, **decision owner**, **next action**, and links for affected \`AI-##\` items. Closed items stay listed with resolution and commit/clip references; do not silently overwrite history. If an artist answer changes scope, update both trackers and the owning commission authority only after approval. After a code commit, update test/log evidence and the relevant items here; never use this tracker to supersede \`docs/gameplay/COMBAT.md\` or the production spec.
