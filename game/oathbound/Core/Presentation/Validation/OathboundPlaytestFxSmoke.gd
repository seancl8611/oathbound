extends Node2D

const STATUS_SCRIPT: Script = preload("res://Core/Presentation/OathboundPlaytestFxStatus.gd")

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	var runtime: Node = get_node_or_null("/root/TechniqueEffects/PlaytestFxRuntime")
	_check(runtime != null, "TechniqueEffects should own the debug PlaytestFxRuntime")
	if runtime == null:
		_finish()
		return

	if runtime.has_method("enable_for_tests"):
		runtime.call("enable_for_tests")
	_check(bool(runtime.call("is_enabled")), "PlaytestFxRuntime should be enabled for validation")

	var before_count: int = get_tree().get_nodes_in_group("playtest_fx").size()
	var spawned: int = int(runtime.call("debug_spawn_showcase", Vector2(160.0, 120.0)))
	await get_tree().process_frame
	var after_count: int = get_tree().get_nodes_in_group("playtest_fx").size()
	_check(spawned >= 7, "showcase should create all core procedural silhouettes")
	_check(after_count >= before_count + 7, "procedural primitives should register as playtest_fx")

	var target := Node2D.new()
	target.name = "FxSmokeTarget"
	add_child(target)
	runtime.call("_set_status_visual", target, "rupture", true, "rupture", Color(1.0, 0.58, 0.12, 1.0), 0.65, 1, Vector2.RIGHT)
	runtime.call("_set_status_visual", target, "seal", true, "seal", Color(0.72, 0.40, 1.0, 1.0), 0.67, 2, Vector2.RIGHT)
	runtime.call("_set_status_visual", target, "rift", true, "rift", Color(1.0, 0.96, 0.78, 1.0), 0.67, 2, Vector2.RIGHT)
	runtime.call("_set_status_visual", target, "vulnerable", true, "vulnerable", Color(0.95, 0.16, 0.20, 1.0), 1.0, 1, Vector2.RIGHT)
	await get_tree().process_frame
	_check(target.get_node_or_null("PlaytestFx_rupture") != null, "Rupture should have a persistent code-only marker")
	_check(target.get_node_or_null("PlaytestFx_seal") != null, "Seal should have a persistent code-only marker")
	_check(target.get_node_or_null("PlaytestFx_rift") != null, "Rift should have a persistent code-only marker")
	_check(target.get_node_or_null("PlaytestFx_vulnerable") != null, "Vulnerable should have a persistent code-only marker")

	var previous := {
		"echo": 1,
		"rupture": 96.0,
		"seal": 2,
		"bound": false,
		"rift": 3,
		"vulnerable": false,
		"shock": false,
		"burn": false,
		"slow": false,
		"deathblow": false,
	}
	var current := {
		"echo": 0,
		"rupture": 0.0,
		"seal": 0,
		"bound": true,
		"rift": 0,
		"vulnerable": true,
		"shock": true,
		"burn": true,
		"slow": true,
		"deathblow": true,
	}
	var transition_before: int = get_tree().get_nodes_in_group("playtest_fx").size()
	runtime.call("_handle_enemy_transitions", target, previous, current)
	await get_tree().process_frame
	var transition_after: int = get_tree().get_nodes_in_group("playtest_fx").size()
	_check(transition_after > transition_before, "Technique/status transitions should create transient world-space FX")

	for style: String in ["echo", "rupture", "seal", "bound", "rift", "vulnerable", "shock", "burn", "slow", "deathblow", "unseen", "umbrella", "bloodletting", "aspect"]:
		var status_value: Variant = STATUS_SCRIPT.new()
		_check(status_value is Node2D, "status style %s should instantiate" % style)
		if status_value is Node2D:
			var status := status_value as Node2D
			add_child(status)
			status.call("set_state", style, Color.WHITE, 0.75, 2, Vector2.RIGHT)
			status.queue_redraw()
			status.queue_free()

	runtime.call("_set_status_visual", target, "rupture", false, "rupture", Color.WHITE, 1.0, 1, Vector2.RIGHT)
	await get_tree().process_frame
	_check(target.get_node_or_null("PlaytestFx_rupture") == null, "persistent marker should clear when its observed state ends")

	_finish()


func _check(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("[OathboundPlaytestFxSmoke] %s" % message)


func _finish() -> void:
	if _failures.is_empty():
		print("[OathboundPlaytestFxSmoke] PASS - code-only primitives | persistent Technique/status markers | transition bursts | debug-only runtime attachment")
		get_tree().quit(0)
		return
	print("[OathboundPlaytestFxSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)
