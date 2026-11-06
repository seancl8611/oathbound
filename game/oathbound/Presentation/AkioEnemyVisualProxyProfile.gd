extends "res://Presentation/DirectionalSpriteProfile.gd"

## Debug-only reuse of Akio's three Proof A Actions on an enemy actor.
## This class changes VISUAL selection only. Enemy AI, damage, hitboxes and
## attack timings remain owned by the original Corrupted Swordsman controller.
## Replace the entire proxy with the actual enemy profile when its art arrives.

func animation_base_for(state: String, action_id: String = "") -> String:
	match state.strip_edges().to_lower():
		"attack":
			# Corrupted Swordsman attacks have different gameplay IDs.
			# Always play the available Akio slash for this temporary skin.
			return "attack_quick_slash"
		"dash":
			return "move"
		"defend", "hurt", "death":
			# These animations have NOT been commissioned for Proof A.
			# The neutral fallback is intentionally temporary.
			return "idle"
		_:
			return super.animation_base_for(state, action_id)


# Reuse the verified 44-frame, 30 FPS Quick Slash phase boundaries rather
# than sweeping twenty-two contact poses through a ~0.22s hitbox window.
# Other enemy attacks still borrow Akio's SLASH and are only visual stand-ins.
const SOURCE_TIMING = preload("res://Core/Combat/AkioCheckpointBTiming.gd")


func visual_frame_for_phase(phase: String, progress: float, frame_count: int) -> int:
	if frame_count <= 1:
		return 0
	var normalized: float = clampf(progress, 0.0, 1.0)
	var startup_end: int = maxi(0, int(round(
		float(frame_count - 1) * float(SOURCE_TIMING.STARTUP_FRAMES - 1)
		/ float(SOURCE_TIMING.SOURCE_FRAME_COUNT - 1)
	)))
	var strike_begin: int = mini(frame_count - 1, startup_end + 1)
	var strike_end: int = maxi(strike_begin, int(round(
		float(frame_count - 1) * float(SOURCE_TIMING.STARTUP_FRAMES + SOURCE_TIMING.ACTIVE_FRAMES - 1)
		/ float(SOURCE_TIMING.SOURCE_FRAME_COUNT - 1)
	)))
	var recovery_begin: int = mini(frame_count - 1, strike_end + 1)
	match phase:
		"STARTUP", "COMMITTED":
			return clampi(int(round(normalized * startup_end)), 0, startup_end)
		"ACTIVE":
			return clampi(strike_begin + int(round(normalized * (strike_end - strike_begin))), strike_begin, strike_end)
		"RECOVERY":
			return clampi(recovery_begin + int(round(normalized * (frame_count - 1 - recovery_begin))), recovery_begin, frame_count - 1)
		_:
			return 0
