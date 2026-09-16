extends Node

const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const EXPECTED_EXECUTOR_SCRIPT := "res://Core/Prosthetics/OathboundProstheticExecutor.gd"


func _ready() -> void:
	call_deferred("_run_contract")


func _run_contract() -> void:
	var player_value: Node = PLAYER_SCENE.instantiate()
	if player_value == null:
		_fail("canonical Player scene could not instantiate")
		return
	add_child(player_value)
	await get_tree().process_frame

	var player: Node = player_value
	var executor: Node = player.get_node_or_null("ProstheticExecutor")
	if executor == null:
		_fail("canonical Player is missing ProstheticExecutor")
		return

	var executor_script: Variant = executor.get_script()
	var executor_path := ""
	if executor_script is Script:
		executor_path = (executor_script as Script).resource_path
	if executor_path != EXPECTED_EXECUTOR_SCRIPT:
		_fail("wrong Prosthetic executor: %s" % executor_path)
		return

	# Universal player Posture is retired. Keep a non-zero sentinel so this test catches
	# both direct writes and the old inherited apply_umbrella_posture() behavior.
	player.set("stagger", 7.0)
	var stagger_before := float(player.get("stagger"))
	player.call("apply_umbrella_posture", 12.5)
	if not is_equal_approx(float(player.get("stagger")), stagger_before):
		_fail("Mirror Umbrella compatibility call changed player stagger")
		return

	# Put the real executor in an active Umbrella window without spending persistent
	# progression resources. The contract under test is absorption/storage/overflow.
	executor.set("_active_prosthetic_id", "mirror_umbrella")
	executor.set("_umbrella_phase", "active")
	executor.set("_umbrella_storage", 0.0)
	executor.set("_umbrella_capacity", 50.0)
	player.set_meta("_oathbound_umbrella_active", true)

	var facing := Vector2.RIGHT
	if player.has_method("get_defensive_facing"):
		facing = Vector2(player.call("get_defensive_facing"))
	if facing.length() < 0.01:
		facing = Vector2.RIGHT

	var attacker := Node2D.new()
	attacker.name = "UmbrellaSmokeAttacker"
	add_child(attacker)
	attacker.global_position = (player as Node2D).global_position + facing.normalized() * 24.0
	attacker.set_meta("block_posture_damage", 20.0)

	var absorbed := bool(executor.call("try_umbrella_absorb", 20, "physical", attacker))
	if not absorbed:
		_fail("valid frontal pressure was not absorbed")
		return
	if not is_equal_approx(float(executor.get("_umbrella_storage")), 20.0):
		_fail("Umbrella did not retain absorbed pressure locally")
		return
	if not is_equal_approx(float(player.get("stagger")), stagger_before):
		_fail("absorbed pressure leaked into retired player Posture")
		return

	# Only 30 capacity remains. A 31-pressure hit must overflow and resolve normally
	# without silently clipping or increasing the stored value.
	attacker.set_meta("block_posture_damage", 31.0)
	var overflow_absorbed := bool(executor.call("try_umbrella_absorb", 31, "physical", attacker))
	if overflow_absorbed:
		_fail("over-capacity pressure was incorrectly absorbed")
		return
	if not is_equal_approx(float(executor.get("_umbrella_storage")), 20.0):
		_fail("overflow mutated stored Umbrella pressure")
		return

	# Releasing may have no targets in this isolated smoke, but it must always consume
	# the local storage and still leave the player-wide retired stagger sentinel alone.
	executor.call("_release_umbrella_pressure")
	if not is_zero_approx(float(executor.get("_umbrella_storage"))):
		_fail("Umbrella release did not clear local storage")
		return
	if not is_equal_approx(float(player.get("stagger")), stagger_before):
		_fail("Umbrella release changed retired player Posture")
		return

	print("[OathboundProstheticRuntimeSmoke] PASS - Umbrella local storage overflow release no-player-Posture")
	get_tree().quit(0)


func _fail(message: String) -> void:
	push_error("[OathboundProstheticRuntimeSmoke] FAIL - %s" % message)
	get_tree().quit(1)
