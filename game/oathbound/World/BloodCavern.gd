extends HubInteractable

## Blood Cavern — canonical Strand training / trial entry.
##
## This station owns sandbox combat practice and challenge entry. It deliberately reuses
## production combat targets while suppressing normal enemy/run rewards. Permanent Blood
## Mirror progression remains owned by the nested BloodMirror node and its Keeper gate.

signal training_started(mode: String)
signal training_ended
signal trial_completed(trial_id: String, first_clear: bool, relic_id: String)

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")
const TECHNIQUE_CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")
const TRAINING_TARGET = preload("res://World/BloodCavernTrainingTarget.tscn")

const TECHNIQUE_RECORD_PREFIX := "technique_record/"
const TRIAL_EXECUTION := "execution_trial"
const TRAINING_TARGET_OFFSET := Vector2(-112.0, 0.0)
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
var _active_trial_id: String = ""
var _trial_completion_queued: bool = false
var _last_trial_result: Dictionary = {}


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
	_build_trial_section(content)
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
	mirror_button.disabled = _find_blood_mirror() == null or not _blood_mirror_unlocked()
	mirror_button.pressed.connect(_open_blood_mirror)
	content.add_child(mirror_button)

	var close_button := Button.new()
	close_button.name = "Close"
	close_button.text = LOCALIZATION.ui("common.close", "Close")
	close_button.pressed.connect(_close_menu_surface)
	content.add_child(close_button)
	return root


func _build_trial_section(content: VBoxContainer) -> void:
	var heading := Label.new()
	heading.text = LOCALIZATION.ui("blood_cavern.trials.title", "BASIC TRIALS")
	heading.add_theme_font_size_override("font_size", 16)
	content.add_child(heading)

	var note := Label.new()
	note.text = LOCALIZATION.ui(
		"blood_cavern.trials.note",
		"Opt-in deterministic challenges use real combat rules. Trial targets never grant normal run rewards or enemy drops."
	)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(note)

	var status := Label.new()
	status.name = "TrialStatus"
	status.text = _trial_status_text()
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(status)

	var execution_button := Button.new()
	execution_button.name = "StartExecutionTrial"
	execution_button.text = LOCALIZATION.ui("blood_cavern.trials.execution.start", "Start Execution Trial")
	execution_button.tooltip_text = LOCALIZATION.ui(
		"blood_cavern.trials.execution.details",
		"Break the target's Posture and land a real deathblow. Health-only defeats reset the target and do not complete the trial."
	)
	execution_button.pressed.connect(_start_execution_trial)
	content.add_child(execution_button)


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
	var blood_body := LOCALIZATION.ui(
		"blood_cavern.refresher.blood_aspects.awakened",
		"Aspect selection is available after Returning Blood awakens. The Blood Mirror owns permanent Aspect reliability progression."
	) if _returning_blood_awakened() else LOCALIZATION.ui(
		"blood_cavern.refresher.blood_aspects.locked",
		"Blood Aspects unlocks after Returning Blood awakens. Continue the campaign before practicing Aspect selection."
	)
	var topics: Dictionary = {
		"execution": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.execution.title", "Execution / Deathblow"),
			"body": LOCALIZATION.ui("blood_cavern.refresher.execution.body", "Break enemy Posture, then press %s during the deathblow prompt. Health-only defeats are not the execution condition.") % execution,
		},
		"parry": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.parry.title", "Parry / Deflect"),
			"body": LOCALIZATION.ui("blood_cavern.refresher.parry.body", "Tap %s as a blockable strike arrives. Clean deflects pressure enemy Posture and preserve your own guard stability.") % parry,
		},
		"dodge_red": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.dodge_red.title", "Dodge Red Attacks"),
			"body": LOCALIZATION.ui("blood_cavern.refresher.dodge_red.body", "Red attacks cannot be guarded normally. Read the warning, then use %s to evade the danger window.") % dash,
		},
		"posture_guard": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.posture_guard.title", "Posture / Guard"),
			"body": LOCALIZATION.ui("blood_cavern.refresher.posture_guard.body", "Guarding prevents normal damage but builds Posture. Release pressure and reposition before your Posture breaks."),
		},
		"targeting": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.targeting.title", "Targeting / Movement"),
			"body": LOCALIZATION.ui("blood_cavern.refresher.targeting.body", "Move with %s / %s / %s / %s. Keep threats framed and use spacing before committing to long attack strings.") % [up, left, down, right],
		},
		"prosthetic_spirit": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.prosthetic_spirit.title", "Prosthetic / Spirit"),
			"body": LOCALIZATION.ui("blood_cavern.refresher.prosthetic_spirit.body", "Press %s to use the equipped Prosthetic. Tools consume Spirit, so spend them deliberately around enemy openings.") % prosthetic,
		},
		"blood_aspects": {
			"title": LOCALIZATION.ui("blood_cavern.refresher.blood_aspects.title", "Blood Aspects"),
			"body": blood_body,
		},
	}
	return (topics.get(topic_id, {}) as Dictionary).duplicate(true)


