extends HubInteractable

## Blood Cavern — canonical Strand training / trial entry.
##
## Launch framework intentionally starts with a production-combat passive target and
## the existing Blood Mirror progression surface. Exact authored trial counts,
## rewards, fixed loadouts, and mastery content remain later content work per the
## approved Blood Cavern authority docs.
##
## Guardrails:
## - training targets never award Gold, XP, Mist, Scrolls, boss materials, or records;
## - the target never mutates the player's run loadout;
## - Blood Mirror progression remains owned by BloodMirror.gd/Menu, not this station.

signal training_started(mode: String)
signal training_ended

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const TRAINING_TARGET = preload("res://World/BloodCavernTrainingTarget.tscn")

var _menu: Control = null
var _training_target: Node2D = null
var _training_active: bool = false
var _previous_paused: bool = false


func _on_ready_custom() -> void:
	pass


func _open_menu() -> void:
	super._open_menu()
	if _menu != null and is_instance_valid(_menu):
		return
	var current_scene: Node = get_tree().current_scene
	var ui_layer: Node = current_scene.get_node_or_null("UILayer") if current_scene != null else null
	if ui_layer == null:
		push_error("[BloodCavern] Hub UILayer missing")
		close_menu()
		return

	_previous_paused = get_tree().paused
	get_tree().paused = true
	_menu = _build_menu_surface()
	ui_layer.add_child(_menu)
	READABILITY_STYLER.apply(_menu)


func _build_menu_surface() -> Control:
	var root := Control.new()
	root.name = "BloodCavernMenu"
	root.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP

	var dimmer := ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0.01, 0.01, 0.015, 0.74)
	root.add_child(dimmer)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.20
	panel.anchor_top = 0.14
	panel.anchor_right = 0.80
	panel.anchor_bottom = 0.86
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.055, 0.04, 0.055, 0.97)
	panel_style.border_color = Color(0.50, 0.18, 0.26, 0.85)
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(6)
	panel.add_theme_stylebox_override("panel", panel_style)
	root.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var title := Label.new()
	title.text = LOCALIZATION.ui("blood_cavern.title", "BLOOD CAVERN")
	title.add_theme_font_size_override("font_size", 20)
	content.add_child(title)

	var intro := Label.new()
	intro.text = LOCALIZATION.ui(
		"blood_cavern.intro",
		"Training Hall — test execution, posture pressure, combos, and current build behavior without run rewards or progression."
	)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(intro)

	var target_status := Label.new()
	target_status.name = "TrainingStatus"
	target_status.text = _training_status_text()
	target_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(target_status)

	var target_button := Button.new()
	target_button.name = "StartTrainingTarget"
	target_button.text = LOCALIZATION.ui("blood_cavern.training_target", "Start Passive Combat Target")
	target_button.pressed.connect(_start_passive_target)
	content.add_child(target_button)

	var reset_button := Button.new()
	reset_button.name = "ResetTrainingTarget"
	reset_button.text = LOCALIZATION.ui("blood_cavern.reset_target", "Reset Training Target")
	reset_button.disabled = not _has_training_target()
	reset_button.pressed.connect(_reset_training_target)
	content.add_child(reset_button)

	var end_button := Button.new()
	end_button.name = "EndTraining"
	end_button.text = LOCALIZATION.ui("blood_cavern.end_training", "End Training")
	end_button.disabled = not _has_training_target()
	end_button.pressed.connect(_end_training)
	content.add_child(end_button)

	var separator := HSeparator.new()
	content.add_child(separator)

	var mirror_status := Label.new()
	mirror_status.name = "BloodMirrorStatus"
	mirror_status.text = _blood_mirror_status_text()
	mirror_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(mirror_status)

	var mirror_button := Button.new()
	mirror_button.name = "OpenBloodMirror"
	mirror_button.text = LOCALIZATION.ui("blood_cavern.blood_mirror", "Enter Blood Mirror")
	mirror_button.disabled = _find_blood_mirror() == null
	mirror_button.pressed.connect(_open_blood_mirror)
	content.add_child(mirror_button)

	var close_button := Button.new()
	close_button.name = "Close"
	close_button.text = LOCALIZATION.ui("common.close", "Close")
	close_button.pressed.connect(_close_menu_surface)
	content.add_child(close_button)
	return root


