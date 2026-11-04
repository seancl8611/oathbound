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