func _discovered_action_techniques_for_playtest() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var seen: Dictionary = {}
	var candidates: Array = []
	if typeof(RunData) == TYPE_OBJECT:
		candidates.append_array(RunData.acquired_upgrades)
	candidates.append_array(_discovered_technique_records())
	for technique_value: Variant in candidates:
		var technique_id := str(technique_value)
		if seen.has(technique_id):
			continue
		var data: Dictionary = TECHNIQUE_CATALOG.get_entry(technique_id)
		if data.is_empty() or str(data.get("kind", "")) != TECHNIQUE_CATALOG.KIND_ACTION:
			continue
		seen[technique_id] = true
		out.append({
			"id": technique_id,
			"name": LOCALIZATION.catalog_name("technique", technique_id, str(data.get("displayname", technique_id.capitalize()))),
			"action_label": _technique_action_label(data),
			"details": LOCALIZATION.catalog_details("technique", technique_id, str(data.get("details", ""))),
		})
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return str(a.get("name", "")) < str(b.get("name", "")))
	return out


func _discovered_technique_records() -> Array:
	var out: Array = []
	if typeof(MetaProgress) != TYPE_OBJECT:
		return out
	for key_value: Variant in MetaProgress.progression_flags.keys():
		var key := str(key_value)
		if key.begins_with(TECHNIQUE_RECORD_PREFIX) and bool(MetaProgress.progression_flags.get(key_value, false)):
			out.append(key.trim_prefix(TECHNIQUE_RECORD_PREFIX))
	return out


func _technique_action_label(data: Dictionary) -> String:
	match str(data.get("action", "")):
		TECHNIQUE_CATALOG.ACTION_DEATHBLOW:
			return LOCALIZATION.ui("blood_cavern.technique_demos.action.finisher", "Finisher")
		TECHNIQUE_CATALOG.ACTION_COUNTER:
			return LOCALIZATION.ui("blood_cavern.technique_demos.action.counter", "Counter")
		TECHNIQUE_CATALOG.ACTION_DASH:
			return LOCALIZATION.ui("blood_cavern.technique_demos.action.dash", "Dash Attack")
		TECHNIQUE_CATALOG.ACTION_HELD:
			return LOCALIZATION.ui("blood_cavern.technique_demos.action.held", "Held Attack")
		TECHNIQUE_CATALOG.ACTION_BASIC:
			return LOCALIZATION.ui("blood_cavern.technique_demos.action.basic", "Basic Attack")
	return LOCALIZATION.ui("blood_cavern.technique_demos.action.general", "Action")


func _start_technique_demo(technique_id: String) -> void:
	var data: Dictionary = TECHNIQUE_CATALOG.get_entry(technique_id)
	if data.is_empty() or str(data.get("kind", "")) != TECHNIQUE_CATALOG.KIND_ACTION:
		return
	_clear_trial_completion_banner()
	_close_menu_surface()
	if not _demo_snapshot_active:
		_demo_original_upgrades = RunData.acquired_upgrades.duplicate(true) if typeof(RunData) == TYPE_OBJECT else []
		_demo_snapshot_active = true
	_active_trial_id = ""
	_trial_completion_queued = false
	_active_demo_technique_id = technique_id
	if typeof(RunData) == TYPE_OBJECT:
		RunData.acquired_upgrades = [technique_id]
	if _has_training_target():
		_clear_training_target()
	_spawn_training_target("technique_demo")
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


func _start_execution_trial() -> void:
	_clear_trial_completion_banner()
	_close_menu_surface()
	_restore_demo_loadout()
	_stop_training_state()
	_active_trial_id = TRIAL_EXECUTION
	_trial_completion_queued = false
	_last_trial_result.clear()
	_spawn_training_target(TRIAL_EXECUTION)


func _on_training_deathblow_completed(mode: String) -> void:
	if mode != TRIAL_EXECUTION or _active_trial_id != TRIAL_EXECUTION or _trial_completion_queued:
		return
	_trial_completion_queued = true
	call_deferred("_complete_trial", TRIAL_EXECUTION)


