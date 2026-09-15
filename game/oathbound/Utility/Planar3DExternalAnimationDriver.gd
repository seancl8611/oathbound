extends RefCounted

## Presentation-only driver for direct production GLB AnimationPlayers.
##
## The authoritative Node2D remains the owner of attack timing and movement. This helper
## maps that existing state into imported animation clips without giving the model any
## combat authority. When exact source attack progress is available, the production
## attack clip is sampled at that progress instead of being allowed to free-run and drift
## away from the hitbox/damage timeline.

const IDLE_CLIPS: Array[String] = ["Idle", "idle"]
const LOCOMOTION_CLIPS: Array[String] = ["Jog", "Run", "Walk", "walk"]
const ATTACK_CLIPS: Array[String] = ["Sword_Attack", "SwordAttack", "Attack", "attack"]
const DEATH_CLIPS: Array[String] = ["Death", "death", "Dying"]
const ATTACK_STATE_TOKENS: Array[String] = ["attack", "slash", "cleave", "thrust", "bite", "lunge", "charge", "shot", "shoot"]


static func sync(visual_root: Node, source_actor: Node2D, speed: float) -> Dictionary:
	var state: Dictionary = {
		"mode": "inactive",
		"clip": "",
		"source": "none",
		"progress": -1.0,
		"sample_seconds": -1.0,
		"player_found": false,
	}
	var player := _find_animation_player(visual_root)
	if player == null:
		state["mode"] = "missing_animation_player"
		return state
	state["player_found"] = true

	var source_animation := _source_animation_name(source_actor)
	var attacking := _source_attack_active(source_actor) or _contains_any(source_animation, ATTACK_STATE_TOKENS)
	var desired := ""
	if _source_dead(source_actor):
		desired = _first_existing_animation(player, DEATH_CLIPS)
		state["source"] = "death_state"
	elif attacking:
		desired = _first_existing_animation(player, ATTACK_CLIPS)
		var progress_state := _exact_source_attack_progress(source_actor)
		if not desired.is_empty() and bool(progress_state.get("valid", false)):
			var animation := player.get_animation(desired)
			if animation != null:
				var progress := clampf(float(progress_state.get("progress", 0.0)), 0.0, 1.0)
				var sample_seconds := progress * maxf(0.001, animation.length)
				if str(player.current_animation) != desired:
					player.play(desired)
				player.seek(sample_seconds, true)
				player.pause()
				state["mode"] = "source_progress"
				state["clip"] = desired
				state["source"] = str(progress_state.get("source", "unknown"))
				state["progress"] = progress
				state["sample_seconds"] = sample_seconds
				return state
		state["source"] = "attack_state_without_exact_progress"
	elif speed > 12.0:
		desired = _first_existing_animation(player, LOCOMOTION_CLIPS)
		state["source"] = "velocity"
	else:
		desired = _first_existing_animation(player, IDLE_CLIPS)
		state["source"] = "idle_state"

	if desired.is_empty():
		state["mode"] = "missing_semantic_clip"
		return state

	# Locomotion/idle/death may run normally because they do not own combat timing. If an
	# attack source exposes no exact timeline yet, free playback is retained as an explicit
	# diagnostic fallback instead of fabricating authoritative progress.
	if str(player.current_animation) != desired or not player.is_playing():
		player.play(desired)
	state["clip"] = desired
	state["mode"] = "clip_playback_fallback" if attacking else "clip_playback"
	return state


static func _exact_source_attack_progress(source_actor: Node2D) -> Dictionary:
	if source_actor == null or not is_instance_valid(source_actor):
		return {"valid": false, "source": "none", "progress": 0.0}

	# Player/shared action controllers expose an authoritative attack profile + elapsed
	# time. Treat elapsed=0 as valid so a new attack samples frame zero deterministically.
	var profile_value := _property(source_actor, "_attack_profile", null)
	var elapsed_value := _property(source_actor, "_attack_elapsed", null)
	if profile_value is Dictionary and not (profile_value as Dictionary).is_empty() and (elapsed_value is int or elapsed_value is float):
		var profile := profile_value as Dictionary
		var duration := maxf(0.05, float(profile.get("duration", 0.45)))
		return {
			"valid": true,
			"source": "attack_elapsed",
			"progress": clampf(float(elapsed_value) / duration, 0.0, 1.0),
		}

	# Some legacy enemies expose attack timing only through their existing 2D
	# AnimationPlayer. Mirroring its position keeps the production mesh aligned with the
	# source presentation instead of inventing an unrelated loop.
	var source_player := _find_animation_player(source_actor)
	if source_player != null:
		var current_name := str(source_player.current_animation)
		if not current_name.is_empty() and _contains_any(current_name, ATTACK_STATE_TOKENS):
			var source_animation := source_player.get_animation(current_name)
			if source_animation != null and source_animation.length > 0.001:
				return {
					"valid": true,
					"source": "source_animation",
					"progress": clampf(source_player.current_animation_position / source_animation.length, 0.0, 1.0),
				}

	return {"valid": false, "source": "none", "progress": 0.0}


static func _source_animation_name(source_actor: Node2D) -> String:
	var player := _find_animation_player(source_actor)
	if player == null:
		return ""
	return str(player.current_animation).to_lower()


static func _source_attack_active(source_actor: Node2D) -> bool:
	var profile := _property(source_actor, "_attack_profile", null)
	return profile is Dictionary and not (profile as Dictionary).is_empty()


static func _source_dead(source_actor: Node2D) -> bool:
	var hp_value := _property(source_actor, "hp", null)
	return hp_value != null and (hp_value is int or hp_value is float) and float(hp_value) <= 0.0


static func _property(object: Object, property_name: String, fallback: Variant = null) -> Variant:
	if object == null:
		return fallback
	for info: Dictionary in object.get_property_list():
		if str(info.get("name", "")) == property_name:
			return object.get(property_name)
	return fallback


static func _contains_any(value: String, needles: Array[String]) -> bool:
	var lower := value.to_lower()
	for needle: String in needles:
		if lower.contains(needle):
			return true
	return false


static func _find_animation_player(node: Node) -> AnimationPlayer:
	if node == null:
		return null
	for child: Node in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested := _find_animation_player(child)
		if nested != null:
			return nested
	return null


static func _first_existing_animation(player: AnimationPlayer, candidates: Array[String]) -> String:
	for candidate: String in candidates:
		if player.has_animation(candidate):
			return candidate
	return ""
