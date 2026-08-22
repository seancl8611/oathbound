extends "res://Player/SwordHitBox.gd"

## Thin bridge that preserves the canonical SwordHitBox AttackEvent while exposing
## Blood Aspect trigger/geometry metadata to TechniqueEffects and AspectRuntime.

func activate_for_profile(profile: Dictionary, combo_index: int = 0) -> void:
	super.activate_for_profile(profile, combo_index)
	set_meta("action_trigger", str(profile.get("action_trigger", "")))
	set_meta("aspect_id", str(profile.get("aspect_id", "")))
	set_meta("aspect_tier", int(profile.get("aspect_tier", 0)))
	set_meta("blood_generation", bool(profile.get("blood_generation", true)))
	set_meta("spectral_min_range", float(profile.get("spectral_min_range", 0.0)))
	set_meta("spectral_edge", bool(profile.get("spectral_edge", false)))
	set_meta("aspect_passage", bool(profile.get("aspect_passage", false)))
	set_meta("perfect_weight", bool(profile.get("perfect_weight", false)))
	set_meta("blood_tempo_continuation", bool(profile.get("blood_tempo_continuation", false)))