func _complete_trial(trial_id: String) -> void:
	_trial_completion_queued = false
	if _active_trial_id != trial_id:
		return
	var result: Dictionary = {"first_clear": false, "relic_id": ""}
	if typeof(MetaProgressionManager) == TYPE_OBJECT and MetaProgressionManager.has_method("complete_blood_cavern_trial"):
		var result_value: Variant = MetaProgressionManager.call("complete_blood_cavern_trial", trial_id)
		if result_value is Dictionary:
			result = (result_value as Dictionary).duplicate(true)
	else:
		push_error("[BloodCavern] MetaProgressionManager cannot complete Blood Cavern trials")
	_last_trial_result = result.duplicate(true)
	_active_trial_id = ""
	_clear_training_target()
	var first_clear := bool(result.get("first_clear", false))
	var relic_id := str(result.get("relic_id", ""))
	_show_trial_completion_banner(trial_id, result)
	training_ended.emit()
	trial_completed.emit(trial_id, first_clear, relic_id)
	print("[BloodCavern] Execution Trial complete — first_clear=%s relic=%s" % [str(first_clear), relic_id if not relic_id.is_empty() else "none"])


func _trial_completion_copy_for_playtest(trial_id: String, result: Dictionary) -> Dictionary:
	var title := LOCALIZATION.ui("blood_cavern.trials.complete", "TRIAL COMPLETE")
	if trial_id == TRIAL_EXECUTION:
		title = LOCALIZATION.ui("blood_cavern.trials.execution.complete", "EXECUTION TRIAL COMPLETE")
	var first_clear := bool(result.get("first_clear", false))
	var relic_id := str(result.get("relic_id", ""))
	if first_clear and not relic_id.is_empty():
		var relic_name := LOCALIZATION.catalog_name("relic", relic_id, RELIC_CATALOG.get_display_name(relic_id))
		return {
			"title": title,
			"detail": LOCALIZATION.ui("blood_cavern.trials.first_clear_reward", "%s unlocked. First-clear challenge reward claimed.") % relic_name,
		}
	return {
		"title": title,
		"detail": LOCALIZATION.ui("blood_cavern.trials.repeat_clear_reward", "Practice clear. The first-clear reward was already claimed."),
	}


func _show_trial_completion_banner(trial_id: String, result: Dictionary) -> void:
	var current_scene: Node = get_tree().current_scene
	var ui_layer: Node = current_scene.get_node_or_null("UILayer") if current_scene != null else null
	if ui_layer == null:
		return
	_clear_trial_completion_banner()
	var copy := _trial_completion_copy_for_playtest(trial_id, result)
	var panel := PanelContainer.new()
	panel.name = "BloodCavernTrialResult"
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.0
	panel.offset_left = -240.0
	panel.offset_right = 240.0
	panel.offset_top = 28.0
	panel.offset_bottom = 116.0
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.035, 0.05, 0.96)
	style.border_color = Color(0.68, 0.28, 0.34, 0.95)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", style)
	ui_layer.add_child(panel)

	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(content)
	var title := Label.new()
	title.name = "Title"
	title.text = str(copy.get("title", ""))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	content.add_child(title)
	var detail := Label.new()
	detail.name = "Detail"
	detail.text = str(copy.get("detail", ""))
	detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(detail)
	READABILITY_STYLER.apply(panel)

	var timer := Timer.new()
	timer.name = "DismissTimer"
	timer.one_shot = true
	timer.wait_time = 3.0
	timer.process_callback = Timer.TIMER_PROCESS_IDLE
	panel.add_child(timer)
	timer.timeout.connect(Callable(panel, "queue_free"))
	timer.start()


func _clear_trial_completion_banner() -> void:
	var current_scene: Node = get_tree().current_scene
	var ui_layer: Node = current_scene.get_node_or_null("UILayer") if current_scene != null else null
	var banner: Node = ui_layer.get_node_or_null("BloodCavernTrialResult") if ui_layer != null else null
	if banner != null and is_instance_valid(banner):
		banner.queue_free()


func _start_passive_target() -> void:
	_clear_trial_completion_banner()
	_close_menu_surface()
	_restore_demo_loadout()
	_active_trial_id = ""
	_trial_completion_queued = false
	if _has_training_target():
		_reset_training_target()
		return
	_spawn_training_target("passive_target")


func _spawn_training_target(mode: String) -> void:
	if _has_training_target():
		if _training_target.has_method("configure_training_mode"):
			_training_target.call("configure_training_mode", mode)
		else:
			_reset_training_target()
		_training_active = true
		training_started.emit(mode)
		return
	var target_value: Variant = TRAINING_TARGET.instantiate()
	if not (target_value is Node2D):
		push_error("[BloodCavern] Training target scene did not instantiate as Node2D")
		_restore_demo_loadout()
		_active_trial_id = ""
		return
	_training_target = target_value as Node2D
	_training_target.name = "BloodCavernTrainingTarget"
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		_training_target.queue_free()
		_training_target = null
		_restore_demo_loadout()
		_active_trial_id = ""
		return
	current_scene.add_child(_training_target)
	if _training_target.has_method("configure_training_mode"):
		_training_target.call("configure_training_mode", mode)
	if _training_target.has_signal("training_deathblow_completed"):
		var deathblow_cb := Callable(self, "_on_training_deathblow_completed")
		if not _training_target.is_connected("training_deathblow_completed", deathblow_cb):
			_training_target.connect("training_deathblow_completed", deathblow_cb)
	_training_target.global_position = global_position + TRAINING_TARGET_OFFSET
	_training_active = true
	training_started.emit(mode)
	print("[BloodCavern] %s training target active — rewards disabled" % mode)


