extends Node

const RUN_HUD_SCRIPT = preload("res://Core/Prosthetics/OathboundRunHUD.gd")

var _failed := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
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
	print("[RunHUDRewardSurfaceSmoke] PASS - canonical reward toast | deprecated generic Boss Emblem suppressed")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[RunHUDRewardSurfaceSmoke] FAIL - %s" % message)
