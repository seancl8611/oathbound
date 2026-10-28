extends RefCounted
class_name AkioCheckpointBTiming

## Debug-only Checkpoint B source-cadence combat experiment.
## These 44 frames belong to Hammer's delivered directional Quick Slash.
## The current move's impact poses differ by direction, so these phase
## boundaries are deliberately provisional and must be checked in playtests.
const SOURCE_FPS: float = 30.0
const SOURCE_FRAME_COUNT: int = 44
const SOURCE_TOTAL_DURATION: float = float(SOURCE_FRAME_COUNT) / SOURCE_FPS
const STARTUP_FRAMES: int = 15
const ACTIVE_FRAMES: int = 8
const RECOVERY_FRAMES: int = SOURCE_FRAME_COUNT - STARTUP_FRAMES - ACTIVE_FRAMES
const STARTUP_DURATION: float = float(STARTUP_FRAMES) / SOURCE_FPS
const ACTIVE_DURATION: float = float(ACTIVE_FRAMES) / SOURCE_FPS
const RECOVERY_DURATION: float = float(RECOVERY_FRAMES) / SOURCE_FPS

static func apply_source_timing(original: Dictionary) -> Dictionary:
	var result := original.duplicate(true)
	# Legacy: duration is the active attack state; recovery is a separate state.
	# Combat V2: action_duration = startup + active + recovery.
	# Keeping these equal makes frame 0..43 advance at the intended 30 FPS.
	result["duration"] = STARTUP_DURATION + ACTIVE_DURATION
	result["startup"] = STARTUP_DURATION
	result["active"] = ACTIVE_DURATION
	result["recovery"] = RECOVERY_DURATION
	# Attack must finish its damaging portion before voluntary defensive cancel.
	# A dedicated recovery-state permission enables dash/parry afterward.
	result["cancel_at"] = 1.0
	result["queue_start"] = 1.0
	result["combo_start"] = 1.0
	result["combo_end"] = 1.0
	result["checkpoint_b_source_timing"] = true
	return result
