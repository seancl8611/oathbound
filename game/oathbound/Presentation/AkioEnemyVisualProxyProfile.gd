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


# Per-enemy authored visual "weapon data", inspired by Hades's separate
# EnemyData/WeaponAIData. This is a temporary preview using Hammer's Quick
# Slash source, NOT a substitute for a commissioned Swordsman strike.
# Fractions use the number of available frames (currently 44), so a new
# Blender export can be audited without rewriting the common presentation.
const ANTICIPATION_INITIAL_FRACTION: float = 0.07
const ANTICIPATION_EARLY_FRACTION: float = 0.18
const ANTICIPATION_COMMITTED_FRACTION: float = 0.27
const ANTICIPATION_COMMIT_TIME_FRACTION: float = 0.78
const ATTACK_START_FRACTION: float = 0.29
const ATTACK_END_FRACTION: float = 0.80


func visual_frame_for_phase(phase: String, progress: float, frame_count: int) -> int:
	if frame_count <= 1:
		return 0
	var maximum: int = frame_count - 1
	var clamped: float = clampf(progress, 0.0, 1.0)
	var frame_fraction: float = ANTICIPATION_EARLY_FRACTION
	match phase:
		"STARTUP":
			# Let Akio's temporary sword-ready poses advance slowly and
			# continuously rather than holding a frozen frame, then jumping
			# to another one at the commitment beat.
			frame_fraction = lerpf(
				ANTICIPATION_INITIAL_FRACTION, ANTICIPATION_EARLY_FRACTION,
				clampf(clamped / ANTICIPATION_COMMIT_TIME_FRACTION, 0.0, 1.0)
			)
		"COMMITTED":
			frame_fraction = lerpf(
				ANTICIPATION_EARLY_FRACTION, ANTICIPATION_COMMITTED_FRACTION,
				clampf(
					(clamped - ANTICIPATION_COMMIT_TIME_FRACTION)
					/ (1.0 - ANTICIPATION_COMMIT_TIME_FRACTION), 0.0, 1.0
				)
			)
		"ACTIVE":
			frame_fraction = lerpf(ATTACK_START_FRACTION, ATTACK_END_FRACTION, clamped)
		"RECOVERY":
			frame_fraction = lerpf(ATTACK_END_FRACTION, 1.0, clamped)
		_:
			frame_fraction = 0.0
	return clampi(int(round(frame_fraction * float(maximum))), 0, maximum)