func _start_passive_target() -> void:
	_close_menu_surface()
	if _has_training_target():
		_reset_training_target()
		return
	var target_value: Variant = TRAINING_TARGET.instantiate()
	if not (target_value is Node2D):
		push_error("[BloodCavern] Training target scene did not instantiate as Node2D")
		return
	_training_target = target_value as Node2D
	_training_target.name = "BloodCavernTrainingTarget"
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		_training_target.queue_free()
		_training_target = null
		return
	current_scene.add_child(_training_target)
	_training_target.global_position = global_position + Vector2(112.0, 0.0)
	_training_active = true
	training_started.emit("passive_target")
	print("[BloodCavern] Passive production-combat training target active — rewards disabled")


func _reset_training_target() -> void:
	if not _has_training_target():
		return
	if _training_target.has_method("reset_training_target"):
		_training_target.call("reset_training_target")
	_training_target.global_position = global_position + Vector2(112.0, 0.0)
	print("[BloodCavern] Training target reset")


func _end_training() -> void:
	var was_active: bool = _training_active or _has_training_target()
	if _has_training_target():
		_training_target.queue_free()
	_training_target = null
	_training_active = false
	if was_active:
		training_ended.emit()
		print("[BloodCavern] Training ended — no run or permanent rewards granted")
	_close_menu_surface()


func _open_blood_mirror() -> void:
	var mirror: Node = _find_blood_mirror()
	_close_menu_surface()
	if mirror != null and mirror.has_method("_open_menu"):
		mirror.call_deferred("_open_menu")


func _find_blood_mirror() -> Node:
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		return null
	var mirror: Node = current_scene.get_node_or_null("BloodMirror")
	if mirror != null:
		return mirror
	return get_node_or_null("BloodMirror")


func _blood_mirror_status_text() -> String:
	var unlocked: bool = false
	if typeof(MetaProgressionManager) == TYPE_OBJECT and MetaProgressionManager.has_method("is_blood_mirror_unlocked"):
		unlocked = bool(MetaProgressionManager.is_blood_mirror_unlocked())
	return LOCALIZATION.ui(
		"blood_cavern.mirror.available",
		"Blood Mirror — awakened after the Keeper. Permanent Aspect reliability progression is available inside."
	) if unlocked else LOCALIZATION.ui(
		"blood_cavern.mirror.locked",
		"Blood Mirror — dormant until the first Keeper defeat. The outer Training Hall remains available."
	)


func _training_status_text() -> String:
	return LOCALIZATION.ui(
		"blood_cavern.training.active",
		"Training target active. Damage and posture reset on defeat; no currencies or records are awarded."
	) if _has_training_target() else LOCALIZATION.ui(
		"blood_cavern.training.ready",
		"Training target ready. This first launch slice is passive so build testing cannot kill Akio or alter run state."
	)


func _has_training_target() -> bool:
	return _training_target != null and is_instance_valid(_training_target)


func _close_menu_surface() -> void:
	if _menu != null and is_instance_valid(_menu):
		_menu.queue_free()
	_menu = null
	get_tree().paused = _previous_paused
	close_menu()


func _on_menu_closed_custom() -> void:
	_menu = null


func _menu_snapshot_for_playtest() -> Dictionary:
	return {
		"title": LOCALIZATION.ui("blood_cavern.title", "BLOOD CAVERN"),
		"training_target": LOCALIZATION.ui("blood_cavern.training_target", "Start Passive Combat Target"),
		"reset_target": LOCALIZATION.ui("blood_cavern.reset_target", "Reset Training Target"),
		"end_training": LOCALIZATION.ui("blood_cavern.end_training", "End Training"),
		"blood_mirror": LOCALIZATION.ui("blood_cavern.blood_mirror", "Enter Blood Mirror"),
		"mirror_status": _blood_mirror_status_text(),
		"training_active": _has_training_target(),
	}


func _exit_tree() -> void:
	if _has_training_target():
		_training_target.queue_free()
	_training_target = null
	_training_active = false
