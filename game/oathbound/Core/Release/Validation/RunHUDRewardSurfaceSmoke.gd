extends Node

const RUN_HUD_SCRIPT = preload("res://Core/Prosthetics/OathboundRunHUD.gd")
const STRAND_PLAYER_SCENE = preload("res://Player/player.tscn")
const RUN_PLAYER_SCENE = preload("res://Player/aspect_player.tscn")

var _failed := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await _verify_player_spirit_bootstrap(STRAND_PLAYER_SCENE, "Strand Player")
	await _verify_player_spirit_bootstrap(RUN_PLAYER_SCENE, "Run Player")

	var hud_value: Variant = RUN_HUD_SCRIPT.new()
	_expect(hud_value is CanvasLayer, "current RunHUD wrapper could not instantiate")
	if not (hud_value is CanvasLayer):
		get_tree().quit(1)
		return

	var hud := hud_value as CanvasLayer
	add_child(hud)
	await get_tree().process_frame

	var toast_value: Variant = hud.get("_toast_container")
	_expect(toast_value is VBoxContainer, "RunHUD toast container was not built")
	if toast_value is VBoxContainer:
		var toasts := toast_value as VBoxContainer
		var before: int = toasts.get_child_count()
		hud.call("show_currency_toast", "emblem", 3)
		await get_tree().process_frame
		_expect(toasts.get_child_count() == before, "deprecated generic Boss Emblem produced a visible reward toast")
		_expect(str(hud.call("_localized_reward_label_for_playtest", "emblem")).is_empty(), "deprecated generic Boss Emblem still has current player-facing reward copy")

		hud.call("show_currency_toast", "mist", 2)
		await get_tree().process_frame
		_expect(toasts.get_child_count() == before + 1, "canonical Mist reward did not produce a visible reward toast")
		_expect(str(hud.call("_localized_reward_label_for_playtest", "mist")) == "Mist", "canonical Mist reward label did not preserve English localization fallback")

	hud.queue_free()
	await get_tree().process_frame
	if _failed:
		get_tree().quit(1)
		return
	print("[RunHUDRewardSurfaceSmoke] Spirit PASS - Strand bootstrap silent | run bootstrap silent | real same-cap gain visible")
	print("[RunHUDRewardSurfaceSmoke] PASS - canonical reward toast | deprecated generic Boss Emblem suppressed")
	get_tree().quit(0)


func _verify_player_spirit_bootstrap(scene: PackedScene, context: String) -> void:
	var player_value: Variant = scene.instantiate()
	_expect(player_value is Node, "%s could not instantiate" % context)
	if not (player_value is Node):
		return

	var player := player_value as Node
	add_child(player)
	await get_tree().process_frame

	var executor_value: Variant = player.get("prosthetic_executor")
	_expect(executor_value is Node, "%s did not expose a Prosthetic executor" % context)
	var hud_value: Variant = player.get("run_hud")
	_expect(hud_value is Node, "%s did not expose a RunHUD" % context)
	if executor_value is Node and hud_value is Node:
		var executor := executor_value as Node
		var player_hud := hud_value as Node
		_expect(int(executor.get("current_spirit")) == 100, "%s did not bootstrap at 100 Spirit" % context)
		_expect(int(executor.get("max_spirit")) == 100, "%s did not bootstrap with 100 max Spirit" % context)

		var popup_value: Variant = player_hud.get("_spirit_pop_label")
		_expect(popup_value is Label, "%s Spirit popup label was not built" % context)
		if popup_value is Label:
			var popup := popup_value as Label
			_expect(popup.modulate.a <= 0.001, "%s displayed a false Spirit gain during bootstrap" % context)

			executor.set("current_spirit", 90)
			executor.emit_signal("spirit_changed", 90, 100)
			_expect(popup.modulate.a <= 0.001, "%s displayed a Spirit gain while Spirit decreased" % context)

			executor.set("current_spirit", 100)
			executor.emit_signal("spirit_changed", 100, 100)
			_expect(popup.text == "+10", "%s did not preserve the real +10 Spirit gain label" % context)
			_expect(popup.modulate.a > 0.5, "%s did not visibly present a real same-cap Spirit gain" % context)

	player.queue_free()
	await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[RunHUDRewardSurfaceSmoke] FAIL - %s" % message)
