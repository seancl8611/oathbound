extends HubInteractable

## Blood Cavern — canonical Strand training / trial entry.
##
## Launch framework provides a production-combat passive target, replayable tutorial
## refreshers, discovered Action-Technique demos, and the existing Blood Mirror
## progression surface. Exact authored trial tuning, fixed challenge loadouts, and
## mastery content remain later content work per the approved Blood Cavern authority.
##
## Guardrails:
## - training targets never award Gold, XP, Mist, Scrolls, boss materials, or records;
## - temporary Technique demos restore the exact prior run Technique array on exit;
## - refreshers describe current runtime controls and never create a second tutorial state;
## - Blood Mirror progression remains owned by BloodMirror.gd/Menu, not this station.

signal training_started(mode: String)
signal training_ended

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")
const TECHNIQUE_CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")
const TRAINING_TARGET = preload("res://World/BloodCavernTrainingTarget.tscn")

const TECHNIQUE_RECORD_PREFIX := "technique_record/"
const REFRESHER_TOPICS: Array[String] = [
	"execution",
	"parry",
	"dodge_red",
	"posture_guard",
	"targeting",
	"prosthetic_spirit",
	"blood_aspects",
]

var _menu: Control = null
var _training_target: Node2D = null
var _training_active: bool = false
var _previous_paused: bool = false
var _demo_snapshot_active: bool = false
var _demo_original_upgrades: Array = []
var _active_demo_technique_id: String = ""


func _on_ready_custom() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()


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
	_show_refresher("execution")


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
	panel.anchor_left = 0.16
	panel.anchor_top = 0.07
	panel.anchor_right = 0.84
	panel.anchor_bottom = 0.93
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

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	margin.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)

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
	end_button.disabled = not _has_training_target() and not _demo_snapshot_active
	end_button.pressed.connect(_end_training)
	content.add_child(end_button)

	content.add_child(HSeparator.new())
	_build_refresher_section(content)
	content.add_child(HSeparator.new())
	_build_technique_demo_section(content)
	content.add_child(HSeparator.new())

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


func _build_refresher_section(content: VBoxContainer) -> void:
	var heading := Label.new()
	heading.text = LOCALIZATION.ui("blood_cavern.refreshers.title", "TUTORIAL REFRESHERS")
	heading.add_theme_font_size_override("font_size", 16)
	content.add_child(heading)

	var note := Label.new()
	note.text = LOCALIZATION.ui(
		"blood_cavern.refreshers.note",
		"Replay concise combat reminders using your current bindings. Refreshers do not alter progression or run state."
	)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(note)

	var grid := GridContainer.new()
	grid.name = "RefresherButtons"
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(grid)
	for topic_id: String in REFRESHER_TOPICS:
		var topic: Dictionary = _refresher_copy_for_playtest(topic_id, INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
		var button := Button.new()
		button.name = "Refresher_%s" % topic_id
		button.text = str(topic.get("title", topic_id.capitalize()))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.disabled = topic_id == "blood_aspects" and not _returning_blood_awakened()
		button.pressed.connect(_show_refresher.bind(topic_id))
		grid.add_child(button)

	var detail := RichTextLabel.new()
	detail.name = "RefresherDetail"
	detail.fit_content = true
	detail.custom_minimum_size = Vector2(0, 92)
	detail.bbcode_enabled = false
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(detail)


func _build_technique_demo_section(content: VBoxContainer) -> void:
	var heading := Label.new()
	heading.text = LOCALIZATION.ui("blood_cavern.technique_demos.title", "TECHNIQUE DEMOS")
	heading.add_theme_font_size_override("font_size", 16)
	content.add_child(heading)

	var note := Label.new()
	note.text = LOCALIZATION.ui(
		"blood_cavern.technique_demos.note",
		"Practice discovered Action Techniques on the passive target. The demo temporarily replaces run Techniques and restores the exact prior list when training ends."
	)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(note)

	var demos: Array[Dictionary] = _discovered_action_techniques_for_playtest()
	var grid := GridContainer.new()
	grid.name = "TechniqueDemoButtons"
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(grid)
	if demos.is_empty():
		var empty := Label.new()
		empty.name = "TechniqueDemoEmpty"
		empty.text = LOCALIZATION.ui(
			"blood_cavern.technique_demos.empty",
			"No discovered Action Techniques yet. Discover them during runs to make their combat demos available here."
		)
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		grid.add_child(empty)
		return

	for demo: Dictionary in demos:
		var technique_id: String = str(demo.get("id", ""))
		var button := Button.new()
		button.name = "TechniqueDemo_%s" % technique_id
		button.text = "%s — %s" % [str(demo.get("name", technique_id)), str(demo.get("action_label", "Action"))]
		button.tooltip_text = str(demo.get("details", ""))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_start_technique_demo.bind(technique_id))
		grid.add_child(button)


