# Akio Checkpoint B — Focused Playtest

## Updated revised-source Idle + Quick Slash candidate (2026-10-28)

This section supersedes older 40/41-frame Quick Slash descriptions below.
Source SHA-256: \`2d81b409f326cd6c265e4b78d0076ec3bde23f6e0e209d2fcfb4709c79efbe7a\`.
The October revised source has **Idle 40 frames (0..39, frame 40 identical to 0)**,
**Run 18 frames (0..17, frame 18 closes 0)** and **non-looping Quick Slash 44-frame inspection candidate (0..43)** in all eight views. Total **816**.
Quick Slash still has manually saved Action range 0..40 but real artist keys through 43;
do not use the saved range alone. Source FPS 30; Quick Slash test lasts 44/30 ~= 1.467 seconds.
Provisional combat phases remain startup 15 (0.5s), active 8 (~0.267s) and
recovery **21** (~0.7s), subject to impact-pose and cancel-feel review. No
new damage authority or hitbox rules are assigned to rendered frames.
View the new candidate in the Playtest Lab, stationary then while holding
movement, for all eight directions; verify recovery, sheath and Attack->Idle/Run
transitions and recovery dash/parry. Keep Run smoothing experiments off. Do not
accept final commissioned Quick Slash solely on frame-count or CI checks.
Verification: \`runtime_frames_candidate_v2/idle_quickslash_source_verified_candidate_report.json\`.
Repeatable procedure: \`tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md\`.

## Observed revised-source 44-frame playtest (2026-10-28)

**Evidence:** \`combat_1793194705.jsonl\` (573 valid JSONL events) and \`godot(20261028-134110).log\` from exact \`agent/akio-checkpoint-b-playtest\` commit \`017b66692a596ecdbeb406d02760e2f750c2fe83\`. All 13 exact-head GitHub Actions workflows passed. The real Akio atlas prepared with 24 animations / 816 frames in 2897 ms. No Godot script/runtime errors were reported.

**Confirmed:** Seven ordinary (non-isolated) Quick Slash actions started and completed. Each reported \`source_30fps=true\`, \`presentation_duration=1.4666667s\`, \`attack_duration=0.7666667s\`, \`recovery_duration=0.7s\` and \`combat_v2_action_completed.elapsed=1.4666667s\`. All seven used zero voluntary locomotion weights for startup/committed/active/recovery; the intended planted-attack policy was applied. The tested attack-start facings were South (five), North (one), East (one). One later \`hold_thrust\` was started while normal combo isolation was off; capture ended before it completed, not a Quick Slash error. The 55.91 ms startup hitch and two Firing Line encounter fallback warnings are not direct Quick Slash export errors.

**NOT YET PROVED:** These logs have **no** \`akio_focus_visual_frame\`, \`akio_focus_visual_exit\`, \`akio_focus_hitbox_edge\`, or dash/parry-focused events. Seven successful 44/30-second action lifecycles **do not prove all 44 individual visible indices (0..43) were shown** or that frame 43 matches a pleasing Idle transition. No qualitative owner feedback was included. The recorded North/South/East attack starts do not cover all eight orientations. Do not call the animation aesthetically accepted or the sprite-frame sampler verified solely from this capture.

**Next focused verification:** In Hushiro, backtick -> Focused Tests -> **Akio Checkpoint B - Quick Slash only**, select **Hammer revised (44 frames / 30 FPS)**, turn on **Record focused animation frames in combat telemetry**, close the lab. Perform one uninterrupted Quick Slash while facing each of E/SE/S/SW/W/NW/N/NE, then repeat an attack with movement input held and separately test a recovery dash/parry. The next \`combat_*.jsonl\` must contain frame-level event traces; verify that each uncancelled attack reports indices **0..43** in order and that blade/Idle transitions look acceptable. Keep Run baseline interpolation OFF; do not change gameplay attack/hitbox authority to force sprite test success.

## Verified Run 18 integration (2026-10-27)

The October revised Blender Run was re-rendered from the verified SHA-256 `2d81b409f326cd6c265e4b78d0076ec3bde23f6e0e209d2fcfb4709c79efbe7a`. The rig returns visually to its starting pose at frame 18, not 16. The correct 30 FPS runtime loop is **18 images, frames 0–17 per direction** (0.6 seconds). Across eight directions that is 144 Run frames, with 320 Idle and 320 Quick Slash, **784 total**. Preserve the physics-callback camera fix. The experimental Run-frame interpolation is **OFF** by default for baseline playtesting; an optional toggle remains available in Focused Tests.

This section supersedes older investigation entries below that mention a 16-frame Run or 768 total PNGs; those older entries are retained as investigation history. The verification report under `runtime_frames_candidate_v2/run_18_verified_export_report.json` is the authoritative new Run export record. Historical candidate-v2 audit files still describe the original 16-frame export.

**Current checkpoint (2026-10-22): Owner playtested the permanent PHYSICS+ON camera fix, with good Run and stationary Quick Slash. New problem: moving during the 41-frame Quick Slash caused visible skating; recovery dash cancellation felt unreliable. Telemetry confirms movement weights were high throughout the attack and at least four recovery dash cancellations succeeded across the uploaded sessions. The new debug source-timing Quick Slash now ignores free locomotion and prototype lunge for the entire 1.3667-second draw-strike-sheathe, while still allowing recovery dash/parry. Debug telemetry additionally captures dash input accepted/buffered/expired. This is an integration test, not a request for Hammer to revise frames.**

**Ongoing decisions and follow-up:** [Hammer artist feedback tracker](../../commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md) and [internal Godot integration tracker](../../art_production/AKIO_PROOF_A_INTEGRATION_TRACKER.md). Those are draft working queues; this page records the current debug testing procedure.

## Where to find it

In a Godot debug playtest, enter Hushiro and press the backtick key to open **Oathbound Playtest Lab**. Open the **Focused Tests** tab. The lab pauses gameplay while open.

### Mode A — Quick Slash-only gameplay

Select **Akio Checkpoint B - Quick Slash only** from the scenario dropdown, then close the lab with backtick. With the default base katana (no selected Blood Aspect), regular tap and hold releases produce only Quick Slash. Cross Cut/Heavy Cleave and their queued branches are bypassed for this debug scenario.

- Quick Slash identity, damage, aim and authored movement policy remain unchanged. The timing dropdown independently controls all debug base-katana Quick Slashes. The fast prototype remains available without modifying the shared AspectCatalog.
- The ordinary three-hit/six-hit combo system is not deleted or retuned. Select **Normal combat** to restore it.
- Switching scenarios resets only transient combo/queue state.
- The **Record focused animation frames in combat telemetry** checkbox records actual presentation-frame changes and authoritative hitbox edges into the existing combat JSONL capture. No per-frame hitbox scans.
- The scenario is session-only, defaults to Normal on the next launch, and does not operate in non-debug builds.
- Selecting a Blood Aspect leaves that aspect's gameplay untouched.

### Mode A2 — Quick Slash timing in real gameplay

Within **Focused Tests**, select the **Quick Slash timing in live gameplay (independent of combo isolation)** dropdown. You can leave the scenario on **Normal combat** and still use Hammer's 30 FPS Quick Slash. Select **Akio Checkpoint B - Quick Slash only** separately if you want to prevent Cross Cut/Heavy Cleave from interrupting your evaluation.

- **Hammer original (41 frames / 30 FPS)** — default gameplay timing in debug builds with the base katana, whether or not Quick Slash isolation is selected. This is the actual playable animation, not merely the paused source viewer. The 41-frame 30 FPS clock covers approximately **1.3667 s**.
- **Original prototype (fast)** — restores the previously tested gameplay profile, with its original **0.36 s attack duration + 0.19 s separate recovery** and accelerated frame sampling.

Hammer's 41 source frames are provisionally divided as **15 windup frames (0.5 s)**, **8 active frames (~0.267 s)** and **18 recovery/sheathing frames (0.6 s)**. The playable attack state lasts ~0.767 s and is followed by ~0.6 s of recovery. Combat V2's presentation clock advances through **both** states in the Hammer experiment, so the original sequence does not end early at the start of recovery.

**During the windup/strike**, Akio cannot voluntarily dash- or parry-cancel this test attack. **During the recovery/sheathing**, dash or parry may cancel immediately if their normal cooldown/lockout permits. An early dash or parry press still uses the existing 0.15 s input buffer; pressing too early will expire and is intentionally not held indefinitely. Successful defensive cancellation ends the source animation and clears the combo through the existing CombatActionRunner/PlayerMotor paths.

**Normal combo chaining remains disabled only in the Quick Slash-only scenario.** If the player does not cancel, the full 41 frames play before the next normal attack can start. In Normal combat, the first Quick Slash now plays at the selected Hammer timing, while Cross Cut and Heavy Cleave remain available with their prior profile timings. Debug builds initially select Hammer; released builds retain original authored values.

**Important:** The 15/8/18 frame phase boundaries are a test hypothesis, not a verified frame-by-frame impact annotation from Hammer. Blade impact poses appear to vary by viewing direction. After playtesting, compare hitbox-edge timestamps with the presented frames per direction and tune these provisional windows if needed. The original 30 FPS source preview below is unchanged and remains paused/independent.

### Mode A2b — Quick Slash skating fix and recovery dash diagnosis (after camera fix)

**Evidence:** User provided `combat_1792711340.jsonl`, `combat_1792711418.jsonl`, `combat_1792711539.jsonl`, and `godot(20261022-232728).log` from permanent-camera build `c81ead7`. The Run looks corrected in gameplay. Stationary Quick Slash looks good, but attacks with directional input visibly skate. The source-timing action uses ordinary mobile Combat V2 locomotion weights (startup 0.90, committed 0.58, active 0.44, recovery 0.82) and potentially inherited lunge. Four actual `dash_cancel` runner interrupts are recorded across the captures, including three near the recovery boundary: cancel mechanics exist but not every attempted button press can be inferred from those older logs.

**New targeted fix:** When and only when the debug base-katana Quick Slash uses `checkpoint_b_source_timing`, disable player-directed movement in its startup, committed, active and recovery phases and suppress the inherited lunge. This keeps the 41 PNG frames, 30 FPS, ~1.3667 seconds, hitbox timing, dash/parry permissions, external knockback and camera unchanged. All other attack movement policies remain mobile; ordinary prototype Quick Slash remains unchanged. The first iteration is deliberately planted; a short Hades-like directional step can be authored against a verified strike phase later without giving unrestricted movement back.

**Retest:** Launch the existing branch. Keep camera **A. FIXED baseline**, Run sharpness **1. Baseline**, and Quick Slash timing **Hammer original**. In normal combat and, separately, focused Quick Slash-only combat: hold a movement direction while attacking. Akio should stay grounded while completing the full unsheathe, attack and sheath; normal movement resumes after recovery, unless deliberately interrupted by a dash/parry. Try a dash during the ~0.60-second recovery after the ~0.767-second startup+strike. It should cancel the action and move immediately; a dash input much earlier is not supposed to bypass the committed strike. Upload the next `combat_*.jsonl` if dash still feels unreliable.

**New telemetry** (`CombatTelemetry` debug sessions): `akio_focus_dash_input` records dash attempts, whether initially allowed, accepted, or buffered, attack elapsed, recovery time left and cooldown. `akio_focus_dash_buffer_executed` and `akio_focus_dash_buffer_expired` identify replay and expiration. Unlike earlier logs, this lets us distinguish an early press or cooldown from an input-queue defect. No arbitrary buffer extension or unauthorized invincibility changes have been made.

### Mode A3 — Akio Run clarity / Godot rendering A/B (actual gameplay)

**Purpose:** Diagnose soft or blurry looking Run sprites without changing Hammer's PNGs, character source, Quick Slash timing, player movement, enemy visuals, camera zoom, or animation FPS. Applies **only to Akio's Checkpoint B live directional presenter**, not the source preview.

Open Playtest Lab with backtick, select **Focused Tests**, and scroll to **Akio Run sharpness test (LIVE GAMEPLAY ONLY)**. Choose one preset, **close the lab**, and run the same short route in N/S then E/W. Open the lab again to switch to the next setting.

| Preset | Akio filtering | World-position rounding | Visual size | What it isolates |
|---|---|---|---|---|
| **1. Baseline** (default) | Linear | Off (original) | 100% | Reproduce existing game. |
| **2. Nearest filter only** | Nearest | Off | 100% | Does interpolation make the character look soft? Expect possible jaggies; not necessarily an improvement. |
| **3. Linear + world-pixel snap** | Linear | On | 100% | Are fractional world coordinates contributing? May add movement jitter; this is **not** screen-space snapping with a moving camera. |
| **4. Nearest + world-pixel snap** | Nearest | On | 100% | Combined rendering comparison, after judging 2 and 3 separately. |
| **5. Linear + 125% Akio size** | Linear | Off | 125% | Does ordinary gameplay scale lose important silhouette/detail? **Changes apparent character size**, so do not use it as a final character-scale recommendation. |

**Test order:** baseline → nearest → baseline → linear+snap → baseline → 125% size. Keep a similar route, window size, camera view and direction. A short clip of Akio running North and South in each useful setting is more informative than stills alone. If nearest looks crisp but jagged, that suggests an interpolation/downsampling tradeoff; if 125% becomes clearer, the accepted gameplay scale may be part of the problem. Neither result alone proves the Blender model is defective.

Switch **back to Baseline** after testing. All presets are session-only and default to Baseline on a new debug run; **release builds always use the authored profile**. The Godot log records `[AkioRenderTest] preset=...` and the existing combat JSONL records `akio_render_test_preset` when capture is enabled. These are configuration-change markers, **not an image-quality measurement**. The animation itself stays at its existing 30 FPS.

Run and Idle source clips can still be inspected separately through Mode B. If the blur persists under every preset, compare the original PNGs or Blender renders directly against the real in-game capture before deciding whether to request an art revision.

### Mode A3b — Run-only genuine mipmap A/B (new; no video required)

The first five presets did not resolve Run jitter; the live trace already proved that all Run frames advance in order. The next isolated test is **Baseline vs preset 6, Run-only generated mipmaps**, at identical window resolution, native Akio scale and 30 FPS. Preset 6 does more than toggle the texture filter: it builds actual mip levels for all eight 16-frame Run directions in memory. Original PNGs, Idle, attacks, camera, collisions and movement are unchanged. No derivative image files or backups are written.

Wait until the startup log reports all 776 frames. Open Focused Tests, select preset 6, close the lab and allow first-time in-memory preparation. **Only treat the test as active if the Godot log prints `[AkioRenderTest] mipmaps READY generated=128`**. Run sustained North/South and East/West after that message. Compare against preset 1 Baseline on the same route and window size, preferably alternating Baseline → mipmapped → Baseline. Observe whether edge shimmer is reduced, or the figure is merely blurrier. The selected mode is **not** an automated visual-quality score.

If both appear equally jittery, move to a debug-only camera/physics interpolation A/B; do not request a Hammer re-export or change Run FPS based solely on the clean frame-index trace. Restore Baseline after the test.

### Mode A3c — Camera jitter root cause and permanent fix

**Evidence from successive owner playtests on 2026-10-22:**
- The 128-frame Run-only mipmap experiment generated successfully but made Akio's jitter/blur worse (`combat_1792709349.jsonl` and `godot(20261022-225254).log`; mipmap build `b15bbf6`).
- In the next focused comparison build `892943bd`: B (Run frame 4 frozen) **still jittered**; C (camera physics callback, smoothing unchanged) **completely cleared the jitter**; D (camera smoothing OFF, default idle callback) **also cleared it**; reverting to A (idle callback + smoothing ON) **reproduced blur/jitter**.
- This isolates the **old idle callback + smoothing combination** as the runtime presentation problem. The precise lower-level Godot scheduling mechanism is not separately proven. Hammer's PNG frames/30 FPS playback and combat animation state do not need changes to resolve this particular defect.

**Permanent correction:** `CameraFollow.gd` now chooses `Camera2D.CAMERA2D_PROCESS_PHYSICS` in `_ready()`, before activating the camera. Camera follow target is already updated during `_physics_process()`; its camera refresh now runs in physics mode as well. Normal `position_smoothing_enabled = smoothing_on_start` and existing smoothing speed, zoom, projection, combat/movement and asset files remain unchanged. This default applies outside the debug Playtest Lab, too.

**One short post-fix acceptance pass:** Update and launch the existing branch, enter Hushiro, and move N/S/E/W in **normal gameplay**, with **Akio Run sharpness = 1. Baseline** and **Akio camera jitter fix / legacy regression = A. FIXED baseline**. It should look like the previously successful camera C test, with smoothing still working. Also briefly try attacking, dashing, stopping and room transitions, then confirm A remains the normal default.

The debug dropdown has **changed meaning** on the fixed branch:

| Current selection | Callback | Smoothing | Purpose |
|---|---|---|---|
| **A. FIXED baseline** | PHYSICS | ON | Permanent behavior; expected smooth |
| **B. Freeze Run frame 4** | PHYSICS | ON | Fixed-pose isolation, no longer expected to shake |
| **C. OLD BUG** | IDLE | ON | Deliberately reproduce the old jitter for regression only |
| **D. OLD workaround** | IDLE | OFF | Reproduce why turning smoothing off previously helped |

**Important:** In the earlier comparison build C was the *fix*, but in the **new corrected build C is the old bug** for regression testing. Compare against A; restore A after any experiment. The Godot log prints `[AkioSyncTest]` when the camera comparison changes.

Do not confuse a remaining artistic gait/waddle issue (if noticed *after* the camera fix) with the resolved position jitter. No need to repeat frame-index traces, mipmapping or texture-filter experiments.

### Mode A4 — Run frame integrity / camera timing diagnostics (no video needed)

After the first five visual A/B presets failed to improve jitter, the next question is **whether the correct PNG frames are loaded and displayed in order**, and whether camera/presentation motion is uneven.

The offline CI build now runs `tools/rig2d/validate_frame_set.py --manifest tools/rig2d/akio_checkpoint_b_manifest.json --actor akio --source game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames`. This verifies **128 Run PNGs = 16 consecutive frames × 8 directions**, 512×512 RGBA dimensions, plus the 320 Idle and 328 Quick Slash frames. A passing check establishes file completeness against our *declared manifest*, **not** that 16 frames faithfully capture Hammer's original Blender scene or pose spacing.

**In-game, do one Run trace at Baseline:**

1. Wait for the Godot log to say `[AkioCheckpointB] threaded atlas ready animations=24 frames=776`.
2. Open Playtest Lab → **Focused Tests** → **Akio Run frame-order / camera diagnostics**.
3. Click **Export 4 Run frame contact sheets (E/W/N/S)** once. The images are saved in `C:/OathboundPlaytest/game/oathbound/playtest_logs/` as `akio_run_source_frames_e.png`, `_w.png`, `_n.png`, `_s.png`. Each is a single 4×4 index grid (row-major frames 0–15), cropped at one **fixed** canvas rectangle. Do not crop each sprite differently. The files show per-frame pose registration and continuity and can be uploaded individually, without a gameplay video.
4. Keep the rendering option on **Baseline**, select **Arm 12-second Run trace (starts when lab closes)** and close the lab with backtick.
5. Run **East/West for approximately the first 6 seconds**, then **North/South for the remaining 6 seconds**. The trace stops automatically and prints `[AkioRunTrace] COMPLETE`. It does not alter gameplay.
6. Upload the new `combat_*.jsonl`, Godot log and **four contact sheets**. Those allow analysis of frame order, actual displayed-frame timing, missing/duplicate/blended poses, presenter versus authoritative world motion, and actual camera versus camera target positions.

The JSONL contains `akio_run_trace_begin`, `akio_run_frame_sample` and `akio_run_trace_end`. Each per-render-callback sample records: semantic state, direction, `animation`, displayed `frame`, `frame_count`, `sprite_fps`, `frame_changed`, `frame_jumped`, frame interval, render/physics frame indices, player velocity and world position, presenter position, on-screen sprite position, and Camera2D actual screen center/target. Diagnostics are **off outside the 12-second window**; no camera or animation changes are made during this diagnostic.

**Interpretation:** If source-frame sheets show a large discontinuity at constant canvas registration, focus next on Blender/action export and the fixed-camera staging. If frames are consecutive, stable and visually coherent but `akio_run_frame_sample` shows repeated unexpected restarts, jumps or high on-screen positional variance while actor velocity is stable, investigate Godot animation playback or camera synchronization first. High stable game FPS does **not** rule out these subtler problems.

### Mode B — Original source animation (30 FPS; no combat)

Keep the lab open and enable **Play source animation at 30 FPS (while lab is open)**.

- Choose attack_quick_slash, move or idle and one of E, SE, S, SW, W, NW, N, NE.
- A cropped preview viewport plays the delivered PNG sequence at 30 FPS independently of player state, attack hitbox, CombatActionRunner and combos.
- The source preview runs with either gameplay scenario selected, but only while the lab is visible and the game is paused.
- Quick Slash loops 41 frames; Run loops 16 frames; Idle loops 40 frames. The preview does not alter assets or create copies.
- If frames are not ready, close the lab briefly after entering Hushiro to allow the 776-frame atlas to load, then reopen it.

## Recommended comparison

**The first priority is a real gameplay test, not another source-preview review.** With the Playtest Lab closed, confirm Quick Slash's live timing visually and check the timing log. A paused source animation cannot verify the live controller.

1. Preview all eight directional Quick Slash clips at original 30 FPS only as the reference comparison.
2. Select Quick Slash-only gameplay with frame diagnostics, then close the lab.
3. Attack in all eight directions, allowing each attack to complete.
4. Compare presented frame progression and hitbox edges from the existing combat JSONL against the source preview. Test dash/parry during the committed opening, again during recovery, and once after the whole clip; observe whether it feels responsive but punishing.
5. Switch to Original prototype (fast) and compare the same attacks without changing normal gameplay.
6. Do not classify frame skipping or authored recovery as bugs without design context.
7. Switch to Normal combat when finished.

## Why the previous gameplay test remained fast

The first implementation mistakenly coupled the Hammer gameplay-timing selection to the **Quick Slash-only scenario**. With the Playtest Lab on Normal combat, selecting Hammer's 30 FPS playback had no effect and the original fast authored profile continued to run. This has now been corrected: **timing and combo isolation are separate settings**.

In the Godot log, each live basic Quick Slash now prints a line beginning with `[AkioCheckpointB] live Quick Slash timing=`. It also emits `akio_checkpoint_b_live_timing` combat telemetry with `timing_mode`, `source_30fps`, `attack_duration`, `recovery_duration`, and `presentation_duration`. For Hammer mode, the displayed `action_total` is approximately **1.3667s**.

## Combat-ready art recommendation: do not sheath after every hit

Checkpoint B's delivered `attack_quick_slash` sequence visibly re-sheathes near the end (east-facing frames ~30–40). The current `idle` and `move` assets also show Akio's default sheathed posture. Merely cropping the source clip or clamping a drawn-sword pose will not create a seamless drawn-sword movement or idle loop; doing so would snap the sword back to the sheath as soon as Akio moves.

Recommended future artist deliverables: **first draw/unsheathe**, **Quick Slash performed with blade already drawn (no sheathing tail)**, **combat idle with blade drawn**, **combat movement with blade drawn**, and **delayed sheath transition**. Keep the original full Quick Slash as the source-reference/one-off unsheathe attack. All deliverables should match the eight directional camera angles, rig, costume and blade silhouettes. For now, preserve the delivered original to assess its full 30 FPS cadence without replacing source PNGs.

## Diagnostic event names

- focused_test_scenario_changed: scenario selection.
- akio_focus_timing_mode_changed: selected gameplay cadence.
- akio_checkpoint_b_live_timing: actual attack duration, recovery duration and Combat V2 presentation duration for every live base-katana Quick Slash.
- akio_focus_attack_started: attack sequence number, copied per-test timing, source_30fps flag and aim.
- akio_focus_hitbox_edge: actual hitbox enabled/disabled and attack elapsed time.
- akio_focus_visual_frame: displayed frame, direction, animation, phase/progress and hitbox state.
- akio_focus_visual_exit: attack presentation returned to a non-attack state.

Events share the existing t_ms and physics_frame fields. Source preview is independent and does not count as a combat attack.

## Architecture

The reusable scenario selector and paused preview extend the existing Playtest Lab autoload chain, not a separate application. The canonical player has a debug-only Quick Slash selection seam and the directional presenter adds gated frame-change telemetry. The shared authored AspectCatalog attack definitions and normal-mode timing/combos remain unchanged. Only a copied Quick Slash profile is adjusted during the focused Hammer experiment.

The first scenario ID is akio_checkpoint_b_quick_slash. The same Playtest Lab scenario pattern can support later enemy or animation checkpoints without permanent one-off controls.
