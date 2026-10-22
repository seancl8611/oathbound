# Akio Checkpoint B — Focused Playtest

## Where to find it

In a Godot debug playtest, enter Hushiro and press the backtick key to open **Oathbound Playtest Lab**. Open the **Focused Tests** tab. The lab pauses gameplay while open.

### Mode A — Quick Slash-only gameplay

Select **Akio Checkpoint B - Quick Slash only** from the scenario dropdown, then close the lab with backtick. With the default base katana (no selected Blood Aspect), regular tap and hold releases produce only Quick Slash. Cross Cut/Heavy Cleave and their queued branches are bypassed for this debug scenario.

- Quick Slash identity, damage, aim and authored movement policy remain unchanged. Timing depends on the selection below; the original prototype remains available without modifying the shared AspectCatalog.
- The ordinary three-hit/six-hit combo system is not deleted or retuned. Select **Normal combat** to restore it.
- Switching scenarios resets only transient combo/queue state.
- The **Record focused animation frames in combat telemetry** checkbox records actual presentation-frame changes and authoritative hitbox edges into the existing combat JSONL capture. No per-frame hitbox scans.
- The scenario is session-only, defaults to Normal on the next launch, and does not operate in non-debug builds.
- Selecting a Blood Aspect leaves that aspect's gameplay untouched.

### Mode A2 — Quick Slash timing in real gameplay

Within **Focused Tests**, first choose **Akio Checkpoint B - Quick Slash only**, then select the **Quick Slash timing during actual gameplay** dropdown:

- **Hammer original (41 frames / 30 FPS)** — default for the focused scenario. This is the actual playable animation, not merely the paused source viewer. The 41-frame 30 FPS clock covers approximately **1.3667 s**.
- **Original prototype (fast)** — restores the previously tested gameplay profile, with its original **0.36 s attack duration + 0.19 s separate recovery** and accelerated frame sampling.

Hammer's 41 source frames are provisionally divided as **15 windup frames (0.5 s)**, **8 active frames (~0.267 s)** and **18 recovery/sheathing frames (0.6 s)**. The playable attack state lasts ~0.767 s and is followed by ~0.6 s of recovery. Combat V2's presentation clock advances through **both** states in the Hammer experiment, so the original sequence does not end early at the start of recovery.

**During the windup/strike**, Akio cannot voluntarily dash- or parry-cancel this test attack. **During the recovery/sheathing**, dash or parry may cancel immediately if their normal cooldown/lockout permits. An early dash or parry press still uses the existing 0.15 s input buffer; pressing too early will expire and is intentionally not held indefinitely. Successful defensive cancellation ends the source animation and clears the combo through the existing CombatActionRunner/PlayerMotor paths.

**Normal combo chaining remains disabled in the focused scenario.** If the player does not cancel, the full 41 frames play before the next normal attack can start. Cross Cut and Heavy Cleave keep all their prior profile timings when Normal combat is selected.

**Important:** The 15/8/18 frame phase boundaries are a test hypothesis, not a verified frame-by-frame impact annotation from Hammer. Blade impact poses appear to vary by viewing direction. After playtesting, compare hitbox-edge timestamps with the presented frames per direction and tune these provisional windows if needed. The original 30 FPS source preview below is unchanged and remains paused/independent.

### Mode B — Original source animation (30 FPS; no combat)

Keep the lab open and enable **Play source animation at 30 FPS (while lab is open)**.

- Choose attack_quick_slash, move or idle and one of E, SE, S, SW, W, NW, N, NE.
- A cropped preview viewport plays the delivered PNG sequence at 30 FPS independently of player state, attack hitbox, CombatActionRunner and combos.
- The source preview runs with either gameplay scenario selected, but only while the lab is visible and the game is paused.
- Quick Slash loops 41 frames; Run loops 16 frames; Idle loops 40 frames. The preview does not alter assets or create copies.
- If frames are not ready, close the lab briefly after entering Hushiro to allow the 776-frame atlas to load, then reopen it.

## Recommended comparison

1. Preview all eight directional Quick Slash clips at original 30 FPS.
2. Select Quick Slash-only gameplay with frame diagnostics, then close the lab.
3. Attack in all eight directions, allowing each attack to complete.
4. Compare presented frame progression and hitbox edges from the existing combat JSONL against the source preview. Test dash/parry during the committed opening, again during recovery, and once after the whole clip; observe whether it feels responsive but punishing.
5. Switch to Original prototype (fast) and compare the same attacks without changing normal gameplay.
6. Do not classify frame skipping or authored recovery as bugs without design context.
7. Switch to Normal combat when finished.

## Diagnostic event names

- focused_test_scenario_changed: scenario selection.
- akio_focus_attack_started: attack sequence number, copied per-test timing, source_30fps flag and aim.
- akio_focus_hitbox_edge: actual hitbox enabled/disabled and attack elapsed time.
- akio_focus_visual_frame: displayed frame, direction, animation, phase/progress and hitbox state.
- akio_focus_visual_exit: attack presentation returned to a non-attack state.

Events share the existing t_ms and physics_frame fields. Source preview is independent and does not count as a combat attack.

## Architecture

The reusable scenario selector and paused preview extend the existing Playtest Lab autoload chain, not a separate application. The canonical player has a debug-only Quick Slash selection seam and the directional presenter adds gated frame-change telemetry. The shared authored AspectCatalog attack definitions and normal-mode timing/combos remain unchanged. Only a copied Quick Slash profile is adjusted during the focused Hammer experiment.

The first scenario ID is akio_checkpoint_b_quick_slash. The same Playtest Lab scenario pattern can support later enemy or animation checkpoints without permanent one-off controls.