func _show_refresher(topic_id: String) -> void:
	if _menu == null or not is_instance_valid(_menu):
		return
	var detail_value: Node = _menu.find_child("RefresherDetail", true, false)
	if not (detail_value is RichTextLabel):
		return
	var keyboard: Dictionary = _refresher_copy_for_playtest(topic_id, INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
	var controller: Dictionary = _refresher_copy_for_playtest(topic_id, INPUT_GLYPHS.FAMILY_CONTROLLER)
	var detail := detail_value as RichTextLabel
	var title: String = str(keyboard.get("title", topic_id.capitalize()))
	var keyboard_body: String = str(keyboard.get("body", ""))
	var controller_body: String = str(controller.get("body", ""))
	if keyboard_body == controller_body:
		detail.text = "%s\n%s" % [title, keyboard_body]
	else:
		detail.text = "%s\n%s: %s\n%s: %s" % [
			title,
			LOCALIZATION.ui("blood_cavern.refreshers.keyboard", "Keyboard / Mouse"),
			keyboard_body,
			LOCALIZATION.ui("blood_cavern.refreshers.controller", "Controller"),
			controller_body,
		]


func _refresher_copy_for_playtest(topic_id: String, family: String) -> Dictionary:
	INPUT_GLYPHS.ensure_controller_defaults()
	var execution: String = INPUT_GLYPHS.preferred_label("execute_finisher", family)
	var parry: String = INPUT_GLYPHS.preferred_label("parry", family)
	var dash: String = INPUT_GLYPHS.preferred_label("dash", family)
	var prosthetic: String = INPUT_GLYPHS.preferred_label("prosthetic", family)
	var up: String = INPUT_GLYPHS.preferred_label("up", family)
	var down: String = INPUT_GLYPHS.preferred_label("down", family)
	var left: String = INPUT_GLYPHS.preferred_label("left", family)
	var right: String = INPUT_GLYPHS.preferred_label("right", family)
	match topic_id:
		"execution":
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.execution.title", "Execution"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.execution.body",
					"Break enemy Posture, then use %s when the deathblow prompt appears. Execution ends the target's current life state; Cavern targets immediately reset instead of granting rewards."
				) % execution,
			}
		"parry":
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.parry.title", "Parry"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.parry.body",
					"Use %s just before a blockable strike lands. A clean parry pressures enemy Posture more efficiently than simply absorbing pressure."
				) % parry,
			}
		"dodge_red":
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.dodge_red.title", "Dodge / Red Attacks"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.dodge_red.body",
					"Red attacks are unblockable. Read the warning, reposition, and use %s to evade instead of trying to guard the hit."
				) % dash,
			}
		"posture_guard":
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.posture_guard.title", "Posture / Guard"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.posture_guard.body",
					"Use %s for the current guard/parry action. Your Posture measures defensive pressure; enemy Posture creates the opening for an Execution. Hold/Toggle behavior follows your Settings choice."
				) % parry,
			}
		"targeting":
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.targeting.title", "Targeting"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.targeting.body",
					"The current build uses facing and proximity rather than a dedicated lock-on button. Reposition with %s %s %s %s so Akio is oriented toward the target you intend to pressure."
				) % [up, down, left, right],
			}
		"prosthetic_spirit":
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.prosthetic_spirit.title", "Prosthetic / Spirit"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.prosthetic_spirit.body",
					"Use %s to fire the equipped Prosthetic when you have enough Spirit. The Run HUD shows current Spirit and the equipped tool's cost."
				) % prosthetic,
			}
		"blood_aspects":
			if not _returning_blood_awakened():
				return {
					"title": LOCALIZATION.ui("blood_cavern.refresher.blood_aspects.title", "Blood / Aspects"),
					"body": LOCALIZATION.ui("blood_cavern.refresher.blood_aspects.locked", "This refresher unlocks after Returning Blood awakens."),
				}
			return {
				"title": LOCALIZATION.ui("blood_cavern.refresher.blood_aspects.title", "Blood / Aspects"),
				"body": LOCALIZATION.ui(
					"blood_cavern.refresher.blood_aspects.body",
					"Returning Blood enables Aspect selection before a run. Corruption is run pressure, while permanent Aspect reliability upgrades remain owned by the Blood Mirror inside this Cavern."
				),
			}
		_:
			return {
				"title": LOCALIZATION.ui("blood_cavern.refreshers.title", "Tutorial Refreshers"),
				"body": LOCALIZATION.ui("blood_cavern.refreshers.unknown", "No refresher is authored for this topic."),
			}


