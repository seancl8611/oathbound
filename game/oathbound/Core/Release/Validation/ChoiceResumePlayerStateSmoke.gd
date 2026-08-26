extends Node

## Regression smoke for choice-first regional resume boundaries. Yomori always opens on
## a route choice, and Kagutsuchi may do the same. A safe Continue at that boundary must
## preserve the saved Player snapshot while no concrete chamber/Player exists, then
## apply it exactly once after the selected chamber parents the canonical Player.

const FLOW_SCRIPT = preload("res://Core/Release/OathboundReleaseGameFlow.gd")


class CheckpointExecutor:
	extends Node
	signal spirit_changed(current: int, maximum: int)
	var current_spirit: int = 1
	var max_spirit: int = 20

	func get_spirit() -> int:
		return current_spirit

	func get_max_spirit() -> int:
		return max_spirit


class CheckpointPlayer:
	extends Node
	var hp: int = 100
	var maxhp: int = 100
	var stagger_max: float = 1.0
	var collected_upgrades: Array = []
	var prosthetic_executor: Node = null

	func _update_health_bar() -> void:
		pass


var _failed := false


func _ready() -> void:
	call_deferred("_run_smoke")


func _run_smoke() -> void:
	var flow: Node = FLOW_SCRIPT.new()
	var saved_state := {
		"hp": 46,
		"maxhp": 130,
		"stagger_max": 84.0,
		"spirit": 37,
		"max_spirit": 120,
	}

	# Simulate resume landing on an unresolved CHOICE_* slot. There is intentionally
	# no Player yet, but any checkpoint written here must retain the saved snapshot.
	flow.set("_resume_player_state", saved_state.duplicate(true))
	flow.player = null
	var boundary_capture: Dictionary = flow.call("_capture_player_state")
	_expect(boundary_capture == saved_state, "choice boundary checkpoint discarded pending Player state")
	_expect(not bool(flow.call("_apply_pending_resume_player_state_if_ready")), "pending state applied before a concrete Player existed")
	_expect((flow.get("_resume_player_state") as Dictionary) == saved_state, "failed early apply consumed pending Player state")

	# Resolve the choice: the selected room now owns the canonical Player. Pending state
	# should apply once and clear only after the Player is parented.
	var checkpoint_player := CheckpointPlayer.new()
	var checkpoint_executor := CheckpointExecutor.new()
	checkpoint_player.prosthetic_executor = checkpoint_executor
	checkpoint_player.add_child(checkpoint_executor)
	flow.add_child(checkpoint_player)
	flow.player = checkpoint_player

	_expect(bool(flow.call("_apply_pending_resume_player_state_if_ready")), "pending Player state did not apply after chamber ownership existed")
	_expect(checkpoint_player.hp == 46, "choice resume lost Health")
	_expect(checkpoint_player.maxhp == 130, "choice resume lost max Health")
	_expect(is_equal_approx(checkpoint_player.stagger_max, 84.0), "choice resume lost Posture capacity")
	_expect(checkpoint_executor.current_spirit == 37, "choice resume lost Spirit")
	_expect(checkpoint_executor.max_spirit == 120, "choice resume lost max Spirit")
	_expect((flow.get("_resume_player_state") as Dictionary).is_empty(), "applied Player snapshot remained pending and could apply twice")
	_expect(not bool(flow.call("_apply_pending_resume_player_state_if_ready")), "consumed Player snapshot applied more than once")

	flow.free()

	if _failed:
		get_tree().quit(1)
		return
	print("[ChoiceResumePlayerStateSmoke] PASS - choice boundary preserves snapshot | chamber ownership applies once | Health/Posture/Spirit restored")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[ChoiceResumePlayerStateSmoke] FAIL - %s" % message)