func _reset_training_target() -> void:
	if not _has_training_target():
		return
	if _training_target.has_method("reset_training_target"):
		_training_target.call("reset_training_target")
	_training_target.global_position = global_position + TRAINING_TARGET_OFFSET
	print("[BloodCavern] Training target reset")


func _clear_training_target() -> void:
	if _has_training_target():
		_training_target.queue_free()
	_training_target = null
	_training_active = false


func _stop_training_state() -> bool:
	var was_active := _training_active or _has_training_target() or _demo_snapshot_active or not _active_trial_id.is_empty()
	_clear_training_target()
	_restore_demo_loadout()
	_active_trial_id = ""
	_trial_completion_queued = false
	if was_active:
		training_ended.emit()
	return was_active


func _end_training() -> void:
	var was_active := _stop_training_state()
	if was_active:
		print("[BloodCavern] Training ended — no run or permanent rewards granted")
	_close_menu_surface()


func _open_blood_mirror() -> void:
	var mirror := _find_blood_mirror()
	var stopped_training := _stop_training_state()
	if stopped_training:
		print("[BloodCavern] Training state cleared before entering Blood Mirror")
	_clear_trial_completion_banner()
	_close_menu_surface()
	if mirror != null and mirror.has_method("_open_menu"):
		mirror.call_deferred("_open_menu")


func _find_blood_mirror() -> Node:
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		return null
	var mirror := current_scene.get_node_or_null("BloodMirror")
	if mirror != null:
		return mirror
	return get_node_or_null("BloodMirror")


func _blood_mirror_unlocked() -> bool:
	return (
		typeof(MetaProgressionManager) == TYPE_OBJECT
		and MetaProgressionManager.has_method("is_blood_mirror_unlocked")
		and bool(MetaProgressionManager.call("is_blood_mirror_unlocked"))
	)


func _blood_mirror_status_text() -> String:
	return LOCALIZATION.ui(
		"blood_cavern.mirror.available",
		"Blood Mirror — awakened after the Keeper. Permanent Aspect reliability progression is available inside."
	) if _blood_mirror_unlocked() else LOCALIZATION.ui(
		"blood_cavern.mirror.locked",
		"Blood Mirror — dormant until the first Keeper defeat. The outer Training Hall remains available."
	)


func _trial_status_text() -> String:
	if _active_trial_id == TRIAL_EXECUTION:
		return LOCALIZATION.ui(
			"blood_cavern.trials.execution.active",
			"Execution Trial active — break the target's Posture, then land the real deathblow prompt. A Health-only defeat simply resets the target."
		)
	if not _last_trial_result.is_empty():
		if bool(_last_trial_result.get("first_clear", false)):
			return LOCALIZATION.ui("blood_cavern.trials.execution.first_clear", "Execution Trial cleared. The current first-clear challenge Relic has been unlocked; repeats grant no duplicate reward.")
		return LOCALIZATION.ui("blood_cavern.trials.execution.repeat_clear", "Execution Trial cleared again. Repeat clears grant no duplicate Relic or run currency.")
	var completed := typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("has_completed_blood_cavern_trial") and bool(MetaProgress.call("has_completed_blood_cavern_trial", TRIAL_EXECUTION))
	if completed:
		return LOCALIZATION.ui("blood_cavern.trials.execution.completed", "Execution Trial completed previously. It remains repeatable for practice with no duplicate first-clear reward.")
	return LOCALIZATION.ui("blood_cavern.trials.execution.ready", "Execution Trial — break the passive target's Posture and complete a real deathblow.")


func _training_status_text() -> String:
	if _active_trial_id == TRIAL_EXECUTION:
		return _trial_status_text()
	if not _active_demo_technique_id.is_empty():
		var data := TECHNIQUE_CATALOG.get_entry(_active_demo_technique_id)
		var technique_name := LOCALIZATION.catalog_name(
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
		"trials": LOCALIZATION.ui("blood_cavern.trials.title", "BASIC TRIALS"),
		"execution_trial": LOCALIZATION.ui("blood_cavern.trials.execution.start", "Start Execution Trial"),
		"active_trial": _active_trial_id,
		"last_trial_result": _last_trial_result.duplicate(true),
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
	_clear_trial_completion_banner()
	_clear_training_target()
	_restore_demo_loadout()