func _discovered_action_techniques_for_playtest() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if typeof(MetaProgress) != TYPE_OBJECT:
		return out
	for id_value: Variant in TECHNIQUE_CATALOG.TECHNIQUES.keys():
		var technique_id: String = str(id_value)
		if not bool(MetaProgress.get_progression_flag(TECHNIQUE_RECORD_PREFIX + technique_id, false)):
			continue
		var data: Dictionary = TECHNIQUE_CATALOG.get_entry(technique_id)
		if str(data.get("kind", "")) != TECHNIQUE_CATALOG.KIND_ACTION:
			continue
		out.append({
			"id": technique_id,
			"name": LOCALIZATION.catalog_name("technique", technique_id, str(data.get("displayname", technique_id.capitalize()))),
			"details": LOCALIZATION.catalog_details("technique", technique_id, str(data.get("details", ""))),
			"family": str(data.get("family", "")),
			"action": str(data.get("action", "")),
			"action_label": _technique_action_label(str(data.get("action", ""))),
		})
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return str(a.get("name", "")) < str(b.get("name", ""))
	)
	return out


func _technique_action_label(action: String) -> String:
	match action:
		"basic": return LOCALIZATION.ui("technique.kind.basic", "Basic Attack")
		"held": return LOCALIZATION.ui("technique.kind.held", "Held Attack")
		"dash": return LOCALIZATION.ui("technique.kind.dash", "Dash Attack")
		"counter": return LOCALIZATION.ui("technique.kind.counter", "Parry / Counter")
		"deathblow": return LOCALIZATION.ui("technique.kind.deathblow", "Deathblow")
		_: return LOCALIZATION.ui("technique.kind.action", "Action Technique")


func _is_discovered_action_technique(technique_id: String) -> bool:
	for demo: Dictionary in _discovered_action_techniques_for_playtest():
		if str(demo.get("id", "")) == technique_id:
			return true
	return false


func _start_technique_demo(technique_id: String) -> void:
	if not _is_discovered_action_technique(technique_id):
		push_warning("[BloodCavern] Technique demo rejected because it is not a discovered Action Technique: %s" % technique_id)
		return
	_close_menu_surface()
	_clear_training_target()
	_begin_demo_loadout(technique_id)
	_spawn_training_target("technique_demo")


func _begin_demo_loadout(technique_id: String) -> void:
	if typeof(RunData) != TYPE_OBJECT:
		return
	if not _demo_snapshot_active:
		_demo_original_upgrades = RunData.acquired_upgrades.duplicate(true)
		_demo_snapshot_active = true
	RunData.acquired_upgrades = [technique_id]
	_active_demo_technique_id = technique_id
	print("[BloodCavern] Technique demo loadout active: %s" % technique_id)


