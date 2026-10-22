# Akio Checkpoint B — Focused Playtest

**Current checkpoint (2026-10-22): The project owner has seen Hammer's 30 FPS source preview but has NOT yet validated that speed during actual gameplay on the updated branch. Complete a live playtest before treating the timing fix as visually verified or finalizing Hammer feedback.**

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