func _restore_demo_loadout() -> void:
	if not _demo_snapshot_active:
		_active_demo_technique_id = ""
		return
	if typeof(RunData) == TYPE_OBJECT:
		RunData.acquired_upgrades = _demo_original_upgrades.duplicate(true)
	_demo_original_upgrades.clear()
	_demo_snapshot_active = false
	_active_demo_technique_id = ""
	print("[BloodCavern] Technique demo loadout restored")


func _start_passive_target() -> void:
	_close_menu_surface()
	_restore_demo_loadout()
	if _has_training_target():
		_reset_training_target()
		return
	_spawn_training_target("passive_target")


func _spawn_training_target(mode: String) -> void:
	if _has_training_target():
		_reset_training_target()
		_training_active = true
		training_started.emit(mode)
		return
	var target_value: Variant = TRAINING_TARGET.instantiate()
	if not (target_value is Node2D):
		push_error("[BloodCavern] Training target scene did not instantiate as Node2D")
		_restore_demo_loadout()
		return
	_training_target = target_value as Node2D
	_training_target.name = "BloodCavernTrainingTarget"
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		_training_target.queue_free()
		_training_target = null
		_restore_demo_loadout()
		return
	current_scene.add_child(_training_target)
	_training_target.global_position = global_position + Vector2(112.0, 0.0)
	_training_active = true
	training_started.emit(mode)
	print("[BloodCavern] %s training target active — rewards disabled" % mode)


func _reset_training_target() -> void:
	if not _has_training_target():
		return
	if _training_target.has_method("reset_training_target"):
		_training_target.call("reset_training_target")
	_training_target.global_position = global_position + Vector2(112.0, 0.0)
	print("[BloodCavern] Training target reset")


func _clear_training_target() -> void:
	if _has_training_target():
		_training_target.queue_free()
	_training_target = null
	_training_active = false


func _end_training() -> void:
	var was_active: bool = _training_active or _has_training_target() or _demo_snapshot_active
	_clear_training_target()
	_restore_demo_loadout()
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
	if not _active_demo_technique_id.is_empty():
		var data: Dictionary = TECHNIQUE_CATALOG.get_entry(_active_demo_technique_id)
		var technique_name: String = LOCALIZATION.catalog_name(
			"technique",
			_active_demo_technique_id,
			str(data.get("displayname", _active_demo_technique_id.capitalize()))
		)
		return LOCALIZATION.ui(
			"blood_cavern.training.technique_demo_active",
			"Technique demo active: %s. The passive target resets on defeat and the prior Technique list returns when training ends."
		) % technique_name
	return LOCALIZATION.ui(
		"blood_cavern.training.active",
		"Training target active. Damage and posture reset on defeat; no currencies or records are awarded."
	) if _has_training_target() else LOCALIZATION.ui(
		"blood_cavern.training.ready",
		"Training target ready. This first launch slice is passive so build testing cannot kill Akio or alter run state."
	)


func _returning_blood_awakened() -> bool:
	return typeof(MetaProgress) == TYPE_OBJECT and bool(MetaProgress.returning_blood_awakened)


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
		"refreshers": LOCALIZATION.ui("blood_cavern.refreshers.title", "TUTORIAL REFRESHERS"),
		"refresher_topics": REFRESHER_TOPICS.duplicate(),
		"technique_demos": LOCALIZATION.ui("blood_cavern.technique_demos.title", "TECHNIQUE DEMOS"),
		"discovered_action_demos": _discovered_action_techniques_for_playtest(),
		"active_demo_technique": _active_demo_technique_id,
		"blood_mirror": LOCALIZATION.ui("blood_cavern.blood_mirror", "Enter Blood Mirror"),
		"mirror_status": _blood_mirror_status_text(),
		"training_active": _has_training_target(),
	}


func _exit_tree() -> void:
	_clear_training_target()
	_restore_demo_loadout()
